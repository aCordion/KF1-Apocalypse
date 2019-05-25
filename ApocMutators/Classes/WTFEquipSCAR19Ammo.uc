//=============================================================================
// SCAR19 Ammo.
//=============================================================================
class WTFEquipSCAR19Ammo extends KFAmmunition;

#EXEC OBJ LOAD FILE=KillingFloorHUD.utx

defaultproperties
{
     MaxAmmo=2400
     InitialAmount=1000
     AmmoPickupAmount=40
     PickupClass=Class'ApocMutators.WTFEquipSCAR19AmmoPickup'
}
