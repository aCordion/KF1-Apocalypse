Class HL_SMG extends HL2Weapon;

defaultproperties
{
     MagCapacity=45
     ReloadRate=1.800000
     bHasSecondaryAmmo=True
     bReduceMagAmmoOnSecondaryFire=False
     FlashBoneName="Muzzle"
     WeaponReloadAnim="Reload_BullPup"
     HudImage=Texture'HL2WeaponsA.Icons.I_SMG'
     SelectedHudImage=Texture'HL2WeaponsA.Icons.I_SMG'
     Weight=5.000000
     TraderInfoTexture=Texture'HL2WeaponsA.Icons.I_SMG'
     FireModeClass(0)=Class'ApocMutators.SMGFire'
     FireModeClass(1)=Class'ApocMutators.SMGAltFire'
     Description="An assault rifle with an attached grenade launcher."
     Priority=190
     InventoryGroup=3
     GroupOffset=8
     PickupClass=Class'ApocMutators.HL_SMGPickup'
     PlayerViewPivot=(Yaw=32768)
     AttachmentClass=Class'ApocMutators.SMGAttachment'
     ItemName="Submachine Gun"
     Mesh=SkeletalMesh'HL2WeaponsA.HL_SMG'
}
