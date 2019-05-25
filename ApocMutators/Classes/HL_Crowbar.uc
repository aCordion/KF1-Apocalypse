Class HL_Crowbar extends HL2WeaponNA;

defaultproperties
{
     FlashBoneName="Bip01_R_Hand"
     HudImage=Texture'HL2WeaponsA.Icons.I_Crowbar'
     SelectedHudImage=Texture'HL2WeaponsA.Icons.I_Crowbar'
     Weight=2.000000
     TraderInfoTexture=Texture'HL2WeaponsA.Icons.I_Crowbar'
     FireModeClass(0)=Class'ApocMutators.CrowbarFire'
     FireModeClass(1)=Class'KFMod.NoFire'
     Description="A steel crowbar."
     Priority=35
     GroupOffset=1
     PickupClass=Class'ApocMutators.HL_CrowbarPickup'
     PlayerViewPivot=(Yaw=32768)
     AttachmentClass=Class'ApocMutators.CrowbarAttachment'
     ItemName="Crowbar"
     Mesh=SkeletalMesh'HL2WeaponsA.HL_Crowbar'
}
