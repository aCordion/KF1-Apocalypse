//=============================================================================
// Nade
//=============================================================================
class FGrenade extends HL2Projectile;

var() float LongExplodeTimer,ShortExplodeTimer,DampenFactor;
var() byte NumLongWarns,NumShortWarns;
var() vector RotMag;            // how far to rot view
var() vector RotRate;           // how fast to rot view
var() float  RotTime;           // how much time to rot the instigator's view
var() vector OffsetMag;         // max view offset vertically
var() vector OffsetRate;        // how fast to offset view vertically
var() float  OffsetTime;        // how much time to offset view

var() Sound ExplodeSound;

var AvoidMarker Fear;
var vector RepNewVelocity,RepLandedPosition;
var FX_FGrenTrail MyTrail;

var bool bHasExploded;

replication
{
    reliable if (Role==ROLE_Authority)
        RepNewVelocity,RepLandedPosition;
}

simulated function PostNetBeginPlay()
{
	if( Level.NetMode!=NM_DedicatedServer && MyTrail==None )
	{
		MyTrail = Spawn(Class'FX_FGrenTrail',,,Location+(vect(0,0,4)>>Rotation));
		MyTrail.SetBase(Self);
	}
	RepNewVelocity = vect(0,0,0);
	RepLandedPosition = vect(0,0,0);
	bNetNotify = true;
}
simulated function PostNetReceive()
{
	if( RepNewVelocity!=vect(0,0,0) )
	{
		Velocity = RepNewVelocity;
		SetPhysics(PHYS_Falling);
		bBounce = true;
		RepNewVelocity = vect(0,0,0);
	}
	if( RepLandedPosition!=vect(0,0,0) )
	{
		if( Physics!=PHYS_None || VSizeSquared(Location-RepLandedPosition)>2200.f )
		{
			SetLocation(RepLandedPosition);
			bBounce = False;
			SetPhysics(PHYS_None);
			DesiredRotation = Rotation;
			DesiredRotation.Roll = 0;
			DesiredRotation.Pitch = 16384;
			SetRotation(DesiredRotation);
		}
		RepLandedPosition = vect(0,0,0);
	}
}

function Timer()
{
	if( NumLongWarns==0 && NumShortWarns==0 )
		Explode(Location, vect(0,0,1));
	else
	{
		PlaySound(Sound'tick1',SLOT_Pain);
		if( NumLongWarns==0 )
		{
			--NumShortWarns;
			SetTimer(ShortExplodeTimer, false);
		}
		else
		{
			--NumLongWarns;
			SetTimer(LongExplodeTimer, false);
		}
    }
}

function TakeDamage( int Damage, Pawn InstigatedBy, Vector Hitlocation, Vector Momentum, class<DamageType> damageType, optional int HitIndex)
{
	if ( Monster(instigatedBy) != none || instigatedBy == Instigator )
	{
		Velocity+=(Momentum/50.f);
		RepNewVelocity = Velocity;
		SetPhysics(PHYS_Falling);
		bBounce = true;
		if( Fear!=none )
			Fear.Destroy();
	}
}

simulated function PostBeginPlay()
{
	RandSpin(25000);
	if( Level.NetMode!=NM_Client )
		SetTimer(LongExplodeTimer, false);
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
	local PlayerController LocalPlayer;

	bHasExploded = True;
	BlowUp(HitLocation);

	if( Level.NetMode!=NM_DedicatedServer )
	{
		PlaySound(ExplodeSound,,2.0);

		if ( EffectIsRelevant(Location,false) )
		{
			Spawn(Class'KFmod.KFNadeExplosion',,, HitLocation, rotator(vect(0,0,1)));
			Spawn(ExplosionDecal,self,,HitLocation, rotator(-HitNormal));
		}

		// Shake nearby players screens
		LocalPlayer = Level.GetLocalPlayerController();
		if ( (LocalPlayer != None) && (VSize(Location - LocalPlayer.ViewTarget.Location) < (DamageRadius * 1.5)) )
			LocalPlayer.ShakeView(RotMag, RotRate, RotTime, OffsetMag, OffsetRate, OffsetTime);
	}

	Destroy();
}

