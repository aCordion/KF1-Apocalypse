class ZEDS_ZombieHusk extends ZombieHusk_STANDARD
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
    DrawScale=1.4
    Prepivot=(Z=22.0)
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
    GroundSpeed=115.0
    WaterSpeed=102.000000
    MeleeDamage=15
    JumpZ=320.000000
    bCannibal = False // No animation for him.
    MenuName="Husk"
    CollisionRadius=26.000000
    CollisionHeight=44
    bCanDistanceAttackDoors=True
    Intelligence=BRAINS_Mammal
    bUseExtendedCollision=True
    ColOffset=(Z=36)
    ColRadius=30
    ColHeight=33
    ZombieFlag=1
    SeveredHeadAttachScale=0.9
    SeveredLegAttachScale=0.9
    SeveredArmAttachScale=0.9
    BleedOutDuration=6.0
    HeadHeight=1.0
    HeadScale=1.5
    ProjectileFireInterval=5.5
    BurnDamageScale=0.25
    OnlineHeadshotOffset=(X=20,Y=0,Z=55)
    OnlineHeadshotScale=1.0
    MotionDetectorThreat=1.0
    Health=600//700
    HealthMax=600//700
    HeadHealth=200//250
    PlayerCountHealthScale=0.6 //0.10 kyan
    PlayerNumHeadHealthScale=0.15 //0.05 kyan
}
