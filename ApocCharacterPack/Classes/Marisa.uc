class Marisa extends PlayerRecordClass;

#exec OBJ LOAD FILE=Marisa_A.ukx
#exec OBJ LOAD FILE=Marisa_T.utx
#exec OBJ LOAD FILE=KFmod.u

defaultproperties
{
     Species=Class'MarisaSpecies'
     MeshName="Marisa_A.Marisamesh"
     BodySkinName="Marisa_T.Marisa_cmb"
     FaceSkinName="Marisa_T.Marisa_cmb"
     Portrait=Texture'Marisa_T.MarisaP'
     VoiceClassName="KFMod.KFVoicePackFemale"
     Sex="F"
     Menu="SP"
     Skeleton="Marisa_A.Marisamesh"
     Ragdoll="British_Soldier1"
}
