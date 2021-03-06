class Rem870EC extends KFWeaponShotgun;

#exec OBJ LOAD FILE=Rem870_A.ukx

// Overridden to not take us out of ironsights when firing
simulated function WeaponTick(float dt)
{
	local float LastSeenSeconds,ReloadMulti;

	 if ( (Level.NetMode == NM_Client) || Instigator == None || KFFriendlyAI(Instigator.Controller) == none && Instigator.PlayerReplicationInfo == None)
		return;

	// Turn it off on death  / battery expenditure
	if (FlashLight != none)
	{
		// Keep the 1Pweapon client beam up to date.
		AdjustLightGraphic();
		if (FlashLight.bHasLight)
		{
			if (Instigator.Health <= 0 || KFHumanPawn(Instigator).TorchBatteryLife <= 0 || Instigator.PendingWeapon != none )
			{
				//Log("Killing Light...you're out of batteries, or switched / dropped weapons");
				KFHumanPawn(Instigator).bTorchOn = false;
				ServerSpawnLight();
			}
		}
	}

	UpdateMagCapacity(Instigator.PlayerReplicationInfo);

	if(!bIsReloading)
	{
		if(!Instigator.IsHumanControlled())
		{
			LastSeenSeconds = Level.TimeSeconds - Instigator.Controller.LastSeenTime;
			if(MagAmmoRemaining == 0 || ((LastSeenSeconds >= 5 || LastSeenSeconds > MagAmmoRemaining) && MagAmmoRemaining < MagCapacity))
				ReloadMeNow();
		}
	}
	else
	{
		if((Level.TimeSeconds - ReloadTimer) >= ReloadRate)
		{
			if(AmmoAmount(0) <= MagCapacity && !bHoldToReload)
			{
				MagAmmoRemaining = AmmoAmount(0);
				ActuallyFinishReloading();
			}
			else
			{
				if ( KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo) != none && KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill != none )
				{
					ReloadMulti = KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill.Static.GetReloadSpeedModifier(KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo), self);
				}
				else
				{
					ReloadMulti = 1.0;
				}

				AddReloadedAmmo();

				if( bHoldToReload )
                {
                    NumLoadedThisReload++;
                }

				if(MagAmmoRemaining < MagCapacity && MagAmmoRemaining < AmmoAmount(0) && bHoldToReload)
					ReloadTimer = Level.TimeSeconds;
				if(MagAmmoRemaining >= MagCapacity || MagAmmoRemaining >= AmmoAmount(0) || !bHoldToReload || bDoSingleReload)
					ActuallyFinishReloading();
				else if( Level.NetMode!=NM_Client )
					Instigator.SetAnimAction(WeaponReloadAnim);
			}
		}
		else if(bIsReloading && !bReloadEffectDone && Level.TimeSeconds - ReloadTimer >= ReloadRate / 2)
		{
			bReloadEffectDone = true;
			ClientReloadEffects();
		}
	}
}

// Copied from KFWeaponShotgun to support Achievements
simulated function AddReloadedAmmo()
{
    if(AmmoAmount(0) > 0)
        ++MagAmmoRemaining;

    // Don't do this on a "Hold to reload" weapon, as it can update too quick actually and cause issues maybe - Ramm
    if( !bHoldToReload )
    {
        ClientForceKFAmmoUpdate(MagAmmoRemaining,AmmoAmount(0));
    }

    if ( PlayerController(Instigator.Controller) != none && KFSteamStatsAndAchievements(PlayerController(Instigator.Controller).SteamStatsAndAchievements) != none )
    {
		KFSteamStatsAndAchievements(PlayerController(Instigator.Controller).SteamStatsAndAchievements).OnBenelliReloaded();
	}
}

simulated exec function IronSightZoomIn()
{
	if( bHasAimingMode )
	{
		if (Owner.Physics == PHYS_Falling)
			return;
/*
   		InterruptReload(); //Прерывание перезарядки
*/
		if( bIsReloading || !CanZoomNow() )
			return;

		PerformZoom(True);
	}
}

