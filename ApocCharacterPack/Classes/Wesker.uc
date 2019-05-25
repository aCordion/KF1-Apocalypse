class Wesker extends PlayerRecordClass;

//Load Files
#exec OBJ LOAD FILE=Wesker_A.ukx
#exec OBJ LOAD FILE=Wesker_T.utx

//Import Wesker Textures
#exec TEXTURE IMPORT FILE="Assets\WeskerPortrait.dds" NAME=WeskerPortrait GROUP=Wesker

defaultproperties
{
     Species=Class'WeskerSpecies'
     MeshName="Wesker_A.WeskerMesh"
     BodySkinName="Wesker_T.WeskerSkin"
     FaceSkinName="Wesker_T.WeskerSkin"
     Portrait=Texture'Wesker.WeskerPortrait'
     TextName=" Wesker"
     VoiceClassName="VoicePack"
     Sex="Male"
     Menu="SP"
     Skeleton="KFSoldiers.Soldier"
     Ragdoll="British_Soldier1"
}
