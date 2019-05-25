class HL_SMGPickup extends HL2WeaponPickup;

defaultproperties
{
     Weight=4.000000
     cost=1200
     AmmoCost=100
     BuyClipSize=45
     PowerValue=35
     SpeedValue=95
     RangeValue=60
     Description="A submachine gun."
     ItemName="Submachine Gun"
     ItemShortName="Machine Gun"
     AmmoItemName="Machinegun rounds"
     SecondaryAmmoShortName="SMG1 grenades"
     PrimaryWeaponPickup=Class'ApocMutators.HL_SMGPickupAlt'
     CorrespondingPerkIndex=3
     EquipmentCategoryID=3
     InventoryType=Class'ApocMutators.HL_SMG'
     PickupMessage="You got a Submachine Gun"
     Mesh=SkeletalMesh'HL2WeaponsA.HL_SMG3rd'
     CollisionRadius=25.000000
     CollisionHeight=5.000000
}
