Class IRifleProjectile extends HL2Projectile;

var() Sound BounceSound;

var FX_IRifleProjTrail MyTrail;
var byte NumBounces;
var vector RepUpdate,RepPosition;
var float LifeTime;

var bool bHasExploded;

replication
{
	reliable if( Role == ROLE_Authority )
		RepUpdate,RepPosition;
}

// Sync net server vs client
simulated function PostNetBeginPlay()
{
	if( Level.NetMode==NM_Client )
	{
		RepUpdate = vect(0,0,0);
		RepPosition = vect(0,0,0);
		bNetNotify = true;
	}
}
simulated function PostNetReceive()
{
	if( RepPosition!=vect(0,0,0) )
	{
		SetLocation(RepPosition);
		RepPosition = vect(0,0,0);
	}
	if( RepUpdate!=vect(0,0,0) && FastTrace(RepUpdate,Location) )
	{
		Velocity = Normal(RepUpdate-Location)*Speed;
		RepUpdate = vect(0,0,0);
	}
}

simulated function PostBeginPlay()
{
	if( Level.NetMode!=NM_DedicatedServer && MyTrail==None )
		MyTrail = Spawn(Class'FX_IRifleProjTrail',Self);
		
	if( Level.NetMode!=NM_Client )
	{
		Velocity = vector(Rotation)*Speed;
		SetTimer(6,false);
	}
}
simulated function ProcessTouch(Actor Other, Vector HitLocation)
{
	local int Dam;

	if ( (Other!=Instigator || NumBounces>0) && ExtendedZCollision(Other)==None )
	{
		if ( Level.NetMode!=NM_Client && (Instigator==None || Instigator.Controller==None) )
			Other.SetDelayedDamageInstigatorController(InstigatorController);
		Dam = Damage;
		if( KFPawn(Other)!=None )
			Dam = Dam/10;
		Other.TakeDamage(Dam,instigator,Location,MomentumTransfer*Normal(Other.Location-Location),MyDamageType);
		if( Level.NetMode!=NM_DedicatedServer && Pawn(Other)!=None )
			PlaySound(BounceSound,SLOT_Pain);

		if( Level.NetMode!=NM_Client && Monster(Other)!=None )
		{
			if( Monster(Other).bBoss )
				Explode(HitLocation,Normal(HitLocation-Other.Location));
			else
			{
				FindMovementTarget(Other); // Home into next target.
				RepPosition = Location; // May need to sync position here
			}
		}
	}
}
simulated singular function HitWall(vector HitNormal, actor Wall)
{
	if ( Role == ROLE_Authority )
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
	}
	NumBounces = Min(++NumBounces,16);
	if( NumBounces>=10 && Level.NetMode!=NM_Client )
	{
		if( NumBounces==10 )
			SetTimer(1.f,false);
		if( NumBounces==16 )
			Explode(Location,HitNormal);
	}
	if( !bDeleteMe )
	{
		if( Level.NetMode!=NM_DedicatedServer )
		{
			PlaySound(BounceSound,SLOT_Pain);
			Spawn(Class'FX_IRifleHitFX',,,Location+HitNormal,rotator(HitNormal));
		}
		Velocity = MirrorVectorByNormal(Velocity,HitNormal);
		if( Level.NetMode!=NM_Client )
			FindMovementTarget();
	}
	HurtWall = None;
}
simulated function Explode(vector HitLocation, vector HitNormal)
{
	bHasExploded = true;
	HurtRadius(Damage*5.f,DamageRadius,MyDamageType,MomentumTransfer,HitLocation);
	if ( Role == ROLE_Authority )
		MakeNoise(1.0);
	if( Level.NetMode!=NM_DedicatedServer )
	{
		Spawn(Class'FX_IRifleProjExpl',,,HitLocation);
		PlayStereoSound(HitLocation,ImpactSound,1.35f,3000.f,1.f);
	}
	Destroy();
}
simulated function Destroyed()
{
	if( !bHasExploded )
		Explode(Location,Normal(Velocity));
	if( MyTrail!=None )
	{
		MyTrail.LifeSpan = 0.5;
		MyTrail.Kill();
	}
}
simulated function Tick( float Delta )
{
	if( Level.NetMode!=NM_DedicatedServer )
	{
		LifeTime+=Delta;
		Delta = FMin(LifeTime,6.f)*64.f;
		SoundPitch = 70+Delta;
	}
}

function Timer()
{
	Explode(Location,Normal(Velocity));
}

function FindMovementTarget( optional Actor Ignore ) // Auto-aim at specimen
{
	local Controller C;
	local vector Dir,X;
	local float D,BD;
	local Actor Best;
	
	Dir = Normal(Velocity);

	// Find the closest and most centered target.
	for( C=Level.ControllerList; C!=None; C=C.nextController )
	{
		if( Ignore!=C.Pawn && Monster(C.Pawn)!=None && C.Pawn.Health>=0 && VSizeSquared(C.Pawn.Location-Location)<64000000.f )
		{
			X = C.Pawn.Location-Location;
			
			D = Normal(X) Dot Dir;
			if( D>0.85f && FastTrace(C.Pawn.Location,Location) )
			{
				D = VSizeSquared(C.Pawn.Location-Location)*(1.1f-D);
				if( Best==None || BD>D )
				{
					Best = C.Pawn;
					BD = D;
				}
			}
		}
	}
	if( Best!=None )
	{
		RepUpdate = Best.Location+Best.Velocity*FMin(VSize(Best.Location-Location)/Speed,1.5f);
		Velocity = Normal(RepUpdate-Location)*Speed;
		NetUpdateTime = Level.TimeSeconds-1.f;
	}
}

defaultproperties
{
     BounceSound=SoundGroup'HL2WeaponsS.IRifle.Energy_Bounce'
     Speed=1500.000000
     Damage=450.000000
     DamageRadius=600.000000
     MomentumTransfer=15000.000000
     MyDamageType=Class'ApocMutators.DamTypeIRifleOrb'
     ImpactSound=Sound'HL2WeaponsS.IRifle.energy_sing_explosion2'
     DrawType=DT_None
     bNetTemporary=False
     AmbientSound=Sound'HL2WeaponsS.IRifle.energy_sing_loop4'
     LifeSpan=0.000000
     bClientAnim=True
     bFullVolume=True
     SoundVolume=255
     SoundPitch=70
     SoundRadius=50.000000
     TransientSoundVolume=1.500000
     TransientSoundRadius=400.000000
     bBounce=True
}
