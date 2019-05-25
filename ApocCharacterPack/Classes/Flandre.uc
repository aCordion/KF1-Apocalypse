class Flandre extends PlayerRecordClass;

#exec OBJ LOAD FILE=Flandre_A.ukx
#exec OBJ LOAD FILE=Flandre_T.utx
#exec OBJ LOAD FILE=KFmod.u

defaultproperties
{
     Species=Class'FlandreSpecies'
     MeshName="Flandre_A.Flandremesh"
     BodySkinName="Flandre_T.Flandre"
     FaceSkinName="Flandre_T.Flandre"
     Portrait=Texture'Flandre_T.FlandreP'
     VoiceClassName="KFMod.KFVoicePackFemale"
     Sex="F"
     Menu="SP"
     Skeleton="Flandre_A.Flandremesh"
     Ragdoll="British_Soldier1"
}
