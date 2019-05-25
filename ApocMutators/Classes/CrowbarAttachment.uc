Class CrowbarAttachment extends HL2WeaponAttachment;

simulated function DrawTraceHit( vector Start, vector HL, vector HN, Actor Other )
{
	if( Other!=None )
	{
		if( Pawn(Other)!=None && Vehicle(Other)==None )
			Spawn(Class'FX_HitBlood',,,HL,Rotator(-HN));
		else Spawn(WallHitEffect,,,HL,Rotator(-HN));
	}
	CheckForSplash();
}
function UpdateHit(Actor HitActor, vector HitLocation, vector HitNormal)
{
	Instigator.SetAnimAction(FireAnims[Rand(4)]);
	if( HitActor!=None )
		Super.UpdateHit(HitActor,HitLocation,HitNormal);
}
event ThirdPersonEffects();

defaultproperties
{
     mTracerClass=None
     MovementAnims(0)="JogF_Knife"
     MovementAnims(1)="JogB_Knife"
     MovementAnims(2)="JogL_Knife"
     MovementAnims(3)="JogR_Knife"
     TurnLeftAnim="TurnL_Knife"
     TurnRightAnim="TurnR_Knife"
     CrouchAnims(0)="CHwalkF_Knife"
     CrouchAnims(1)="CHwalkB_Knife"
     CrouchAnims(2)="CHwalkL_Knife"
     CrouchAnims(3)="CHwalkR_Knife"
     CrouchTurnRightAnim="CH_TurnR_Knife"
     CrouchTurnLeftAnim="CH_TurnL_Knife"
     IdleCrouchAnim="CHIdle_Knife"
     IdleWeaponAnim="Idle_Knife"
     IdleRestAnim="Idle_Knife"
     IdleChatAnim="Idle_Knife"
     IdleHeavyAnim="Idle_Knife"
     IdleRifleAnim="Idle_Knife"
     FireAnims(0)="FastAttack1_Knife"
     FireAnims(1)="FastAttack2_Machete"
     FireAnims(2)="FastAttack3_Knife"
     FireAnims(3)="FastAttack3_Machete"
     FireAltAnims(0)="Attack1_Knife"
     FireAltAnims(1)="Attack1_Knife"
     FireAltAnims(2)="Attack1_Knife"
     FireAltAnims(3)="Attack1_Knife"
     FireCrouchAnims(0)="CHAttack2_Knife"
     FireCrouchAnims(1)="CHAttack2_Knife"
     FireCrouchAnims(2)="CHAttack2_Knife"
     FireCrouchAnims(3)="CHAttack2_Knife"
     FireCrouchAltAnims(0)="CHAttack1_Knife"
     FireCrouchAltAnims(1)="CHAttack1_Knife"
     FireCrouchAltAnims(2)="CHAttack1_Knife"
     FireCrouchAltAnims(3)="CHAttack1_Knife"
     HitAnims(0)="HitF_Knife"
     HitAnims(1)="HitB_Knife"
     HitAnims(2)="HitL_Knife"
     HitAnims(3)="HitR_Knife"
     PostFireBlendStandAnim="Blend_Knife"
     PostFireBlendCrouchAnim="CHBlend_Knife"
     Mesh=SkeletalMesh'HL2WeaponsA.HL_Crowbar3rd'
     RelativeLocation=(Z=7.000000)
     RelativeRotation=(Pitch=32768,Roll=-16384)
}
