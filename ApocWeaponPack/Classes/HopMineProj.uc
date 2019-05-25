Class HopMineProj extends Projectile;

#exec obj load file="KF_GrenadeSnd.uax"

var PanzerfaustTrail SmokeTrail;
var vector RepAttachPos,RepAttachDir,RepLaunchPos;
var HopMineLight DotLight;
var HopMineLchr WeaponOwner;
var Sound Blip3Sound,BladeInSound,BladeCutSound,MineDeploySound;

var bool bWarningTarget,bCriticalTarget,bPreLaunched,bNeedsDetonate;

replication
{
	// Variables the server should send to the client.
	reliable if( Role==ROLE_Authority )
		RepAttachPos,RepAttachDir,bWarningTarget,bCriticalTarget,RepLaunchPos;
}

simulated function AddSmoke()
{
	if( SmokeTrail==None )
		SmokeTrail = Spawn(class'PanzerfaustTrail',self);
	SmokeTrail.SetBase(self);
	SmokeTrail.SetRelativeRotation(rot(32768,0,0));
}
simulated function PostBeginPlay()
{
	Velocity = speed * vector(Rotation);
	Super.PostBeginPlay();
}
simulated function Destroyed()
{
	if( WeaponOwner!=None )
		WeaponOwner.RemoveMine(Self);
	if ( SmokeTrail != None )
		SmokeTrail.HandleOwnerDestroyed();
	if( DotLight!=None )
		DotLight.Destroy();
	if( Level.NetMode==NM_Client )
		BlowUp(Location);
	Super.Destroyed();
}
simulated function Landed( vector HitNormal )
{
	HitWall(HitNormal,Base);
}
simulated function HitWall(vector HitNormal, actor Wall)
{
	if( Level.NetMode==NM_Client )
	{
		SetPhysics(PHYS_None);
		return;
	}
	AttachTo(Location,HitNormal,Wall);
}
simulated final function AttachTo( vector Pos, vector Dir, Actor Wall )
{
	SetPhysics(PHYS_None);
	SetLocation(Pos + Dir*2);
	SetRotation(rotator(Dir)-rot(16384,0,0));
	RepAttachPos = Location;
	RepAttachDir = Dir*1000.f;
	if( Wall!=None && !Wall.bStatic )
		SetBase(Wall);
	GoToState('OnWall');
}
simulated function PostNetBeginPlay()
{
	bNetNotify = true;
	if( Physics==PHYS_None )
		GoToState('OnWall');
	else if( Physics==PHYS_Projectile || RepLaunchPos!=vect(0,0,0) )
		GoToState('LaunchMine');
	else if ( Level.NetMode!=NM_DedicatedServer )
	{
		AddSmoke();
		TweenAnim('Up',0.01f);
		PlaySound(BladeInSound);
		RandSpin(65000.f);
	}
}
simulated function PostNetReceive()
{
	if( RepAttachPos!=vect(0,0,0) )
	{
		ClientAttachProj();
		RepAttachPos = vect(0,0,0);
	}
}
simulated final function ClientAttachProj()
{
	local vector HL,HN,D;
	local Actor A;

	D = Normal(RepAttachDir);
	A = Trace(HL,HN,RepAttachPos-D*10.f,RepAttachPos+D,false);
	if( A==None )
	{
		HN = D;
		HL = RepAttachPos;
	}
	AttachTo(HL,HN,A);
}
simulated function BlowUp(vector HitLocation)
{
	if( Level.NetMode!=NM_DedicatedServer )
	{
		PlaySound(ImpactSound,,2.0);
		if ( EffectIsRelevant(Location,false) )
			Spawn(class'KFNadeLExplosion',,,HitLocation, rot(16384,0,0));
	}

	HurtRadius(Damage,DamageRadius, MyDamageType, MomentumTransfer, HitLocation );
	if ( Role == ROLE_Authority )
		MakeNoise(1.0);
}
simulated function Touch(Actor Other);
simulated function ClientSideTouch(Actor Other, Vector HitLocation);
simulated function ProcessTouch(Actor Other, Vector HitLocation);

