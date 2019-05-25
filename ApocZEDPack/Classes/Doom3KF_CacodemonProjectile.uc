class Doom3KF_CacodemonProjectile extends Doom3KF_DoomProjectile;

var Doom3KF_CacodemonProjTrail Trail;
var Sound NewImpacts[3];

simulated function PostBeginPlay()
{
	local Rotator R;

	Super.PostBeginPlay();

	if (Level.NetMode != NM_DedicatedServer)
		Trail = Spawn(class'Doom3KF_CacodemonProjTrail', self);
	Velocity = Vector(Rotation) * Speed;
	R = Rotation;
	R.Roll = 32768;
	SetRotation(R);
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
	if (Role == ROLE_Authority)
		HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation);

	PlaySound(NewImpacts[Rand(3)], SLOT_Misc);
	if (EffectIsRelevant(Location, false))
		Spawn(class'Doom3KF_CacodemonProjExplosion', , , Location);
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
     NewImpacts(0)=Sound'2009DoomMonstersSounds.Cacodemon.caco_pimpact_02'
     NewImpacts(1)=Sound'2009DoomMonstersSounds.Cacodemon.caco_pimpact_03'
     NewImpacts(2)=Sound'2009DoomMonstersSounds.Cacodemon.caco_pimpact_05'
     Speed=900.000000
     MaxSpeed=1500.000000
     Damage=15.000000
     DamageRadius=150.000000
     MomentumTransfer=10000.000000
     MyDamageType=Class'Doom3KF_DamTypeCacodemonProj'
     LightType=LT_Steady
     LightEffect=LE_QuadraticNonIncidence
     LightHue=28
     LightSaturation=127
     LightBrightness=169.000000
     LightRadius=4.000000
     DrawType=DT_Sprite
     CullDistance=4000.000000
     bDynamicLight=True
     AmbientSound=Sound'2009DoomMonstersSounds.Cacodemon.caco_fireball_travel_loop'
     LifeSpan=10.000000
     Texture=Texture'2009DoomMonstersTex.Revenant.InvisMat'
     DrawScale=0.200000
     SoundVolume=255
     SoundRadius=150.000000
     CollisionRadius=3.000000
     CollisionHeight=3.000000
}
