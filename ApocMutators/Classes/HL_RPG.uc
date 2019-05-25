Class HL_RPG extends HL2Weapon;

var transient FX_RPGLaser1st LaserAttachment;
var FX_LaserDot TargetDot;
var bool bTrackingProjectile;

replication
{
    reliable if( Role==ROLE_Authority && bNetOwner )
        bTrackingProjectile;
}

function AttachToPawn(Pawn P)
{
	Super.AttachToPawn(P);
	if( TargetDot==None && RPGAttachment(ThirdPersonActor)!=None )
	{
		TargetDot = Spawn(Class'FX_LaserDot');
		TargetDot.EffectOwner = RPGAttachment(ThirdPersonActor);
	}
}
function DetachFromPawn(Pawn P)
{
	Super.DetachFromPawn(P);
	if( TargetDot!=None )
		TargetDot.Destroy();
}

simulated event RenderOverlays( Canvas Canvas )
{
    if (Instigator == None)
        return;
	if ( Instigator.Controller != None )
		Hand = Instigator.Controller.Handedness;
    if ((Hand < -1.0) || (Hand > 1.0))
        return;

	if( LaserAttachment==None )
	{
		LaserAttachment = Spawn(Class'FX_RPGLaser1st');
		AttachToBone(LaserAttachment,'Muzzle');
	}
	Super.RenderOverlays(Canvas);
}
simulated function Destroyed()
{
	if( LaserAttachment!=None )
		LaserAttachment.Destroy();
	if( TargetDot!=None )
		TargetDot.Destroy();
	Super.Destroyed();
}

defaultproperties
{
     bHasCrosshair=False
     MagCapacity=1
     ReloadRate=1.730000
     WeaponReloadAnim="Reload_LAW"
     HudImage=Texture'HL2WeaponsA.Icons.I_RPG'
     SelectedHudImage=Texture'HL2WeaponsA.Icons.I_RPG'
     Weight=8.000000
     TraderInfoTexture=Texture'HL2WeaponsA.Icons.I_RPG'
     FireModeClass(0)=Class'ApocMutators.RPGFire'
     FireModeClass(1)=Class'KFMod.NoFire'
     Description="RPG"
     Priority=220
     InventoryGroup=4
     GroupOffset=6
     PickupClass=Class'ApocMutators.HL_RPGPickup'
     PlayerViewPivot=(Yaw=-16384)
     AttachmentClass=Class'ApocMutators.RPGAttachment'
     ItemName="Rocket propelled grenade launcher"
     Mesh=SkeletalMesh'HL2WeaponsA.HL_RPG'
}
