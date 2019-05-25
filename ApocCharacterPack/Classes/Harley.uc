class Harley extends PlayerRecordClass;

//Load Files
#exec OBJ LOAD FILE=Harley_A.ukx
#exec OBJ LOAD FILE=Harley_T.utx

//Import harley Textures
#exec TEXTURE IMPORT FILE="Assets\harley_portrait.dds" NAME=harley_portrait GROUP=harley

defaultproperties
{
     Species=Class'HarleySpecies'
     MeshName="Harley_A.harley_mdl"
     BodySkinName="Harley_T.Harley_Body"
     FaceSkinName="Harley_T.Harley_Limbs"
     Portrait=Texture'harley.harley_portrait'
     TextName="XPlayers.Default"
     VoiceClassName="VoicePackFemale"
     Sex="Male"
     Menu="SP"
     Skeleton="KFSoldiers.Soldier"
     Ragdoll="British_Soldier1"
}
