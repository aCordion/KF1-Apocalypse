//=============================================================================
// 9mm Ammo.
//=============================================================================
class WTFEquipSingleAmmo extends KFAmmunition;

#EXEC OBJ LOAD FILE=InterfaceContent.utx

defaultproperties
{
     MaxAmmo=240
     InitialAmount=200
     AmmoPickupAmount=30
     PickupClass=Class'ApocMutators.WTFEquipSingleAmmoPickup'
}
