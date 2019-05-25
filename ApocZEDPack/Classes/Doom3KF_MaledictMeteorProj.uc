class Doom3KF_MaledictMeteorProj extends Doom3KF_MaledictMeteorBigProj;

simulated function PostBeginPlay()
{
	RandSpin(25000);
	PlaySound(SpawnSounds[Rand(2)], SLOT_Interact);
	if (Level.NetMode != NM_DedicatedServer)
	{
		SetStaticMesh(SmallMeteorMesh[Rand(3)]);
		Trail = Spawn(class'Doom3KF_MaledictMeteorTrail', self);
	}
	Velocity = Vector(Rotation) * Speed;
}

simulated function PostNetBeginPlay()
{
	Acceleration = Normal(Velocity)*Speed;
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
	HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation);
	PlaySound(NewImpactSounds[Rand(2)], SLOT_Misc);
	if (EffectIsRelevant(Location, false))
		Spawn(class'Doom3KF_HunterProjExplosion', , , Location);
	Destroy();
}

defaultproperties
{
     Speed=1200.000000
     MaxSpeed=3500.000000
     Damage=60.000000
}
