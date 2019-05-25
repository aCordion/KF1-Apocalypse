//=============================================================================
// M32 MGL Semi automatic grenade launcher Inventory class
//=============================================================================
class Weapon_M32GrenadeLauncher extends M32GrenadeLauncher;

defaultproperties
{
    FireModeClass(0)=Class'ApocMutators.Weapon_M32Fire'
    FireModeClass(1)=Class'KFMod.NoFire'
    PickupClass=Class'ApocMutators.Weapon_M32Pickup'
}
