class B94Pickup extends KFWeaponPickup;

/*
function ShowDeagleInfo(Canvas C)
{
  C.SetPos((C.SizeX - C.SizeY) / 2,0);
  C.DrawTile( Texture'KillingfloorHUD.ClassMenu.Deagle', C.SizeY, C.SizeY, 0.0, 0.0, 256, 256);
}
*/

defaultproperties
{
     Weight=12.000000
     cost=4000
     AmmoCost=10 //kyan
     BuyClipSize=40
     PowerValue=100
     SpeedValue=40
     RangeValue=100
     Description="Крупнокалиберная снайперская самозарядная винтовка B94, под отечественный патрон 12,7х108. разработана КБ "Приборостроение" (КБП, г. Тула)."
     ItemName="B94"
     ItemShortName="B94"
     AmmoItemName="Патроны 12,7-мм"
     Mesh=SkeletalMesh'B94_A.b94mesh_3rd'
     CorrespondingPerkIndex=2
     EquipmentCategoryID=2
     InventoryType=Class'B94'
     PickupMessage="Вы подобрали B94"
     PickupSound=Sound'B94_SN.holster'
     PickupForce="AssaultRiflePickup"
     StaticMesh=StaticMesh'B94_SM.B94static'
     CollisionRadius=30.000000
     CollisionHeight=5.000000
}
