class Sentry_DamTypeSentryBot extends DamTypeMelee
    abstract;

// 경험치 막음
static function AwardDamage(KFSteamStatsAndAchievements KFStatsAndAchievements, int Amount)
{
}
    
defaultproperties
{
     DeathString="%o was gunned down by %s."
}
