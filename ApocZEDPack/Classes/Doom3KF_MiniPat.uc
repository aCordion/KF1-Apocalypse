class Doom3KF_MiniPat extends ZEDS_ZombieBoss;

simulated function PostNetBeginPlay()
{
    super.PostNetBeginPlay();
    //SetHeadScale(0.5);
    SetBoneScale(2, 1.75, 'rarm'); // let's put some big beefy arms on there...
}

function Died(Controller Killer, class<DamageType> damageType, vector HitLocation)
{
    super(ZombieBossBase).Died(Killer, damageType, HitLocation);
}

state FireMissile
{
Ignores RangedAttack;

    function bool ShouldChargeFromDamage()
    {
        return false;
    }

	function BeginState()
	{
        Acceleration = vect(0,0,0);
	}

	function AnimEnd( int Channel )
	{
		local vector Start;
		local Rotator R;

		Start = GetBoneCoords('tip').Origin;

		if ( !SavedFireProperties.bInitialized )
		{
			SavedFireProperties.AmmoClass = MyAmmo.Class;
			SavedFireProperties.ProjectileClass = MyAmmo.ProjectileClass;
			SavedFireProperties.WarnTargetPct = 0.15;
			SavedFireProperties.MaxRange = 10000;
			SavedFireProperties.bTossed = False;
			SavedFireProperties.bTrySplash = False;
			SavedFireProperties.bLeadTarget = True;
			SavedFireProperties.bInstantHit = True;
			SavedFireProperties.bInitialized = true;
		}

		R = AdjustAim(SavedFireProperties,Start,100);
		PlaySound(RocketFireSound,SLOT_Interact,2.0,,TransientSoundRadius,,false);
		Spawn(Class'MiniPatLAWProj',,,Start,R);

		bShotAnim = true;
		Acceleration = vect(0,0,0);
		SetAnimAction('FireEndMissile');
		HandleWaitForAnim('FireEndMissile');

		// Randomly send out a message about Patriarch shooting a rocket(5% chance)
		if ( FRand() < 0.05 && Controller.Enemy != none && PlayerController(Controller.Enemy.Controller) != none )
		{
			PlayerController(Controller.Enemy.Controller).Speech('AUTO', 10, "");
		}

		GoToState('');
	}
Begin:
	while ( true )
	{
		Acceleration = vect(0,0,0);
		Sleep(0.1);
	}
}

defaultproperties
{
    DrawScale=1.05

    bOnlyDamagedByCrossbow=true

    bMeleeStunImmune = true
    damageForce=170000
    bFatAss=True
    KFRagdollName="Patriarch_Trip"

    ScoringValue=500

    RagDeathVel=80.000000
    RagDeathUpKick=100.000000
    MeleeRange=10.000000

    MovementAnims(0)="WalkF"
    MovementAnims(1)="WalkF"
    MovementAnims(2)="WalkF"
    MovementAnims(3)="WalkF"
    WalkAnims(0)="WalkF"
    WalkAnims(1)="WalkF"
    WalkAnims(2)="WalkF"
    WalkAnims(3)="WalkF"
    BurningWalkFAnims(0)="WalkF"
    BurningWalkFAnims(1)="WalkF"
    BurningWalkFAnims(2)="WalkF"
    BurningWalkAnims(0)="WalkF"
    BurningWalkAnims(1)="WalkF"
    BurningWalkAnims(2)="WalkF"
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
    TurnLeftAnim="TurnLeft"
    TurnRightAnim="TurnRight"

    ChargingAnim="RunF"

    IdleHeavyAnim="BossIdle"
    IdleRifleAnim="BossIdle"
    IdleCrouchAnim="BossIdle"
    IdleWeaponAnim="BossIdle"
    IdleRestAnim="BossIdle"

    AmbientGlow=0
    Mass=1000.000000
    RotationRate=(Yaw=36000,Roll=0)

    GroundSpeed=120.000000
    WaterSpeed=120.000000
    MeleeDamage=25//75

    Health=4000
    HealthMax=4000
    HeadHealth=1250
    PlayerCountHealthScale=0.6//0.25
    PlayerNumHeadHealthScale=0.1//0.30 // Was 0.35 in Balance Round 1
    //PlayerCountHealthScale=0.75

    bBoss=False
    MenuName="Patriarch Jr."

    CollisionRadius=26
    CollisionHeight=44

    Mesh=SkeletalMesh'KF_Freaks_Trip.Patriarch_Freak'
    Skins(0)=Combiner'KF_Specimens_Trip_T.gatling_cmb'
    Skins(1)=Combiner'KF_Specimens_Trip_T.patriarch_cmb'

    HitSound(0)=Sound'KF_EnemiesFinalSnd.Kev_Pain'
    AmbientSound=Sound'KF_BasePatriarch.Idle.Kev_IdleLoop'

    MoanVoice=Sound'KF_EnemiesFinalSnd.Kev_Talk'
    DeathSound(0)=Sound'KF_EnemiesFinalSnd.Kev_Death'
    JumpSound=Sound'KF_EnemiesFinalSnd.Kev_Jump'

    MeleeAttackHitSound=sound'KF_EnemiesFinalSnd.Kev_HitPlayer_Fist'
    MeleeImpaleHitSound=sound'KF_EnemiesFinalSnd.Kev_HitPlayer_Impale'
    RocketFireSound=sound'KF_EnemiesFinalSnd.Kev_FireRocket'
    MiniGunFireSound=sound'KF_BasePatriarch.Kev_MG_GunfireLoop'
    MiniGunSpinSound=Sound'KF_BasePatriarch.Attack.Kev_MG_TurbineFireLoop'


    SoundVolume=75

    Intelligence=BRAINS_Human
    bCanDistanceAttackDoors=True
    bNetNotify=False
    bUseExtendedCollision=True
    ColOffset=(Z=65)//(Z=50)
    ColRadius=27
    ColHeight=25//40
    PrePivot=(Z=3)
    HealingLevels(0)=5600
    HealingLevels(1)=3500
    HealingLevels(2)=2187
    HealingAmount=1750
    ZombieFlag=3

    ClawMeleeDamageRange=25//85//50
    ImpaleMeleeDamageRange=25//45//75
    MGDamage=1.0//6.0
    //bForceSkelUpdate=true

    SeveredHeadAttachScale=1.5
    SeveredLegAttachScale=1.2
    SeveredArmAttachScale=1.1
    HeadHeight=2.0
    HeadScale=1.3
    CrispUpThreshhold=1
    OnlineHeadshotOffset=(X=28,Y=0,Z=75)
    OnlineHeadshotScale=1.2
    MotionDetectorThreat=10.0
    PipeBombDamageScale=0.0
    ZapThreshold=5.0
    ZappedDamageMod=1.25
    ZapResistanceScale=1.0 // don't let the patriarch gain resistance, since his zapp effects are pretty light
}
