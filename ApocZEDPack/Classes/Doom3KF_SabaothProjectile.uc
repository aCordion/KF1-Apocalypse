class Doom3KF_SabaothProjectile extends Doom3KF_DoomProjectile;

var Doom3KF_SabaothProjTrail Trail;
var Sound NewImpactSounds[4];
var class<Doom3KF_SabaothProjArc> GreenArcs[2];
var Sound ArcSounds[3];
var vector NormalDir;
var bool bHadDeathFX;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	if (Level.NetMode != NM_DedicatedServer)
		Trail = Spawn(class'Doom3KF_SabaothProjTrail', self);
	Velocity = Vector(Rotation) * Speed;
	SetTimer(0.1, true);
}

simulated function Timer()
{
	local Actor A;
	local byte ArcCounter;
	local Doom3KF_SabaothProjArc Arc;

	if (NormalDir==vect(0, 0, 0))
		NormalDir = Normal(Velocity);

	foreach VisibleCollidingActors(class'Actor', A, 600)
	{
		if (!A.bStatic && A.Class != Class && A != Instigator && (A.bProjTarget || A.bBlockActors) && ((NormalDir Dot Normal(A.Location-Location))>0.45f))
		{
			if (Level.NetMode != NM_DedicatedServer)
			{
				Arc = Spawn(GreenArcs[Rand(2)], Self);
				Arc.mSpawnVecA = A.Location;
				Arc.Target = A;
				Arc.AmbientSound = ArcSounds[Rand(3)];
			}
			if (A.Role==ROLE_Authority)
				A.TakeDamage(5, Instigator, Location, 1000.f * vRand(), MyDamageType);
			if (++ArcCounter >= 6)
				break;
		}
	}
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
	if (bHadDeathFX)
		return;
	bHadDeathFX = true;
	HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation);

	PlaySound(NewImpactSounds[Rand(4)], SLOT_Misc);
	if (EffectIsRelevant(Location, false))
		Spawn(class'Doom3KF_SabaothProjExplosion', , , Location);
	Destroy();
}

simulated function Destroyed()
{
	if (Trail != None)
		Trail.Kill();
	if (!bHadDeathFX && Level.NetMode==NM_Client)
		Explode(Location, Normal(-Velocity));
	Super.Destroyed();
}

function ProcessTouch(Actor Other, Vector HitLocation)
{
	if (Other != Instigator && ExtendedZCollision(Other)==None)
		Explode(HitLocation, Normal(HitLocation-Other.Location));
}

singular function HitWall(vector HitNormal, actor Wall)
{
	if (!Wall.bStatic && !Wall.bWorldGeometry)
	{
		if (Instigator == None || Instigator.Controller == None)
			Wall.SetDelayedDamageInstigatorController(InstigatorController);
		Wall.TakeDamage(Damage, instigator, Location, MomentumTransfer * Normal(Velocity), MyDamageType);
		if (DamageRadius > 0 && Vehicle(Wall) != None && Vehicle(Wall).Health > 0)
			Vehicle(Wall).DriverRadiusDamage(Damage, DamageRadius, InstigatorController, MyDamageType, MomentumTransfer, Location);
		HurtWall = Wall;
	}
	MakeNoise(1.0);
	Explode(Location + ExploWallOut * HitNormal, HitNormal);
	HurtWall = None;
}

function TakeDamage(int Damage, Pawn InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional int HitIndex)
{
	if (Damage>40)
	{
		DamageRadius = 50.f;
		Explode(Location, Normal(Location-HitLocation));
	}
}

defaultproperties
{
     NewImpactSounds(0)=Sound'2009DoomMonstersSounds.BFG.bfg_explode1'
     NewImpactSounds(1)=Sound'2009DoomMonstersSounds.BFG.bfg_explode2'
     NewImpactSounds(2)=Sound'2009DoomMonstersSounds.BFG.bfg_explode3'
     NewImpactSounds(3)=Sound'2009DoomMonstersSounds.BFG.bfg_explode4'
     GreenArcs(0)=Class'Doom3KF_SabaothProjArc'
     GreenArcs(1)=Class'Doom3KF_SabaothProjArcFat'
     ArcSounds(0)=Sound'2009DoomMonstersSounds.BFG.arc_1'
     ArcSounds(1)=Sound'2009DoomMonstersSounds.BFG.arc_3'
     ArcSounds(2)=Sound'2009DoomMonstersSounds.BFG.arc_4'
     Speed=1000.000000
     MaxSpeed=1150.000000
     Damage=60.000000
     DamageRadius=250.000000
     MomentumTransfer=10000.000000
     MyDamageType=Class'Doom3KF_DamTypeSabaothProj'
     ExplosionDecal=Class'Doom3KF_SabaothProjDecal'
     LightType=LT_Steady
     LightEffect=LE_QuadraticNonIncidence
     LightHue=106
     LightSaturation=104
     LightBrightness=169.000000
     LightRadius=4.000000
     DrawType=DT_None
     bDynamicLight=True
     bNetTemporary=False
     AmbientSound=Sound'2009DoomMonstersSounds.BFG.bfg_fly'
     LifeSpan=10.000000
     DrawScale=0.200000
     SoundVolume=255
     SoundRadius=250.000000
     TransientSoundVolume=1.500000
     TransientSoundRadius=450.000000
     CollisionRadius=16.000000
     CollisionHeight=16.000000
     bProjTarget=True
}
