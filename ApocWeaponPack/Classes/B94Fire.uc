class B94Fire extends KFShotgunFire;


simulated function bool AllowFire()
{


	if(KFWeapon(Weapon).bIsReloading)
		return false;
	if(KFPawn(Instigator).SecondaryItem!=none)
		return false;
	if(KFPawn(Instigator).bThrowingNade)
		return false;

	if(KFWeapon(Weapon).MagAmmoRemaining < 1)
	{
    	if( Level.TimeSeconds - LastClickTime>FireRate )
    	{
    		LastClickTime = Level.TimeSeconds;
    	}

		if( AIController(Instigator.Controller)!=None )
			KFWeapon(Weapon).ReloadMeNow();
		return false;
	}

	return super(WeaponFire).AllowFire();
}

function float MaxRange()
{
    return 25000;
}

function DoFireEffect()
{
   Super(KFShotgunFire).DoFireEffect();
}

function DrawMuzzleFlash(Canvas Canvas)
{
    super.DrawMuzzleFlash(Canvas);

}

function FlashMuzzleFlash()
{
    super.FlashMuzzleFlash();

}

defaultproperties
{
     EffectiveRange=25000.000000
     RecoilRate=0.100000
     maxVerticalRecoilAngle=4000
     maxHorizontalRecoilAngle=90
     FireAimedAnim="Fire"
     StereoFireSound=Sound'B94_SN.b94_shoot_stereo'
     ProjPerFire=1
     ProjSpawnOffset=(Y=0.000000,Z=0.000000)
     bWaitForRelease=True
     bModeExclusive=False
     TransientSoundVolume=2.800000
     FireLoopAnim=
     FireSound=Sound'B94_SN.b94_shoot_mono'
     NoAmmoSound=Sound'B94_SN.empty'
     FireForce="ShockRifleFire"
     FireRate=1.800000
     AmmoClass=Class'B94Ammo'
     ShakeRotMag=(X=100.000000,Y=100.000000,Z=500.000000)
     ShakeRotRate=(X=10000.000000,Y=10000.000000,Z=10000.000000)
     ShakeRotTime=2.000000
     ShakeOffsetMag=(X=10.000000,Y=3.000000,Z=12.000000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     KickMomentum=(X=-350.000000,Z=176.000000)
     ShakeOffsetTime=2.000000
     ProjectileClass=Class'B94Bullet'
     BotRefireRate=3.750000
     FlashEmitterClass=Class'B94MuzzleFlash1st'
     aimerror=0.000000
     Spread=0.000000
}
