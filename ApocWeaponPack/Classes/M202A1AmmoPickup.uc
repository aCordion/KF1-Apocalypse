//=============================================================================
// M202-A1 Ammo Pickup.
//=============================================================================
class M202A1AmmoPickup extends KFAmmoPickup;

#exec OBJ LOAD FILE=M202_SM.usx

defaultproperties
{
     AmmoAmount=4
     InventoryType=Class'M202A1Ammo'
     PickupMessage="Incendary Rockets"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'M202_SM.RocketBoxInc'
     DrawScale=1.500000
     CollisionRadius=40.000000
     CollisionHeight=10.000000
}