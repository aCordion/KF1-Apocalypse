class Weapon_FlameLAWPickup extends KFWeaponPickup;

//#exec OBJ LOAD FILE=KillingFloorWeapons.utx
//#exec OBJ LOAD FILE=WeaponStaticMesh.usx
//#exec OBJ LOAD FILE=ApocMutators.ApocMutators.uax

defaultproperties
{
	 Weight=14.000000
	 cost=6000
	 BuyClipSize=1
	 PowerValue=100
	 SpeedValue=20
	 RangeValue=64
	 AmmoCost=30
	 Description="Light Anti personnel weapon. Designed to cook noobs."
	 ItemName="Incendiary L.A.W"
	 AmmoItemName="Incendiary L.A.W Rockets"
	 AmmoMesh=StaticMesh'KillingFloorStatics.LAWAmmo'
	 MaxDesireability=0.790000
	 InventoryType=Class'ApocMutators.Weapon_FlameLAW'
	 RespawnTime=60.000000
	 PickupMessage="You got the Incendiary L.A.W."
	 PickupForce="AssaultRiflePickup"
	 StaticMesh=StaticMesh'KF_pickups_Trip.LAW_Pickup'
	 CollisionRadius=35.000000
	 CollisionHeight=10.000000
	 PickupSound=Sound'KF_LAWSnd.LAW_Pickup'
	 EquipmentCategoryID=3
}
