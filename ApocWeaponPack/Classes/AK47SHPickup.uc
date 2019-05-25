class AK47SHPickup extends KFWeaponPickup;

defaultproperties
{
     Weight=6.000000
     cost=2500
     AmmoCost=10
     BuyClipSize=30
     PowerValue=62
     SpeedValue=80
     RangeValue=50
     Description="7,62-мм автомат Калашникова (АК, индекс ГАУ — 56-А-212, часто называют АК-47) — автомат, разработанный Михаилом Калашниковым в 1947 и принятый на вооружение Советской Армии в 1949 году."
     ItemName="АК-47"
     ItemShortName="АК-47"
     AmmoItemName="Патроны 7,62×39 мм"
     Mesh=SkeletalMesh'AK47_A.AK47_3rd'
     AmmoMesh=StaticMesh'KillingFloorStatics.L85Ammo'
     CorrespondingPerkIndex=3
     EquipmentCategoryID=2
     InventoryType=Class'AK47SHAssaultRifle'
     PickupMessage="Вы подобрали АК-47"
     PickupSound=Sound'AK47_Snd.ak47_holster'
     PickupForce="AssaultRiflePickup"
     StaticMesh=StaticMesh'AK47_sm.AK47_ST'
     DrawScale=0.9
     CollisionRadius=25.000000
     CollisionHeight=5.000000
}
