class WTFEquipWeldaPickup extends KFWeaponPickup;

#exec obj load file="..\StaticMeshes\NewPatchSM.usx"

defaultproperties
{
     cost=1
     Description="A deadly weapon."
     ItemName="Legend of Welda"
     ItemShortName="Legend of Welda"
     InventoryType=Class'ApocMutators.WTFEquipWelda'
     PickupMessage="The Legend of Welda Begins..."
     Skins(0)=Texture'WTFTex.Welda.Welda_3rd'
}
