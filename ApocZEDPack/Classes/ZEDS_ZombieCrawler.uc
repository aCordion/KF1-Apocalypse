// Zombie Monster for KF Invasion gametype
class ZEDS_ZombieCrawler extends ZombieCrawler_STANDARD
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
    DrawScale=1.1
    Prepivot=(Z=0.0)
    PounceSpeed=330.000000   // 300
    bStunImmune=True
    MeleeDamage=6
    damageForce=5000
    ScoringValue=10
    GroundSpeed=140.000000
    WaterSpeed=130.000000
    JumpZ=350.000000
    CollisionRadius=26.000000
    CollisionHeight=25.000000
    bCannibal = true
    bCrawler = true
    bOrientOnSlope = true
    MenuName="Crawler"
    Intelligence=BRAINS_Mammal
    ZombieFlag=2
    bDoTorsoTwist=False
    SeveredHeadAttachScale=1.1
    SeveredLegAttachScale=0.85
    SeveredArmAttachScale=0.8
    HeadHeight=2.5
    HeadScale=1.05
    CrispUpThreshhold=10
    OnlineHeadshotOffset=(X=28,Y=0,Z=7)
    OnlineHeadshotScale=1.2
    MotionDetectorThreat=0.34
    Health=70//100
    HealthMax=70//100
    HeadHealth=25
    PlayerCountHealthScale=0.6 //0.25 kyan
    PlayerNumHeadHealthScale=0.15 //0.0 kyan
}
