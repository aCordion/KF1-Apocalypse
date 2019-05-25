Class MagnumFire extends HL2WeaponFire;

defaultproperties
{
     DamageType=Class'ApocMutators.DamTypeMagnum'
     DamageMin=350
     DamageMax=330
     Momentum=30000.000000
     DamageKnockForce=30000.000000
     StereoFireSound=SoundGroup'HL2WeaponsS.Magnum.357_FireStereo'
     RandFireAnims(0)="Fire"
     FlashEmitterBone="Muzzle"
     NumPenetrates=4
     bCanPenetrate=True
     bWaitForRelease=True
     TransientSoundVolume=2.000000
     FireSound=SoundGroup'HL2WeaponsS.Magnum.357_FireMono'
     FireRate=0.800000
     AmmoClass=Class'ApocMutators.HL_MagnumAmmo'
     ShakeRotMag=(X=3.000000,Y=4.000000,Z=2.000000)
     ShakeRotRate=(X=10000.000000,Y=10000.000000,Z=10000.000000)
     ShakeOffsetMag=(X=3.000000,Y=3.000000,Z=3.000000)
     FlashEmitterClass=Class'ApocMutators.FX_MagnumMuzzle1st'
     aimerror=42.000000
     Spread=0.040000
}
