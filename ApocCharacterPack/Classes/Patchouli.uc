class Patchouli extends PlayerRecordClass;

#exec OBJ LOAD FILE=Patchouli_A.ukx
#exec OBJ LOAD FILE=Patchouli_T.utx
#exec OBJ LOAD FILE=KFmod.u

defaultproperties
{
     Species=Class'PatchouliSpecies'
     MeshName="Patchouli_A.Patchoulimesh"
     BodySkinName="Patchouli_T.Patchouli"
     FaceSkinName="Patchouli_T.Patchouli"
     Portrait=Texture'Patchouli_T.Common.PatchouliP'
     VoiceClassName="KFMod.KFVoicePackFemale"
     Sex="F"
     Menu="SP"
     Skeleton="Patchouli_A.Patchoulimesh"
     Ragdoll="British_Soldier1"
}
