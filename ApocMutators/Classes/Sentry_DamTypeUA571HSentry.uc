class Sentry_DamTypeUA571HSentry extends DamTypeBurned
    abstract;

// 경험치 막음
static function AwardDamage(KFSteamStatsAndAchievements KFStatsAndAchievements, int Amount)
{
}
    
defaultproperties
{
    WeaponClass=Class'ApocMutators.Sentry_UA571HSentryWeapon'
    DeathString="%o was turned into swiss cheese by %k."
    FemaleSuicide="%o was shot and killed by her own turret."
    MaleSuicide="%o was shot and killed by his own turret."
}
