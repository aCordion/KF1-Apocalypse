Class BugBaitAttachment extends HL2WeaponAttachment;

simulated event ThirdPersonEffects()
{
  	if ( Level.NetMode!=NM_DedicatedServer && FlashCount>0 && KFPawn(Instigator)!=None )
		KFPawn(Instigator).StartFiringX(false,false);
}

defaultproperties
{
     MovementAnims(0)="JogF_Pipe"
     MovementAnims(1)="JogB_Pipe"
     MovementAnims(2)="JogL_Pipe"
     MovementAnims(3)="JogR_Pipe"
     TurnLeftAnim="TurnL_Pipe"
     TurnRightAnim="TurnR_Pipe"
     CrouchAnims(0)="CHwalkF_Pipe"
     CrouchAnims(1)="CHwalkB_Pipe"
     CrouchAnims(2)="CHwalkL_Pipe"
     CrouchAnims(3)="CHwalkR_Pipe"
     WalkAnims(0)="WalkF_Flamethrower"
     WalkAnims(1)="WalkB_Flamethrower"
     WalkAnims(2)="WalkL_Flamethrower"
     WalkAnims(3)="WalkR_Flamethrower"
     CrouchTurnRightAnim="CH_TurnR_Pipe"
     CrouchTurnLeftAnim="CH_TurnL_Pipe"
     IdleCrouchAnim="CHIdle_Pipe"
     IdleWeaponAnim="Idle_Pipe"
     IdleRestAnim="Idle_Pipe"
     IdleChatAnim="Idle_Pipe"
     IdleHeavyAnim="Idle_Pipe"
     IdleRifleAnim="Idle_Pipe"
     FireAnims(0)="Frag_Pipe"
     FireAnims(1)="Frag_Pipe"
     FireAnims(2)="Frag_Pipe"
     FireAnims(3)="Frag_Pipe"
     FireAltAnims(0)="Frag_Pipe"
     FireAltAnims(1)="Frag_Pipe"
     FireAltAnims(2)="Frag_Pipe"
     FireAltAnims(3)="Frag_Pipe"
     FireCrouchAnims(0)="Frag_Pipe"
     FireCrouchAnims(1)="Frag_Pipe"
     FireCrouchAnims(2)="Frag_Pipe"
     FireCrouchAnims(3)="Frag_Pipe"
     FireCrouchAltAnims(0)="Frag_Pipe"
     FireCrouchAltAnims(1)="Frag_Pipe"
     FireCrouchAltAnims(2)="Frag_Pipe"
     FireCrouchAltAnims(3)="Frag_Pipe"
     HitAnims(0)="HitF_Pipe"
     HitAnims(1)="HitB_Pipe"
     HitAnims(2)="HitL_Pipe"
     HitAnims(3)="HitR_Pipe"
     PostFireBlendStandAnim="Blend_Pipe"
     PostFireBlendCrouchAnim="CHBlend_Pipe"
     Mesh=SkeletalMesh'HL2WeaponsA.HL_BugBait3rd'
     RelativeLocation=(Y=-4.000000)
     RelativeRotation=(Yaw=16384)
}
