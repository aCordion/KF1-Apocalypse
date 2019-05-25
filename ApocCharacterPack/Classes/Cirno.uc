class Cirno extends PlayerRecordClass;

#exec OBJ LOAD FILE=Cirno_A.ukx
#exec OBJ LOAD FILE=Cirno_T.utx
#exec OBJ LOAD FILE=KFmod.u

defaultproperties
{
     Species=Class'CirnoSpecies'
     MeshName="Cirno_A.Cirnomesh"
     BodySkinName="Cirno_T.Cirno_cmb"
     FaceSkinName="Cirno_T.Cirno_cmb"
     Portrait=Texture'Cirno_T.CirnoP'
     VoiceClassName="KFMod.KFVoicePackFemale"
     Sex="F"
     Menu="SP"
     Skeleton="Cirno_A.Cirnomesh"
     Ragdoll="British_Soldier1"
}
