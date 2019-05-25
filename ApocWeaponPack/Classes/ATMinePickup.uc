//=============================================================================
// PipeBombPickup Pickup.
//=============================================================================
class ATMinePickup extends KFWeaponPickup;

defaultproperties
{
     Weight=1.000000
     AmmoCost=1000
     BuyClipSize=1
     PowerValue=100
     SpeedValue=5
     RangeValue=15
     Description="An improvised proximity explosive. Blows up when enemies get close."
     ItemName="Anti-Tank Mine"
     ItemShortName="Anti-Tank Mine"
     AmmoItemName="Anti-Tank Mine"
     CorrespondingPerkIndex=6
     EquipmentCategoryID=3
     InventoryType=Class'ATMineExplosive'
     PickupMessage="You got the ATMine proximity explosive."
     PickupSound=Sound'KF_AA12Snd.AA12_Pickup'
     PickupForce="AssaultRiflePickup"
     StaticMesh=StaticMesh'ATMine_A.ATMine_Pickup'
     CollisionRadius=35.000000
     CollisionHeight=5.000000
}
