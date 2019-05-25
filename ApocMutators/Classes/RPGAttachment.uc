Class RPGAttachment extends HL2WeaponAttachment;

simulated function DoFlashEmitter()
{
    if (mMuzFlash3rd == None)
    {
        mMuzFlash3rd = Spawn(mMuzFlashClass);
        AttachToBone(mMuzFlash3rd, 'Bip01_R_Hand');
    }
    if(mMuzFlash3rd != None)
        mMuzFlash3rd.SpawnParticle(1);
}

defaultproperties
{
     mMuzFlashClass=Class'ApocMutators.FX_RPGMuzzle'
     MovementAnims(0)="JogF_LAW"
     MovementAnims(1)="JogB_LAW"
     MovementAnims(2)="JogL_LAW"
     MovementAnims(3)="JogR_LAW"
     TurnLeftAnim="TurnL_LAW"
     TurnRightAnim="TurnR_LAW"
     CrouchAnims(0)="CHwalkF_LAW"
     CrouchAnims(1)="CHwalkB_LAW"
     CrouchAnims(2)="CHwalkL_LAW"
     CrouchAnims(3)="CHwalkR_LAW"
     WalkAnims(0)="WalkF_LAW"
     WalkAnims(1)="WalkB_LAW"
     WalkAnims(2)="WalkL_LAW"
     WalkAnims(3)="WalkR_LAW"
     CrouchTurnRightAnim="CH_TurnR_LAW"
     CrouchTurnLeftAnim="CH_TurnL_LAW"
     IdleCrouchAnim="CHIdle_LAW"
     IdleWeaponAnim="Idle_LAW"
     IdleRestAnim="Idle_LAW"
     IdleChatAnim="Idle_LAW"
     IdleHeavyAnim="Idle_LAW"
     IdleRifleAnim="Idle_LAW"
     FireAnims(0)="Fire_LAW"
     FireAnims(1)="Fire_LAW"
     FireAnims(2)="Fire_LAW"
     FireAnims(3)="Fire_LAW"
     FireAltAnims(0)="Fire_LAW"
     FireAltAnims(1)="Fire_LAW"
     FireAltAnims(2)="Fire_LAW"
     FireAltAnims(3)="Fire_LAW"
     FireCrouchAnims(0)="CHFire_LAW"
     FireCrouchAnims(1)="CHFire_LAW"
     FireCrouchAnims(2)="CHFire_LAW"
     FireCrouchAnims(3)="CHFire_LAW"
     FireCrouchAltAnims(0)="CHFire_LAW"
     FireCrouchAltAnims(1)="CHFire_LAW"
     FireCrouchAltAnims(2)="CHFire_LAW"
     FireCrouchAltAnims(3)="CHFire_LAW"
     HitAnims(0)="HitF_LAW"
     HitAnims(1)="HitB_LAW"
     HitAnims(2)="HitL_LAW"
     HitAnims(3)="HitR_LAW"
     PostFireBlendStandAnim="Blend_LAW"
     PostFireBlendCrouchAnim="CHBlend_LAW"
     Mesh=SkeletalMesh'HL2WeaponsA.HL_RPG3rd'
     RelativeLocation=(X=-8.000000,Y=-2.000000,Z=7.000000)
     RelativeRotation=(Yaw=16384)
}
