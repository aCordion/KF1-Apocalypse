class SubZero extends PlayerRecordClass;

//Load Files
#exec OBJ LOAD FILE=SubZero_A.ukx
#exec OBJ LOAD FILE=SubZero_T.utx

//Import SubZero Textures
#exec TEXTURE IMPORT FILE="Assets\SubZeroPortrait.dds" NAME=SubZeroPortrait GROUP=SubZero

defaultproperties
{
     Species=Class'SubZeroSpecies'
     MeshName="SubZero_A.SZMesh"
     BodySkinName="SubZero_T.SZSkin"
     FaceSkinName="SubZero_T.SZSkin"
     Portrait=Texture'SubZero.SubZeroPortrait'
     TextName="XPlayers.Default"
     VoiceClassName="VoicePack"
     Sex="Male"
     Menu="SP"
     Skeleton="KFSoldiers.Soldier"
     Ragdoll="British_Soldier1"
}
