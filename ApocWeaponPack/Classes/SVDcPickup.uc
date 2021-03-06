class SVDcPickup extends KFWeaponPickup;

defaultproperties
{
     Weight=7.000000
     cost=4000
     AmmoCost=10 //kyan
     BuyClipSize=40
     PowerValue=80
     SpeedValue=40
     RangeValue=100
     Description="Cнайперская винтовка Драгунова (СВД, Индекс ГРАУ — 6В1) — снайперская винтовка, разработанная в 1958—1963 годах группой конструкторов под руководством Евгения Драгунова."
     ItemName="SVD Dragunov"
     ItemShortName="SVD Dragunov"
     AmmoItemName="Патроны 7,62мм"
     Mesh=SkeletalMesh'svd-c_A.svd3rd'
     CorrespondingPerkIndex=2
     EquipmentCategoryID=2
     InventoryType=Class'SVDc'
     PickupMessage="Вы подобрали SVD Dragunov"
     PickupSound=Sound'Svd-c_SN.svd-c_holster'
     PickupForce="AssaultRiflePickup"
     StaticMesh=StaticMesh'svd_c_SM.svd_c'
     CollisionRadius=30.000000
     CollisionHeight=5.000000
}
