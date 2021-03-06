class VSSDTPickup extends KFWeaponPickup;

defaultproperties
{
     Weight=6.000000
     cost=4000
     AmmoCost=10 //kyan
     BuyClipSize=10
     PowerValue=80
     SpeedValue=40
     RangeValue=100
     Description="9-мм винтовка снайперская специальная (ВСС, разработана по теме «Винторез», это название осталось в обиходе, Индекс ГРАУ — 6П29) — бесшумная снайперская винтовка. Создана в ЦНИИ «Точмаш» в Климовске в начале 1980-х годов под руководством Петра Ивановича Сердюкова."
     ItemName="VSS Vintorez"
     ItemShortName="VSS Vintorez"
     AmmoItemName="Rifle bullets"
     Mesh=SkeletalMesh'VSSDT_v2_A.vintorezDT3rd'
     CorrespondingPerkIndex=2
     EquipmentCategoryID=2
     InventoryType=Class'VSSDT'
     PickupMessage="Вы получили винтовку VSS Vintorez"
     PickupSound=Sound'KF_RifleSnd.RifleBase.Rifle_Pickup'
     PickupForce="AssaultRiflePickup"
     StaticMesh=StaticMesh'VSSDT_v2_A.vintorezDT_sm'
	 DrawScale=1.20
     CollisionRadius=30.000000
     CollisionHeight=5.000000
}
