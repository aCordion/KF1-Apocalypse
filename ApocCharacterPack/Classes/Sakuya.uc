class Sakuya extends PlayerRecordClass;

#exec OBJ LOAD FILE=Sakuya_A.ukx
#exec OBJ LOAD FILE=Sakuya_T.utx
#exec OBJ LOAD FILE=KFmod.u

defaultproperties
{
     Species=Class'SakuyaSpecies'
     MeshName="Sakuya_A.Sakuyamesh"
     BodySkinName="Sakuya_T.Sakuya_cmb"
     FaceSkinName="Sakuya_T.Sakuya_cmb"
     Portrait=Texture'Sakuya_T.SakuyaP'
     VoiceClassName="KFMod.KFVoicePackFemale"
     Sex="F"
     Menu="SP"
     Skeleton="Sakuya_A.Sakuyamesh"
     Ragdoll="British_Soldier1"
}
