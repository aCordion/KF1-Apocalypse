//=============================================================================
// M14 EBR Battle Rifle Inventory class
//=============================================================================
class MosinNagant extends KFWeapon
	config(user);

#exec OBJ LOAD FILE=MosinNagant_T.utx
#exec OBJ LOAD FILE=MosinNagant_S.uax
#exec OBJ LOAD FILE=MosinNagant_SM.usx
#exec OBJ LOAD FILE=MosinNagant_A.ukx

var()		name			EmptySelectAnim;
var()		name			NormalSelectAnim;

var			bool 			bIsNormal;


simulated function BringUp(optional Weapon PrevWeapon)
{

	local int Mode;
	local KFPlayerController Player;

	HandleSleeveSwapping();

	// Hint check
	Player = KFPlayerController(Instigator.Controller);

	if ( Player != none && ClientGrenadeState != GN_BringUp )
	{
		if ( class == class'Single' )
		{
			Player.CheckForHint(10);
		}
		else if ( class == class'Dualies' )
		{
			Player.CheckForHint(11);
		}
		else if ( class == class'Deagle' )
		{
			Player.CheckForHint(12);
		}
		else if ( class == class'Bullpup' )
		{
			Player.CheckForHint(13);
		}
		else if ( class == class'Shotgun' )
		{
			Player.CheckForHint(14);
		}
		else if ( class == class'Winchester' )
	   	{
			Player.CheckForHint(15);
		}
		else if ( class == class'Crossbow' )
	   	{
			Player.CheckForHint(16);
		}
		else if ( class == class'BoomStick' )
	   	{
			Player.CheckForHint(17);
			Player.WeaponPulloutRemark(21);
		}
		else if ( class == class'FlameThrower' )
	   	{
			Player.CheckForHint(18);
		}
		else if ( class == class'LAW' )
	   	{
			Player.CheckForHint(19);
			Player.WeaponPulloutRemark(23);
		}
		else if ( class == class'Knife' && bShowPullOutHint )
		{
			Player.CheckForHint(20);
		}
		else if ( class == class'Machete' )
		{
			Player.CheckForHint(21);
		}
		else if ( class == class'Axe' )
		{
			Player.CheckForHint(22);
			Player.WeaponPulloutRemark(24);
		}
		else if ( class == class'DualDeagle' || class == class'GoldenDualDeagle' )
		{
			Player.WeaponPulloutRemark(22);
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
			/*
                if( ClientGrenadeState == GN_BringUp || KFPawn(Instigator).bIsQuickHealing > 0 )
				{
					if (!bIsNormal)
					{
						if (MagAmmoRemaining>0)
						{
						PlayAnim(SelectAnim, SelectAnimRate * (BringUpTime/QuickBringUpTime), 0.0);
						}
						else
						{
						PlayAnim(EmptySelectAnim, SelectAnimRate * (BringUpTime/QuickBringUpTime), 0.0);
						}
					}
					else
					{
						PlayAnim(NormalSelectAnim, SelectAnimRate * (BringUpTime/QuickBringUpTime), 0.0);
					}
				}
				else
				{*/
					if (!bIsNormal)
					{
						if (MagAmmoRemaining>0)
						{
						PlayAnim(SelectAnim, SelectAnimRate, 0.0);
						}
						else
						{
						PlayAnim(EmptySelectAnim, SelectAnimRate, 0.0);
						}
					}
					else
					{
						PlayAnim(NormalSelectAnim, SelectAnimRate, 0.0);
					}
					/*
				}
				*/
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

function bool RecommendRangedAttack()
{
	return true;
}

//TODO: LONG ranged?
function bool RecommendLongRangedAttack()
{
	return true;
}

function float SuggestAttackStyle()
{
	return -1.0;
}

exec function SwitchModes()
{
	DoToggle();
}

function float GetAIRating()
{
	local Bot B;

	B = Bot(Instigator.Controller);
	if ( (B == None) || (B.Enemy == None) )
		return AIRating;

	return AIRating;
}

function byte BestMode()
{
	return 0;
}

simulated function SetZoomBlendColor(Canvas c)
{
	local Byte    val;
	local Color   clr;
	local Color   fog;

	clr.R = 255;
	clr.G = 255;
	clr.B = 255;
	clr.A = 255;

	if( Instigator.Region.Zone.bDistanceFog )
	{
		fog = Instigator.Region.Zone.DistanceFogColor;
		val = 0;
		val = Max( val, fog.R);
		val = Max( val, fog.G);
		val = Max( val, fog.B);
		if( val > 128 )
		{
			val -= 128;
			clr.R -= val;
			clr.G -= val;
			clr.B -= val;
		}
	}
	c.DrawColor = clr;
}

defaultproperties
{
	 bIsNormal=False
     MagCapacity=5
     ReloadRate=4.666666
	 ForceZoomOutOnFireTime=0.400000
     ReloadAnim="Reload"
     ReloadAnimRate=1.000000
     WeaponReloadAnim="Reload_M14"
     Weight=6.000000
	 Sleevenum=2
     bHasAimingMode=True
     IdleAimAnim="Idle_Iron"
	 NormalSelectAnim="Select_Normal"
     StandardDisplayFOV=55.000000
     bModeZeroCanDryFire=True
	 EmptySelectAnim="Select_Empty"
     TraderInfoTexture=Texture'MosinNagant_T.pic_trader'
     bIsTier2Weapon=True
     MeshRef="MosinNagant_A.nagant"
     SkinRefs(0)="MosinNagant_T.nagant_shdr"
	 SkinRefs(1)="MosinNagant_T.stripperclip"
     SelectSoundRef="KF_M14EBRSnd.M14EBR_Select"
     HudImageRef="MosinNagant_T.pic_unsel"
     SelectedHudImageRef="MosinNagant_T.pic_sel"
     PlayerIronSightFOV=60.000000
     ZoomedDisplayFOV=45.000000
	 BringUpTime=1.999999
     FireModeClass(0)=Class'MosinNagantFire'
     FireModeClass(1)=Class'KFMod.NoFire'
     PutDownAnim="PutDown"
     SelectForce="SwitchToAssaultRifle"
     AIRating=0.550000
     CurrentRating=0.550000
     bShowChargingBar=True
     Description="An excellent-to-use Russian rifle, typically used in many wars. Great for experienced riflemen."
     EffectOffset=(X=100.000000,Y=25.000000,Z=-10.000000)
     DisplayFOV=55.000000
     Priority=180
     CustomCrosshair=11
     CustomCrossHairTextureName="Crosshairs.HUD.Crosshair_Cross5"
     InventoryGroup=3
     GroupOffset=5
     PickupClass=Class'MosinNagantPickup'
     PlayerViewOffset=(X=25.000000,Y=17.000000,Z=-8.000000)
     BobDamping=6.000000
     AttachmentClass=Class'MosinNagantAttachment'
     IconCoords=(X1=245,Y1=39,X2=329,Y2=79)
     ItemName="Mosin Nagant"
     TransientSoundVolume=1.250000
}
