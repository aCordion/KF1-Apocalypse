// Zombie Monster for KF Invasion gametype
// He's speedy, and swings with a Single enlongated arm, affording him slightly more range
class Shafter_ZombieShafterBase extends KFMonster;

#exec OBJ LOAD FILE=KF_EnemiesFinalSnd.uax

var bool bRunning;
var float RunAttackTimeout;

replication
{
	reliable if(Role == ROLE_Authority)
		bRunning;
}

//-------------------------------------------------------------------------------
// NOTE: All Code resides in the child class(this class was only created to
//         eliminate hitching caused by loading default properties during play)
//-------------------------------------------------------------------------------

defaultproperties
{
     MeleeAnims(0)="MeleeClaw"
     MeleeAnims(1)="MeleeClaw2"
     MoanVoice=SoundGroup'KF_EnemiesFinalSnd.Bloat.Bloat_Talk'
     KFHitBack="HitReactionF"
     KFHitLeft="HitReactionF"
     KFHitRight="HitReactionF"
     MeleeDamage=30
     damageForce=5000
     KFRagdollName="Bloat_Trip"
     MeleeAttackHitSound=SoundGroup'KF_AxeSnd.Axe_HitFlesh'
     JumpSound=SoundGroup'KF_EnemiesFinalSnd.Bloat.Bloat_Jump'
     CrispUpThreshhold=8
     bUseExtendedCollision=True
     ColOffset=(Z=65.000000)
     ColRadius=27.000000
     ColHeight=25.000000
     ExtCollAttachBoneName="Collision_Attach"
     SeveredArmAttachScale=1.100000
     SeveredLegAttachScale=1.300000
     SeveredHeadAttachScale=1.700000
     PlayerCountHealthScale=0.250000
     OnlineHeadshotOffset=(X=28.000000,Z=75.000000)
     OnlineHeadshotScale=1.700000
     HeadHealth=650.000000
     PlayerNumHeadHealthScale=0.300000
     MotionDetectorThreat=0.500000
     HitSound(0)=SoundGroup'KF_EnemiesFinalSnd.Bloat.Bloat_Pain'
     DeathSound(0)=SoundGroup'KF_EnemiesFinalSnd.Bloat.Bloat_Death'
     ChallengeSound(0)=SoundGroup'KF_EnemiesFinalSnd.Bloat.Bloat_Challenge'
     ChallengeSound(1)=SoundGroup'KF_EnemiesFinalSnd.Bloat.Bloat_Challenge'
     ChallengeSound(2)=SoundGroup'KF_EnemiesFinalSnd.Bloat.Bloat_Challenge'
     ChallengeSound(3)=SoundGroup'KF_EnemiesFinalSnd.Bloat.Bloat_Challenge'
     ScoringValue=50
     IdleHeavyAnim="BossIdle"
     IdleRifleAnim="BossIdle"
     MeleeRange=30.000000
     GroundSpeed=110.000000
     WaterSpeed=100.000000
     HealthMax=750.000000
     Health=750
     HeadHeight=2.200000
     HeadScale=1.500000
     AmbientSoundScaling=8.000000
     MenuName="Shafter"
     MovementAnims(0)="WalkF"
     AirAnims(0)="JumpInAir"
     AirAnims(1)="JumpInAir"
     AirAnims(2)="JumpInAir"
     AirAnims(3)="JumpInAir"
     TakeoffAnims(0)="JumpTakeOff"
     TakeoffAnims(1)="JumpTakeOff"
     TakeoffAnims(2)="JumpTakeOff"
     TakeoffAnims(3)="JumpTakeOff"
     LandAnims(0)="JumpLanded"
     LandAnims(1)="JumpLanded"
     LandAnims(2)="JumpLanded"
     LandAnims(3)="JumpLanded"
     AirStillAnim="JumpInAir"
     TakeoffStillAnim="JumpTakeOff"
     IdleCrouchAnim="BossIdle"
     IdleWeaponAnim="BossIdle"
     IdleRestAnim="BossIdle"
     DrawScale=1.200000
     PrePivot=(Z=10.000000)
     Mass=650.000000
     RotationRate=(Yaw=45000,Roll=0)
}
