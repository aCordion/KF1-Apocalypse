class Nepgear extends PlayerRecordClass;

#exec OBJ LOAD FILE=Nepgear_A.ukx
#exec OBJ LOAD FILE=Nepgear_T.utx
#exec OBJ LOAD FILE=KFmod.u

defaultproperties
{
     Species=Class'NepgearSpecies'
     MeshName="Nepgear_A.Nepgearmesh"
     BodySkinName="Nepgear_T.Nepgear"
     FaceSkinName="Nepgear_T.Nepgear"
     Portrait=Texture'Nepgear_T.NepgearP'
     VoiceClassName="KFMod.KFVoicePackFemale"
     Sex="F"
     Menu="SP"
     Skeleton="Nepgear_A.Nepgearmesh"
     Ragdoll="British_Soldier1"
}
