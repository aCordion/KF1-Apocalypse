//=============================================================================
// Weapon_M99AmmoPickup
//=============================================================================
// M99 Sniper Rifle ammo pickup class
//=============================================================================
// Killing Floor Source
// Copyright (C) 2012 Tripwire Interactive LLC
// - John "Ramm-Jaeger" Gibson, and IJC Development
//=============================================================================
class Weapon_M99AmmoPickup extends M99AmmoPickup;

defaultproperties
{
     AmmoAmount=50
     InventoryType=Class'ApocMutators.Weapon_M99Ammo'
     PickupMessage="50 Cal Bullets"
     StaticMesh=StaticMesh'KillingFloorStatics.XbowAmmo'
     CollisionRadius=25.000000
}
