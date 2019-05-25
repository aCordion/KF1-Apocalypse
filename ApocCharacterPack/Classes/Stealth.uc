class Stealth extends PlayerRecordClass;

//Load Files
#exec OBJ LOAD FILE=StealthDT_A.ukx
#exec OBJ LOAD FILE=StealthDT_T.utx

//Import Stealth Textures
#exec TEXTURE IMPORT FILE="Assets\Stealth_Portrait.dds" NAME=Stealth_Portrait GROUP=Stealth

defaultproperties
{
     Species=Class'StealthDTSpecies'
     MeshName="StealthDT_A.StealthMesh"
     BodySkinName="StealthDT_T.Spy_gk_C"
     FaceSkinName="StealthDT_T.ShaderStealth"
     Portrait=Texture'Stealth.Stealth_Portrait'
     TextName=" Stealth"
     VoiceClassName="VoicePack"
     Sex="Male"
     Menu="SP"
     Skeleton="KFSoldiers.Soldier"
     Ragdoll="British_Soldier1"
}
