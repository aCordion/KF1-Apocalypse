class Claude extends PlayerRecordClass;

//Load Files
#exec OBJ LOAD FILE=Claude_A.ukx
#exec OBJ LOAD FILE=Claude_T.utx

//Import Claude Textures
#exec TEXTURE IMPORT FILE="Assets\ClaudePortrait.dds" NAME=ClaudePortrait GROUP=Claude

defaultproperties
{
     Species=Class'ClaudeSpecies'
     MeshName="Claude_A.ClaudeMesh"
     BodySkinName="Claude_T.ClaudeSkin"
     FaceSkinName="Claude_T.ClaudeSkin"
     Portrait=Texture'Claude.ClaudePortrait'
     TextName="XPlayers.Default"
     VoiceClassName="VoicePack"
     Sex="Male"
     Menu="SP"
     Skeleton="KFSoldiers.Soldier"
     Ragdoll="British_Soldier1"
}
