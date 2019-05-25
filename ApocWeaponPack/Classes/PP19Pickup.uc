class PP19Pickup extends KFWeaponPickup;

defaultproperties
{
     Weight=4.000000
     cost=3000
     AmmoCost=10 //kyan
     BuyClipSize=53
     PowerValue=50
     SpeedValue=70
     RangeValue=50
     Description="Пистолет-пулемёт, разработанный в 1993 году Виктором Михайловичем Калашниковым (сыном конструктора М. Т. Калашникова) и Алексеем Драгуновым (сыном Е. Ф. Драгунова)."
     ItemName="PP-19 Bizon"
     ItemShortName="PP-19 Bizon"
     AmmoItemName="Патроны 9×19 мм Парабеллум"
     Mesh=SkeletalMesh'PP19_A.PP19_3rd'
     AmmoMesh=StaticMesh'KillingFloorStatics.L85Ammo'
     CorrespondingPerkIndex=6
     EquipmentCategoryID=2
     InventoryType=Class'PP19AssaultRifle'
     PickupMessage="Вы подобрали PP-19 Bizon"
     PickupSound=Sound'PP19_Snd.PP19_pickup'
     PickupForce="AssaultRiflePickup"
     StaticMesh=StaticMesh'PP19_sm.PP19_ST'
     CollisionRadius=25.000000
     CollisionHeight=5.000000
}
