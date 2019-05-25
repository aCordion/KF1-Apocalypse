class AKC74Fire extends KFFire;

defaultproperties
{
     FireAimedAnim="Fire"
     RecoilRate=0.150000
     maxVerticalRecoilAngle=500
     maxHorizontalRecoilAngle=250
     bRecoilRightOnly=True
     ShellEjectClass=Class'ROEffects.KFShellEjectAK'
     ShellEjectBoneName="Shell_eject"
     bAccuracyBonusForSemiAuto=True
     bRandomPitchFireSound=False
     FireSound=Sound'AKC74_Snd.akc74_shoot_mono'
     StereoFireSound=Sound'AKC74_Snd.akc74_shoot_stereo'
     NoAmmoSound=Sound'AKC74_Snd.akc74__empty'
     DamageType=Class'DamTypeAKC74'
     DamageMin=70 //45 //kyan
     DamageMax=75 //50
     Momentum=9500.000000
     bPawnRapidFireAnim=True
     TransientSoundVolume=1.800000
     FireLoopAnim="Fire"
     TweenTime=0.025000
     FireForce="AssaultRifleFire"
     FireRate=0.104000
     AmmoClass=Class'AKC74Ammo'
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
     Spread=0.005000
     SpreadStyle=SS_Random
}
