class M202A1Pickup extends LAWPickup;

#exec OBJ LOAD FILE=M202_SM.usx
#exec OBJ LOAD FILE=M202_A.ukx

defaultproperties
{
	Weight=14.000000 // Reduced in Balance Round 2
	cost=6000
	BuyClipSize=4
	PowerValue=100
	SpeedValue=20
	RangeValue=64
	AmmoCost=10 //kyan
	Description=""
	ItemName="M202-A1"
	ItemShortName="M202-A1"
	AmmoItemName="66 mm incendiary rockets"
	Mesh=SkeletalMesh'M202_A.M202_3rd'
	AmmoMesh=StaticMesh'M202_SM.RocketBoxInc'
	MaxDesireability=0.790000
	InventoryType=Class'M202A1'
	RespawnTime=60.000000
	PickupMessage="You got the M202-A1"
	PickupForce="AssaultRiflePickup"
	StaticMesh=StaticMesh'M202_SM.M202A1'
	CollisionRadius=35.000000
	CollisionHeight=10.000000
	PickupSound=Sound'KF_LAWSnd.LAW_Pickup'
	EquipmentCategoryID=3
	CorrespondingPerkIndex=5
}
