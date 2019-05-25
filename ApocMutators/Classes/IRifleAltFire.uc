Class IRifleAltFire extends HL2WeaponFire;

defaultproperties
{
     ProjSpawnOffset=(X=5.000000,Y=6.000000,Z=-4.000000)
     PreFireTimeSec=0.850000
     StereoFireSound=Sound'HL2WeaponsS.IRifle.irifle_fire2'
     PreFireSound=Sound'HL2WeaponsS.IRifle.Charging'
     RandFireAnims(0)="AltFire"
     bUsesAmmoMag=False
     bUseTraceFire=False
     bWaitForRelease=True
     TransientSoundVolume=1.250000
     PreFireAnim="Shake"
     FireAnimRate=0.950000
     FireSound=Sound'HL2WeaponsS.IRifle.npc_ar2_altfire'
     FireRate=2.400000
     AmmoClass=Class'ApocMutators.HL_IRifleAmmoAlt'
     ShakeRotMag=(X=8.000000,Y=9.000000,Z=4.000000)
     ShakeRotRate=(X=20000.000000,Y=20000.000000,Z=20000.000000)
     ShakeOffsetMag=(X=5.000000,Y=5.000000,Z=5.000000)
     ProjectileClass=Class'ApocMutators.IRifleProjectile'
     aimerror=5.000000
}
