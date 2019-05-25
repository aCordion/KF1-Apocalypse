class WTFEquipMachinePistolFire extends BullpupFire;

var bool bMedicNoWaitForRelease; // used in WTFEquipHCFire

event ModeDoFire()
{
	local float Rec;
	local KFPlayerReplicationInfo KFPRI;

	if (!AllowFire())
		return;

	if (Instigator == None || Instigator.Controller == none)
		return;

	Spread = GetSpread();

	Rec = GetFireSpeed();
	FireRate = default.FireRate / Rec;
	FireAnimRate = default.FireAnimRate * Rec;
	ReloadAnimRate = default.ReloadAnimRate * Rec;
	Rec = 1;

	if (KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo) != none && KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill != none)
	{
		Spread *= KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill.Static.ModifyRecoilSpread(KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo), self, Rec);
	}

	LastFireTime = Level.TimeSeconds;

	KFPRI = KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo);
	if (Weapon.Owner != none && AllowFire() && !bFiringDoesntAffectMovement)
	{
		if (bMedicNoWaitForRelease)
		{
			bWaitForRelease=False;
		}
		 //medics are not slowed down by firing this weapon, or dualies, which extends this class of firemode
		if (KFPRI == None || KFPRI.ClientVeteranSkill != Class'SRVetFieldMedic')
		{
			bWaitForRelease=Default.bWaitForRelease;
			Weapon.Owner.Velocity.x *= 0.5;
			Weapon.Owner.Velocity.y *= 0.5;
		}
	}

	Super(InstantFire).ModeDoFire();

	// client
	if (Instigator.IsLocallyControlled())
	{
		if (bDoClientRagdollShotFX && Weapon.Level.NetMode == NM_Client)
		{
			DoClientOnlyFireEffect();
		}
		HandleRecoil(Rec);
	}
}

// Handle setting the recoil amount
simulated function HandleRecoil(float Rec)
{
	local rotator NewRecoilRotation;
	local KFPlayerController KFPC;
	local KFPawn KFPwn;
	local KFPlayerReplicationInfo KFPRI;

	if (Instigator != none)
	{
		KFPC = KFPlayerController(Instigator.Controller);
		KFPwn = KFPawn(Instigator);
	}

	if (KFPC == none || KFPwn == none)
		return;

	if (!KFPC.bFreeCamera)
	{
		if (Weapon.GetFireMode(0).bIsFiring || (DeagleAltFire(Weapon.GetFireMode(1)) != none
		 && DeagleAltFire(Weapon.GetFireMode(1)).bIsFiring))
		{
			  NewRecoilRotation.Pitch = RandRange(maxVerticalRecoilAngle * 0.5, maxVerticalRecoilAngle);
			 NewRecoilRotation.Yaw = RandRange(maxHorizontalRecoilAngle * 0.5, maxHorizontalRecoilAngle);

			  if (Rand(2) == 1)
				 NewRecoilRotation.Yaw *= -1;

			KFPRI = KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo);

			 //movement does not factor into recoil on this weapon for medics
			if (KFPRI == None || KFPRI.ClientVeteranSkill != Class'SRVetFieldMedic')
			{
				NewRecoilRotation.Pitch += (VSize(Weapon.Owner.Velocity) *  3);
				NewRecoilRotation.Yaw += (VSize(Weapon.Owner.Velocity) *  3);
			}
			NewRecoilRotation.Pitch += (Instigator.HealthMax / Instigator.Health * 5);
			NewRecoilRotation.Yaw += (Instigator.HealthMax / Instigator.Health * 5);
			NewRecoilRotation *= Rec;

			 KFPC.SetRecoil(NewRecoilRotation, RecoilRate  / (default.FireRate / FireRate));
		}
	 }
}

defaultproperties
{
	 ShellEjectClass=Class'ROEffects.KFShellEject9mm'
	 ShellEjectBoneName="Shell_eject"
	 StereoFireSound=SoundGroup'KF_9MMSnd.9mm_FireST'
	 DamageType=Class'KFMod.DamTypeDualies'
	 DamageMin=25
	 DamageMax=35
	 Momentum=10000.000000
	 FireSound=SoundGroup'KF_9MMSnd.9mm_Fire'
	 FireRate=0.120000
	 AmmoClass=Class'KFMod.SingleAmmo'
	 aimerror=30.000000
	 Spread=0.015000
}
