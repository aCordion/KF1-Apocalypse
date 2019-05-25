class AUG_A1ARPickup extends KFWeaponPickup;

defaultproperties
{
     Weight=6.000000
     cost=4000
     AmmoCost=10 //kyan
     BuyClipSize=42
     PowerValue=100
     SpeedValue=65
     RangeValue=90
     Description="Steyr AUG (Armee Universal Gewehr - армейская универсальная винтовка) - комплекс стрелкового оружия, выпущенный в 1977 году австрийской компанией Steyr-Daimler-Puch (ныне Штайр Манли́хер AG & Co KG ). Принят на вооружение такими странами, как Австрия, Новая Зеландия, Люксембург и Ирландия. В Австралии винтовка выпускается по лицензии под маркой F88. Имеет сменные стволы разной длины: основной 508 мм, а также укороченные стволы 350 мм и 407 мм и тяжелый ствол 621 мм."
     ItemName="Steyr AUG A1"
     ItemShortName="Steyr AUG A1"
     AmmoItemName="Патроны 5.56 мм NATO (.223rem)"
     Mesh=SkeletalMesh'AUG_A1_A.AUG_A1_3rd'
     CorrespondingPerkIndex=3
     EquipmentCategoryID=2
     InventoryType=Class'AUG_A1AR'
     PickupMessage="Вы получили Steyr AUG A1"
     PickupSound=Sound'AUG_A1_A.AUG_A1_SND.aug_pickup'
     PickupForce="AssaultRiflePickup"
     StaticMesh=StaticMesh'AUG_A1_A.AUG_A1_st'
     DrawScale=1.0
     CollisionRadius=30.000000
     CollisionHeight=5.000000
}
