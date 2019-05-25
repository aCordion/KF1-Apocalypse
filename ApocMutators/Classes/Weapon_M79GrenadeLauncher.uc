//=============================================================================
// M79 Grenade launcher Inventory class
//=============================================================================
class Weapon_M79GrenadeLauncher extends M79GrenadeLauncher;

defaultproperties
{
    FireModeClass(0)=Class'ApocMutators.Weapon_M79Fire'
    FireModeClass(1)=Class'KFMod.NoFire'
    PickupClass=Class'ApocMutators.Weapon_M79Pickup'
}
