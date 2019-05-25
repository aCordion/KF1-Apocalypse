//=============================================================================
// AK47 Ammo.
//=============================================================================
class WTFEquipAK48SAmmo extends KFAmmunition;

#EXEC OBJ LOAD FILE=KillingFloorHUD.utx

defaultproperties
{
     MaxAmmo=2400
     InitialAmount=1200
     AmmoPickupAmount=60
     PickupClass=Class'ApocMutators.WTFEquipAK48SAmmoPickup'
}
