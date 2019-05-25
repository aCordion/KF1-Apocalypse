class Ichigo extends PlayerRecordClass;

//Load Files
#exec OBJ LOAD FILE=SkinsPackV1_A.ukx
#exec OBJ LOAD FILE=SkinsPackV1_T.utx

//Import Ichigo Textures
#exec TEXTURE IMPORT FILE="Assets\Ichigo_Portrait.dds" NAME=Ichigo_Portrait GROUP=Ichigo

defaultproperties
{
     Species=Class'IchigoSpecies'
     MeshName="SkinsPackV1_A.IchigoMesh"
     BodySkinName="SkinsPackV1_T.Ichigo_skin"
     FaceSkinName="SkinsPackV1_T.Ichigo_skin"
     Portrait=Texture'Ichigo.Ichigo_Portrait'
     TextName="XPlayers.Default"
     VoiceClassName="VoicePack"
     Sex="Male"
     Menu="SP"
     Skeleton="KFSoldiers.Soldier"
     Ragdoll="British_Soldier1"
}
