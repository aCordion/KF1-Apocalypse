class Dante extends PlayerRecordClass;

//Load Files
#exec OBJ LOAD FILE=SkinsPackV1_A.ukx
#exec OBJ LOAD FILE=SkinsPackV1_T.utx

//Import Dante Textures
#exec TEXTURE IMPORT FILE="Assets\Dante_Portrait.dds" NAME=Dante_Portrait GROUP=Dante

defaultproperties
{
     Species=Class'DanteSpecies'
     MeshName="SkinsPackV1_A.DanteMesh"
     BodySkinName="SkinsPackV1_T.DanteSkin"
     FaceSkinName="SkinsPackV1_T.DanteSkin"
     Portrait=Texture'Dante.Dante_Portrait'
     TextName="XPlayers.Default"
     VoiceClassName="VoicePack"
     Sex="Male"
     Menu="SP"
     Skeleton="KFSoldiers.Soldier"
     Ragdoll="British_Soldier1"
}
