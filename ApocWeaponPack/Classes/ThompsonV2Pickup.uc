class ThompsonV2Pickup extends KFWeaponPickup;

defaultproperties
{
     Weight=4.000000
     cost=3500
     AmmoCost=10 //kyan
     BuyClipSize=30
     PowerValue=94
     SpeedValue=90
     RangeValue=50
     Description="Американский пистолет-пулемёт, разработанный компанией Auto-Ordnance в 1917 году и активно применявшийся во время Второй мировой войны."
     ItemName="Thompson M1928"
     ItemShortName="Thompson M1928"
     AmmoItemName="Патроны .45 ACP"
     Mesh=SkeletalMesh'ThompsonV2_A.tommy_3rd'
     AmmoMesh=StaticMesh'KillingFloorStatics.L85Ammo'
     CorrespondingPerkIndex=3
     EquipmentCategoryID=2
     InventoryType=Class'ThompsonV2SubmachineGun'
     PickupMessage="Вы подобрали пистолет-пулемет «Томпсона M1»"
     PickupSound=Sound'ThompsonV2_Snd.ThompsonV2_holster'
     PickupForce="AssaultRiflePickup"
     StaticMesh=StaticMesh'ThompsonV2_sm.tommy_st'
     CollisionRadius=25.000000
     CollisionHeight=5.000000
}
