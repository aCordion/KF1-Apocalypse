class LeonCS extends PlayerRecordClass;

#exec OBJ LOAD FILE=LeonCS_A.ukx
#exec OBJ LOAD FILE=LeonCS_T.utx

defaultproperties
{
     Species=Class'KFMod.CivilianSpeciesReverend'
     MeshName="LeonCS_A.LeonCSMesh"
     BodySkinName="LeonCS_T.LeonCSSkin"
     FaceSkinName="LeonCS_T.LeonCSSkin"
     Portrait=Texture'LeonCS_T.LeonCSPortrait2'
     TextName="XPlayers.Default"
     VoiceClassName="KFMod.KFVoicePack"
     Sex="Male"
     Menu="SP"
     Skeleton="KFSoldiers.Soldier"
     Ragdoll="British_Soldier1"
}
