class ZEDS_ZombieBoss extends ZombieBoss_STANDARD
    Config(ApocZEDPack);

struct SZEDInfo {
	var config int ForcedMinPlayers;
	var config int Health;
    var config int HeadHealth;
    var config float PlayerCountHealthScale;
    var config float PlayerNumHeadHealthScale;
};
var config SZEDInfo ZEDInfo;

simulated function PostBeginPlay()
{
    if (ZEDInfo.Health>0 && Health!=ZEDInfo.Health)
    {
        Health = ZEDInfo.Health;
        HealthMax = ZEDInfo.Health;
    }

    if (ZEDInfo.HeadHealth>0 && HeadHealth!=ZEDInfo.HeadHealth)
        HeadHealth = ZEDInfo.HeadHealth;

    if (ZEDInfo.PlayerCountHealthScale>0 && PlayerCountHealthScale!=ZEDInfo.PlayerCountHealthScale)
        PlayerCountHealthScale = ZEDInfo.PlayerCountHealthScale;

    if (ZEDInfo.PlayerNumHeadHealthScale>0 && PlayerNumHeadHealthScale!=ZEDInfo.PlayerNumHeadHealthScale)
        PlayerNumHeadHealthScale = ZEDInfo.PlayerNumHeadHealthScale;
		
	Super.PostBeginPlay();
}

function float NumPlayersHealthModifer()
{
    if (ZEDInfo.ForcedMinPlayers>0)
        return 1.0 + (ZEDInfo.ForcedMinPlayers - 1) * PlayerCountHealthScale;
    return Super.NumPlayersHealthModifer();
}

function float NumPlayersHeadHealthModifer()
{
    if (ZEDInfo.ForcedMinPlayers>0)
        return 1.0 + (ZEDInfo.ForcedMinPlayers - 1) * PlayerNumHeadHealthScale;
    return Super.NumPlayersHeadHealthModifer();
}

defaultproperties
{
    DrawScale=1.05
    bOnlyDamagedByCrossbow=true
    bMeleeStunImmune = true
    damageForce=170000
    bFatAss=True
    ScoringValue=500
    RagDeathVel=80.000000
    RagDeathUpKick=100.000000
    MeleeRange=10.000000
    AmbientGlow=0
    Mass=1000.000000
    RotationRate=(Yaw=36000,Roll=0)
    GroundSpeed=120.000000
    WaterSpeed=120.000000
    MeleeDamage=75
    Health=4000//4000
    HealthMax=4000//4000
    PlayerCountHealthScale=0.75
    bBoss=True
    MenuName="Patriarch"
    CollisionRadius=26
    CollisionHeight=44
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
    ClawMeleeDamageRange=85//50
    ImpaleMeleeDamageRange=45//75
    MGDamage=6.0
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
}
