//=============================================================================
// Weapon_M99Fire
//=============================================================================
// M99 Sniper Rifle primary fire class
//=============================================================================
// Killing Floor Source
// Copyright (C) 2012 Tripwire Interactive LLC
// - John "Ramm-Jaeger" Gibson, and IJC Development
//=============================================================================
class Weapon_M99Fire extends M99Fire;

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
     KickMomentum=(X=-150.000000,Z=85.000000)
     LowGravKickMomentumScale=7.0
     FireAimedAnim=Fire_Iron
     ProjPerFire=1
     TransientSoundVolume=1.800000
     FireSoundRef="KF_M99Snd.M99_Fire_M"
     StereoFireSoundRef="KF_M99Snd.M99_Fire_S"
     NoAmmoSoundRef="KF_SCARSnd.SCAR_DryFire"
     FireForce="AssaultRifleFire"
     FireRate=1.800000
     AmmoClass=Class'ApocMutators.Weapon_M99Ammo'
     ShakeOffsetMag=(X=5.000000,Y=5.000000,Z=5.000000)
     ShakeRotRate=(X=10000.000000,Y=10000.000000,Z=10000.000000)
     ShakeRotMag=(X=5.000000,Y=7.000000,Z=3.000000)
     ProjectileClass=Class'ApocMutators.Weapon_M99Bullet'
     BotRefireRate=3.5700000
     FlashEmitterClass=Class'ROEffects.MuzzleFlash1stPTRD'
     aimerror=0.000000
     Spread=0.004
     SpreadStyle=SS_Random
     ProjSpawnOffset=(Y=0.000000,Z=0.000000)

     EffectiveRange=25000.000000
     RecoilRate=0.1
     maxVerticalRecoilAngle=4000
     maxHorizontalRecoilAngle=90
     bWaitForRelease=True
     bRandomPitchFireSound=False
}
