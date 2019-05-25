//=============================================================================
// M14EBR Pickup.
//=============================================================================
class SniperNagantPickup extends KFWeaponPickup;

defaultproperties
{
     Weight=6.000000
     cost=2800
     AmmoCost=15
     BuyClipSize=5
     PowerValue=80
     SpeedValue=15
     RangeValue=100
     Description="An excellent-to-use Russian rifle, typically used in many wars. Great for experienced riflemen."
     ItemName="Scoped Nagant"
     ItemShortName="Scoped Nagant"
     AmmoItemName="7.62x51mm Ammo"
     //showMesh=SkeletalMesh'MosinNagant_A.nagant_3rd_s'
     AmmoMesh=StaticMesh'KillingFloorStatics.L85Ammo'
     CorrespondingPerkIndex=2
     EquipmentCategoryID=3
     InventoryType=Class'SniperNagant'
     PickupMessage="You got the Scoped Mosin Nagant."
     PickupSound=Sound'MosinNagant_S.strip_bullet'
     PickupForce="AssaultRiflePickup"
     StaticMesh=StaticMesh'MosinNagant_SM.mosin_pickup_s'
     CollisionRadius=25.000000
     CollisionHeight=5.000000
}