simulated function Destroyed()
{
	if( !bHasExploded )
		Explode(Location,vect(0,0,1));
	if( MyTrail!=None )
		MyTrail.Kill();
	if ( Fear != None )
		Fear.Destroy();
	Super.Destroyed();
}

simulated function ProcessTouch( actor Other, vector HitLocation )
{
    if( KFBulletWhipAttachment(Other)==none && KFHumanPawn(Other)==none && ExtendedZCollision(Other)==None )
	{
		if (Other.IsA('NetKActor'))
			KAddImpulse(Velocity,HitLocation,);
		Velocity = MirrorVectorByNormal(Velocity,Normal(Location-Other.Location))*0.2f;
	}
}

// Overridden to tweak the handling of the impact sound
simulated function HitWall( vector HitNormal, actor Wall )
{
	if( GameObjective(Wall) != None )
	{
		Explode(Location, HitNormal);
		return;
	}

    // Reflect off Wall w/damping
	Velocity = MirrorVectorByNormal(Velocity,HitNormal)*DampenFactor;

    RandSpin(100000);
    DesiredRotation.Roll = 0;
    RotationRate.Roll = 0;
    Speed = VSize(Velocity);

    if ( Speed < 20 )
    {
		bBounce = False;
		SetPhysics(PHYS_None);
		DesiredRotation = Rotation;
		DesiredRotation.Roll = 0;
		DesiredRotation.Pitch = 16384;
		SetRotation(DesiredRotation);

		if( Level.NetMode!=NM_Client )
		{
			if( Fear == none )
			{
				Fear = Spawn(class'AvoidMarker');
				Fear.SetCollisionSize(DamageRadius,DamageRadius);
				Fear.StartleBots();
			}
			RepLandedPosition = Location;
		}
    }
    else
    {
		if ( (Level.NetMode != NM_DedicatedServer) && (Speed > 50) )
			PlaySound(ImpactSound, SLOT_Misc );
		else
		{
			bFixedRotationDir = false;
			bRotateToDesired = true;
			DesiredRotation.Pitch = 0;
			RotationRate.Pitch = 50000;
		}
    }
}

defaultproperties
{
     LongExplodeTimer=1.000000
     ShortExplodeTimer=0.250000
     DampenFactor=0.400000
     NumLongWarns=2
     NumShortWarns=3
     RotMag=(X=600.000000,Y=600.000000,Z=600.000000)
     RotRate=(X=12500.000000,Y=12500.000000,Z=12500.000000)
     RotTime=6.000000
     OffsetMag=(X=5.000000,Y=10.000000,Z=5.000000)
     OffsetRate=(X=300.000000,Y=300.000000,Z=300.000000)
     OffsetTime=3.500000
     ExplodeSound=SoundGroup'HL2WeaponsS.Generic.Explosion_G'
     MaxSpeed=1400.000000
     TossZ=0.000000
     Damage=650.000000
     DamageRadius=500.000000
     MomentumTransfer=100000.000000
     MyDamageType=Class'ApocMutators.DamTypeFGrenade'
     ImpactSound=SoundGroup'KF_GrenadeSnd.Nade_HitSurf'
     ExplosionDecal=Class'KFMod.KFScorchMark'
     bNetTemporary=False
     Physics=PHYS_Falling
     Mesh=SkeletalMesh'HL2WeaponsA.HL_Grenade3rd'
     DrawScale=1.300000
     bUnlit=False
     FluidSurfaceShootStrengthMod=3.000000
     TransientSoundVolume=200.000000
     CollisionRadius=1.000000
     CollisionHeight=1.000000
     bBounce=True
     bFixedRotationDir=True
     DesiredRotation=(Pitch=12000,Yaw=5666,Roll=2334)
}
