class WTFEquipBoomStick extends BoomStick;

simulated function WeaponTick(float dt)
{
	super(KFWeaponShotgun).WeaponTick(dt);

	if (bWaitingToLoadShotty)
	{
		CurrentReloadCountDown -= dt;

		if (CurrentReloadCountDown <= 0)
		{
			bWaitingToLoadShotty = false;
			bIsReloading = false; // set this here for the custom reload / shell swap functionality

			if (AmmoAmount(0) > 0)
			{
				MagAmmoRemaining = Min(AmmoAmount(0), 2);
				SingleShotCount = MagAmmoRemaining;
				ClientSetSingleShotCount(SingleShotCount);
				NetUpdateTime = Level.TimeSeconds - 1;
			}
		}
	}
}

function bool AllowReload()
{
	local KFPlayerReplicationInfo KFPRI;
	local WTFEquipBoomStickAltFire FM0;
	local WTFEquipBoomStickFire FM1;

	if (super(KFWeapon).AllowReload())
	{
		SetPendingReload();
		return true;
	}
	else if (!bIsReloading && (MagAmmoRemaining >= MagCapacity) && !IsFiring())
	{
		KFPRI = KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo);
		if (KFPRI == none || KFPRI.ClientVeteranSkill != Class'SRVetSupportSpec')
			return false;

		FM0 = WTFEquipBoomStickAltFire(FireMode[0]);
		FM1 = WTFEquipBoomStickFire(FireMode[1]);

		if (FM0.GetShellType() == 1)
		{
			PlayerController(Instigator.Controller).ReceiveLocalizedMessage(Class'ApocMutators.WTFEquipBoomstickSwitchMessage', 0); // loading slugs
			FM0.SetShellType(0);
			FM1.SetShellType(0);
		}
		else
		{
			PlayerController(Instigator.Controller).ReceiveLocalizedMessage(Class'ApocMutators.WTFEquipBoomstickSwitchMessage', 1); // loading shot
			FM0.SetShellType(1);
			FM1.SetShellType(1);
		}
		SetPendingReload();
		return true;
	}
	return false;
}

defaultproperties
{
	 ReloadRate=30.000000
	 ReloadAnim="Fire_Last"
	 WeaponReloadAnim="Fire_Last"
	 FireModeClass(0)=Class'ApocMutators.WTFEquipBoomStickAltFire'
	 FireModeClass(1)=Class'ApocMutators.WTFEquipBoomStickFire'
	 Description="A deadly weapon"
	 PickupClass=Class'ApocMutators.WTFEquipBoomStickPickup'
	 ItemName="BOOMSTICK"
}
