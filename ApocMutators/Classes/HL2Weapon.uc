// Half-Life 2 weapons, written by Marco
Class HL2Weapon extends KFWeapon
	abstract;

var() Material CrosshairTexture;
var() float ReloadTweenTime;
var() bool bCanScavengeAmmo,bHasCrosshair;
var bool bIsPendingPutDown;

#exec obj load file="HL2WeaponsA.ukx"
#exec obj load file="HL2WeaponsS.uax"
#exec TEXTURE IMPORT FILE="Assets/SentryTech/XHair.bmp" NAME="HL2Crosshair" GROUP="Icons" MIPS=0 MASKED=1

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
function bool HandlePickupQuery( pickup Item )
{
	if ( Item.InventoryType==Class )
	{
		if( !bCanScavengeAmmo || AmmoAmount(0)>=MaxAmmo(0) )
		{
			if( LastHasGunMsgTime<Level.TimeSeconds && PlayerController(Instigator.Controller)!=none )
			{
				LastHasGunMsgTime = Level.TimeSeconds+0.5;
				PlayerController(Instigator.Controller).ReceiveLocalizedMessage(Class'KFMainMessages',1);
			}
			return true;
		}
	}
	return Super(Weapon).HandlePickupQuery(Item);
}

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

simulated function ClientFinishReloading()
{
	bIsReloading = false;
	PlayIdle();
}

simulated final function float GetReloadRate()
{
	if ( KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo) != none && KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill != none )
		return KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill.Static.GetReloadSpeedModifier(KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo), self);
	return 1.0;
}
simulated function ClientReload()
{
	if( bHasAimingMode && bAimingRifle )
	{
		FireMode[1].bIsFiring = False;
		ZoomOut(false);
		if( Role < ROLE_Authority)
			ServerZoomOut(false);
	}
	// Avoid making reload noises whenever possible.
	if( Instigator==None || !Instigator.IsLocallyControlled() || !Instigator.IsFirstPerson() )
		return;

	bIsReloading = true;
	PlayAnim(ReloadAnim, ReloadAnimRate*GetReloadRate(), ReloadTweenTime);
}

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

// Always auto-switch weapon if old one is destroyed in the hand.
simulated function Destroyed()
{
	local Pawn P;

	if( Instigator!=None && Instigator.Controller!=None && Instigator.Weapon==Self && Instigator.IsLocallyControlled() )
		P = Instigator;
    Super.Destroyed();
	if( P!=None )
	{
		P.Weapon = None;
		P.Controller.SwitchToBestWeapon();
	}
}

defaultproperties
{
     CrosshairTexture=Texture'ApocMutators.Icons.HL2Crosshair'
     ReloadTweenTime=0.100000
     bHasCrosshair=True
     ReloadAnim="Reload"
     ReloadAnimRate=1.000000
     bModeZeroCanDryFire=True
     SelectAnim="Draw"
     PutDownAnim="Holster"
     PlayerViewOffset=(X=-15.000000)
     DrawScale=1.500000
}
