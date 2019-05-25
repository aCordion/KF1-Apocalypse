//=============================================================================
// M4203AssaultRifle
//=============================================================================
// An M4 Assault Rifle with M203 Grenade launcher
//=============================================================================
// Killing Floor Source
// Copyright (C) 2011 Tripwire Interactive LLC
// - John "Ramm-Jaeger" Gibson
//=============================================================================
class Weapon_M4203AssaultRifle extends M4203AssaultRifle
	config(user);

defaultproperties
{
    FireModeClass(0)=Class'KFMod.M4203BulletFire'
    FireModeClass(1)=Class'KFMod.M203Fire'
    PickupClass=Class'ApocMutators.Weapon_M4203Pickup'
}
