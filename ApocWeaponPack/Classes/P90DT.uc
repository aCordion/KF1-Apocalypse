class P90DT extends KFWeapon
	config(user);

#exec OBJ LOAD FILE=P90DT_A.ukx

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
     //BringUpTime=0.930000
     MagCapacity=50
     ReloadRate=3.700000
     ReloadAnim="Reload"
     ReloadAnimRate=1.00000
     WeaponReloadAnim="Reload_Crossbow"
     SelectAnimRate=1.000000
     Weight=5.000000
     bHasAimingMode=True
     IdleAimAnim="IronIdle"
     StandardDisplayFOV=65.000000
     bModeZeroCanDryFire=True
     TraderInfoTexture=Texture'P90DT_A.P90_T.P90_trader'
     SleeveNum=2
     bIsTier2Weapon=True
     Mesh=SkeletalMesh'P90DT_A.P90DTMesh'
	 DrawScale=1.0
     Skins(0)=Shader'P90DT_A.P90_T.wpn_p90_sh'
     Skins(1)=Shader'KF_Weapons2_Trip_T.Special.Aimpoint_sight_shdr'
     Skins(2)=Combiner'KF_Weapons_Trip_T.hands.hands_1stP_military_cmb'
     SelectSound=Sound'P90DT_A.P90DT_SND.p90_select'
     HudImage=Texture'P90DT_A.P90_T.P90_Unselected'
     SelectedHudImage=Texture'P90DT_A.P90_T.P90_Selected'
     PlayerIronSightFOV=65.000000
     ZoomedDisplayFOV=32.000000
     FireModeClass(0)=Class'P90DTFire'
     FireModeClass(1)=Class'KFMod.NoFire'
     PutDownAnim="PutDown"
     SelectForce="SwitchToAssaultRifle"
     AIRating=0.550000
     CurrentRating=0.550000
     bShowChargingBar=True
     Description="FN P90 - бельгийский пистолет-пулемет (персональное оружие самообороны), разработанный в 1986-1987 годах фирмой FN Herstal. Был разработан, в первую очередь, для танкистов и водителей боевых автомобилей."
     EffectOffset=(X=100.000000,Y=25.000000,Z=-10.000000)
     DisplayFOV=65.000000
     Priority=100
     CustomCrosshair=11
     CustomCrossHairTextureName="Crosshairs.HUD.Crosshair_Cross5"
     InventoryGroup=4
     GroupOffset=7
     PickupClass=Class'P90DTPickup'
     PlayerViewOffset=(X=25.500000,Y=11.000000,Z=0.000000)
     BobDamping=5.000000
     AttachmentClass=Class'P90DTAttachment'
     IconCoords=(X1=245,Y1=39,X2=329,Y2=79)
     ItemName="FN P90"
     TransientSoundVolume=1.250000
}
