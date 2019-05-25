class G2ContenderDTFire extends KFShotgunFire;

simulated function bool AllowFire()
{
	return (Weapon.AmmoAmount(ThisModeNum) >= AmmoPerFire);
}

function float MaxRange()
{
    return 25000;
}

function DoFireEffect()
{
   Super(KFShotgunFire).DoFireEffect();
}

defaultproperties
{
     EffectiveRange=25000.000000
     RecoilRate=0.100000
     maxVerticalRecoilAngle=1400
     maxHorizontalRecoilAngle=90
     FireAimedAnim="Fire"
     bRandomPitchFireSound=False
     FireSound=Sound'Thompson_G2_A.G2_Shot'
     StereoFireSound=Sound'Thompson_G2_A.G2_Shot'
     NoAmmoSound=Sound'KF_SCARSnd.SCAR_DryFire'
     ProjPerFire=1
     ProjSpawnOffset=(Y=0.000000,Z=0.000000)
     bWaitForRelease=True
     TransientSoundVolume=1.800000
     FireForce="AssaultRifleFire"
     FireRate=1.60000
     AmmoClass=Class'G2ContenderDTAmmo'
	 FlashEmitterClass=Class'ROEffects.MuzzleFlash1stKar'
     ShakeRotMag=(X=5.000000,Y=7.000000,Z=3.000000)
     ShakeRotRate=(X=10000.000000,Y=10000.000000,Z=10000.000000)
     ShakeOffsetMag=(X=5.000000,Y=5.000000,Z=5.000000)
     ProjectileClass=Class'G2ContenderDTBullet'
     BotRefireRate=3.570000
     aimerror=0.000000
     Spread=0.004000
}
