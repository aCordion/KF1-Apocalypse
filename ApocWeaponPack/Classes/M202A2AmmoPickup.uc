//=============================================================================
// M202-A2 Ammo Pickup.
//=============================================================================
class M202A2AmmoPickup extends M202A1AmmoPickup;

//#exec OBJ LOAD FILE=M202_SM.usx
#EXEC OBJ LOAD FILE=KillingFloorHUD.utx

defaultproperties
{
     InventoryType=Class'M202A2Ammo'
     PickupMessage="H.E.A.T. Rockets"
     Skins(0)=Texture'M202_T.items.Box_HEAT'
}