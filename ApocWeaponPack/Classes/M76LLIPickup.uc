//=============================================================================
// Zastava M76 Pickup.
//=============================================================================
class M76LLIPickup extends KFWeaponPickup;

defaultproperties
{
     Weight=8.000000
     cost=4000
     AmmoCost=10 //kyan
     BuyClipSize=10
     PowerValue=75
     SpeedValue=20
     RangeValue=95
     Description="Zastava M76 - винтовка, разработанная в Югославии на базе автомата Калашникова, адаптированного под более длинные и мощные винтовочные патроны 7,92×57 мм."
     ItemName="Zastava M76"
     ItemShortName="Zastava M76"
     AmmoItemName="Патроны 7,92×57 мм"
     Mesh=SkeletalMesh'M76LLI_A.M76LLI_3rd'
     AmmoMesh=StaticMesh'KillingFloorStatics.L85Ammo'
     CorrespondingPerkIndex=2
     EquipmentCategoryID=3
     InventoryType=Class'M76LLIBattleRifle'
     PickupMessage="Вы получили Zastava M76"
     PickupSound=Sound'M76LLI_A.M76LLI_SND.M76LLI_pickup'
     PickupForce="AssaultRiflePickup"
     StaticMesh=StaticMesh'M76LLI_A.M76LLI_st'
     CollisionRadius=25.000000
     CollisionHeight=5.000000
}
