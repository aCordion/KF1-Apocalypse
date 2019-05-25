class Billy extends PlayerRecordClass;

#exec OBJ LOAD FILE=Billy.ukx
#exec OBJ LOAD FILE=Billy_T.utx

defaultproperties
{
     Species=Class'BillySpecies'
     MeshName="Billy.Billy_Soldier"
     BodySkinName="Billy_T.billy_skin"
     FaceSkinName="Billy_T.billy_skin"
     Portrait=Texture'Billy_T.billy_portrait'
     TextName="XPlayers.Default"
     VoiceClassName="KFMod.KFVoicePack"
     Sex="Male"
     Menu="SP"
     Skeleton="KFSoldiers.Soldier"
     Ragdoll="British_Soldier1"
}
