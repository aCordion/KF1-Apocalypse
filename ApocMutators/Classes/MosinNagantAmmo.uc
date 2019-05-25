//=============================================================================
// M14EBR Ammo.
//=============================================================================
class MosinNagantAmmo extends KFAmmunition;

#EXEC OBJ LOAD FILE=KillingFloorHUD.utx

defaultproperties
{
     AmmoPickupAmount=5
     MaxAmmo=60
     InitialAmount=30
     PickupClass=None
     IconMaterial=Texture'KillingFloorHUD.Generic.HUD'
     IconCoords=(X1=336,Y1=82,X2=382,Y2=125)
     ItemName="Nagant Bullets"
}
