class DamTypeUSP extends KFProjectileWeaponDamageType
	abstract;

defaultproperties
{
     bSniperWeapon=True
     WeaponClass=Class'ApocMutators.HL_USP'
     DeathString="%o was gunned down by %k's USP Match."
     bRagdollBullet=True
     bBulletHit=True
     FlashFog=(X=600.000000)
     KDamageImpulse=3000.000000
     KDeathVel=85.000000
     KDeathUpKick=35.000000
     VehicleDamageScaling=0.050000
}
