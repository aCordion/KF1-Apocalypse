Class HL_BlueGravityGun extends HL_GravityGun;

defaultproperties
{
     EnergyColor=(B=128,G=80,R=64)
     GrabRange=1100.000000
     HoldLoopSound=Sound'HL2WeaponsS.PhysCannon.superphys_hold_loop'
     bIsOrganic=True
     HudImage=Texture'HL2WeaponsA.Icons.I_BGravGun'
     SelectedHudImage=Texture'HL2WeaponsA.Icons.I_BGravGun'
     TraderInfoTexture=Texture'HL2WeaponsA.Icons.I_BGravGun'
     Description="An Organic Zero Point Energy Manipulator."
     Priority=250
     PickupClass=Class'ApocMutators.HL_BlueGravityGunPickup'
     AttachmentClass=Class'ApocMutators.BGravityGunAttachment'
     ItemName="Organic Zero Point Energy Manipulator"
     Skins(0)=Combiner'HL2WeaponsA.Comb.v_hand_Refl'
     Skins(1)=Shader'HL2WeaponsA.Shaders.v_SuperPhysCanSh'
}
