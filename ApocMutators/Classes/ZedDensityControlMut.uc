//=============================================================================
// ZedDensityControlMut.  Version 1.41
//=============================================================================
class ZedDensityControlMut extends Mutator
    config( ApocMutators );

var config bool bDebug;
var config float CanRespawnTime;
var config float TouchDisableTime;
var config float ZombieCountMulti;
var config float SpawnDesirability;
var config float MinDistanceToPlayer;
var config bool bAllowPlainSightSpawns;

function PreBeginPlay()
{
    local ZombieVolume ZV;

    Super.PreBeginPlay();

    foreach AllActors(Class'ZombieVolume', ZV)
    {
        ZV.CanRespawnTime = CanRespawnTime;
        ZV.TouchDisableTime = TouchDisableTime;
        ZV.ZombieCountMulti = ZombieCountMulti;
        ZV.SpawnDesirability = SpawnDesirability;
        ZV.MinDistanceToPlayer = MinDistanceToPlayer;
        ZV.bAllowPlainSightSpawns = bAllowPlainSightSpawns;
    }
}

function PostBeginPlay()
{
    local KFGameType KF;

    Super.PostBeginPlay();

    if (KF == none)
    {
        if (class'KFLevelRules' == none)
            log("No Level rules or default gametype, spawning kflevelrules actor");

        spawn(class'KFLevelRules');
    }

    KF = KFGameType(Level.Game);
    if (bDebug)
    {
        log("Can Respawn Time:" @ CanRespawnTime);
        log("Touch Disable Time:" @ TouchDisableTime);
        log("Minimum Distance to Player:" @ MinDistanceToPlayer);
        log("Allow Plain Sight Spawns:" @ bAllowPlainSightSpawns);
    }
}

function ModifyPlayer(Pawn Other)
{
    Super.ModifyPlayer(Other);

    SetTimer(5.0, false);
}

function Timer()
{
    local Controller C;
    local KFGametype KF;

    if (!bDebug) return;

    for (C = Level.ControllerList; C != None; C = C.NextController)
    {
        if( C.Pawn!=None && C.bIsPlayer )
        {
            C.Pawn.ClientMessage(" @ ?Can Respawn Time:" @ CanRespawnTime);
            C.Pawn.ClientMessage("? @ Touch Disable Time:" @ TouchDisableTime);
            C.Pawn.ClientMessage("? @ Minimum Distance To Player:" @ MinDistanceToPlayer);
            C.Pawn.ClientMessage(" @ ?Zed Density Control Mut Settings:");
            C.Pawn.ClientMessage("??llow Plain Sight Spawning:" @ bAllowPlainSightSpawns);
            C.Pawn.ClientMessage(" ");

            if (KF == none)
            {
                if (class'KFLevelRules' == none)
                    C.Pawn.ClientMessage("瓢 @ No KFLevelRules actor found in map, one was created");
            }
            else
            {
                C.Pawn.ClientMessage(" ");
            }

            C.Pawn.ClientMessage("? @ Press ~ To see advanced settings such as 'Allow Plain Sight Spawning'");
        }
    }
}

static function FillPlayInfo(PlayInfo PlayInfo)
{
    super.FillPlayInfo(PlayInfo);

    PlayInfo.AddSetting(default.GameGroup, "CanRespawnTime", "Can Respawn Time Override", 1, 1, "text", "4;0.0:10.0" , , , True);
    PlayInfo.AddSetting(default.GameGroup, "TouchDisableTime", "Touch Disable Time Override", 1, 1, "text", "4;0.0:20.0" , , , True);
    PlayInfo.AddSetting(default.GameGroup, "MinDistanceToPlayer", "Minimum Distance To Player Override", 1, 1, "text", "4;1:2000" , , , True);
    PlayInfo.AddSetting(default.GameGroup, "bAllowPlainSightSpawns", "Allow Plain Sight Spawns ", 0, 0, "check", , , , True);
}

static function string GetDescriptionText(string SettingName)
{
    switch (SettingName)
    {
    case "CanRespawnTime": return "Interval on a Zombie Volume before allowing new Zeds to spawn, similar to the global Spawn Interval setting.";
    case "TouchDisableTime": return "Duration that a Zombie Volume cannot produce spawns after a player has passed through it.";
    case "MinDistanceToPlayer": return "Minimum distance required between a player and a Zombie Volume before allowing spawns.";
    case "bAllowPlainSightSpawns": return ".";
    }

    return Super.GetDescriptionText(SettingName);
}

defaultproperties
{
    bDebug=False
    CanRespawnTime=1.5
    TouchDisableTime=10
    ZombieCountMulti=1
    SpawnDesirability=3000
    MinDistanceToPlayer=600
    bAllowPlainSightSpawns=False
    GroupName="KF-ApocZedMut"
    FriendlyName="[APOC] ApocZedMut"
    Description="A must have for increasing challenge and optimal zed count. You can change the max Zeds allowed at a time between a range of 25-200, and also can change the spawn delay between new spawns and previous anywhere from 0.0-5.0 seconds. Includes Advanced features for tweaking the attributes of spawns themselves in the map, such as the Minimum Distance To Player And Can Respawn Time."
}
