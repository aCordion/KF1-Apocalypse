class HK417Fire extends KFFire;

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

    if(HK417(Weapon).bBulletType)
{
	DamageType=Class'DamTypeHK417';
	maxVerticalRecoilAngle=1000;
	maxHorizontalRecoilAngle=500;
	FireRate=0.200000;
	RecoilRate=0.100000;
	DamageMin=250; //80; //kyan
	DamageMax=250; //90;
	bWaitForRelease=True;
	aimerror=60.000000;
	Spread=0.002000;
    Weapon.ItemName=Weapon.default.ItemName $ "(Semi-auto)";
}  
  else
{
	DamageType=Class'DamTypeHK417';
	maxVerticalRecoilAngle=800;
	maxHorizontalRecoilAngle=400;
	FireRate=0.230000;
	RecoilRate=0.130000;
	DamageMin=250; //60; //kyan
	DamageMax=250; //70;
	bWaitForRelease=False;
	aimerror=42.000000;
	Spread=0.008000;
    Weapon.ItemName=Weapon.default.ItemName $ "(Auto)";
}

	return super(WeaponFire).AllowFire();
}

defaultproperties
{
     FireAimedAnim="Iron_Idle"
     RecoilRate=0.100000
     maxVerticalRecoilAngle=1500
     maxHorizontalRecoilAngle=500
	 ShellEjectClass=Class'ROEffects.KFShellEjectAK'
     ShellEjectBoneName="Shell_eject"
     FireSound=Sound'HK417_A.HK417_shot'
     StereoFireSound=Sound'HK417_A.HK417_shot'
     NoAmmoSound=Sound'HK417_A.HK417_empty'
     DamageType=Class'DamTypeHK417'
     DamageMin=250 //75 //kyan
     DamageMax=250 //85
     Momentum=20000.000000
     bPawnRapidFireAnim=True
     bWaitForRelease=True
     TransientSoundVolume=1.800000
     FireLoopAnim="Fire"
     TweenTime=0.025000
     FireForce="AssaultRifleFire"
     FireRate=0.230000
     AmmoClass=Class'HK417Ammo'
     AmmoPerFire=1
     ShakeRotMag=(X=50.000000,Y=50.000000,Z=300.000000)
     ShakeRotRate=(X=9500.000000,Y=9500.000000,Z=9500.000000)
     ShakeRotTime=0.650000
     ShakeOffsetMag=(X=3.000000,Y=3.000000,Z=3.000000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ShakeOffsetTime=1.250000
     BotRefireRate=0.990000
     FlashEmitterClass=Class'ROEffects.MuzzleFlash1stSTG'
     aimerror=60.000000
     Spread=0.002000
     SpreadStyle=SS_Random
}
