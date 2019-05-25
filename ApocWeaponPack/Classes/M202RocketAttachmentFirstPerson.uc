class M202RocketAttachmentFirstPerson extends InventoryAttachment;

#exec OBJ LOAD FILE=M202_T.utx

defaultproperties
{
	DrawType=DT_Mesh
	bAcceptsProjectors=False
	bUseLightingFromBase=True
	bUnlit = true
	AttachmentBone=LightBone
	Mesh = SkeletalMesh 'M202_A.ERockets'
	Skins(0)=Combiner'M202_T.items.ExplosiveRockets_ForHandsDT_cmb'
	bUseDynamicLights=True
	MaxLights = 0
	DrawScale = 1.0
}
