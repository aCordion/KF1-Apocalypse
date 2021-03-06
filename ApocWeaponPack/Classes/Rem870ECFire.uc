class Rem870ECFire extends ShotgunFire;

function DrawMuzzleFlash(Canvas Canvas)
{
    super.DrawMuzzleFlash(Canvas);
}

function FlashMuzzleFlash()
{
    super.FlashMuzzleFlash();
}

simulated function DestroyEffects()
{
    super.DestroyEffects();
}

defaultproperties
{
     maxVerticalRecoilAngle=3000
     maxHorizontalRecoilAngle=700
     RecoilRate=0.200000
     FireAimedAnim="Fire_Iron"
     bRandomPitchFireSound=False
     FireSound=Sound'Rem870_A.Rem870_SND.Rem870_shot'
     StereoFireSound=Sound'Rem870_A.Rem870_SND.Rem870_shot'
     NoAmmoSound=Sound'Rem870_A.Rem870_SND.Rem870_empty'
     bWaitForRelease=true
     ProjPerFire=25
     bAttachSmokeEmitter=True
     TransientSoundVolume=3.000000
     TransientSoundRadius=500.000000
     FireRate=1.265000
     AmmoClass=Class'Rem870ECAmmo'
     ShakeRotMag=(X=50.000000,Y=50.000000,Z=400.000000)
     ShakeRotRate=(X=12500.000000,Y=12500.000000,Z=12500.000000)
     ShakeRotTime=5.000000
     ShakeOffsetMag=(X=6.000000,Y=2.000000,Z=10.000000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ShakeOffsetTime=3.000000
     ProjectileClass=Class'Rem870ECBullet'
     BotRefireRate=1.850000
     FlashEmitterClass=Class'ROEffects.MuzzleFlash1stKar'
     aimerror=2.000000
     Spread=3000.000000
}
