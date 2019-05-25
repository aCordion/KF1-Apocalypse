class Aya extends PlayerRecordClass;

#exec OBJ LOAD FILE=Aya_A.ukx
#exec OBJ LOAD FILE=Aya_T.utx
#exec OBJ LOAD FILE=KFmod.u

defaultproperties
{
     Species=Class'AyaSpecies'
     MeshName="Aya_A.Ayamesh"
     BodySkinName="Aya_T.Aya_cmb"
     FaceSkinName="Aya_T.Aya_cmb"
     Portrait=Texture'Aya_T.AyaP'
     VoiceClassName="KFMod.KFVoicePackFemale"
     Sex="F"
     Menu="SP"
     Skeleton="Aya_A.Ayamesh"
     Ragdoll="British_Soldier1"
}
