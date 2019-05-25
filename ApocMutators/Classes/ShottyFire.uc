Class ShottyFire extends HL2WeaponFire;

simulated function Timer()
{
	HL_Shotgun(Weapon).PumpShotgun();
}

defaultproperties
{
     DamageType=Class'ApocMutators.DamTypeShotty'
     DamageMin=20
     DamageMax=30
     ProjPerFire=6
     PostFireTimeSec=0.400000
     RandFireAnims(0)="Fire"
     FlashEmitterBone="Gun"
     NumPenetrates=1
     bCanPenetrate=True
     bWaitForRelease=True
     TransientSoundVolume=1.000000
     FireSound=SoundGroup'HL2WeaponsS.Shotgun.Shotgun_FireG'
     FireRate=1.000000
     AmmoClass=Class'ApocMutators.HL_ShotgunAmmo'
     ShakeRotMag=(X=5.000000,Y=6.000000,Z=4.000000)
     ShakeRotRate=(X=15000.000000,Y=15000.000000,Z=15000.000000)
     ShakeOffsetMag=(X=4.000000,Y=5.000000,Z=4.000000)
     FlashEmitterClass=Class'ApocMutators.FX_ShottyMuzzle1st'
     aimerror=42.000000
     Spread=0.080000
}
