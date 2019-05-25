class Pony extends PlayerRecordClass;

//Load Files
#exec OBJ LOAD FILE=SkinsPackV1_A.ukx
#exec OBJ LOAD FILE=SkinsPackV1_T.utx

//Import Dante Textures
#exec TEXTURE IMPORT FILE="Assets\Pony_Portrait.dds" NAME=Pony_Portrait GROUP=Pony

defaultproperties
{
     Species=Class'PonySpecies'
     MeshName="SkinsPackV1_A.AJMLPMesh"
     BodySkinName="SkinsPackV1_T.Pony_skin"
     FaceSkinName="SkinsPackV1_T.Pony_skin"
     Portrait=Texture'Pony.Pony_Portrait'
     TextName="XPlayers.Default"
     VoiceClassName="VoicePackFemale"
     Sex="Female"
     Menu="SP"
     Skeleton="KFSoldiers.Soldier"
     Ragdoll="British_Soldier1"
}
