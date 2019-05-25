Class RPGProjectile extends HL2Projectile;

var HL_RPG MyWeapon;
var FX_LaserDot TrackingTarget;
var FX_RPGTrail MyTrail;
var bool bIsFlighting,bHasBlownUp;

replication
{
	reliable if( Role == ROLE_Authority )
		bIsFlighting;
}

simulated function ArmRocket()
{
	if( Level.NetMode!=NM_DedicatedServer )
	{
		if( MyTrail==None )
		{
			MyTrail = Spawn(Class'FX_RPGTrail',,,Location-vector(Rotation)*15);
			MyTrail.SetBase(Self);
		}
		AmbientSound = Sound'rocket1';
		LinkMesh(mesh'RPG_MissileO');
	}
	bIsFlighting = true;
	bOrientToVelocity = true;
	SetPhysics(PHYS_Projectile);
}
simulated function PostNetReceive()
{
	if( bIsFlighting )
	{
		ArmRocket();
		bNetNotify = false;
	}
}

function PostBeginPlay()
{
	Velocity = vector(Rotation)*Speed+vect(0,0,64);
	SetTimer(0.4,false);
}
function Timer()
{
	ArmRocket();
	bUpdateSimulatedPosition = true;
	Speed = 400.f;
	Velocity = vector(Rotation)*Speed;
	GoToState('TargetTracker');
}

simulated function Destroyed()
{
	if( !bHasBlownUp )
		Explode(Location,-Normal(Velocity));
	if( MyTrail!=None )
		MyTrail.Kill();
	if( MyWeapon!=None )
		MyWeapon.bTrackingProjectile = false;
}
function Landed( vector HN )
{
	Explode(Location,HN);
}
function ProcessTouch(Actor Other, Vector HitLocation)
{
	if ( Other!=Instigator && KFPawn(Other)==None && ROBulletWhipAttachment(Other)==None )
		Explode(HitLocation,Normal(HitLocation-Other.Location));
}
simulated function Explode(vector HitLocation, vector HitNormal)
{
	if( bHasBlownUp )
		return;
	bHasBlownUp = true;
	HurtRadius(Damage,DamageRadius,MyDamageType,MomentumTransfer,HitLocation);
	if ( Role == ROLE_Authority )
		MakeNoise(2.0);
	if( Level.NetMode!=NM_DedicatedServer )
	{
		//Spawn(Class'GrenadeExplosion',,,HitLocation).RemoteRole = ROLE_None;
		PlaySound(ImpactSound);
	}
	Destroy();
}
singular function HitWall(vector HitNormal, actor Wall)
{
	if ( !Wall.bStatic && !Wall.bWorldGeometry )
	{
		if ( Instigator == None || Instigator.Controller == None )
			Wall.SetDelayedDamageInstigatorController( InstigatorController );
		Wall.TakeDamage( Damage, instigator, Location, MomentumTransfer * Normal(Velocity), MyDamageType);
		if (DamageRadius > 0 && Vehicle(Wall) != None && Vehicle(Wall).Health > 0)
			Vehicle(Wall).DriverRadiusDamage(Damage, DamageRadius, InstigatorController, MyDamageType, MomentumTransfer, Location);
		HurtWall = Wall;
	}
	MakeNoise(1.0);
	Explode(Location + ExploWallOut * HitNormal, HitNormal);
}

state TargetTracker
{
	function BeginState()
	{
		SetTimer(0.1,true);
	}
	function Timer()
	{
		if( Speed<MaxSpeed )
			Speed = FMin(Speed+60.f,MaxSpeed);
		if( TrackingTarget!=None )
			Velocity = GetTargetVelocity()*Speed;
		else Velocity = Normal(Velocity)*Speed;
	}
	final function vector GetTargetVelocity()
	{
		local vector X,V;

		V = Normal(Velocity);
		X = Normal(TrackingTarget.LaserTargetPosition-Location);

		if( (X Dot V)>0.95 )
			return X;
		return Normal(V+X*0.4);
	}
}

defaultproperties
{
     Speed=100.000000
     MaxSpeed=1200.000000
     Damage=1000.000000
     DamageRadius=650.000000
     MomentumTransfer=15000.000000
     MyDamageType=Class'ApocMutators.DamTypeRPG'
     ImpactSound=SoundGroup'HL2WeaponsS.Generic.Explosion_G'
     bNetTemporary=False
     Physics=PHYS_Falling
     LifeSpan=0.000000
     Mesh=SkeletalMesh'HL2WeaponsA.RPG_MissileC'
     DrawScale=1.300000
     bClientAnim=True
     bFullVolume=True
     SoundVolume=255
     SoundPitch=72
     SoundRadius=90.000000
     TransientSoundVolume=1.500000
     TransientSoundRadius=400.000000
     bNetNotify=True
     bBounce=True
     bNoRepMesh=True
}
