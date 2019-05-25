//=============================================================================
// SeekerSixRocketLauncher
//=============================================================================
// Weapon class for the SeekerSix mini rocket launcher
//=============================================================================
// Killing Floor Source
// Copyright (C) 2013 Tripwire Interactive LLC
// - John "Ramm-Jaeger" Gibson
//=============================================================================
class Weapon_SeekerSixRocketLauncher extends SeekerSixRocketLauncher;

defaultproperties
{
    FireModeClass(0)=Class'ApocMutators.Weapon_SeekerSixFire'
    FireModeClass(1)=Class'ApocMutators.Weapon_SeekerSixMultiFire'
    PickupClass=Class'ApocMutators.Weapon_SeekerSixPickup'
}
