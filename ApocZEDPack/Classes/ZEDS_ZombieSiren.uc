class ZEDS_ZombieSiren extends ZombieSiren_STANDARD
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
    bUseExtendedCollision=true
    ColOffset=(Z=48)
    ColRadius=25
    ColHeight=5
    DrawScale=1.05
    PrePivot=(Z=3)
    ScreamRadius=700//800
    ScreamDamage=8 // 10
    ScreamForce=-150000//-300000
    RotMag=(Pitch=150,Yaw=150,Roll=150)
    RotRate=500
    OffsetMag=(X=0.000000,Y=5.000000,Z=1.000000)
    OffsetRate=500
    MeleeDamage=13
    damageForce=5000
    ScoringValue=25
    MeleeRange=45.000000
    GroundSpeed=100.0//100.000000
    WaterSpeed=80.000000
    AmbientGlow=0
    CollisionRadius=26.000000
    RotationRate=(Yaw=45000,Roll=0)
    MenuName="Siren"
    bCanDistanceAttackDoors=True
    ZombieFlag=1
    ShakeEffectScalar=1.0
    ShakeTime=2.0
    ShakeFadeTime=0.25
    MinShakeEffectScale=0.6
    ScreamBlurScale=0.85
    SeveredHeadAttachScale=1.0
    SeveredLegAttachScale=0.7
    SeveredArmAttachScale=1.0
    HeadHeight=1.0
    HeadScale=1.0
    CrispUpThreshhold=7
    OnlineHeadshotOffset=(X=6,Y=0,Z=41)
    OnlineHeadshotScale=1.2
    MotionDetectorThreat=2.0
    Health=300//350
    HealthMax=300
    HeadHealth=200
    PlayerCountHealthScale=0.6 //0.10 kyan
    PlayerNumHeadHealthScale=0.15 //0.05 kyan
}
