//=============================================================================
// SealSquealHarpoonBomber
//=============================================================================
// Weapon class for the seal squeal harpoon bomb launcher
//=============================================================================
// Killing Floor Source
// Copyright (C) 2013 Tripwire Interactive LLC
// - John "Ramm-Jaeger" Gibson
//=============================================================================
class Weapon_SealSquealHarpoonBomber extends SealSquealHarpoonBomber;

defaultproperties
{
    FireModeClass(0)=Class'ApocMutators.Weapon_SealSquealFire'
    FireModeClass(1)=Class'KFMod.NoFire'
    PickupClass=Class'ApocMutators.Weapon_SealSquealPickup'
}
