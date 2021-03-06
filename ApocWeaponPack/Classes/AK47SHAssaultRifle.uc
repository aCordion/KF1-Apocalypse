class AK47SHAssaultRifle extends KFWeapon
	config(user);

#exec OBJ LOAD FILE=KillingFloorWeapons.utx
#exec OBJ LOAD FILE=KillingFloorHUD.utx
#exec OBJ LOAD FILE=Inf_Weapons_Foley.uax
#exec OBJ LOAD FILE=AK47_T.utx
#exec OBJ LOAD FILE=AK47_Snd.uax
#exec OBJ LOAD FILE=AK47_sm.usx
#exec OBJ LOAD FILE=AK47_A.ukx

// Use alt fire to switch fire modes
simulated function AltFire(float F)
{
    if(ReadyToFire(0))
    {
        DoToggle();
    }
}

// Toggle semi/auto fire
simulated function DoToggle ()
{
	local PlayerController Player;

	Player = Level.GetLocalPlayerController();
	if ( Player!=None )
	{
		//PlayOwnedSound(sound'Inf_Weapons_Foley.stg44_firemodeswitch01',SLOT_None,2.0,,,,false);
		FireMode[0].bWaitForRelease = !FireMode[0].bWaitForRelease;
		if ( FireMode[0].bWaitForRelease )
			Player.ReceiveLocalizedMessage(class'KFmod.BullpupSwitchMessage',0);
		else Player.ReceiveLocalizedMessage(class'KFmod.BullpupSwitchMessage',1);
	}
	Super.DoToggle();

	ServerChangeFireMode(FireMode[0].bWaitForRelease);
}

// Set the new fire mode on the server
function ServerChangeFireMode(bool bNewWaitForRelease)
{
    FireMode[0].bWaitForRelease = bNewWaitForRelease;
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
     FlashBoneName="tip"
     BringUpTime=0.930000
     MagCapacity=30
     ReloadRate=3.000000
     ReloadAnim="Reload"
     ReloadAnimRate=1.00000
     WeaponReloadAnim="Reload_AK47"
     SelectAnimRate=1.300000
     Weight=6.000000
     bHasAimingMode=True
     IdleAimAnim="Iron_Idle"
     StandardDisplayFOV=65.000000
     bModeZeroCanDryFire=True
     TraderInfoTexture=Texture'AK47_T.AK47_Trader'
     SleeveNum=1
     bIsTier2Weapon=True
     Mesh=SkeletalMesh'AK47_A.ak47mesh'
	 DrawScale=1.0
     Skins(0)=Texture'AK47_T.7'
     Skins(1)=Texture'KF_Weapons3_Trip_T.hands.Priest_Hands_1st_P'
     Skins(2)=Texture'AK47_T.lastochka'
     Skins(3)=Texture'AK47_T.762x39_AP'
     Skins(4)=Texture'AK47_T.ak47'
     SelectSound=Sound'AK47_Snd.ak47_draw'
     HudImage=Texture'AK47_T.AK47_Unselected'
     SelectedHudImage=Texture'AK47_T.AK47_selected'
     PlayerIronSightFOV=65.000000
     ZoomedDisplayFOV=32.000000
     FireModeClass(0)=Class'AK47SHFire'
     FireModeClass(1)=Class'KFMod.NoFire'
     PutDownAnim="PutDown"
     SelectForce="SwitchToAssaultRifle"
     AIRating=0.550000
     CurrentRating=0.550000
     bShowChargingBar=True
     Description="7,62-мм автомат Калашникова (АК, индекс ГАУ — 56-А-212, часто называют АК-47) — автомат, разработанный Михаилом Калашниковым в 1947 и принятый на вооружение Советской Армии в 1949 году."
     EffectOffset=(X=100.000000,Y=25.000000,Z=-10.000000)
     DisplayFOV=65.000000
     Priority=95
     CustomCrosshair=11
     CustomCrossHairTextureName="Crosshairs.HUD.Crosshair_Cross5"
     InventoryGroup=3
     GroupOffset=7
     PickupClass=Class'AK47SHPickup'
     PlayerViewOffset=(X=12.500000,Y=10.000000,Z=-4.000000)
     BobDamping=5.000000
     AttachmentClass=Class'AK47SHAttachment'
     IconCoords=(X1=245,Y1=39,X2=329,Y2=79)
     ItemName="АК-47"
     TransientSoundVolume=1.250000
}