state OnWall
{
	simulated function BeginState()
	{
		if ( SmokeTrail != None )
		{
			SmokeTrail.HandleOwnerDestroyed();
			SmokeTrail = None;
		}
		bCollideWorld = false;
		bFixedRotationDir = false;
		RotationRate = rot(0,0,0);
		if( Level.NetMode!=NM_DedicatedServer )
		{
			TweenAnim('Down',0.05f);
			PlaySound(BladeCutSound);
			DotLight = Spawn(Class'HopMineLight',,,Location + (vect(0,0,5) << Rotation));
			if( DotLight!=None )
			{
				DotLight.SetBase(Self);
				DotLight.SetRelativeLocation(vect(0,0,5));
			}
		}
		if( Level.NetMode!=NM_Client )
		{
			NetUpdateFrequency = 1.f;
			SetTimer(0.25+FRand()*0.25,true);
		}
	}
	simulated function EndState()
	{
		if( Level.NetMode!=NM_Client )
		{
			SetTimer(0,false);
			NetUpdateFrequency = Default.NetUpdateFrequency;
			NetUpdateTime = Level.TimeSeconds-1;
		}
	}
	function Timer()
	{
		local Controller C;
		local vector X,Y,Z;
		local float DotP;
		local int ThreatLevel;
		local bool bA,bB;

		GetAxes(Rotation,X,Y,Z);
		for( C=Level.ControllerList; C!=None; C=C.nextController )
			if( C.Pawn!=None && C.Pawn.Health>0 && VSizeSquared(C.Pawn.Location-Location)<1000000.f )
			{
				X = C.Pawn.Location-Location;
				DotP = (X Dot Z);
				if( DotP<0 )
					continue;
				DotP = VSizeSquared(X - (Z * DotP));
				if( DotP>90000.f || !FastTrace(C.Pawn.Location,Location) )
					continue;
				if( Monster(C.Pawn)!=None )
				{
					bB = true;
					if( DotP<35500.f )
					{
						Y = C.Pawn.Location;
						ThreatLevel+=C.Pawn.Health;
					}
				}
				else bA = true;
			}
		if( bA!=bWarningTarget || bB!=bCriticalTarget )
		{
			bWarningTarget = bA;
			bCriticalTarget = bB;
			if( DotLight!=None )
				DotLight.SetMode(bA,bB);
			NetUpdateTime = Level.TimeSeconds-1;
		}
		if( bB && ThreatLevel>400 )
		{
			bWarningTarget = false;
			bCriticalTarget = false;
			RepLaunchPos = Y;
			GoToState('LaunchMine');
		}
		else if( InstigatorController==None || bNeedsDetonate || (WeaponOwner!=None && WeaponOwner.NumMinesOut>WeaponOwner.MaximumMines) )
		{
			bWarningTarget = false;
			bCriticalTarget = false;
			RepLaunchPos = Location + Z*(150.f+FRand()*250.f);
			GoToState('LaunchMine');
		}
	}
	simulated function PostNetReceive()
	{
		if( RepLaunchPos!=vect(0,0,0) )
			GoToState('LaunchMine');
		else if( DotLight!=None )
			DotLight.SetMode(bWarningTarget,bCriticalTarget);
	}
}
state LaunchMine
{
	simulated function BeginState()
	{
		if( WeaponOwner!=None )
			WeaponOwner.RemoveMine(Self);
		bNeedsDetonate = true;
		if( DotLight!=None )
			DotLight.SetMode(true,true);
		if( Physics!=PHYS_Projectile )
		{
			bFixedRotationDir = false;
			RotationRate = rot(0,0,0);
			if( Level.NetMode!=NM_DedicatedServer )
			{
				TweenAnim('Up',0.1f);
				PlaySound(BladeInSound);
				PlaySound(MineDeploySound,SLOT_Talk);
			}
			SetTimer(0.6,false);
		}
		bNetNotify = false;
	}
	function HitWall(vector HitNormal, actor Wall)
	{
		BlowUp(Location);
		Destroy();
	}
	simulated function Timer()
	{
		if( !bPreLaunched )
		{
			bPreLaunched = true;
			if( Level.NetMode!=NM_DedicatedServer )
				PlaySound(Blip3Sound,SLOT_Misc);
			SetTimer(0.2,false);
		}
		else if( Level.NetMode!=NM_Client && Physics==PHYS_Projectile )
		{
			BlowUp(Location);
			Destroy();
		}
		else
		{
			if( DotLight!=None )
				DotLight.Destroy();
			if ( Level.NetMode != NM_DedicatedServer)
			{
				AddSmoke();
				bFixedRotationDir = true;
				RandSpin(45000.f);
			}
			bCollideWorld = true;
			SetPhysics(PHYS_Projectile);
			Velocity = (RepLaunchPos-Location)*2.f;
			if( Level.NetMode!=NM_Client )
				SetTimer(0.5,false);
		}
	}
}

