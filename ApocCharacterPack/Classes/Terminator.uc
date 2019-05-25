class Terminator extends PlayerRecordClass;

//Load Files
#exec OBJ LOAD FILE=Term_A.ukx
#exec OBJ LOAD FILE=Term_T.utx

//Import Terminator Textures
#exec TEXTURE IMPORT FILE="Assets\terminator_portrait.dds" NAME=terminator_portrait GROUP=Terminator

defaultproperties
{
     Species=Class'TerminatorSpecies'
     MeshName="Term_A.terminatormesh"
     BodySkinName="Term_T.Term_cmb"
     FaceSkinName="Term_T.TermH_cmb"
     Portrait=Texture'Terminator.terminator_portrait'
     TextName=" Terminator"
     VoiceClassName="VoicePack"
     Sex="Male"
     Menu="SP"
     Skeleton="KFSoldiers.Soldier"
     Ragdoll="British_Soldier1"
}
