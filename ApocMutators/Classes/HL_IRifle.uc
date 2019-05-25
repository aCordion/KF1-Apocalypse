Class HL_IRifle extends HL2Weapon;

defaultproperties
{
     MagCapacity=30
     ReloadRate=1.500000
     bHasSecondaryAmmo=True
     bReduceMagAmmoOnSecondaryFire=False
     WeaponReloadAnim="Reload_MP5"
     HudImage=Texture'HL2WeaponsA.Icons.I_IRifle'
     SelectedHudImage=Texture'HL2WeaponsA.Icons.I_IRifle'
     Weight=5.000000
     TraderInfoTexture=Texture'HL2WeaponsA.Icons.I_IRifle'
     FireModeClass(0)=Class'ApocMutators.IRifleFire'
     FireModeClass(1)=Class'ApocMutators.IRifleAltFire'
     Description="An assault rifle with an attached grenade launcher."
     Priority=190
     InventoryGroup=4
     GroupOffset=8
     PickupClass=Class'ApocMutators.HL_IRiflePickup'
     PlayerViewPivot=(Yaw=-16384)
     AttachmentClass=Class'ApocMutators.IRifleAttachment'
     ItemName="Overwatch Standard Issue Pulse Rifle"
     Mesh=SkeletalMesh'HL2WeaponsA.HL_IRifle'
}
