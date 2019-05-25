class Molotov extends M79GrenadeLauncher;

#exec OBJ LOAD FILE=Molotov_A.ukx

defaultproperties
{
     ReloadAnim="Select"
     FlashBoneName="Hands_R_wrist"
     WeaponReloadAnim="Select"
     HudImage=Texture'Molotov_A.Molotov_unselected'
     SelectedHudImage=Texture'Molotov_A.Molotov_selected'
     Weight=0.000000
     bHasAimingMode=False
     IdleAimAnim="Idle"
     TraderInfoTexture=Texture'Molotov_A.Trader_Molotov'
     MeshRef="Molotov_A.Molotov_Trip"
     SkinRefs(0)="Molotov_A.Molotov_cmb"
     SkinRefs(2)="Molotov_A.v_eq_molotov_cmb"
     SkinRefs(3)="Molotov_A.FBFlameOrange"
     FireModeClass(0)=class'MolotovFire'
     Description="A deadly weapon"
     Priority=4
     InventoryGroup=5
     GroupOffset=4
     PickupClass=class'MolotovPickup'
     PlayerViewOffset=(X=0.000000,Y=0.000000,Z=0.000000)
     AttachmentClass=class'MolotovAttachment'
     ItemName="Molotov Cocktail"
     Mesh=SkeletalMesh'Molotov_A.Molotov_Trip'
     Skins(0)=Combiner'Molotov_A.Molotov_cmb'
     Skins(2)=Combiner'Molotov_A.v_eq_molotov_cmb'
     Skins(3)=FinalBlend'Molotov_A.FBFlameOrange'
}
