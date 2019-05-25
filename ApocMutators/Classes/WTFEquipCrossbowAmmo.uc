class WTFEquipCrossbowAmmo extends KFAmmunition;

#EXEC OBJ LOAD FILE=KillingFloorHUD.utx

defaultproperties
{
     MaxAmmo=2000// Reduced in Balance Round 1
     InitialAmount=1000// Reduced in Balance Round 1
     AmmoPickupAmount=10// Reduced in Balance Round 1
     PickupClass=Class'ApocMutators.WTFEquipCrossbowAmmoPickup'
}
