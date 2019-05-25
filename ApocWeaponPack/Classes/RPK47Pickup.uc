class RPK47Pickup extends KFWeaponPickup;

defaultproperties
{
     Weight=7.000000
     cost=3500
     AmmoCost=10 //kyan
     BuyClipSize=50
     PowerValue=93
     SpeedValue=80
     RangeValue=50
     Description="RPG-7 (Ручной Пулемет Калашникова) под 7,62-мм промежуточный патрон образца 1943 г., создан как оружие поддержки стрелкового взвода на основе автомата АКМ. На вооружение Советской Армии RPG-7 был принят в 1961 г., заменив ручной пулемет Дегтярева РПД, созданный в конце 40-х годов."
     ItemName="RPG-7"
     ItemShortName="RPG-7"
     AmmoItemName="Патроны 7,62-мм"
     Mesh=SkeletalMesh'RPK47_A.RPK47_3rd'
     AmmoMesh=StaticMesh'KillingFloorStatics.L85Ammo'
     CorrespondingPerkIndex=3
     EquipmentCategoryID=2
     InventoryType=Class'RPK47MachineGun'
     PickupMessage="Вы подобрали Ручной Пулемет Калашникова"
     PickupSound=Sound'RPK47_A.rpk47_pickup'
     PickupForce="AssaultRiflePickup"
     StaticMesh=StaticMesh'RPK47_A.RPK47_st'
     CollisionRadius=25.000000
     CollisionHeight=5.000000
}
