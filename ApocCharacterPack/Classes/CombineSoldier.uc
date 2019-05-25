class CombineSoldier extends PlayerRecordClass;

#exec OBJ LOAD FILE=CombineSoldier_A.ukx
#exec OBJ LOAD FILE=CombineSoldier_T.utx

defaultproperties
{
     Species=class'CombineSoldierSpecies'
     MeshName="CombineSoldier_A.HLMarineMesh"
     BodySkinName="CombineSoldier_T.CombineSoldierSkin"
     FaceSkinName="CombineSoldier_T.CombineSoldierSkin"
     Portrait=Texture'CombineSoldier_T.CombineSoldierPortrait'
     TextName="XPlayers.Default"
     VoiceClassName="KFMod.KFVoicePack"
     Sex="Male"
     Menu="SP"
     Skeleton="KFSoldiers.Soldier"
     Ragdoll="British_Soldier1"
}
