class Doom3KF_HunterInvulBigProjectile extends Doom3KF_DoomProjectile;

var Doom3KF_HunterInvulBigProjTrail Trail;
var Doom3KF_HunterInvulProjSmokeTrail SmokeTrail;
var Sound NewImpactSounds[2];
var Actor Seeking;
var vector InitialDir;

replication
{
	reliable if (Role==ROLE_Authority)
		Seeking;
}

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	if (Level.NetMode != NM_DedicatedServer)
	{
		Trail = Spawn(class'Doom3KF_HunterInvulBigProjTrail', self);
		Trail.SetBase(self);
		SmokeTrail = Spawn(class'Doom3KF_HunterInvulProjSmokeTrail', self);
		SmokeTrail.SetBase(Self);
	}
	Velocity = Vector(Rotation) * Speed;
	Velocity.Z += 150;
	SetTimer(0.2, true);
}

simulated function Timer()
{
	local vector ForceDir;
	local float VelMag;

	if (InitialDir == vect(0, 0, 0))
		InitialDir = Normal(Velocity);

	Acceleration = vect(0, 0, 0);
	if (Seeking != None)
	{
		ForceDir = Normal(Seeking.Location - Location);

		if ((ForceDir Dot InitialDir) > 0)
		{
			VelMag = VSize(Velocity);

			if (Seeking.Physics == PHYS_Karma)
				ForceDir = Normal(ForceDir * 0.8 * VelMag + Velocity);
			else ForceDir = Normal(ForceDir * 0.5 * VelMag + Velocity);
			Velocity =  VelMag * ForceDir;
			Acceleration += 5 * ForceDir;
		}
		SetRotation(rotator(Velocity));
	}
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
	if (Role == ROLE_Authority)
		HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation);
	PlaySound(NewImpactSounds[Rand(2)], SLOT_Misc);
	if (EffectIsRelevant(Location, false))
		Spawn(class'Doom3KF_HunterInvulProjExplosion', , , Location);
	ShakeView(180.f, 2.f);
	Destroy();
}

simulated function Destroyed()
{
	if (Trail != None)
		Trail.Kill();
	if (SmokeTrail != None)
		SmokeTrail.Kill();
	Super.Destroyed();
}

defaultproperties
{
     NewImpactSounds(0)=Sound'2009DoomMonstersSounds.Hunter.Hunter_helltime_exp_03'
     NewImpactSounds(1)=Sound'2009DoomMonstersSounds.Hunter.Hunter_helltime_exp_05'
     Speed=900.000000
     MaxSpeed=1150.000000
     Damage=30.000000
     DamageRadius=150.000000
     MomentumTransfer=6000.000000
     MyDamageType=Class'Doom3KF_DamTypeHunterInvulShockWave'
     ImpactSound=Sound'2009DoomMonstersSounds.Imp.imp_exp_03'
     LightType=LT_Steady
     LightEffect=LE_QuadraticNonIncidence
     LightHue=141
     LightSaturation=127
     LightBrightness=255.000000
     LightRadius=4.000000
     DrawType=DT_Sprite
     CullDistance=4000.000000
     bDynamicLight=True
     bNetTemporary=False
     AmbientSound=Sound'2009DoomMonstersSounds.Hunter.Hunter_helltime_flight1'
     LifeSpan=10.000000
     Texture=Shader'2009DoomMonstersTex.Effects.HunterInvulProjTex'
     DrawScale=0.600000
     SoundVolume=50
     SoundRadius=150.000000
     TransientSoundRadius=500.000000
     CollisionRadius=10.000000
     CollisionHeight=10.000000
}
