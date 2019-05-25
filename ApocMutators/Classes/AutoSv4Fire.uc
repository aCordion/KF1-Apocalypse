class AutoSv4Fire extends KFShotgunFire;

simulated function bool AllowFire()
{
	return (Weapon.AmmoAmount(ThisModeNum) >= AmmoPerFire);
}

function float MaxRange()
{
    return 2500;
}

function DoFireEffect()
{
   Super(KFShotgunFire).DoFireEffect();
}

defaultproperties
{
     EffectiveRange=2500.000000
     maxVerticalRecoilAngle=1
     maxHorizontalRecoilAngle=1
     FireAimedAnim="Fire_Iron"
     bRandomPitchFireSound=False
     ProjPerFire=1
     ProjSpawnOffset=(Y=0.000000,Z=0.000000)
     TransientSoundVolume=1.800000
     FireSound=SoundGroup'KF_XbowSnd.Xbow_Fire'
     NoAmmoSound=Sound'KF_XbowSnd.Xbow_DryFire'
     FireForce="AssaultRifleFire"
     FireRate=0.200000
     AmmoClass=Class'AutoSv4Ammo'
     ShakeRotMag=(X=3.000000,Y=4.000000,Z=2.000000)
     ShakeRotRate=(X=10000.000000,Y=10000.000000,Z=10000.000000)
     ShakeOffsetMag=(X=3.000000,Y=3.000000,Z=3.000000)
     ProjectileClass=Class'AutoSv4Arrow'
     BotRefireRate=1.800000
     aimerror=1.000000
     Spread=0.000010
     SpreadStyle=SS_None
}
