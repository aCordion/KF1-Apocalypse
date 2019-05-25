class Doom3KF_GuardianProjectile extends Doom3KF_DoomProjectile;

var Doom3KF_GuardianFireBallTrail Trail;
var Sound NewImpactSounds[2];

simulated function PostBeginPlay()
{
	if (Level.NetMode != NM_DedicatedServer)
		Trail = Spawn(class'Doom3KF_GuardianFireBallTrail', self);
	Velocity = Vector(Rotation) * Speed;
	Velocity.z += RandRange(300, 700);
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
	HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation);

	PlaySound(NewImpactSounds[Rand(2)], SLOT_Misc);
	if (EffectIsRelevant(Location, false))
		Spawn(class'Doom3KF_GuardianFireBallExplosion', , , Location);
	Destroy();
}

simulated function Destroyed()
{
	if (Trail != None)
		Trail.Kill();
	Super.Destroyed();
}

defaultproperties
{
     NewImpactSounds(0)=Sound'2009DoomMonstersSounds.Imp.imp_exp_03'
     NewImpactSounds(1)=Sound'2009DoomMonstersSounds.Imp.imp_exp_05'
     Speed=900.000000
     MaxSpeed=1150.000000
     Damage=20.000000
     DamageRadius=200.000000
     MomentumTransfer=3000.000000
     MyDamageType=Class'Doom3KF_DamTypeImpFireBall'
     LightType=LT_Steady
     LightEffect=LE_QuadraticNonIncidence
     LightHue=8
     LightSaturation=90
     LightBrightness=255.000000
     LightRadius=4.000000
     DrawType=DT_Sprite
     CullDistance=4000.000000
     bDynamicLight=True
     Physics=PHYS_Falling
     AmbientSound=Sound'2009DoomMonstersSounds.Imp.imp_fireball_flight_04'
     LifeSpan=6.000000
     Texture=Shader'2009DoomMonstersTex.Effects.ImpFireBallTexture'
     DrawScale=0.200000
     SoundVolume=255
     SoundRadius=150.000000
     CollisionRadius=10.000000
     CollisionHeight=10.000000
}
