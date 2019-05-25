class ThompsonV2Fire extends KFFire;

defaultproperties
{
     FireAimedAnim="Fire"
     RecoilRate=0.150000
     maxVerticalRecoilAngle=500
     maxHorizontalRecoilAngle=250
     bRecoilRightOnly=True
     ShellEjectClass=Class'ROEffects.KFShellEjectMP5SMG'
     ShellEjectBoneName="Shell_eject"
     bAccuracyBonusForSemiAuto=True
     bRandomPitchFireSound=False
     FireSound=Sound'ThompsonV2_Snd.ThompsonV2_shoot_mono'
     StereoFireSound=Sound'ThompsonV2_Snd.ThompsonV2_shoot_stereo'
     NoAmmoSound=Sound'ThompsonV2_Snd.ThompsonV2_empty'
     DamageType=Class'DamTypeThompsonV2'
     DamageMin=70 //40 //kyan
     DamageMax=75 //55
     Momentum=7500.000000
     bPawnRapidFireAnim=True
     TransientSoundVolume=1.800000
     FireLoopAnim="Fire"
     TweenTime=0.025000
     FireForce="AssaultRifleFire"
     FireRate=0.079000
     AmmoClass=Class'ThompsonV2Ammo'
     AmmoPerFire=1
     ShakeRotMag=(X=50.000000,Y=50.000000,Z=350.000000)
     ShakeRotRate=(X=5000.000000,Y=5000.000000,Z=5000.000000)
     ShakeRotTime=0.750000
     ShakeOffsetMag=(X=6.000000,Y=3.000000,Z=7.500000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ShakeOffsetTime=1.250000
     BotRefireRate=0.990000
     FlashEmitterClass=Class'ROEffects.MuzzleFlash1stMP'
     aimerror=42.000000
     Spread=0.015000
     SpreadStyle=SS_Random
}
