class M202A2Pickup extends M202A1Pickup;

#exec OBJ LOAD FILE=M202_T.utx
#exec OBJ LOAD FILE=M202_SM.usx
#exec OBJ LOAD FILE=M202_A.ukx

defaultproperties
{
	ItemName="M202-A2"
	ItemShortName="M202-A2"
	AmmoItemName="66 mm rockets"
	Mesh=SkeletalMesh'M202_A.M202_3rd'
	AmmoMesh=StaticMesh'M202_SM.RocketBoxInc'
	InventoryType=Class'M202A2'
	PickupMessage="You got the M202-A2"
	StaticMesh=StaticMesh'M202_SM.M202A1'
	Skins(0)=Texture'M202_T.items.M202_Black_SM'
	EquipmentCategoryID=3
	CorrespondingPerkIndex=6
}
