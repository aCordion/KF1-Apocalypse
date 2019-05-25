//=============================================================================
// Weapon_M99Pickup
//=============================================================================
// M99 Sniper Rifle Pickup Class
//=============================================================================
// Killing Floor Source
// Copyright (C) 2012 Tripwire Interactive LLC
// - John "Ramm-Jaeger" Gibson and IJC
//=============================================================================

class Weapon_M99Pickup extends M99Pickup;

defaultproperties
{
     cost=4000
     AmmoCost=10
     BuyClipSize=2
     Weight=11.000000
     PowerValue=95
     SpeedValue=30
     RangeValue=100
     Description="M99 50 Caliber Single Shot Sniper Rifle - The ultimate in long range accuracy and knock down power."
     ItemName="M99 AMR"
     ItemShortName="M99 AMR"
     AmmoItemName="50 Cal Bullets"
     MaxDesireability=0.790000
     InventoryType=Class'ApocMutators.Weapon_M99SniperRifle'
     PickupMessage="You got the M99 Sniper Rifle."
     PickupForce="AssaultRiflePickup"
     StaticMesh=StaticMesh'KF_pickups4_Trip.M99_Sniper_Pickup'
     CollisionRadius=25.000000
     CollisionHeight=10.000000
     PickupSound=Sound'KF_M99Snd.M99_Pickup'
     EquipmentCategoryID=3
     CorrespondingPerkIndex=2
}
