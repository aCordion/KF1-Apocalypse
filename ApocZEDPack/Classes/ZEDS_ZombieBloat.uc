class ZEDS_ZombieBloat extends ZombieBloat_STANDARD
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
    DrawScale=1.075
    Prepivot=(Z=5.0)
    damageForce=70000
    bFatAss=True
    ScoringValue=17
    MeleeRange=30.0//55.000000
    //SoundRadius=2.5
    AmbientSoundScaling=8.0
    SoundVolume=200
    AmbientGlow=0
    Mass=400.000000
    RotationRate=(Yaw=45000,Roll=0)
    GroundSpeed=75.0//105.000000
    WaterSpeed=102.000000
    MeleeDamage=14
    JumpZ=320.000000
    bCannibal = False // No animation for him.
    MenuName="Bloat"
    CollisionRadius=26.000000
    CollisionHeight=44
    bCanDistanceAttackDoors=True
    Intelligence=BRAINS_Stupid
    bUseExtendedCollision=True
    ColOffset=(Z=60)//(Z=42)
    ColRadius=27
    ColHeight=22//40
    ZombieFlag=1
    SeveredHeadAttachScale=1.7
    SeveredLegAttachScale=1.3
    SeveredArmAttachScale=1.1
    BleedOutDuration=6.0
    HeadHeight=2.5
    HeadScale=1.5
    OnlineHeadshotOffset=(X=5,Y=0,Z=70)
    OnlineHeadshotScale=1.5
    MotionDetectorThreat=1.0
    Health=525//800
    HealthMax=525
    HeadHealth=25
    PlayerCountHealthScale=0.6 //0.25 kyan
    PlayerNumHeadHealthScale=0.15 //0.0 kyan
}
