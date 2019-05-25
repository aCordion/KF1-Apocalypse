class WTFEquipFlaregun extends M79GrenadeLauncher;

#exec obj load file=WTFTex.utx

defaultproperties
{
     Weight=1.000000
     FireModeClass(0)=Class'ApocMutators.WTFEquipFlaregunFire'
     Description="A deadly weapon"
     Priority=5
     InventoryGroup=5
     GroupOffset=3
     PickupClass=Class'ApocMutators.WTFEquipFlaregunPickup'
     AttachmentClass=Class'ApocMutators.WTFEquipFlaregunAttachment'
     ItemName="Flaregun"
     Skins(0)=Texture'WTFTex.Flaregun.Flaregun'
}
