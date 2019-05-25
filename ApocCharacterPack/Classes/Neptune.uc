class Neptune extends PlayerRecordClass;

#exec OBJ LOAD FILE=Neptune_A.ukx
#exec OBJ LOAD FILE=Neptune_T.utx
#exec OBJ LOAD FILE=KFmod.u

defaultproperties
{
     Species=Class'NeptuneSpecies'
     MeshName="Neptune_A.Neptunemesh"
     BodySkinName="Neptune_T.Neptune"
     FaceSkinName="Neptune_T.Neptune"
     Portrait=Texture'Neptune_T.NeptuneP'
     VoiceClassName="KFMod.KFVoicePackFemale"
     Sex="F"
     Menu="SP"
     Skeleton="Neptune_A.Neptunemesh"
     Ragdoll="British_Soldier1"
}
