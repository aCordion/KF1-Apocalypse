class Remilia extends PlayerRecordClass;

#exec OBJ LOAD FILE=Remilia_A.ukx
#exec OBJ LOAD FILE=Remilia_T.utx
#exec OBJ LOAD FILE=KFmod.u

defaultproperties
{
     Species=Class'RemiliaSpecies'
     MeshName="Remilia_A.Remiliamesh"
     BodySkinName="Remilia_T.Remilia_cmb"
     FaceSkinName="Remilia_T.Remilia_cmb"
     Portrait=Texture'Remilia_T.RemiliaP'
     VoiceClassName="KFMod.KFVoicePackFemale"
     Sex="F"
     Menu="SP"
     Skeleton="Remilia_A.Remiliamesh"
     Ragdoll="British_Soldier1"
}
