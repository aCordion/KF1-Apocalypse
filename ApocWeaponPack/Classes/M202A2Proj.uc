// subclassing ROBallisticProjectile so we can do the ambient volume scaling
class M202A2Proj extends LAWProj;

#exec OBJ LOAD FILE=M202_SM.usx

defaultproperties
{
	StaticMeshRef="M202_SM.ExpRocket"
}