// Zombie Monster for KF Invasion gametype
class ZEDS_ZombieFleshpound extends ZombieFleshpound_STANDARD
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
    bMeleeStunImmune = true
    BlockDamageReduction=0.400000
    damageForce=15000
    bFatAss=True
    ScoringValue=200
    RagDeathVel=100.000000
    RagDeathUpKick=100.000000
    MeleeRange=55.000000
    AmbientGlow=0
    Mass=600.000000
    RotationRate=(Yaw=45000,Roll=0)
    RotMag=(X=500.000000,Y=500.000000,Z=600.000000)
    RotRate=(X=12500.000000,Y=12500.000000,Z=12500.000000)
    RotTime=6.000000
    OffsetMag=(X=5.000000,Y=10.000000,Z=5.000000)
    OffsetRate=(X=300.000000,Y=300.000000,Z=300.000000)
    OffsetTime=3.500000
    GroundSpeed=130.000000
    WaterSpeed=120.000000
    MeleeDamage=22//15
    //StunTime=0.3 //Was used in Balance Round 1(removed for Round 2)
    StunsRemaining=1 //Added in Balance Round 2
    SpinDamConst=20.000000
    SpinDamRand=20.000000
    bBoss=True
    MenuName="Flesh Pound"
    CollisionRadius=26
    CollisionHeight=44
    RageDamageThreshold = 360
    Intelligence=BRAINS_Mammal // Changed in Balance Round 1
    bUseExtendedCollision=True
    ColOffset=(Z=52)
    ColRadius=36
    ColHeight=35//46
    PrePivot=(Z=0)
    ZombieFlag=3
    SeveredHeadAttachScale=1.5
    SeveredLegAttachScale=1.2
    SeveredArmAttachScale=1.3
    BleedOutDuration=7.0
    HeadHeight=2.5
    HeadScale=1.3
    OnlineHeadshotOffset=(X=22,Y=0,Z=68)
    OnlineHeadshotScale=1.3
    MotionDetectorThreat=5.0
    Health=1500//2000
    HealthMax=1500
    HeadHealth=700
    PlayerCountHealthScale=1.3//2.0
    PlayerNumHeadHealthScale=0.3 // Was 0.35 in Balance Round 1
}
