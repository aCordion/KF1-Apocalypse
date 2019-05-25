class ZoeyBikini extends PlayerRecordClass;

//Load Files
#exec OBJ LOAD FILE=SkinsPackV1_A.ukx
#exec OBJ LOAD FILE=SkinsPackV1_T.utx

//Import Dante Textures
#exec TEXTURE IMPORT FILE="Assets\Zoey_Bikini_Portrait.dds" NAME=Zoey_Bikini_Portrait GROUP=ZoeyBikini

defaultproperties
{
     Species=Class'ZoeyBikiniSpecies'
     MeshName="SkinsPackV1_A.ZoeyBMesh"
     BodySkinName="SkinsPackV1_T.Zoey_Bikin_skin"
     FaceSkinName="SkinsPackV1_T.Zoey_Bikin_skin"
     Portrait=Texture'ZoeyBikini.Zoey_Bikini_Portrait'
     TextName="XPlayers.Default"
     VoiceClassName="VoicePackFemale"
     Sex="Female"
     Menu="SP"
     Skeleton="KFSoldiers.Soldier"
     Ragdoll="British_Soldier1"
}
