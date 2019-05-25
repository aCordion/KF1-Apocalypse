class Shiver_ZombieShiverBase extends KFMonster;

#exec OBJ LOAD FILE=ShiverT.utx
#exec OBJ LOAD FILE=ShiverS.uax

var name WalkAnim, RunAnim;

// Head twitch
var rotator CurHeadRot, NextHeadRot, HeadRot;
var float NextHeadTime;
var float MaxHeadTime;
var float MaxTilt, MaxTurn;

// Targetting, charging
var bool bDelayedReaction;
var bool bCanSeeTarget;
var float SeeTargetTime;
var float RunUntilTime;
var float RunCooldownEnd;
var float PeriodSeeTarget;
var float PeriodRunBase;
var float PeriodRunRan;
var float PeriodRunCoolBase;
var float PeriodRunCoolRan;

// Teleporting
var byte FadeStage;
var byte OldFadeStage;
var float AlphaFader;
var bool bFlashTeleporting;
var float LastFlashTime;
var float MinTeleportDist, MaxTeleportDist;
var float MinLandDist, MaxLandDist; // How close we can teleport to the target (collision cylinders are taken into account)
var int MaxTeleportAttempts; // Attempts per angle
var int MaxTeleportAngles;
var ColorModifier MatAlphaSkin;

replication
{
    reliable if (Role == ROLE_Authority)
        FadeStage;
}

defaultproperties
{
     WalkAnim="ClotWalk"
     RunAnim="Run"
     MaxHeadTime=0.100000
     MaxTilt=10000.000000
     MaxTurn=20000.000000
     bDelayedReaction=True
     PeriodSeeTarget=2.000000
     PeriodRunBase=4.000000
     PeriodRunRan=4.000000
     PeriodRunCoolBase=4.000000
     PeriodRunCoolRan=3.000000
     AlphaFader=255.000000
     MinTeleportDist=550.000000
     MaxTeleportDist=2000.000000
     MinLandDist=150.000000
     MaxLandDist=500.000000
     MaxTeleportAttempts=3
     MaxTeleportAngles=3
     MoanVoice=SoundGroup'ShiverS.TalkGroup'
     bCannibal=True
     MeleeDamage=8
     damageForce=5000
     KFRagdollName="Clot_Trip"
     JumpSound=SoundGroup'KF_EnemiesFinalSnd.clot.Clot_Jump'
     CrispUpThreshhold=9
     PuntAnim="ClotPunt"
     Intelligence=BRAINS_Mammal
     bUseExtendedCollision=True
     ColOffset=(Z=48.000000)
     ColRadius=25.000000
     ColHeight=5.000000
     ExtCollAttachBoneName="Collision_Attach"
     SeveredArmAttachScale=0.800000
     SeveredLegAttachScale=0.800000
     SeveredHeadAttachScale=0.800000
     DetachedArmClass=Class'Shiver_SeveredArmShiver'
     DetachedLegClass=Class'Shiver_SeveredLegShiver'
     DetachedHeadClass=Class'Shiver_SeveredHeadShiver'
     OnlineHeadshotOffset=(X=20.000000,Z=37.000000)
     OnlineHeadshotScale=1.300000
     MotionDetectorThreat=0.340000
     HitSound(0)=SoundGroup'ShiverS.PainGroup'
     DeathSound(0)=SoundGroup'ShiverS.DeathGroup'
     ChallengeSound(0)=SoundGroup'ShiverS.TalkGroup'
     ChallengeSound(1)=SoundGroup'ShiverS.TalkGroup'
     ChallengeSound(2)=SoundGroup'ShiverS.TalkGroup'
     ChallengeSound(3)=SoundGroup'ShiverS.TalkGroup'
     ScoringValue=7
     GroundSpeed=100.000000
     WaterSpeed=100.000000
     AccelRate=1024.000000
     JumpZ=340.000000
     HealthMax=650.000000
     Health=650
     MenuName="Shiver"
     MovementAnims(0)="ClotWalk"
     AmbientSound=SoundGroup'ShiverS.IdleGroup'
     Mesh=SkeletalMesh'ShiverA.Shiver'
     DrawScale=1.100000
     PrePivot=(Z=5.000000)
     Skins(0)=Combiner'ShiverT.CmbRemoveAlpha'
     RotationRate=(Yaw=45000,Roll=0)
}
