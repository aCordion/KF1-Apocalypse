class AK74uFire extends KFFire;

defaultproperties
{
     FireAimedAnim="Fire"
     RecoilRate=0.150000
     maxVerticalRecoilAngle=500
     maxHorizontalRecoilAngle=250
     bRecoilRightOnly=True
     ShellEjectClass=Class'ROEffects.KFShellEjectAK'
     ShellEjectBoneName="Shell_ejector"
     bAccuracyBonusForSemiAuto=True
     bRandomPitchFireSound=False
     FireSound=Sound'AK74u_Snd.ak74u_shoot_mono'
     StereoFireSound=Sound'AK74u_Snd.ak74u_shoot_stereo'
     NoAmmoSound=Sound'AK74u_Snd.ak74u_empty'
     DamageType=Class'DamTypeAK74u'
     DamageMin=45 //40 //kyan
     DamageMax=50 //45
     Momentum=9500.000000
     bPawnRapidFireAnim=True
     TransientSoundVolume=1.800000
     FireLoopAnim="Fire"
     TweenTime=0.025000
     FireForce="AssaultRifleFire"
     FireRate=0.109000
     AmmoClass=Class'AK74uAmmo'
     AmmoPerFire=1
     ShakeRotMag=(X=50.000000,Y=50.000000,Z=350.000000)
     ShakeRotRate=(X=5000.000000,Y=5000.000000,Z=5000.000000)
     ShakeRotTime=0.750000
     ShakeOffsetMag=(X=6.000000,Y=3.000000,Z=7.500000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ShakeOffsetTime=1.250000
     BotRefireRate=0.990000
     FlashEmitterClass=Class'ROEffects.MuzzleFlash1stSTG'
     aimerror=42.000000
     Spread=0.015000
     SpreadStyle=SS_Random
}
