Class GravityGunAttachment extends HL2WeaponAttachment;

var transient FX_GravityGunFBolt BoltFX;
var() color EffectColor;

simulated function DrawTraceHit( vector Start, vector HL, vector HN, Actor Other )
{
	Instigator.PlaySound(Sound'Phys_Launch',SLOT_None,1.4f,,400.f);
	if( BoltFX==None )
	{
		BoltFX = Spawn(Class'FX_GravityGunFBolt');
		BoltFX.SetColor(EffectColor);
	}
	BoltFX.DrawBeam(GetTracerStart(),HL);
	WeaponLight();
	KFPawn(Instigator).StartFiringX(false,false);
}
simulated function Destroyed()
{
	if( BoltFX!=None )
		BoltFX.Destroy();
	Super.Destroyed();
}

defaultproperties
{
     EffectColor=(B=50,G=128,R=255,A=255)
     MovementAnims(0)="JogF_M4203"
     MovementAnims(1)="JogB_M4203"
     MovementAnims(2)="JogL_M4203"
     MovementAnims(3)="JogR_M4203"
     TurnLeftAnim="TurnL_M4203"
     TurnRightAnim="TurnR_M4203"
     CrouchAnims(0)="CHWalkF_M4203"
     CrouchAnims(1)="CHWalkB_M4203"
     CrouchAnims(2)="CHWalkL_M4203"
     CrouchAnims(3)="CHWalkR_M4203"
     WalkAnims(0)="WalkF_M4203"
     WalkAnims(1)="WalkB_M4203"
     WalkAnims(2)="WalkL_M4203"
     WalkAnims(3)="WalkR_M4203"
     CrouchTurnRightAnim="CH_TurnR_M4203"
     CrouchTurnLeftAnim="CH_TurnL_M4203"
     IdleCrouchAnim="CHIdle_M4203"
     IdleWeaponAnim="Idle_M4203"
     IdleRestAnim="Idle_M4203"
     IdleChatAnim="Idle_M4203"
     IdleHeavyAnim="Idle_M4203"
     IdleRifleAnim="Idle_M4203"
     FireAnims(0)="Fire_M4203"
     FireAnims(1)="Fire_M4203"
     FireAnims(2)="Fire_M4203"
     FireAnims(3)="Fire_M4203"
     FireAltAnims(0)="Reload_Secondary_M4203"
     FireAltAnims(1)="Reload_Secondary_M4203"
     FireAltAnims(2)="Reload_Secondary_M4203"
     FireAltAnims(3)="Reload_Secondary_M4203"
     FireCrouchAnims(0)="CHFire_M4203"
     FireCrouchAnims(1)="CHFire_M4203"
     FireCrouchAnims(2)="CHFire_M4203"
     FireCrouchAnims(3)="CHFire_M4203"
     FireCrouchAltAnims(0)="Reload_Secondary_M4203"
     FireCrouchAltAnims(1)="Reload_Secondary_M4203"
     FireCrouchAltAnims(2)="Reload_Secondary_M4203"
     FireCrouchAltAnims(3)="Reload_Secondary_M4203"
     HitAnims(0)="HitF_M4203"
     HitAnims(1)="HitB_M4203"
     HitAnims(2)="HitL_M4203"
     HitAnims(3)="HitR_M4203"
     PostFireBlendStandAnim="Blend_M4203"
     PostFireBlendCrouchAnim="CHBlend_M4203"
     Mesh=SkeletalMesh'HL2WeaponsA.HL_PhysCannon3rd'
     RelativeLocation=(X=14.000000)
     RelativeRotation=(Yaw=-16384)
}
