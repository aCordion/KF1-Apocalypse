//=============================================================================
// Weapon_M99Attachment
//=============================================================================
// M99 Sniper Rifle Attachment Class
//=============================================================================
// Killing Floor Source
// Copyright (C) 2012 Tripwire Interactive LLC
// - John "Ramm-Jaeger" Gibson and IJC
//=============================================================================
class Weapon_M99Attachment extends M99Attachment;

defaultproperties
{
    MeshRef="KF_Weapons3rd4_Trip.M99_Sniper_3rd"
    mMuzFlashClass=Class'ROEffects.MuzzleFlash3rdPTRD'

    MovementAnims(0)=JogF_M4203
    MovementAnims(1)=JogB_M4203
    MovementAnims(2)=JogL_M4203
    MovementAnims(3)=JogR_M4203
    CrouchAnims(0)=CHwalkF_M4203
    CrouchAnims(1)=CHwalkB_M4203
    CrouchAnims(2)=CHwalkL_M4203
    CrouchAnims(3)=CHwalkR_M4203
    WalkAnims(0)=WalkF_M4203
    WalkAnims(1)=WalkB_M4203
    WalkAnims(2)=WalkL_M4203
    WalkAnims(3)=WalkR_M4203
    AirStillAnim=JumpF_Mid
    AirAnims(0)=JumpF_Mid
    AirAnims(1)=JumpF_Mid
    AirAnims(2)=JumpL_Mid
    AirAnims(3)=JumpR_Mid
    TakeoffStillAnim=JumpF_Takeoff
    TakeoffAnims(0)=JumpF_Takeoff
    TakeoffAnims(1)=JumpF_Takeoff
    TakeoffAnims(2)=JumpL_Takeoff
    TakeoffAnims(3)=JumpR_Takeoff
    LandAnims(0)=JumpF_Land
    LandAnims(1)=JumpF_Land
    LandAnims(2)=JumpL_Land
    LandAnims(3)=JumpR_Land

    TurnRightAnim=TurnR_M4203
    TurnLeftAnim=TurnL_M4203
    CrouchTurnRightAnim=CH_TurnR_M4203
    CrouchTurnLeftAnim=CH_TurnL_M4203
    IdleRestAnim=Idle_M4203
    IdleCrouchAnim=CHIdle_M4203
    IdleSwimAnim=Swim_Tread
    IdleWeaponAnim=Idle_M4203
    IdleHeavyAnim=Idle_M4203
    IdleRifleAnim=Idle_M4203
    IdleChatAnim=Idle_M4203
    FireAnims(0)=Fire_M99
    FireAnims(1)=Fire_M99
    FireAnims(2)=Fire_M99
    FireAnims(3)=Fire_M99
    FireAltAnims(0)=Fire_M99
    FireAltAnims(1)=Fire_M99
    FireAltAnims(2)=Fire_M99
    FireAltAnims(3)=Fire_M99
    FireCrouchAnims(0)=CHFire_M99
    FireCrouchAnims(1)=CHFire_M99
    FireCrouchAnims(2)=CHFire_M99
    FireCrouchAnims(3)=CHFire_M99
    FireCrouchAltAnims(0)=CHFire_M99
    FireCrouchAltAnims(1)=CHFire_M99
    FireCrouchAltAnims(2)=CHFire_M99
    FireCrouchAltAnims(3)=CHFire_M99
    HitAnims(0)=HitF_M4203
    HitAnims(1)=HitB_M4203
    HitAnims(2)=HitL_M4203
    HitAnims(3)=HitR_M4203
    PostFireBlendStandAnim=Blend_M4203
    PostFireBlendCrouchAnim=CHBlend_M4203
}
