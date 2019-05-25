//=============================================================================
// MP7M Pickup.
//=============================================================================
class PPSHPickup extends KFWeaponPickup;

defaultproperties
{
     Weight=3.000000
     cost=3000
     AmmoCost=10
     BuyClipSize=20
     PowerValue=22
     SpeedValue=95
     RangeValue=45
     Description="Prototype sub machine gun. Modified to fire healing darts."
     ItemName="PPSh-41"
     ItemShortName="PPSh-41"
     AmmoItemName="7.62x25mm Tokarev"
     AmmoMesh=StaticMesh'KillingFloorStatics.L85Ammo'
     CorrespondingPerkIndex=3
     EquipmentCategoryID=3
     InventoryType=Class'ApocMutators.PPSH41x'
     PickupMessage="You got the PPSH-41"
     PickupSound=Sound'KF_MP7Snd.MP7_Pickup'
     PickupForce="AssaultRiflePickup"
     StaticMesh=StaticMesh'KF_pickups2_Trip.Supers.MP7_Pickup'
     CollisionRadius=25.000000
     CollisionHeight=5.000000
}
