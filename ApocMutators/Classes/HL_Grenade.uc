Class HL_Grenade extends HL2Weapon;

exec function ReloadMeNow();

simulated function AnimEnd(int channel)
{
	local name anim;
	local float frame, rate;

	GetAnimParams(0, anim, frame, rate);

	if (ClientState == WS_ReadyToFire)
	{
		if( (anim=='Throw' || anim=='Roll') && ammoAmount(0)>0 )
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
     HudImage=Texture'HL2WeaponsA.Icons.I_Grenade'
     SelectedHudImage=Texture'HL2WeaponsA.Icons.I_Grenade'
     Weight=1.000000
     TraderInfoTexture=Texture'HL2WeaponsA.Icons.I_Grenade'
     FireModeClass(0)=Class'ApocMutators.FGrenFire'
     FireModeClass(1)=Class'ApocMutators.FGrenAltFire'
     PutDownTime=0.230000
     BringUpTime=1.330000
     Description="A fragmentation grenade."
     Priority=10
     InventoryGroup=5
     GroupOffset=5
     PickupClass=Class'ApocMutators.HL_GrenadePickup'
     PlayerViewPivot=(Yaw=-16384)
     AttachmentClass=Class'ApocMutators.FGrenAttachment'
     ItemName="Frag Grenade"
     Mesh=SkeletalMesh'HL2WeaponsA.HL_Grenade'
}
