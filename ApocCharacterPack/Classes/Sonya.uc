class Sonya extends PlayerRecordClass;

//Load Files
#exec OBJ LOAD FILE=Sonya_T.utx
#exec OBJ LOAD FILE=Sonya_A.ukx

//Import Sonya Textures
#exec TEXTURE IMPORT FILE="Assets\SonyaPortrait.dds" NAME=SonyaPortrait GROUP=Sonya

defaultproperties
{
     Species=Class'SonyaSpecies'
     MeshName="Sonya_A.SonyaMesh"
     BodySkinName="Sonya_T.SonyaSkin"
     FaceSkinName="Sonya_T.SonyaSkin"
     Portrait=Texture'Sonya.SonyaPortrait'
     TextName="XPlayers.Default"
     VoiceClassName="VoicePackFemale"
     Sex="Male"
     Menu="SP"
     Skeleton="KFSoldiers.Soldier"
     Ragdoll="British_Soldier1"
}
