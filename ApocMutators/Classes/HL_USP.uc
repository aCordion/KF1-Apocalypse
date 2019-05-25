Class HL_USP extends HL2Weapon;

var bool bZeroClipSet;

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
		{
			IdleAnim = 'IdleEmpty';
			SelectAnim = 'DrawEmpty';
			PutDownAnim = 'HolsterEmpty';
		}
		else
		{
			IdleAnim = Default.IdleAnim;
			SelectAnim = Default.SelectAnim;
			PutDownAnim = Default.PutDownAnim;
		}
	}
}

defaultproperties
{
     MagCapacity=18
     ReloadRate=1.500000
     FlashBoneName="Muzzle"
     WeaponReloadAnim="Reload_Single9mm"
     HudImage=Texture'HL2WeaponsA.Icons.I_USP'
     SelectedHudImage=Texture'HL2WeaponsA.Icons.I_USP'
     Weight=1.000000
     TraderInfoTexture=Texture'HL2WeaponsA.Icons.I_USP'
     FireModeClass(0)=Class'ApocMutators.USPFire'
     FireModeClass(1)=Class'KFMod.NoFire'
     BringUpTime=0.860000
     Description="A pistol."
     Priority=90
     InventoryGroup=2
     GroupOffset=4
     PickupClass=Class'ApocMutators.HL_USPPickup'
     PlayerViewPivot=(Yaw=32768)
     AttachmentClass=Class'ApocMutators.USPAttachment'
     ItemName="USP Match"
     Mesh=SkeletalMesh'HL2WeaponsA.HL_Pistol'
}
