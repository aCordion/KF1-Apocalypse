class Jill extends PlayerRecordClass;

//Load Files
#exec OBJ LOAD FILE=Jill_A.ukx
#exec OBJ LOAD FILE=Jill_T.utx

//Import Jill Textures
#exec TEXTURE IMPORT FILE="Assets\jill_portrait.dds" NAME=jill_portrait GROUP=Jill

defaultproperties
{
     Species=Class'JillSpecies'
     MeshName="Jill_A.J5Mesh"
     BodySkinName="Jill_T.J5Skin"
     FaceSkinName="Jill_T.J5Skin"
     Portrait=Texture'Jill.jill_portrait'
     TextName="XPlayers.Default"
     VoiceClassName="VoicePackFemale"
     Sex="Male"
     Menu="SP"
     Skeleton="KFSoldiers.Soldier"
     Ragdoll="British_Soldier1"
}
