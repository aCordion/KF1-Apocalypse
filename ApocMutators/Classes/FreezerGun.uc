class FreezerGun extends KFWeapon;

#exec OBJ LOAD FILE=IJC_Project_Santa_A.ukx

var ScriptedTexture MyScriptedTexture;
var string MyMessage;
var   Font MyFont;
var   Font SmallMyFont;
var  color MyFontColor;

var int OldValue;
var localized   string  ReloadMessage;
var localized   string  EmptyMessage;

var array<Material> GlowSkins; // 0 - glow off, length-1 - all lights on
/*
simulated function PostNetBeginPlay()
{
    Super.PostNetBeginPlay();
    ;   // this spawns a unquie Scripted texture for us to use
    MyFont = Font(DynamicLoadObject("IJCFonts.DigitalBig", class'Font', true));
    SmallMyFont = Font(DynamicLoadObject("IJCFonts.DigitalMed", class'Font', true));
}

static function PreloadAssets(Inventory Inv, optional bool bSkipRefCount)
{

	//default.MyScriptedTexture = ScriptedTexture(DynamicLoadObject("IJC_Project_Santa_A.Counter.Counter_Scripted", class'ScriptedTexture', true));
	default.SmallMyFont = Font(DynamicLoadObject("IJCFonts.DigitalMed", class'Font', true));
	default.MyFont = Font(DynamicLoadObject("IJCFonts.DigitalBig", class'Font', true));

	if ( FreezerGun(Inv) != none )
	{

		//FreezerGun(Inv).MyScriptedTexture = default.MyScriptedTexture;
		FreezerGun(Inv).SmallMyFont = default.SmallMyFont;
		FreezerGun(Inv).MyFont = default.MyFont;
	}

	super.PreloadAssets(Inv, bSkipRefCount);
}

static function bool UnloadAssets()
{
	if ( super.UnloadAssets() )
	{
    	//default.MyScriptedTexture = none;
    	default.SmallMyFont = none;
    	default.MyFont = none;
		return true;
	}

	return false;
}
*/

simulated final function SetTextColor( byte R, byte G, byte B )
{
	MyFontColor.R = R;
	MyFontColor.G = G;
	MyFontColor.B = B;
	MyFontColor.A = 255;
}


 simulated function RenderOverlays( Canvas Canvas )
{
	if( MagAmmoRemaining <= 0 )
	{
		if( OldValue!=-5 )
		{
			OldValue = -5;
			MyFont = SmallMyFont;
			SetTextColor(218,18,18);
			MyMessage = EmptyMessage;
			++MyScriptedTexture.Revision;
            GlowOff();
		}
	}
	else if( bIsReloading )
	{
		if( OldValue!=-4 )
		{
			OldValue = -4;
			MyFont = SmallMyFont;
			SetTextColor(30,38,43);
			MyMessage = ReloadMessage;
			++MyScriptedTexture.Revision;
		}
	}
	else if( OldValue!=AmmoAmount(0)*100+MagAmmoRemaining )
	{
		OldValue = AmmoAmount(0)*100+MagAmmoRemaining;
		MyFont = SmallMyFont;

		//if ((MagAmmoRemaining ) <= (MagCapacity/2))
		//	SetTextColor(32,60,77);
		if ( MagAmmoRemaining < 30 )
			SetTextColor(224,44,56);
		else
			SetTextColor(30,38,43);
		MyMessage = MagAmmoRemaining$" / " $ (AmmoAmount(0) - MagAmmoRemaining);
		++MyScriptedTexture.Revision;
        // glowstage
        GlowStage(MagAmmoRemaining/15 + 1);
	}

	MyScriptedTexture.Client = Self;
	Super.RenderOverlays(Canvas);
	MyScriptedTexture.Client = None;
}

simulated function RenderTexture( ScriptedTexture Tex )
{
	local int w, h;

	// Ammo     - ( w / 2 )    - ( h / 1.2 )
	Tex.TextSize( MyMessage, MyFont, w, h );
	Tex.DrawText( ( Tex.USize / 2.4) - ( w / 2 ), (Tex.VSize / 2 ) - ( h / 2 ),MyMessage, MyFont, MyFontColor );
}


