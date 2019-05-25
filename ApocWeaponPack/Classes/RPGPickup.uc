class RPGPickup extends KFWeaponPickup;

#exec OBJ LOAD FILE=KillingFloorWeapons.utx

defaultproperties
{
     cost=4500
     AmmoCost=30
     BuyClipSize=1
     PowerValue=100
     SpeedValue=20
     RangeValue=64
     Description="Light Anti Tank weapon. Designed to punch through armored vehicles."
     ItemName="RPG-7"
     ItemShortName="RPG-7"
     AmmoItemName="RPG Rockets"
     AmmoMesh=StaticMesh'RPG7DT_A.Rocket'
     CorrespondingPerkIndex=6
     EquipmentCategoryID=3
     SellValue=300
     MaxDesireability=0.790000
     InventoryType=Class'RPG'
     RespawnTime=60.000000
     PickupMessage="You got the RPG-7"
     PickupSound=Sound'KF_LAWSnd.LAW_Pickup'
     PickupForce="AssaultRiflePickup"
     StaticMesh=StaticMesh'RPG7DT_A.RPG7'
     CollisionRadius=35.000000
     CollisionHeight=6.000000
}
