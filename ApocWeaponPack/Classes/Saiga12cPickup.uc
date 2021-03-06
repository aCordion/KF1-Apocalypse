class Saiga12cPickup extends KFWeaponPickup;

defaultproperties
{
     cost=4000
     AmmoCost=10 //kyan
     BuyClipSize=20
     PowerValue=87
     SpeedValue=45
     RangeValue=20
     Weight=5.000000
     Description="Гладкоствольный карабин Saiga-12 Shotgun, 12-го калибра под дробовые и пулевые охотничьи патроны."
     ItemName="Saiga-12 Shotgun"
     ItemShortName="Saiga-12 Shotgun"
     AmmoItemName="12-й калибр."
     Mesh=SkeletalMesh'saigac_A.saigac3rd'
     CorrespondingPerkIndex=1
     EquipmentCategoryID=3
     InventoryType=Class'Saiga12c'
     PickupMessage="Вы подобрали Saiga-12 Shotgun"
     PickupSound=Sound'KF_AA12Snd.AA12_Pickup'
     PickupForce="AssaultRiflePickup"
     StaticMesh=StaticMesh'Saigac_sm.saiga'
     CollisionRadius=35.000000
     CollisionHeight=5.000000
}
