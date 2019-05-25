class P90DTPickup extends KFWeaponPickup;

defaultproperties
{
     Weight=5.000000
     cost=3500
     AmmoCost=10 //kyan
     BuyClipSize=50
     PowerValue=84
     SpeedValue=90
     RangeValue=50
     Description="FN P90 - бельгийский пистолет-пулемет (персональное оружие самообороны), разработанный в 1986-1987 годах фирмой FN Herstal. Был разработан, в первую очередь, для танкистов и водителей боевых автомобилей."
     ItemName="FN P90"
     ItemShortName="FN P90"
     AmmoItemName="Патроны 5,7×28 мм"
     Mesh=SkeletalMesh'P90DT_A.P90DTMesh_3rd'
     AmmoMesh=StaticMesh'KillingFloorStatics.L85Ammo'
     CorrespondingPerkIndex=3
     EquipmentCategoryID=2
     InventoryType=Class'P90DT'
     PickupMessage="Вы подобрали FN P90"
     PickupSound=Sound'P90DT_A.P90DT_SND.p90_pickup'
     PickupForce="AssaultRiflePickup"
     StaticMesh=StaticMesh'P90DT_A.P90DT_sm'
     DrawScale=0.9
     CollisionRadius=25.000000
     CollisionHeight=5.000000
}
