Class HL_BugBait extends HL2Weapon;

exec function ReloadMeNow();

simulated function AnimEnd(int channel)
{
	local name anim;
	local float frame, rate;

	GetAnimParams(0, anim, frame, rate);

	if (ClientState == WS_ReadyToFire)
	{
		if( anim=='Throw' && ammoAmount(0)>0 )
			PlayAnim(SelectAnim, SelectAnimRate, 0.1);
		else if( !FireMode[0].bIsFiring && !FireMode[1].bIsFiring )
			PlayIdle();
	}
}
simulated function bool ConsumeAmmo( int Mode, float Load, optional bool bAmountNeededIsMax )
{
	local bool bResult;
	
	bResult = Super.ConsumeAmmo(Mode,Load,bAmountNeededIsMax);
	MagAmmoRemaining = Min(AmmoAmount(0),1);
	return bResult;
}

defaultproperties
{
     bCanScavengeAmmo=True
     bHasCrosshair=False
     MagCapacity=1
     MagAmmoRemaining=1
     HudImage=Texture'HL2WeaponsA.Icons.I_BugBait'
     SelectedHudImage=Texture'HL2WeaponsA.Icons.I_BugBait'
     Weight=2.000000
     TraderInfoTexture=Texture'HL2WeaponsA.Icons.I_BugBait'
     FireModeClass(0)=Class'ApocMutators.BugBaitFire'
     FireModeClass(1)=Class'ApocMutators.BugBaitAltFire'
     Description="Bug bait."
     Priority=190
     InventoryGroup=4
     GroupOffset=8
     PickupClass=Class'ApocMutators.HL_BugBaitPickup'
     PlayerViewPivot=(Yaw=-16384)
     AttachmentClass=Class'ApocMutators.BugBaitAttachment'
     ItemName="Pheropod"
     Mesh=SkeletalMesh'HL2WeaponsA.HL_BugBait'
}
