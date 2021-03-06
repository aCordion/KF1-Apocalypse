class UMP45Pickup extends KFWeaponPickup;

defaultproperties
{
     Weight=5.000000
     cost=2000
     AmmoCost=10 //kyan
     BuyClipSize=25
     PowerValue=45
     SpeedValue=60
     RangeValue=50
     Description="Универсальный пистолет-пулемет, разработанный немецкой компанией Heckler & Koch в 1990-х годах в качестве дополнения к семейству пистолетов-пулеметов HK MP5."
     ItemName="HK UMP-45"
     ItemShortName="HK UMP-45"
     AmmoItemName="Патроны .45 ACP"
     Mesh=SkeletalMesh'UMP45_A.ump45_3rd'
     AmmoMesh=StaticMesh'KillingFloorStatics.L85Ammo'
     CorrespondingPerkIndex=5
     EquipmentCategoryID=2
     InventoryType=Class'UMP45SubmachineGun'
     PickupMessage="Вы подобрали пистолет-пулемет HK UMP-45"
     PickupSound=Sound'UMP45_Snd.ump45_pickup'
     PickupForce="AssaultRiflePickup"
     StaticMesh=StaticMesh'UMP45_sm.ump45_st'
     CollisionRadius=25.000000
     CollisionHeight=5.000000
}