simulated function BringUp(optional Weapon PrevWeapon)
{
	local int Mode;
	local KFPlayerController Player;

	HandleSleeveSwapping();

	// Hint check
	Player = KFPlayerController(Instigator.Controller);

	if ( Player != none && ClientGrenadeState != GN_BringUp )
	{
		if ( class == class'Rem870EC' )
		{
			Player.CheckForHint(19);
			Player.WeaponPulloutRemark(23);
		}

		bShowPullOutHint = true;
	}

	if ( KFHumanPawn(Instigator) != none )
		KFHumanPawn(Instigator).SetAiming(false);

	bAimingRifle = false;
	bIsReloading = false;
	IdleAnim = default.IdleAnim;
	//Super.BringUp(PrevWeapon);

	// From Weapon.uc
    if ( ClientState == WS_Hidden || ClientGrenadeState == GN_BringUp || KFPawn(Instigator).bIsQuickHealing > 0 )
	{
		PlayOwnedSound(SelectSound, SLOT_Interact,,,,, false);
		ClientPlayForceFeedback(SelectForce);  // jdf

		if ( Instigator.IsLocallyControlled() )
		{
			if ( (Mesh!=None) && HasAnim(SelectAnim) )
			{
                if( ClientGrenadeState == GN_BringUp || KFPawn(Instigator).bIsQuickHealing > 0 )
				{
					PlayAnim(SelectAnim, SelectAnimRate * (BringUpTime/QuickBringUpTime), 0.0);
				}
				else
				{
					PlayAnim(SelectAnim, SelectAnimRate, 0.0);
				}
			}
		}

		ClientState = WS_BringUp;
        if( ClientGrenadeState == GN_BringUp || KFPawn(Instigator).bIsQuickHealing > 0 )
		{
			ClientGrenadeState = GN_None;
			SetTimer(QuickBringUpTime, false);
		}
		else
		{
			SetTimer(BringUpTime, false);
		}
	}

	for (Mode = 0; Mode < NUM_FIRE_MODES; Mode++)
	{
		FireMode[Mode].bIsFiring = false;
		FireMode[Mode].HoldTime = 0.0;
		FireMode[Mode].bServerDelayStartFire = false;
		FireMode[Mode].bServerDelayStopFire = false;
		FireMode[Mode].bInstantStop = false;
	}

	if ( (PrevWeapon != None) && PrevWeapon.HasAmmo() && !PrevWeapon.bNoVoluntarySwitch )
		OldWeapon = PrevWeapon;
	else
		OldWeapon = None;
}

defaultproperties
{
     FlashBoneName="tip1"
     MagCapacity=10
     ReloadRate=1.000000
     ReloadAnim="Reload"
     ReloadAnimRate=1.200000
     WeaponReloadAnim="Reload_Shotgun"
     Weight=10.000000
     bTorchEnabled=false
     bHasAimingMode=True
     IdleAimAnim="Idle_Iron"
     StandardDisplayFOV=65.000000
     bModeZeroCanDryFire=True
     SleeveNum=1
     TraderInfoTexture=Texture'Rem870_A.Rem870_Trader'
     Mesh=SkeletalMesh'Rem870_A.rem870_mesh'
     Skins(0)=Shader'Rem870_A.Rem870_T.Rem870_tex_shdr'
     Skins(1)=Texture'KF_Weapons3_Trip_T.hands.Priest_Hands_1st_P'
     Skins(2)=Combiner'KF_Weapons_Trip_T.Shotguns.shotgun_cmb'
     SelectSound=Sound'Rem870_A.Rem870_select'
     HudImage=Texture'Rem870_A.Rem870_Unselected'
     SelectedHudImage=Texture'Rem870_A.Rem870_selected'
     PlayerIronSightFOV=70.000000
     ZoomedDisplayFOV=40.000000
     FireModeClass(0)=Class'Rem870ECFire'
     FireModeClass(1)=Class'KFMod.NoFire'
     PutDownAnim="PutDown"
     AIRating=0.600000
     CurrentRating=0.600000
     bShowChargingBar=True
     Description="Охотничье ружье Remington 870 Express Combo американское ружье, впервые представленное компанией Remington Arms. Remington 870 благодаря своей характерной перезарядке является одним из самых знаменитых помповых ружей в мире."
     DisplayFOV=65.000000
     Priority=199
     InventoryGroup=4
     GroupOffset=9
     PickupClass=Class'Rem870ECPickup'
     PlayerViewOffset=(X=18.000000,Y=13.000000,Z=-8.000000)
     BobDamping=5.000000
     AttachmentClass=Class'Rem870ECAttachment'
     IconCoords=(X1=169,Y1=172,X2=245,Y2=208)
     ItemName="Remington 870 Express Combo"
     TransientSoundVolume=2.250000
}
