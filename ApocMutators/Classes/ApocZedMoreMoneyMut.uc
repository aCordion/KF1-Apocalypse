class ApocZedMoreMoneyMut extends Mutator;

function PostBeginPlay()
{
    UpdateScoringValues();
}

function UpdateScoringValues()
{
    class'KFChar.ZombieClot_STANDARD'.default.ScoringValue = 14;       // 7
    class'KFChar.ZombieCrawler_STANDARD'.default.ScoringValue = 20;    // 10
    class'KFChar.ZombieGorefast_STANDARD'.default.ScoringValue = 24;   // 12
    class'KFChar.ZombieStalker_STANDARD'.default.ScoringValue = 30;    // 15
    class'KFChar.ZombieBloat_STANDARD'.default.ScoringValue = 34;      // 17
    class'KFChar.ZombieHusk_STANDARD'.default.ScoringValue = 34;       // 17
    class'KFChar.ZombieSiren_STANDARD'.default.ScoringValue = 34;      // 25
    class'KFChar.ZombieScrake_STANDARD'.default.ScoringValue = 50;     // 75
    class'KFChar.ZombieFleshpound_STANDARD'.default.ScoringValue = 70; // 200

    class'KFChar.ZombieClot_CIRCUS'.default.ScoringValue = 21;
    class'KFChar.ZombieCrawler_CIRCUS'.default.ScoringValue = 30;
    class'KFChar.ZombieGorefast_CIRCUS'.default.ScoringValue = 36;
    class'KFChar.ZombieStalker_CIRCUS'.default.ScoringValue = 45;
    class'KFChar.ZombieBloat_CIRCUS'.default.ScoringValue = 51;
    class'KFChar.ZombieHusk_CIRCUS'.default.ScoringValue = 51;
    class'KFChar.ZombieSiren_CIRCUS'.default.ScoringValue = 75;
    class'KFChar.ZombieScrake_CIRCUS'.default.ScoringValue = 100;
    class'KFChar.ZombieFleshpound_CIRCUS'.default.ScoringValue = 140;

    class'KFChar.ZombieClot_HALLOWEEN'.default.ScoringValue = 21;
    class'KFChar.ZombieCrawler_HALLOWEEN'.default.ScoringValue = 30;
    class'KFChar.ZombieGorefast_HALLOWEEN'.default.ScoringValue = 36;
    class'KFChar.ZombieStalker_HALLOWEEN'.default.ScoringValue = 45;
    class'KFChar.ZombieBloat_HALLOWEEN'.default.ScoringValue = 51;
    class'KFChar.ZombieHusk_HALLOWEEN'.default.ScoringValue = 51;
    class'KFChar.ZombieSiren_HALLOWEEN'.default.ScoringValue = 75;
    class'KFChar.ZombieScrake_HALLOWEEN'.default.ScoringValue = 100;
    class'KFChar.ZombieFleshpound_HALLOWEEN'.default.ScoringValue = 140;

    class'KFChar.ZombieClot_XMAS'.default.ScoringValue = 21;
    class'KFChar.ZombieCrawler_XMAS'.default.ScoringValue = 30;
    class'KFChar.ZombieGorefast_XMAS'.default.ScoringValue = 36;
    class'KFChar.ZombieStalker_XMAS'.default.ScoringValue = 45;
    class'KFChar.ZombieBloat_XMAS'.default.ScoringValue = 51;
    class'KFChar.ZombieHusk_XMAS'.default.ScoringValue = 51;
    class'KFChar.ZombieSiren_XMAS'.default.ScoringValue = 75;
    class'KFChar.ZombieScrake_XMAS'.default.ScoringValue = 100;
    class'KFChar.ZombieFleshpound_XMAS'.default.ScoringValue = 140;
}

defaultproperties
{
    GroupName="KF-ApocZedMoreMoneyMut"
    FriendlyName="[Apoc] ZED More Money"
    Description="Get more money if you kill a specimen"
}
