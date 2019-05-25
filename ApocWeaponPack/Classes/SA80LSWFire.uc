//=============================================================================
 //L86A1 Fire
//=============================================================================
class SA80LSWFire extends KFFire;

defaultproperties
{
     FireAimedAnim="Iron_Idle"
     RecoilRate=0.150000
     maxVerticalRecoilAngle=500
     maxHorizontalRecoilAngle=250
     ShellEjectClass=Class'ROEffects.KFShellEjectBullpup'
     ShellEjectBoneName="Shell_eject"
     bAccuracyBonusForSemiAuto=True
     StereoFireSound=Sound'SA80LSW_A.SA80LSW_SND.SA80LSW_shot'
     DamageType=Class'DamTypeSA80LSW'
     DamageMin=30//26 //kyan
     DamageMax=35//36
     Momentum=10500.000000
     bPawnRapidFireAnim=True
     TransientSoundVolume=1.800000
     FireLoopAnim="Fire"
     TweenTime=0.025000
     FireSound=Sound'SA80LSW_A.SA80LSW_SND.SA80LSW_shot'
     NoAmmoSound=Sound'SA80LSW_A.SA80LSW_SND.SA80LSW_empty'
     FireForce="AssaultRifleFire"
     FireRate=0.100000
     AmmoClass=Class'SA80LSWAmmo'
     AmmoPerFire=1
     ShakeRotMag=(X=75.000000,Y=75.000000,Z=250.000000)
     ShakeRotRate=(X=10000.000000,Y=10000.000000,Z=10000.000000)
     ShakeRotTime=0.500000
     ShakeOffsetMag=(X=6.000000,Y=3.000000,Z=10.000000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ShakeOffsetTime=1.000000
     BotRefireRate=0.990000
     FlashEmitterClass=Class'ROEffects.MuzzleFlash1stSTG'
     aimerror=42.000000
     Spread=0.008500
     SpreadStyle=SS_Random
}
