//=============================================================================
// L85 Ammo.
//=============================================================================
class WTFEquipBulldogAmmo extends KFAmmunition;

#EXEC OBJ LOAD FILE=KillingFloorHUD.utx

defaultproperties
{
     MaxAmmo=1200
     InitialAmount=520
     AmmoPickupAmount=80
     PickupClass=Class'ApocMutators.WTFEquipBulldogAmmoPickup'
}
