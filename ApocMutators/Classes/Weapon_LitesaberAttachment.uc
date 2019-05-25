//-----------------------------------------------------------
//
//-----------------------------------------------------------
class Weapon_LitesaberAttachment  extends KFMeleeAttachment;

/*simulated function Timer()
{
	Super.Timer();
	if (Instigator != None && ClientState == WS_Hidden)
	{
		LightType = LT_None;
	}
	else
		LightType = LT_SubtlePulse;
}*/

simulated function DoFlashEmitter()
{
    if (mMuzFlash3rd == None)
    {
        mMuzFlash3rd = Spawn(mMuzFlashClass);
        AttachToBone(mMuzFlash3rd, 'katana');
    }
    if(mMuzFlash3rd != None)
        mMuzFlash3rd.SpawnParticle(1);
}

defaultproperties
{
     bDoFiringEffects=True
     MovementAnims(0)="JogF_Katana"
     MovementAnims(1)="JogB_Katana"
     MovementAnims(2)="JogL_Katana"
     MovementAnims(3)="JogR_Katana"
     TurnLeftAnim="TurnL_Katana"
     TurnRightAnim="TurnR_Katana"
     CrouchAnims(0)="CHWalkF_Katana"
     CrouchAnims(1)="CHWalkB_Katana"
     CrouchAnims(2)="CHWalkL_Katana"
     CrouchAnims(3)="CHWalkR_Katana"
     CrouchTurnRightAnim="CH_TurnR_Katana"
     CrouchTurnLeftAnim="CH_TurnL_Katana"
     IdleCrouchAnim="CHIdle_Katana"
     IdleWeaponAnim="Idle_Katana"
     IdleRestAnim="Idle_Katana"
     IdleChatAnim="Idle_Katana"
     IdleHeavyAnim="Idle_Katana"
     IdleRifleAnim="Idle_Katana"
     FireAnims(0)="FastAttack1_Katana"
     FireAnims(1)="FastAttack2_Katana"
     FireAnims(2)="FastAttack3_Katana"
     FireAnims(3)="FastAttack4_Katana"
     FireAltAnims(0)="HardAttack1_Katana"
     FireAltAnims(1)="HardAttack1_Katana"
     FireAltAnims(2)="HardAttack1_Katana"
     FireAltAnims(3)="HardAttack1_Katana"
     FireCrouchAnims(0)="CHFastAttack1_Katana"
     FireCrouchAnims(1)="CHFastAttack2_Katana"
     FireCrouchAnims(2)="CHFastAttack3_Katana"
     FireCrouchAnims(3)="CHFastAttack4_Katana"
     FireCrouchAltAnims(0)="CHHardAttack1_Katana"
     FireCrouchAltAnims(1)="CHHardAttack1_Katana"
     FireCrouchAltAnims(2)="CHHardAttack1_Katana"
     FireCrouchAltAnims(3)="CHHardAttack1_Katana"
     HitAnims(0)="HitF_Katana"
     HitAnims(1)="HitB_Katana"
     HitAnims(2)="HitL_Katana"
     HitAnims(3)="HitR_Katana"
     PostFireBlendStandAnim="Blend_Katana"
     PostFireBlendCrouchAnim="CHBlend_Katana"
     LightType=LT_SubtlePulse
     LightHue=170
     LightSaturation=155
     LightBrightness=200.000000
     LightRadius=5.000000
     bDynamicLight=True
     Mesh=SkeletalMesh'daforce.LiteSaber_3rd'
     Skins(1)=Combiner'KF_Weapons2_Trip_T.Special.MP_7_cmb'
     Skins(2)=Shader'daforce.LiteSaberSHD'
}
