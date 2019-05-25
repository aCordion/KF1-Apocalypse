class WTFEquipSelfDestruct extends PipeBombExplosive;

#exec obj load file=WTFTex.utx

defaultproperties
{
     FireModeClass(0)=Class'ApocMutators.WTFEquipSelfDestructFire'
     bCanThrow=True
     AmmoClass(0)=Class'ApocMutators.WTFEquipSelfDestructAmmo'
     Description="A deadly weapon"
     Priority=0
     InventoryGroup=1
     GroupOffset=0
     PickupClass=Class'ApocMutators.WTFEquipSelfDestructPickup'
     AttachmentClass=Class'ApocMutators.WTFEquipSelfDestructAttachment'
     ItemName="Self Destruct!"
     Skins(0)=Texture'WTFTex.Selfdestruct.Selfdestruct'
     Skins(1)=Texture'KF_Weapons2_Trip_T.Special.Pipebomb_RLight_OFF'
     Skins(2)=Shader'KF_Weapons2_Trip_T.Special.Pipebomb_GLight_shdr'
}
