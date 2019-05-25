class Reimu extends PlayerRecordClass;

#exec OBJ LOAD FILE=Reimu_A.ukx
#exec OBJ LOAD FILE=Reimu_T.utx
#exec OBJ LOAD FILE=KFmod.u

defaultproperties
{
     Species=Class'ReimuSpecies'
     MeshName="Reimu_A.Reimu_mesh"
     BodySkinName="Reimu_T.Reimu_cmb"
     FaceSkinName="Reimu_T.Reimu_cmb"
     Portrait=Texture'Reimu_T.ReimuP'
     VoiceClassName="KFMod.KFVoicePackFemale"
     Sex="F"
     Menu="SP"
     Skeleton="Reimu_A.Reimu_mesh"
     Ragdoll="British_Soldier1"
}
