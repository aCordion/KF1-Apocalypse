class WTFEquipGlowstickPickup extends M79Pickup;

#exec obj load file=Asylum_SM.usx
#exec obj load file=Asylum_T.utx

defaultproperties
{
     Weight=0.000000
     cost=5
     PowerValue=0
     Description="A deadly weapon."
     ItemName="Glowstick"
     ItemShortName="Glowstick"
     InventoryType=Class'ApocMutators.WTFEquipGlowstick'
     PickupMessage="You got the Glowstick."
     StaticMesh=StaticMesh'Asylum_SM.Lighting.glow_sticks_green_pile'
     DrawScale=2.000000
}
