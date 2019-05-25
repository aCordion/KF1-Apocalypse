class ZEDS_ZombieStalker extends ZombieStalker_STANDARD
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
    Prepivot=(Z=5.0)
    MeleeDamage=9
    damageForce=5000
    ScoringValue=15
    GroundSpeed=200.000000
    WaterSpeed=180.000000
    JumpZ=350.000000
    AmbientGlow=0
    CollisionRadius=26.000000
    RotationRate=(Yaw=45000,Roll=0)
    bCannibal=false
    MenuName="Stalker"
    SeveredHeadAttachScale=1.0
    SeveredLegAttachScale=0.7
    SeveredArmAttachScale=0.8
    MeleeRange=30.000000
    HeadHeight=2.5
    HeadScale=1.1
    CrispUpThreshhold=10
    OnlineHeadshotOffset=(X=18,Y=0,Z=33)
    OnlineHeadshotScale=1.2
    MotionDetectorThreat=0.25
    Health=100 // 120
    HealthMax=100 // 120
    HeadHealth=25
    PlayerCountHealthScale=0.6 //0.25 kyan
    PlayerNumHeadHealthScale=0.15 //0.0 kyan
}
