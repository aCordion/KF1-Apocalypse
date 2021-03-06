class ThompsonV2SubmachineGun extends KFWeapon
	config(user);

#exec OBJ LOAD FILE=KillingFloorWeapons.utx
#exec OBJ LOAD FILE=KillingFloorHUD.utx
#exec OBJ LOAD FILE=Inf_Weapons_Foley.uax
#exec OBJ LOAD FILE=ThompsonV2_T.utx
#exec OBJ LOAD FILE=ThompsonV2_Snd.uax
#exec OBJ LOAD FILE=ThompsonV2_sm.usx
#exec OBJ LOAD FILE=ThompsonV2_A.ukx

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
     MagCapacity=30
     ReloadRate=3.000000
     ReloadAnim="Reload"
     ReloadAnimRate=1.00000
     WeaponReloadAnim="Reload_AK47"
     Weight=4.000000
     bHasAimingMode=True
     IdleAimAnim="Iron_Idle"
     StandardDisplayFOV=65.000000
     bModeZeroCanDryFire=True
     TraderInfoTexture=Texture'ThompsonV2_T.ThompsonV2_Trader'
     SleeveNum=1
     bIsTier2Weapon=True
     Mesh=SkeletalMesh'ThompsonV2_A.tommy_mesh'
     Skins(0)=Texture'ThompsonV2_T.thomp_skin'
     Skins(1)=Combiner'KF_Weapons_Trip_T.hands.hands_1stP_military_cmb'
     SelectSound=Sound'ThompsonV2_Snd.ThompsonV2_select'
     HudImage=Texture'ThompsonV2_T.ThompsonV2_Unselected'
     SelectedHudImage=Texture'ThompsonV2_T.ThompsonV2_selected'
     PlayerIronSightFOV=65.000000
     ZoomedDisplayFOV=32.000000
     FireModeClass(0)=Class'ThompsonV2Fire'
     FireModeClass(1)=Class'KFMod.NoFire'
     PutDownAnim="PutDown"
     SelectForce="SwitchToAssaultRifle"
     AIRating=0.550000
     CurrentRating=0.550000
     bShowChargingBar=True
     Description="Американский пистолет-пулемёт, разработанный компанией Auto-Ordnance в 1917 году и активно применявшийся во время Второй мировой войны."
     EffectOffset=(X=100.000000,Y=25.000000,Z=-10.000000)
     DisplayFOV=65.000000
     Priority=90
     CustomCrosshair=11
     CustomCrossHairTextureName="Crosshairs.HUD.Crosshair_Cross5"
     InventoryGroup=3
     GroupOffset=7
     PickupClass=Class'ThompsonV2Pickup'
     PlayerViewOffset=(X=10.000000,Y=9.000000,Z=-3.000000)
     BobDamping=4.000000
     AttachmentClass=Class'ThompsonV2Attachment'
     IconCoords=(X1=245,Y1=39,X2=329,Y2=79)
     ItemName="«ПП Томпсона M1»"
     TransientSoundVolume=1.250000
}
