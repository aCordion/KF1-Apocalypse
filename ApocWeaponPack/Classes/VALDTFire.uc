class VALDTFire extends KFFire;

defaultproperties
{
     FireAimedAnim="Fire"
     RecoilRate=0.150000
     maxVerticalRecoilAngle=400
     maxHorizontalRecoilAngle=200
     bRecoilRightOnly=True
     ShellEjectClass=Class'ROEffects.KFShellEjectMac'
     ShellEjectBoneName="Shell_eject"
     bAccuracyBonusForSemiAuto=True
     bRandomPitchFireSound=False
     FireSound=Sound'VALDT_v2_A.VSS_Fire'
     StereoFireSound=Sound'VALDT_v2_A.VSS_Fire'
     NoAmmoSoundRef="KF_AK47Snd.AK47_DryFire"
     DamageType=Class'DamTypeVALDT'
     DamageMin=74 //65 //kyan
     DamageMax=79 //75
     Momentum=18500.000000
     bPawnRapidFireAnim=True
     TransientSoundVolume=2.800000
     FireLoopAnim="Fire"
     TweenTime=0.025000
     FireForce="AssaultRifleFire"
     FireRate=0.089000
     AmmoClass=Class'VALDTAmmo'
     AmmoPerFire=1
     ShakeRotMag=(X=50.000000,Y=50.000000,Z=350.000000)
     ShakeRotRate=(X=5000.000000,Y=5000.000000,Z=5000.000000)
     ShakeRotTime=0.750000
     ShakeOffsetMag=(X=6.000000,Y=3.000000,Z=7.500000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ShakeOffsetTime=1.250000
     BotRefireRate=0.990000
     FlashEmitterClass=Class'VALDTMuzzleFlash3rd'
     aimerror=42.000000
     Spread=0.015000
     SpreadStyle=SS_Random
}
