//=============================================================================
// M14EBR Fire
//=============================================================================
class MosinNagantFire extends KFShotgunFire;

simulated function bool AllowFire()
{
	if( KFWeapon(Weapon).bIsReloading || KFWeapon(Weapon).MagAmmoRemaining < 1)
		return false;

	if(KFPawn(Instigator).SecondaryItem!=none)
		return false;
	if( KFPawn(Instigator).bThrowingNade )
		return false;

	if( Level.TimeSeconds - LastClickTime>FireRate )
	{
		LastClickTime = Level.TimeSeconds;
	}

	if( KFWeapon(Weapon).MagAmmoRemaining<1 )
	{
    		return false;
	}

	return super(WeaponFire).AllowFire();
}

function float GetFireSpeed()
{
	if ( KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo) != none && KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill != none )
	{
		return KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill.Static.GetFireSpeedMod(KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo), Weapon);
	}

	return 1;
}

function PlayFiring()
{
	local float Rec;
	local float Rec2;
    //local float RandPitch;

	Rec = GetFireSpeed();
	if (Rec>1 || Rec<1){Rec2 = Rec*1.15;}
	else{Rec2 = Rec;}
	FireRate = default.FireRate/Rec2;
	FireAnimRate = default.FireAnimRate*Rec2;
	Rec = 1;
	Rec2 = 0;

	super.PlayFiring();
}

defaultproperties
{
     FireAimedAnim="Fire_Iron"
     // RecoilRate=0.085000
     maxVerticalRecoilAngle=1500
     maxHorizontalRecoilAngle=500
     FireSoundRef="MosinNagant_S.mosin_fire_m"
     StereoFireSoundRef="MosinNagant_S.mosin_fire_s"
     NoAmmoSoundRef="KF_M14EBRSnd.M14EBR_DryFire"
     bWaitForRelease=True
	 bRandomPitchFireSound=False
     TransientSoundVolume=1.800000
     FireLoopAnim="Fire"
     TweenTime=0.015000
     // FireForce="AssaultRifleFire"
     FireRate=1.833333
     AmmoClass=Class'MosinNagantAmmo'
     // AmmoPerFire=1
     ShakeRotMag=(X=50.000000,Y=50.000000,Z=300.000000)
     ShakeRotRate=(X=7500.000000,Y=7500.000000,Z=7500.000000)
     ShakeRotTime=0.650000
     ShakeOffsetMag=(X=6.000000,Y=3.000000,Z=7.500000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ShakeOffsetTime=1.150000
     BotRefireRate=0.990000
     FlashEmitterClass=Class'ROEffects.MuzzleFlash1stSTG'
     aimerror=42.000000
     Spread=0.002000
	 ProjectileClass=Class'MosinBullet'
	 ProjPerFire=1
     // SpreadStyle=SS_Random
}
