class VALDTPickup extends KFWeaponPickup;

defaultproperties
{
     Weight=5.000000
     cost=4000
     AmmoCost=10 //kyan
     BuyClipSize=30
     PowerValue=99
     SpeedValue=95
     RangeValue=50
     Description="АС «Вал» (Автомат Специальный, Индекс ГРАУ — 6П30) — бесшумный автомат, разработанный в климовском ЦНИИточмаш конструкторами П. Сердюковым и В. Красниковым во второй половине 1980-х годов вместе с бесшумной снайперской винтовкой ВСС и состоящий на вооружении подразделений специального назначения России."
     ItemName="АС «Вал»"
     ItemShortName="AS Val 'Shaft'"
     AmmoItemName="Патроны 9x39 мм"
     Mesh=SkeletalMesh'VALDT_v2_A.ValDT3rd'
     AmmoMesh=StaticMesh'KillingFloorStatics.L85Ammo'
     CorrespondingPerkIndex=3
     EquipmentCategoryID=2
     InventoryType=Class'VALDTAssaultRifle'
     PickupMessage="Вы подобрали АС «Вал»"
     PickupSound=Sound'KF_AK47Snd.AK47_Pickup'
     PickupForce="AssaultRiflePickup"
     StaticMesh=StaticMesh'VALDT_v2_A.ValDT_sm'
     DrawScale=1.3
     CollisionRadius=25.000000
     CollisionHeight=5.000000
}
