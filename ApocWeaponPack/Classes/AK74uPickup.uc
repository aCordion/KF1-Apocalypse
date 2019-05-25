class AK74uPickup extends KFWeaponPickup;

defaultproperties
{
     Weight=3.000000
     cost=1500
     AmmoCost=10
     BuyClipSize=30
     PowerValue=50
     SpeedValue=90
     RangeValue=50
     Description="5,45-мм автомат Калашникова укороченный, Kalashnikov AK74u (Индекс ГРАУ — 6П26) — укороченная модификация автомата АК74, был разработан в конце 1970-х — начале 1980-х годов для вооружения экипажей боевых машин, авиатехники, расчётов орудий, а также десантников."
     ItemName="Kalashnikov AK74u"
     ItemShortName="Kalashnikov AK74u"
     AmmoItemName="Патроны 5,45×39 мм"
     Mesh=SkeletalMesh'AK74u_A.AK74u_3rd'
     AmmoMesh=StaticMesh'KillingFloorStatics.L85Ammo'
     CorrespondingPerkIndex=3
     EquipmentCategoryID=2
     InventoryType=Class'AK74uAssaultRifle'
     PickupMessage="Вы подобрали Kalashnikov AK74u"
     PickupSound=Sound'AK74u_Snd.ak74u_holster'
     PickupForce="AssaultRiflePickup"
     StaticMesh=StaticMesh'AK74u_sm.AK74_ST'
     CollisionRadius=25.000000
     CollisionHeight=5.000000
}
