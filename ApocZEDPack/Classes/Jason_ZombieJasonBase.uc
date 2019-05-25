// Jason Vorhees
// He's not quite as speedy as the other Zombies, But his attacks are TRULY damaging.
class Jason_ZombieJasonBase extends KFMonster;

//#exec OBJ LOAD FILE=PlayerSounds.uax
#exec OBJ LOAD FILE=JasonVor_S.uax
#exec OBJ LOAD File=KF_BaseGorefast.uax

var(Sounds) sound   SawAttackLoopSound; // THe sound for the saw revved up, looping
var(Sounds) sound   ChainSawOffSound;   //The sound of this zombie dieing without a head

var         bool    bCharging;          // Scrake charges when his health gets low
var()       float   AttackChargeRate;   // Ratio to increase scrake movement speed when charging and attacking

// Exhaust effects
var()   class<VehicleExhaustEffect> ExhaustEffectClass; // Effect class for the exhaust emitter
var()   VehicleExhaustEffect        ExhaustEffect;
var         bool    bNoExhaustRespawn;

var()   float   BurnDamageScale;        // How much to reduce fire damage

replication
{
    reliable if(Role == ROLE_Authority)
        bCharging;
}

//-------------------------------------------------------------------------------
// NOTE: All Code resides in the child class(this class was only created to
//         eliminate hitching caused by loading default properties during play)
//-------------------------------------------------------------------------------

defaultproperties
{
     SawAttackLoopSound=Sound'KF_BaseGorefast.Attack.Gorefast_AttackSwish3'
     AttackChargeRate=2.500000
     BurnDamageScale=0.250000
     MeleeAnims(0)="SawZombieAttack1"
     MeleeAnims(1)="SawZombieAttack2"
     StunsRemaining=5
     BleedOutDuration=6.000000
     ZombieFlag=3
     MeleeDamage=25
     damageForce=-75000
     bFatAss=True
     KFRagdollName="Scrake_Trip"
     MeleeAttackHitSound=SoundGroup'KF_EnemiesFinalSnd.GoreFast.Gorefast_HitPlayer'
     bMeleeStunImmune=True
     Intelligence=BRAINS_Mammal
     bUseExtendedCollision=True
     ColOffset=(Z=55.000000)
     ColRadius=29.000000
     ColHeight=18.000000
     SeveredArmAttachScale=1.100000
     SeveredLegAttachScale=1.100000
     PlayerCountHealthScale=0.8//0.15
     PlayerNumHeadHealthScale=0.4//0.05
     PoundRageBumpDamScale=0.010000
     OnlineHeadshotOffset=(X=22.000000,Y=5.000000,Z=58.000000)
     OnlineHeadshotScale=1.500000
     HeadHealth=800.000000
     MotionDetectorThreat=3.000000
     ScoringValue=300
     IdleHeavyAnim="SawZombieIdle"
     IdleRifleAnim="SawZombieIdle"
     MeleeRange=40.000000
     GroundSpeed=85.000000
     WaterSpeed=75.000000
     HealthMax=1500.000000
     Health=1500
     HeadHeight=2.200000
     MenuName="Jason"
     MovementAnims(0)="SawZombieWalk"
     MovementAnims(1)="SawZombieWalk"
     MovementAnims(2)="SawZombieWalk"
     MovementAnims(3)="SawZombieWalk"
     WalkAnims(0)="SawZombieWalk"
     WalkAnims(1)="SawZombieWalk"
     WalkAnims(2)="SawZombieWalk"
     WalkAnims(3)="SawZombieWalk"
     IdleCrouchAnim="SawZombieIdle"
     IdleWeaponAnim="SawZombieIdle"
     IdleRestAnim="SawZombieIdle"
     AmbientSound=Sound'JasonVor_S.Jason_Sound'
     Mesh=SkeletalMesh'JasonVor_A.Jason'
     DrawScale=1.050000
     PrePivot=(Z=3.000000)
     Skins(0)=Shader'JasonVor_T.Jason__FB'
     Skins(1)=Texture'JasonVor_T.JVMaskB'
     Skins(2)=Combiner'JasonVor_T.Machete_cmb'
     SoundVolume=175
     SoundRadius=100.000000
     Mass=500.000000
     RotationRate=(Yaw=45000,Roll=0)
}
