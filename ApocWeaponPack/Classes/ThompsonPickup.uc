class ThompsonPickup extends KFWeaponPickup;

defaultproperties
{
     Weight=6.000000
     cost=4000
     AmmoCost=10 //kyan
     BuyClipSize=50
     PowerValue=85
     SpeedValue=90
     RangeValue=50
     Description="Американский пистолет-пулемёт, разработанный компанией Auto-Ordnance в 1917 году и активно применявшийся во время Второй мировой войны."
     ItemName="Thompson M1A1"
     ItemShortName="Thompson M1A1"
     AmmoItemName="Патроны .45 ACP"
     Mesh=SkeletalMesh'Thompson_A.thompson_3rd'
     AmmoMesh=StaticMesh'KillingFloorStatics.L85Ammo'
     CorrespondingPerkIndex=3
     EquipmentCategoryID=2
     InventoryType=Class'ThompsonSubmachineGun'
     PickupMessage="Вы подобрали пистолет-пулемет «Томпсона»"
     PickupSound=Sound'Thompson_Snd.thompson_holster'
     PickupForce="AssaultRiflePickup"
     StaticMesh=StaticMesh'Thompson_sm.thompson_st'
     CollisionRadius=25.000000
     CollisionHeight=5.000000
}
