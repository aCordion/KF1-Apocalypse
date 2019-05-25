//=============================================================================
// SPGrenadeLauncher
//=============================================================================
// Steam Punk bomb thrower class
//=============================================================================
// Killing Floor Source
// Copyright (C) 2013 Tripwire Interactive LLC
// - John "Ramm-Jaeger" Gibson
//=============================================================================
class Weapon_SPGrenadeLauncher extends SPGrenadeLauncher;

defaultproperties
{
    FireModeClass(0)=Class'ApocMutators.Weapon_SPGrenadeFire'
    FireModeClass(1)=Class'KFMod.NoFire'
    PickupClass=Class'ApocMutators.Weapon_SPGrenadePickup'
}
