// Zombie Monster for KF Invasion gametype
class ZEDS_ZombieGoreFast extends ZombieGoreFast_STANDARD
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
    DrawScale=1.2
    Prepivot=(Z=10.0)
    bUseExtendedCollision=true
    ColOffset=(Z=52)
    ColRadius=25
    ColHeight=10
    MeleeDamage=15
    damageForce=5000
    ScoringValue=12
    MeleeRange=30.0//60.000000
    GroundSpeed=120.0//150.000000
    WaterSpeed=140.000000
    AmbientGlow=0
    CollisionRadius=26.000000
    Mass=350.000000
    RotationRate=(Yaw=45000,Roll=0)
    bCannibal = true
    MenuName="Gorefast"
    SeveredHeadAttachScale=1.0
    SeveredLegAttachScale=0.9
    SeveredArmAttachScale=0.9
    HeadHeight=2.5
    HeadScale=1.5
    CrispUpThreshhold=8
    OnlineHeadshotOffset=(X=5,Y=0,Z=53)
    OnlineHeadshotScale=1.5
    MotionDetectorThreat=0.5
    Health=250//350
    HealthMax=250
    HeadHealth=25
    PlayerCountHealthScale=0.6 //0.15 kyan
    PlayerNumHeadHealthScale=0.15 //0.0 kyan
}
