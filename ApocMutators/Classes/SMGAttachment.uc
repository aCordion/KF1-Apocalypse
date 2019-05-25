Class SMGAttachment extends HL2WeaponAttachment;

simulated event ThirdPersonEffects()
{
	local PlayerController PC;

	if ( (Level.NetMode == NM_DedicatedServer) || (Instigator == None) )
		return;

  	if ( FlashCount>0 )
	{
		if( KFPawn(Instigator)!=None )
			KFPawn(Instigator).StartFiringX(true,false);

    	PC = Level.GetLocalPlayerController();
    	if ( (Level.TimeSeconds - LastRenderTime < 0.2) || (Instigator.Controller == PC) )
    		WeaponLight();
	}
	else
	{
		GotoState('');
		if( KFPawn(Instigator)!=None )
			KFPawn(Instigator).StopFiring();
	}
}

defaultproperties
{
     mMuzFlashClass=Class'ApocMutators.FX_SMGMuzzle'
     TurnLeftAnim="TurnL_Bullpup"
     TurnRightAnim="TurnR_Bullpup"
     WalkAnims(0)="WalkF_Bullpup"
     WalkAnims(1)="WalkB_Bullpup"
     WalkAnims(2)="WalkL_Bullpup"
     WalkAnims(3)="WalkR_Bullpup"
     CrouchTurnRightAnim="CH_TurnR_Bullpup"
     CrouchTurnLeftAnim="CH_TurnL_Bullpup"
     Mesh=SkeletalMesh'HL2WeaponsA.HL_SMG3rd'
     RelativeLocation=(X=3.000000,Z=2.000000)
     RelativeRotation=(Yaw=-16384)
}
