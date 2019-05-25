class Hina extends PlayerRecordClass;

#exec OBJ LOAD FILE=Hina_A.ukx
#exec OBJ LOAD FILE=Hina_T.utx
#exec OBJ LOAD FILE=KFmod.u

defaultproperties
{
     Species=Class'HinaSpecies'
     MeshName="Hina_A.Hinamesh"
     BodySkinName="Hina_T.Hina"
     FaceSkinName="Hina_T.Hina"
     Portrait=Texture'Hina_T.HinaP'
     VoiceClassName="KFMod.KFVoicePackFemale"
     Sex="F"
     Menu="SP"
     Skeleton="Hina_A.Hinamesh"
     Ragdoll="British_Soldier1"
}
