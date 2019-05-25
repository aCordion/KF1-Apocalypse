// Half-Life 2 weapons, written by Marco
// Unlimited ammo weapons.
Class HL2WeaponNA extends KFMeleeGun
	abstract;

var() Material CrosshairTexture;
var() bool bHasCrosshair;
var bool bIsPendingPutDown;

simulated event RenderOverlays(Canvas Canvas)
{
	if( bHasCrosshair && CrosshairTexture!=None )
	{
		Canvas.Style = ERenderStyle.STY_Alpha;
		Canvas.SetDrawColor(255,255,255,200);
		Canvas.SetPos((Canvas.ClipX-CrosshairTexture.MaterialUSize())>>1,(Canvas.ClipY-CrosshairTexture.MaterialVSize())>>1);
		Canvas.DrawTileScaled(CrosshairTexture,1,1);
	}
 	Super.RenderOverlays(Canvas);
}

exec function ReloadMeNow();

simulated function WeaponTick(float dt)
{
	Super.WeaponTick(dt);

	if( bIsPendingPutDown && !bIsReloading && FireMode[0].NextFireTime<Level.TimeSeconds
	 && FireMode[1].NextFireTime<Level.TimeSeconds )
	{
		bIsPendingPutDown = false;
		PutDown();
	}
}

static function PreloadAssets(Inventory Inv, optional bool bSkipRefCount);
static function bool UnloadAssets();
simulated function HandleSleeveSwapping();

// Modified to actually wait until firemodes has finished to stop from breaking.
simulated function bool PutDown()
{
	if( ClientState==WS_PutDown && TimerRate!=0 )
		return true;

	if( bIsReloading || FireMode[0].NextFireTime>Level.TimeSeconds || FireMode[1].NextFireTime>Level.TimeSeconds
		|| FireMode[0].IsFiring() || FireMode[1].IsFiring() )
	{
		InterruptReload();
		if( FireMode[0].IsFiring() )
			ClientStopFire(0);
		if( FireMode[1].IsFiring() )
			ClientStopFire(1);
		bIsPendingPutDown = true;
		return false;
	}
	bIsPendingPutDown = false;

	if( bAimingRifle )
		ZoomOut(False);

	if (Instigator.IsLocallyControlled())
	{
		if ( ClientState == WS_BringUp || KFPawn(Instigator).bIsQuickHealing > 0 )
			TweenAnim(SelectAnim,PutDownTime);
		else if ( HasAnim(PutDownAnim) )
		{
			if( ClientGrenadeState == GN_TempDown || KFPawn(Instigator).bIsQuickHealing > 0)
				PlayAnim(PutDownAnim, PutDownAnimRate * (PutDownTime/QuickPutDownTime), 0.0);
			else PlayAnim(PutDownAnim, PutDownAnimRate, 0.0);
		}
	}
	ClientState = WS_PutDown;

	if( ClientGrenadeState == GN_TempDown )
		SetTimer(QuickPutDownTime, false);
	else SetTimer(PutDownTime, false);
	return false;
}
simulated function BringUp(optional Weapon PrevWeapon)
{
	local byte Mode;

	if ( KFHumanPawn(Instigator) != none )
		KFHumanPawn(Instigator).SetAiming(false);

	bAimingRifle = false;
	bIsReloading = false;
	bIsPendingPutDown = false;

	// From Weapon.uc
    if ( ClientState == WS_Hidden || ClientGrenadeState == GN_BringUp || KFPawn(Instigator).bIsQuickHealing > 0 )
	{
		PlayOwnedSound(SelectSound, SLOT_Interact,,,,, false);

		if ( Instigator.IsLocallyControlled() && HasAnim(SelectAnim) )
		{
			if( ClientGrenadeState == GN_BringUp || KFPawn(Instigator).bIsQuickHealing > 0 )
				PlayAnim(SelectAnim, SelectAnimRate * (BringUpTime/QuickBringUpTime), 0.0);
			else PlayAnim(SelectAnim, SelectAnimRate, 0.0);
		}

		ClientState = WS_BringUp;
        if( ClientGrenadeState == GN_BringUp || KFPawn(Instigator).bIsQuickHealing > 0 )
		{
			ClientGrenadeState = GN_None;
			SetTimer(QuickBringUpTime, false);
		}
		else SetTimer(BringUpTime, false);
	}

	for( Mode = 0; Mode<NUM_FIRE_MODES; ++Mode )
	{
		FireMode[Mode].bIsFiring = false;
		FireMode[Mode].HoldTime = 0.0;
		FireMode[Mode].bServerDelayStartFire = false;
		FireMode[Mode].bServerDelayStopFire = false;
		FireMode[Mode].bInstantStop = false;
	}

	if ( (PrevWeapon != None) && PrevWeapon.HasAmmo() && !PrevWeapon.bNoVoluntarySwitch )
		OldWeapon = PrevWeapon;
	else OldWeapon = None;
}
simulated function bool ConsumeAmmo( int Mode, float Load, optional bool bAmountNeededIsMax )
{
	return true;
}

defaultproperties
{
     CrosshairTexture=Texture'ApocMutators.Icons.HL2Crosshair'
     bHasCrosshair=True
     SelectAnim="Draw"
     PutDownAnim="Holster"
     PlayerViewOffset=(X=-15.000000)
     DrawScale=1.500000
}
