class Deadpool extends PlayerRecordClass;

#exec obj load file=DeadPool_A.ukx
#exec obj load file=DeadPool_T.utx

defaultproperties
{
     Species=Class'DeadpoolSpecies'
     MeshName="DeadPool_A.dpool"
     BodySkinName="DeadPool_T.Male_basic"
     FaceSkinName="DeadPool_T.extras_cmb"
     Portrait=Texture'DeadPool_T.portrait'
     VoiceClassName="KFVoicePack"
     Sex="M"
     Menu="SP"
     Skeleton="DeadPool_T.dpool"
     Ragdoll="British_Soldier1"
}
