// Zombie Monster for KF Invasion gametype
// He's speedy, and swings with a Single enlongated arm, affording him slightly more range
class GoreShank_ZombieGoreShankBase extends KFMonster;

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
     MeleeAnims(0)="GoreAttack1"
     MeleeAnims(1)="GoreAttack2"
     MeleeAnims(2)="GoreAttack3"
     MoanVoice=SoundGroup'KF_EnemiesFinalSnd.GoreFast.Gorefast_Talk'
     MeleeDamage=30
     damageForce=5000
     KFRagdollName="GoreFast_Trip"
     MeleeAttackHitSound=SoundGroup'KF_EnemiesFinalSnd.GoreFast.Gorefast_HitPlayer'
     JumpSound=SoundGroup'KF_EnemiesFinalSnd.GoreFast.Gorefast_Jump'
     CrispUpThreshhold=8
     bUseExtendedCollision=True
     ColOffset=(Z=60.000000)
     ColRadius=29.000000
     ColHeight=18.000000
     ExtCollAttachBoneName="Collision_Attach"
     SeveredArmAttachScale=0.900000
     SeveredLegAttachScale=0.900000
     PlayerCountHealthScale=0.150000
     OnlineHeadshotOffset=(X=22.000000,Y=5.000000,Z=60.000000)
     OnlineHeadshotScale=1.700000
     HeadHealth=650.000000
     PlayerNumHeadHealthScale=0.300000
     MotionDetectorThreat=0.300000
     HitSound(0)=SoundGroup'KF_EnemiesFinalSnd.GoreFast.Gorefast_Pain'
     DeathSound(0)=SoundGroup'KF_EnemiesFinalSnd.GoreFast.Gorefast_Death'
     ChallengeSound(0)=SoundGroup'KF_EnemiesFinalSnd.GoreFast.Gorefast_Challenge'
     ChallengeSound(1)=SoundGroup'KF_EnemiesFinalSnd.GoreFast.Gorefast_Challenge'
     ChallengeSound(2)=SoundGroup'KF_EnemiesFinalSnd.GoreFast.Gorefast_Challenge'
     ChallengeSound(3)=SoundGroup'KF_EnemiesFinalSnd.GoreFast.Gorefast_Challenge'
     ScoringValue=30
     IdleHeavyAnim="GoreIdle"
     IdleRifleAnim="GoreIdle"
     MeleeRange=30.000000
     GroundSpeed=150.000000
     WaterSpeed=180.000000
     HealthMax=400.000000
     Health=400
     HeadHeight=2.500000
     HeadScale=1.500000
     MenuName="GoreShank"
     MovementAnims(0)="WalkF"
     IdleCrouchAnim="GoreIdle"
     IdleWeaponAnim="GoreIdle"
     IdleRestAnim="GoreIdle"
     DrawScale=1.200000
     PrePivot=(Z=10.000000)
     Mass=450.000000
     RotationRate=(Yaw=45000,Roll=0)
}
