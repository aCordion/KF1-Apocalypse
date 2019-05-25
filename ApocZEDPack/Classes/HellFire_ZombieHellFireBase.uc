//=============================================================================
// HellFire_ZombieHellFire
//=============================================================================
// HellFire burned up fire projectile launching zed pawn class
//=============================================================================
// Killing Floor Source
// Copyright (C) 2009 Tripwire Interactive LLC
// - John "Ramm-Jaeger" Gibson
//=============================================================================
class HellFire_ZombieHellFireBase extends KFMonster;

var     float   NextFireProjectileTime; // Track when we will fire again
var()   float   ProjectileFireInterval; // How often to fire the fire projectile
var()   float   BurnDamageScale;        // How much to reduce fire damage for the Husk

//-------------------------------------------------------------------------------
// NOTE: All Code resides in the child class(this class was only created to
//         eliminate hitching caused by loading default properties during play)
//-------------------------------------------------------------------------------

defaultproperties
{
     ProjectileFireInterval=3.500000
     BurnDamageScale=0.250000
     MeleeAnims(0)="Strike"
     MeleeAnims(1)="Strike"
     MeleeAnims(2)="Strike"
     MoanVoice=SoundGroup'KF_HellfireSnd.Speech'
     BleedOutDuration=6.000000
     ZombieFlag=1
     MeleeDamage=25
     damageForce=80000
     bFatAss=True
     KFRagdollName="Burns_Trip"
     MeleeAttackHitSound=SoundGroup'KF_EnemiesFinalSnd.Bloat.Bloat_HitPlayer'
     JumpSound=SoundGroup'KF_HellfireSnd.Jump'
     Intelligence=BRAINS_Mammal
     bCanDistanceAttackDoors=True
     bUseExtendedCollision=True
     ColOffset=(Z=36.000000)
     ColRadius=30.000000
     ColHeight=33.000000
     SeveredArmAttachScale=0.900000
     SeveredLegAttachScale=0.900000
     SeveredHeadAttachScale=0.900000
     OnlineHeadshotOffset=(X=20.000000,Z=55.000000)
     HeadHealth=200.000000
     PlayerCountHealthScale=0.8//0.15
     PlayerNumHeadHealthScale=0.4//0.05
     HitSound(0)=SoundGroup'KF_HellfireSnd.Pain'
     DeathSound(0)=SoundGroup'KF_HellfireSnd.Death'
     ChallengeSound(0)=SoundGroup'KF_HellfireSnd.Speech'
     ChallengeSound(1)=SoundGroup'KF_HellfireSnd.Speech'
     ChallengeSound(2)=SoundGroup'KF_HellfireSnd.Speech'
     ChallengeSound(3)=SoundGroup'KF_HellfireSnd.Speech'
     AmmunitionClass=Class'KFMod.BZombieAmmo'
     ScoringValue=20
     IdleHeavyAnim="Idle"
     IdleRifleAnim="Idle"
     MeleeRange=30.000000
     GroundSpeed=150.000000
     WaterSpeed=120.000000
     HealthMax=700.000000
     Health=700
     HeadHeight=1.000000
     HeadScale=1.500000
     AmbientSoundScaling=8.000000
     MenuName="HellFire"
     MovementAnims(0)="WalkF"
     MovementAnims(1)="WalkB"
     MovementAnims(2)="WalkL"
     MovementAnims(3)="WalkR"
     WalkAnims(1)="WalkB"
     WalkAnims(2)="WalkL"
     WalkAnims(3)="WalkR"
     IdleCrouchAnim="Idle"
     IdleWeaponAnim="Idle"
     IdleRestAnim="Idle"
     AmbientSound=SoundGroup'KF_HellfireSnd.Idle'
     Mesh=SkeletalMesh'HellFireAnims.Burns_Freak'
     DrawScale=1.400000
     PrePivot=(Z=22.000000)
     Skins(0)=Combiner'HellFireTex.HellFire_cmb'
     SoundVolume=250
     Mass=400.000000
     RotationRate=(Yaw=45000,Roll=0)
}
