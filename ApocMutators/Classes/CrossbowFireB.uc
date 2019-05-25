Class CrossbowFireB extends HL2WeaponFire;

simulated function Timer()
{
	if( Instigator.IsLocallyControlled() )
		HL_Crossbow(Weapon).SetClipStatus(false);
	Super.Timer();
}

defaultproperties
{
     ProjSpawnOffset=(X=5.000000,Y=6.000000,Z=-4.000000)
     RandFireAnims(0)="Fire"
     bUseTraceFire=False
     bAutoReloadAfterFire=True
     bWaitForRelease=True
     TransientSoundVolume=1.500000
     FireSound=Sound'HL2WeaponsS.Crossbow.Fire1'
     NoAmmoSound=None
     FireRate=0.740000
     AmmoClass=Class'ApocMutators.HL_CrossbowAmmo'
     ShakeRotMag=(X=3.000000,Y=4.000000,Z=2.000000)
     ShakeRotRate=(X=10000.000000,Y=10000.000000,Z=10000.000000)
     ShakeOffsetMag=(X=3.000000,Y=3.000000,Z=3.000000)
     ProjectileClass=Class'ApocMutators.CrossbowProjectile'
     aimerror=12.000000
}
