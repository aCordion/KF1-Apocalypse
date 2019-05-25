Class SMGFire extends HL2WeaponFire;

defaultproperties
{
     DamageType=Class'ApocMutators.DamTypeSMG'
     DamageMin=28
     DamageMax=35
     StereoFireSound=Sound'HL2WeaponsS.SMG.smg1_fire'
     RandFireAnims(0)="Fire1"
     RandFireAnims(1)="Fire2"
     RandFireAnims(2)="fire3"
     RandFireAnims(3)="Fire4"
     FlashEmitterBone="Muzzle"
     bPawnRapidFireAnim=True
     TransientSoundVolume=1.000000
     FireAnimRate=2.000000
     FireSound=SoundGroup'HL2WeaponsS.SMG.SMG_Fire'
     FireRate=0.080000
     AmmoClass=Class'ApocMutators.HL_SMGAmmo'
     ShakeRotMag=(X=3.000000,Y=4.000000,Z=2.000000)
     ShakeRotRate=(X=10000.000000,Y=10000.000000,Z=10000.000000)
     ShakeOffsetMag=(X=3.000000,Y=3.000000,Z=3.000000)
     FlashEmitterClass=Class'ApocMutators.FX_SMGMuzzle1st'
     aimerror=42.000000
     Spread=0.040000
}
