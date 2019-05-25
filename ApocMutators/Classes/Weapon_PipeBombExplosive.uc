//=============================================================================
// Pipe bomb proximity charge Inventory class
//=============================================================================
class Weapon_PipeBombExplosive extends PipeBombExplosive;

defaultproperties
{
    FireModeClass(0)=Class'ApocMutators.Weapon_PipeBombFire'
    FireModeClass(1)=Class'KFMod.NoFire'
    PickupClass=Class'ApocMutators.Weapon_PipeBombPickup'
}
