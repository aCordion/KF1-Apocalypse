class Sentry_DamTypeUA571DSentry extends KFProjectileWeaponDamageType
    abstract;

var int TotalAmount;

static function AwardDamage(KFSteamStatsAndAchievements KFStatsAndAchievements, int Amount)
{
    /*
    if (Default.TotalAmount >= 1000)
    {
        Default.TotalAmount -= 1000;
        KFStatsAndAchievements.AddHeadshotKill(false);
    }

    Default.TotalAmount += Amount;
    */
}

defaultproperties
{
    WeaponClass=Class'ApocMutators.Sentry_UA571DSentryWeapon'
    DeathString="%o was turned into swiss cheese by %k."
    FemaleSuicide="%o was shot and killed by her own turret."
    MaleSuicide="%o was shot and killed by his own turret."

    HeadShotDamageMult=1.000000// Decreased in Balance Round 2
    bKUseOwnDeathVel=True
    bThrowRagdoll=True
    bFlaming=False
    DamageThreshold=1
    KDamageImpulse=2000.000000
    bSniperWeapon=True

    // Make this bullet move the ragdoll when its shot
    bRagdollBullet=true
    KDeathVel=110.000000
    KDeathUpKick=10

    TotalAmount=0
}
