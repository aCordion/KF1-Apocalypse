class Goku extends PlayerRecordClass;

//Load Files
#exec OBJ LOAD FILE=SkinsPackV1_A.ukx
#exec OBJ LOAD FILE=SkinsPackV1_T.utx

//Import Goku Textures
#exec TEXTURE IMPORT FILE="Assets\GokuSS3Portrait.dds" NAME=GokuSS3Portrait GROUP=Goku

defaultproperties
{
     Species=Class'GokuSpecies'
     MeshName="SkinsPackV1_A.GokuSS3Mesh"
     BodySkinName="SkinsPackV1_T.GokuSS3Skin"
     FaceSkinName="SkinsPackV1_T.GokuSS3Skin"
     Portrait=Texture'Goku.GokuSS3Portrait'
     TextName="XPlayers.Default"
     VoiceClassName="VoicePack"
     Sex="Male"
     Menu="SP"
     Skeleton="KFSoldiers.Soldier"
     Ragdoll="British_Soldier1"
}
