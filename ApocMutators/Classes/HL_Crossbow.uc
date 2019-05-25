Class HL_Crossbow extends HL2Weapon;

var() Material ZoomMat;
var bool bZeroClipSet;

simulated final function SetZoomBlendColor(Canvas c)
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
simulated event RenderOverlays(Canvas Canvas)
{
	if( bAimingRifle )
	{
		SetZoomBlendColor(Canvas);

		// Black-out either side of the main zoom circle.
		Canvas.Style = ERenderStyle.STY_Normal;
		Canvas.SetPos(0, 0);
		Canvas.DrawTile(ZoomMat, (Canvas.SizeX - Canvas.SizeY) / 2, Canvas.SizeY, 0.0, 0.0, 8, 8);
		Canvas.SetPos(Canvas.SizeX, 0);
		Canvas.DrawTile(ZoomMat, -(Canvas.SizeX - Canvas.SizeY) / 2, Canvas.SizeY, 0.0, 0.0, 8, 8);

		// The view through the scope itself.
		Canvas.Style = 255;
		Canvas.SetPos((Canvas.SizeX - Canvas.SizeY) / 2,0);
		Canvas.DrawTile(ZoomMat, Canvas.SizeY, Canvas.SizeY, 0.0, 0.0, 1024, 1024);
	}
 	else Super.RenderOverlays(Canvas);
}

simulated function bool ConsumeAmmo( int Mode, float Load, optional bool bAmountNeededIsMax )
{
	local bool bResult;
	
	bResult = Super.ConsumeAmmo(Mode,Load,bAmountNeededIsMax);
	if( Instigator.IsLocallyControlled() )
		SetClipStatus(MagAmmoRemaining==0);
	return bResult;
}
simulated function PostNetReceive()
{
	SetClipStatus(MagAmmoRemaining==0);
}
simulated function ClientReload()
{
	Super.ClientReload();
	SetClipStatus(false);
}
simulated function BringUp(optional Weapon PrevWeapon)
{
	SetClipStatus(MagAmmoRemaining==0);
	Super.BringUp(PrevWeapon);
}

simulated function SetClipStatus( bool bZeroClip )
{
	if( bZeroClipSet!=bZeroClip )
	{
		bZeroClipSet = bZeroClip;
		if( bZeroClip )
			SetBoneScale(0,0.f,'Bolt');
		else SetBoneScale(0,1.f,'Bolt');
	}
}

defaultproperties
{
     ZoomMat=FinalBlend'KillingFloorWeapons.Xbow.CommandoCrossFinalBlend'
     ReloadTweenTime=0.000000
     bHasScope=True
     MagCapacity=1
     ReloadRate=1.860000
     FlashBoneName="Spark2"
     WeaponReloadAnim="Reload_Crossbow"
     HudImage=Texture'HL2WeaponsA.Icons.I_Crossbow'
     SelectedHudImage=Texture'HL2WeaponsA.Icons.I_Crossbow'
     Weight=5.000000
     bHasAimingMode=True
     IdleAimAnim="Idle"
     TraderInfoTexture=Texture'HL2WeaponsA.Icons.I_Crossbow'
     PlayerIronSightFOV=32.000000
     FireModeClass(0)=Class'ApocMutators.CrossbowFireB'
     FireModeClass(1)=Class'KFMod.NoFire'
     Description="A crossbow."
     Priority=240
     InventoryGroup=4
     GroupOffset=6
     PickupClass=Class'ApocMutators.HL_CrossbowPickup'
     PlayerViewPivot=(Yaw=-16384)
     AttachmentClass=Class'ApocMutators.CrossbowAttachmentB'
     ItemName="Crossbow"
     Mesh=SkeletalMesh'HL2WeaponsA.HL_Crossbow'
}
