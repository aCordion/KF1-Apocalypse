// Zombie Monster for KF Invasion gametype
class Dread_DreadBase extends KFMonster;

//#exec OBJ LOAD FILE=PlayerSounds.uax

var Dread_BileJet BloatJet;
var bool bPlayBileSplash;
var bool bMovingPukeAttack;
var float RunAttackTimeout;

//-------------------------------------------------------------------------------
// NOTE: All Code resides in the child class(this class was only created to
//         eliminate hitching caused by loading default properties during play)
//-------------------------------------------------------------------------------

defaultproperties
{
	 MeleeAnims(0)="ZombieBarf"
	 MeleeAnims(1)="ZombieBarf"
	 MeleeAnims(2)="ZombieBarf"
	 MoanVoice=SoundGroup'DreadSND.Scream.Scream'
	 BleedOutDuration=6.000000
	 ZombieFlag=1
	 MeleeDamage=14
	 damageForce=70000
	 bFatAss=True
	 KFRagdollName="Clot_Trip"
	 MeleeAttackHitSound=SoundGroup'KF_EnemiesFinalSnd.Bloat.Bloat_HitPlayer'
	 JumpSound=SoundGroup'DreadSND.Scream.Scream'
	 PuntAnim="ZombieBarf"
	 Intelligence=BRAINS_Stupid
	 bCanDistanceAttackDoors=True
	 bUseExtendedCollision=True
	 ColOffset=(Z=60.000000)
	 ColRadius=27.000000
	 ColHeight=22.000000
	 SeveredArmAttachScale=1.100000
	 SeveredLegAttachScale=1.300000
	 OnlineHeadshotOffset=(X=5.000000,Z=70.000000)
	 OnlineHeadshotScale=1.500000
	 HitSound(0)=SoundGroup'DreadSND.Scream.Scream'
	 DeathSound(0)=SoundGroup'DreadSND.Dying.Die'
	 ChallengeSound(0)=SoundGroup'DreadSND.Scream.Scream'
	 ChallengeSound(1)=SoundGroup'DreadSND.Scream.Scream'
	 ChallengeSound(2)=SoundGroup'DreadSND.Scream.Scream'
	 ChallengeSound(3)=SoundGroup'DreadSND.Scream.Scream'
	 AmmunitionClass=Class'KFMod.BZombieAmmo'
	 ScoringValue=17
	 IdleHeavyAnim="Idle"
	 IdleRifleAnim="Idle"
	 MeleeRange=30.000000
	 GroundSpeed=230.000000
	 WaterSpeed=230.000000
	 HealthMax=150.000000
	 Health=150
	 HeadHealth=100
	 HeadHeight=2.500000
	 HeadScale=1.500000
	 PlayerCountHealthScale=0.4//0.10
	 PlayerNumHeadHealthScale=0.1//0.05
	 AmbientSoundScaling=8.000000
	 MenuName="Dread"
	 MovementAnims(0)="Run"
	 MovementAnims(1)="Run"
	 WalkAnims(0)="Run"
	 WalkAnims(1)="Run"
	 WalkAnims(2)="Run"
	 WalkAnims(3)="Run"
	 IdleCrouchAnim="Idle"
	 IdleWeaponAnim="Idle"
	 IdleRestAnim="Idle"
	 AmbientSound=SoundGroup'DreadSND.Scream.Scream'
	 Mesh=SkeletalMesh'Dread2.Dread'
	 DrawScale=1.075000
	 PrePivot=(Z=5.000000)
	 Skins(0)=Texture'DreadTex.pipebomb_D'
	 Skins(1)=Texture'DreadTex.bandol'
	 Skins(2)=Texture'DreadTex.pipebomb_D'
	 Skins(3)=Texture'DreadTex.bandol'
	 Skins(4)=Texture'DreadTex.dreadface'
	 Skins(5)=Texture'DreadTex.gorefast_D'
	 Skins(6)=Texture'DreadTex.GibletsSkin'
	 Skins(7)=Texture'DreadTex.gorefast_D'
	 Skins(8)=Texture'DreadTex.dreadlegs'
	 SoundVolume=200
	 Mass=400.000000
	 RotationRate=(Yaw=45000,Roll=0)
}
