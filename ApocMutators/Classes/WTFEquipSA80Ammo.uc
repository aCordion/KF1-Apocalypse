//=============================================================================
// L85 Ammo.
//=============================================================================
class WTFEquipSA80Ammo extends KFAmmunition;

#EXEC OBJ LOAD FILE=KillingFloorHUD.utx

defaultproperties
{
     MaxAmmo=120
     InitialAmount=80
     PickupClass=Class'ApocMutators.WTFEquipSA80AmmoPickup'
     IconMaterial=Texture'KillingFloorHUD.Generic.HUD'
     IconCoords=(X1=336,Y1=82,X2=382,Y2=125)
     ItemName="SA80 bullets"
}