simulated function HurtRadius( float DamageAmount, float DamageRadius, class<DamageType> DamageType, float Momentum, vector HitLocation )
{
	local actor Victims;
	local float damageScale, dist;
	local vector dir;

	if ( bHurtEntry )
		return;

	bHurtEntry = true;
	foreach VisibleCollidingActors( class 'Actor', Victims, DamageRadius, HitLocation )
	{
		// don't let blast damage affect fluid - VisibleCollisingActors doesn't really work for them - jag
		if( (Victims != self) && (Hurtwall != Victims) && (Victims.Role == ROLE_Authority) && !Victims.IsA('FluidSurfaceInfo') && ExtendedZCollision(Victims)==None )
		{
			if( Pawn(Victims)!=None && Monster(Victims)==None && Pawn(Victims).Controller!=InstigatorController )
				continue;
			dir = Victims.Location - HitLocation;
			dist = FMax(1,VSize(dir));
			dir = dir/dist;
			damageScale = 1 - FMax(0,(dist - Victims.CollisionRadius)/DamageRadius);
			if ( Instigator == None || Instigator.Controller == None )
				Victims.SetDelayedDamageInstigatorController( InstigatorController );
			if( Monster(Victims)==None )
				damageScale*=0.15; // Make it a lot less lethal to player self inflicted damage.
			Victims.TakeDamage
			(
				damageScale * DamageAmount,
				Instigator,
				Victims.Location - 0.5 * (Victims.CollisionHeight + Victims.CollisionRadius) * dir,
				(damageScale * Momentum * dir),
				DamageType
			);
			if (Vehicle(Victims) != None && Vehicle(Victims).Health > 0)
				Vehicle(Victims).DriverRadiusDamage(DamageAmount, DamageRadius, InstigatorController, DamageType, Momentum, HitLocation);
		}
	}
	bHurtEntry = false;
}

defaultproperties
{
     Speed=5000.000000
     MaxSpeed=8000.000000
     Damage=1000.000000
     DamageRadius=500.000000
     MomentumTransfer=75000.000000
     MyDamageType=class'DamTypeHopMine'
     ImpactSound=SoundGroup'KF_GrenadeSnd.Nade_Explode_1'
     bNetTemporary=False
     bAlwaysRelevant=True
     bSkipActorPropertyReplication=True
     Physics=PHYS_Falling
     LifeSpan=0.000000
     Mesh=SkeletalMesh'HopMine_rc.HopMineM'
     DrawScale=0.500000
     AmbientGlow=25
     bUnlit=False
     TransientSoundVolume=2.000000
     TransientSoundRadius=350.000000
     bBounce=True
	 bFixedRotationDir=True
	 Blip3Sound=Sound'rmine_blip3'
	 BladeInSound=Sound'blade_in'
	 BladeCutSound=Sound'blade_cut'
	 MineDeploySound=Sound'combine_mine_deploy1'
}
