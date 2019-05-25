class HealThrowerPickup extends MP7MPickup;

defaultproperties
{
	Weight=6 //7 //kyan: modified
	cost=4000 //3500 //kyan: modified
	AmmoCost=10 //40 //kyan: modified
	PowerValue=5
	SpeedValue=100
	RangeValue=40
	Description="Why didn't we think of this earlier? Seriously! I'm sick of dying from Sirens because you fools think a stunned Scrake is a more dangerous target!|-Lt. Masterson"
	ItemName="Heal Thrower"
	ItemShortName="Heal Thrower"
	AmmoItemName="Napalm"
	AmmoMesh=StaticMesh'KillingFloorStatics.FT_AmmoMesh'
	InventoryType=Class'HealThrower'
	PickupMessage="You got the Heal Thrower"
	PickupForce="AssaultRiflePickup"
	DrawType=DT_StaticMesh
	StaticMesh=StaticMesh'HealThrower_R.HealThrower_Pickup'
	DrawScale=1
	CollisionRadius=30
	CollisionHeight=5
	EquipmentCategoryID=3
	PickupSound=Sound'KF_FlamethrowerSnd.FT_Pickup'
	CorrespondingPerkIndex=0
}
