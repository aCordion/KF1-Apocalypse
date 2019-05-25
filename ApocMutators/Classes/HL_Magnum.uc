Class HL_Magnum extends HL2Weapon;

defaultproperties
{
     MagCapacity=6
     ReloadRate=4.600000
     FlashBoneName="Muzzle"
     WeaponReloadAnim="Reload_Revolver"
     HudImage=Texture'HL2WeaponsA.Icons.I_Magnum'
     SelectedHudImage=Texture'HL2WeaponsA.Icons.I_Magnum'
     Weight=2.000000
     TraderInfoTexture=Texture'HL2WeaponsA.Icons.I_Magnum'
     FireModeClass(0)=Class'ApocMutators.MagnumFire'
     FireModeClass(1)=Class'ApocMutators.MagnumFire'
     Description="A powerful magnum."
     Priority=80
     InventoryGroup=2
     GroupOffset=4
     PickupClass=Class'ApocMutators.HL_MagnumPickup'
     PlayerViewPivot=(Yaw=-16384)
     AttachmentClass=Class'ApocMutators.MagnumAttachment'
     ItemName=".357 Magnum"
     Mesh=SkeletalMesh'HL2WeaponsA.HL_Magnum'
}
