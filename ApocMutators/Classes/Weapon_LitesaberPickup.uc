//-----------------------------------------------------------
//
//-----------------------------------------------------------
class Weapon_LitesaberPickup extends KFWeaponPickup;

defaultproperties
{
	 Weight=3.000000
	 cost=4000
	 PowerValue=60
	 SpeedValue=60
	 RangeValue=-21
	 Description="An incredibly hot sword."
	 ItemName="Lite Sabre"
	 ItemShortName="Lite Sabre"
	 CorrespondingPerkIndex=4
	 InventoryType=Class'ApocMutators.Weapon_Litesaber'
	 PickupMessage="You got the Lite Sabre."
	 PickupSound=Sound'KF_AxeSnd.Axe_Pickup'
	 PickupForce="AssaultRiflePickup"
	 StaticMesh=StaticMesh'daforce.litesaberPickup'
	 CollisionRadius=27.000000
	 CollisionHeight=5.000000
}