simulated function bool ConsumeAmmo( int Mode, float Load, optional bool bAmountNeededIsMax )
{
	local Inventory Inv;
	local bool bOutOfAmmo;
	local KFWeapon KFWeap;

    if ( Load > 0 )
        Load = FireMode[Mode].AmmoPerFire;
	if ( Super(Weapon).ConsumeAmmo(Mode, Load, bAmountNeededIsMax) )
	{
		if ( Load > 0 && (Mode == 0 || bReduceMagAmmoOnSecondaryFire) ) {
			MagAmmoRemaining -= Load; // Changed from "MagAmmoRemaining--"  -- PooSH
            if ( MagAmmoRemaining < 0 )
                MagAmmoRemaining = 0;
        }
        if ( MagAmmoRemaining == 0 )
            GlowOff();

		NetUpdateTime = Level.TimeSeconds - 1;

		if ( FireMode[Mode].AmmoPerFire > 0 && InventoryGroup > 0 && !bMeleeWeapon && bConsumesPhysicalAmmo
            && (Ammo[0] == none || FireMode[0] == none || FireMode[0].AmmoPerFire <= 0 || Ammo[0].AmmoAmount < FireMode[0].AmmoPerFire)
            && (Ammo[1] == none || FireMode[1] == none || FireMode[1].AmmoPerFire <= 0 || Ammo[1].AmmoAmount < FireMode[1].AmmoPerFire) )
		{
			bOutOfAmmo = true;

			for ( Inv = Instigator.Inventory; Inv != none; Inv = Inv.Inventory )
			{
				KFWeap = KFWeapon(Inv);

				if ( Inv.InventoryGroup > 0 && KFWeap != none && !KFWeap.bMeleeWeapon && KFWeap.bConsumesPhysicalAmmo &&
					 ((KFWeap.Ammo[0] != none && KFWeap.FireMode[0] != none && KFWeap.FireMode[0].AmmoPerFire > 0 &&KFWeap.Ammo[0].AmmoAmount >= KFWeap.FireMode[0].AmmoPerFire) ||
					 (KFWeap.Ammo[1] != none && KFWeap.FireMode[1] != none && KFWeap.FireMode[1].AmmoPerFire > 0 && KFWeap.Ammo[1].AmmoAmount >= KFWeap.FireMode[1].AmmoPerFire)) )
				{
					bOutOfAmmo = false;
					break;
				}
			}

			if ( bOutOfAmmo )
			{
				PlayerController(Instigator.Controller).Speech('AUTO', 3, "");
			}
		}

		return true;
	}
	return false;
}

simulated function bool StartFire(int Mode)
{
	if( Mode == 0 )
		return super.StartFire(Mode);

	if( !super.StartFire(Mode) )  // returns false when mag is empty
	   return false;

	if( AmmoAmount(Mode) <= 0 )
    	return false;

	AnimStopLooping();

	if( !FireMode[Mode].IsInState('FireLoop') && (AmmoAmount(Mode) > 0) )
	{
		FireMode[Mode].StartFiring();
		return true;
	}
	else
	{
		return false;
	}

	return true;
}

simulated function AnimEnd(int channel)
{
	if(!FireMode[1].IsInState('FireLoop'))
	{
	  	Super.AnimEnd(channel);
	}
}

// Allow this weapon to auto reload on alt fire
simulated function Fire(float F)
{
	if( MagAmmoRemaining < FireMode[0].AmmoPerFire && !bIsReloading &&
		 FireMode[0].NextFireTime <= Level.TimeSeconds )
	{
		// We're dry, ask the server to autoreload
		ServerRequestAutoReload();

		PlayOwnedSound(FireMode[0].NoAmmoSound,SLOT_None,2.0,,,,false);
	}

	super.Fire(F);
}

simulated function AltFire(float F)
{
	if( MagAmmoRemaining < FireMode[1].AmmoPerFire && !bIsReloading &&
		 FireMode[1].NextFireTime <= Level.TimeSeconds )
	{
		// We're dry, ask the server to autoreload
		ServerRequestAutoReload();

		PlayOwnedSound(FireMode[1].NoAmmoSound,SLOT_None,2.0,,,,false);
	}

	super.AltFire(F);
}

