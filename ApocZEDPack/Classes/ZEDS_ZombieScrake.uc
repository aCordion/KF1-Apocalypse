class ZEDS_ZombieScrake extends ZombieScrake_STANDARD
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
    Prepivot=(Z=3.0)
    bMeleeStunImmune = true
    MeleeDamage=20
    damageForce=-75000//-400000
    ScoringValue=75
    MeleeRange=40.0//60.000000
    GroundSpeed=85.000000
    WaterSpeed=75.000000
    //StunTime=0.3 Was used in Balance Round 1(removed for Round 2)
    StunsRemaining=1 //Added in Balance Round 2
    AmbientGlow=0
    bFatAss=True
    Mass=500.000000
    RotationRate=(Yaw=45000,Roll=0)
    bCannibal = false
    MenuName="Scrake"
    CollisionRadius=26
    CollisionHeight=44
    SoundVolume=175
    SoundRadius=100.0
    Intelligence=BRAINS_Mammal
    bUseExtendedCollision=True
    ColOffset=(Z=55)
    ColRadius=29
    ColHeight=18
    ZombieFlag=3
    SeveredHeadAttachScale=1.0
    SeveredLegAttachScale=1.1
    SeveredArmAttachScale=1.1
    BleedOutDuration=6.0
    PoundRageBumpDamScale=0.01
    HeadHeight=2.2
    HeadScale=1.1
    AttackChargeRate=2.5
    OnlineHeadshotOffset=(X=22,Y=5,Z=58)
    OnlineHeadshotScale=1.5
    MotionDetectorThreat=3.0
    Health=1000//1500
    HealthMax=1000
    HeadHealth=650
    PlayerCountHealthScale=1.3//2.0
    PlayerNumHeadHealthScale=0.3 // Was 0.35 in Balance Round 1
}
