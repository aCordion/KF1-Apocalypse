class MikuChan extends PlayerRecordClass;

//Load Files
#exec OBJ LOAD FILE=MikuChan_A.ukx
#exec OBJ LOAD FILE=MikuChan_T.utx

//Import MikuChan Textures
#exec TEXTURE IMPORT FILE="Assets\miku_portrait.dds" NAME=miku_portrait GROUP=MikuChan

defaultproperties
{
     Species=Class'MikuChanSpecies'
     MeshName="MikuChan_A.MikuChan"
     BodySkinName="MikuChan_T.mikuchan_open"
     FaceSkinName="MikuChan_T.mikuchan_open"
     Portrait=Texture'MikuChan.miku_portrait'
     TextName="XPlayers.Default"
     VoiceClassName="JPVoicePackFemale"
     Sex="Male"
     Menu="SP"
     Skeleton="KFSoldiers.Soldier"
     Ragdoll="British_Soldier1"
}
