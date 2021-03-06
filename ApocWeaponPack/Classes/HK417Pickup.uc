class HK417Pickup extends KFWeaponPickup;

/*
function ShowDeagleInfo(Canvas C)
{
  C.SetPos((C.SizeX - C.SizeY) / 2,0);
  C.DrawTile( Texture'KillingfloorHUD.ClassMenu.Deagle', C.SizeY, C.SizeY, 0.0, 0.0, 256, 256);
}
*/

defaultproperties
{
     Weight=6.000000
     cost=4000
     AmmoCost=10 //kyan
     BuyClipSize=10
     PowerValue=60
     SpeedValue=30
     RangeValue=95
     Description="HK-417 20 «Sniper» Model — «снайперский» вариант со стволом улучшенной обработки длиной 508 мм."
     ItemName="HK-417"
     ItemShortName="HK-417"
     AmmoItemName="Патроны 7,62×51 мм НАТО"
     Mesh=SkeletalMesh'HK417_A.HK417_3rd'
     CorrespondingPerkIndex=2
     EquipmentCategoryID=2
     InventoryType=Class'HK417'
     PickupMessage="Вы подобрали HK-417"
     PickupSound=Sound'HK417_A.HK417_pickup'
     PickupForce="AssaultRiflePickup"
     StaticMesh=StaticMesh'HK417_A.HK417_st'
	 DrawScale=0.8
     CollisionRadius=30.000000
     CollisionHeight=5.000000
}
