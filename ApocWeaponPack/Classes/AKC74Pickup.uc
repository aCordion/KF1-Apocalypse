class AKC74Pickup extends KFWeaponPickup;

defaultproperties
{
     Weight=5.000000
     cost=3500
     AmmoCost=10
     BuyClipSize=30
     PowerValue=90
     SpeedValue=90
     RangeValue=50
     Description="5,45-мм автомат Калашникова,вариант АК74 со складывающимся вбок металлическим прикладом пятиугольной формы. Создан для использования в воздушно-десантных войсках (автомат с нескладывающимся прикладом невозможно удобно и безопасно расположить в подвесной системе парашюта)."
     ItemName="Kalashnikov AKS74"
     ItemShortName="Kalashnikov AKS74"
     AmmoItemName="Патроны 5,45×39 мм"
     Mesh=SkeletalMesh'AKC74_A.AKC74_3rd'
     AmmoMesh=StaticMesh'KillingFloorStatics.L85Ammo'
     CorrespondingPerkIndex=3
     EquipmentCategoryID=2
     InventoryType=Class'AKC74AssaultRifle'
     PickupMessage="Вы подобрали Kalashnikov AKS74"
     PickupSound=Sound'AKC74_Snd.akc74_holster'
     PickupForce="AssaultRiflePickup"
     StaticMesh=StaticMesh'AKC74_sm.AKC74_ST'
     CollisionRadius=25.000000
     CollisionHeight=5.000000
}
