class AutoSv4Pickup extends KFWeaponPickup;

#exec OBJ LOAD FILE=KillingFloorWeapons.utx

defaultproperties
{
     cost=500
     AmmoCost=35
     BuyClipSize=25
     PowerValue=64
     SpeedValue=95
     RangeValue=100
     Description="Fully-Automoatic Crossbow Only For GFK Servers. Version 2, Revision 4. Made By -TwIsTeD- Of The GFK Clan."
     ItemName="GFK AutoBow Sv4"
     ItemShortName="AutoBow Sv4"
     AmmoItemName="AutoBow Bolts"
     AmmoMesh=StaticMesh'KillingFloorStatics.XbowAmmo'
     CorrespondingPerkIndex=2
     EquipmentCategoryID=3
     MaxDesireability=0.790000
     InventoryType=Class'AutoSv4_'
     PickupMessage="You got the AutoBow Sv4."
     PickupSound=Sound'KF_XbowSnd.Xbow_Pickup'
     PickupForce="AssaultRiflePickup"
     StaticMesh=StaticMesh'KF_pickups_Trip.Rifle.crossbow_pickup'
     CollisionRadius=25.000000
     CollisionHeight=10.000000
}
