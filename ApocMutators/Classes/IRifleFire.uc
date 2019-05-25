Class IRifleFire extends HL2WeaponFire;

defaultproperties
{
     DamageType=Class'ApocMutators.DamTypeIRifle'
     DamageMin=75
     DamageMax=120
     RandFireAnims(0)="Fire1"
     RandFireAnims(1)="Fire2"
     RandFireAnims(2)="fire3"
     RandFireAnims(3)="Fire4"
     FlashEmitterBone="Base"
     bPawnRapidFireAnim=True
     TransientSoundVolume=1.000000
     FireAnimRate=2.500000
     FireSound=Sound'HL2WeaponsS.IRifle.Fire1'
     FireRate=0.100000
     AmmoClass=Class'ApocMutators.HL_IRifleAmmo'
     ShakeRotMag=(X=3.000000,Y=4.000000,Z=2.000000)
     ShakeRotRate=(X=10000.000000,Y=10000.000000,Z=10000.000000)
     ShakeOffsetMag=(X=3.000000,Y=3.000000,Z=3.000000)
     FlashEmitterClass=Class'ApocMutators.FX_IRifleMuzzle1st'
     aimerror=42.000000
     Spread=0.015000
}
