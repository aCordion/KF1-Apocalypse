class ES extends PlayerRecordClass;

//Load Files
#exec OBJ LOAD FILE=ES_A.ukx
#exec OBJ LOAD FILE=ES_T.utx

//Import ES Textures
#exec TEXTURE IMPORT FILE="Assets\ESPortrait.dds" NAME=ESPortrait GROUP=ES

defaultproperties
{
     Species=Class'ESSpecies'
     MeshName="ES_A.ESMesh"
     BodySkinName="ES_T.ESSkinOne"
     FaceSkinName="ES_T.ESSkinTwo"
     Portrait=Texture'ES.ESPortrait'
     TextName="XPlayers.Default"
     VoiceClassName="VoicePack"
     Sex="Male"
     Menu="SP"
     Skeleton="KFSoldiers.Soldier"
     Ragdoll="British_Soldier1"
}