simulated function ClientFinishReloading()
{
	bIsReloading = false;

    // Reload animation longs 4.5s while weapon becomes ready in 3.6s
    // Continue animation for last 0.9s if player is not shooting
    // -- PooSH
	//PlayIdle();
    SetTimer(0.9, false);

	if(Instigator.PendingWeapon != none && Instigator.PendingWeapon != self)
		Instigator.Controller.ClientSwitchToBestWeapon();
}

simulated function GlowOn()
{
    GlowStage(255);
    Skins[0] = Shader'IJC_Project_Santa_A.FreezerGun.FreezerGun_shdr';
}

simulated function GlowOff()
{
    GlowStage(0);
    Skins[0] = Shader'IJC_Project_Santa_A.FreezerGun.FreezerGun_shdr_off';
}

simulated function GlowStage(byte Stage)
{
    Skins[0] = GlowSkins[min(Stage,GlowSkins.length-1)];
}

simulated function Timer()
{
    if ( ClientState == WS_ReadyToFire )
        PlayIdle();
    else
        super.Timer();
}

defaultproperties
{
     MyScriptedTexture=ScriptedTexture'IJC_Project_Santa_A.Counter.Counter_Scripted'
     MyFont=Font'IJCFonts.DigitalBig'
     SmallMyFont=Font'IJCFonts.DigitalMed'
     MyFontColor=(B=177,G=148,R=76,A=255)
     ReloadMessage="REL"
     EmptyMessage="---"
     GlowSkins(0)=Shader'IJC_Project_Santa_A.FreezerGun.FreezerGun_shdr_off'
     GlowSkins(1)=Shader'IJC_Project_Santa_A.FreezerGun.FreezerGun_shdr_1'
     GlowSkins(2)=Shader'IJC_Project_Santa_A.FreezerGun.FreezerGun_shdr_2'
     GlowSkins(3)=Shader'IJC_Project_Santa_A.FreezerGun.FreezerGun_shdr_3'
     GlowSkins(4)=Shader'IJC_Project_Santa_A.FreezerGun.FreezerGun_shdr'
     MagCapacity=90
     ReloadRate=3.600000
     ReloadAnim="Reload"
     ReloadAnimRate=1.000000
     WeaponReloadAnim="Reload_M7A3"
     HudImage=Texture'IJC_Project_Santa_A.HUD.FreezerGun_Unselected'
     SelectedHudImage=Texture'IJC_Project_Santa_A.HUD.FreezerGun'
     Weight=7.000000
     bHasAimingMode=True
     IdleAimAnim="Idle_Iron"
     StandardDisplayFOV=65.000000
     bModeZeroCanDryFire=True
     SleeveNum=3
     TraderInfoTexture=Texture'IJC_Project_Santa_A.HUD.Trader_FreezerGun'
     bIsTier3Weapon=True
     PlayerIronSightFOV=70.000000
     ZoomedDisplayFOV=40.000000
     FireModeClass(0)=Class'FreezerFire'
     FireModeClass(1)=Class'FreezerAltFire'
     PutDownAnim="PutDown"
     SelectSound=Sound'KF_NailShotgun.Handling.KF_NailShotgun_Pickup'
     SelectForce="SwitchToAssaultRifle"
     AIRating=0.550000
     CurrentRating=0.550000
     bShowChargingBar=True
     Description="Horzine N600-F2-V014.REV2 Cryogenic Device or simply a 'Freezer Gun' is developed to ... blah blah glah ... freeze zeds"
     EffectOffset=(X=100.000000,Y=25.000000,Z=-10.000000)
     DisplayFOV=65.000000
     Priority=150
     InventoryGroup=3
     GroupOffset=15
     PickupClass=Class'FreezerPickup'
     PlayerViewOffset=(X=25.000000,Y=23.000000,Z=-5.000000)
     BobDamping=4.500000
     AttachmentClass=Class'FreezerAttachment'
     IconCoords=(X1=245,Y1=39,X2=329,Y2=79)
     ItemName="Cryo Mass Driver 14"
     Mesh=SkeletalMesh'IJC_Project_Santa_A.FreezerGun'
     Skins(0)=Shader'IJC_Project_Santa_A.FreezerGun.FreezerGun_shdr'
     Skins(1)=Shader'IJC_Project_Santa_A.Counter.Counter_Shdr'
     Skins(2)=Shader'IJC_Project_Santa_A.FreezerGun.FreezerGun_Sight_shdr'
     TransientSoundVolume=1.250000
}
