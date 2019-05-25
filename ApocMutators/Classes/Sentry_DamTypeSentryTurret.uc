class Sentry_DamTypeSentryTurret extends KFProjectileWeaponDamageType
    abstract;

static function AwardDamage(KFSteamStatsAndAchievements KFStatsAndAchievements, int Amount)
{
    //KFStatsAndAchievements.AddBullpupDamage(Amount);
}

defaultproperties
{
    DeathString="%o was turned into swiss cheese by %k."
    FemaleSuicide="%o was shot and killed by her own turret."
    MaleSuicide="%o was shot and killed by his own turret."
    
    // Make this bullet move the ragdoll when its shot
    bRagdollBullet=true
    KDeathVel=175.000000
    KDamageImpulse=6500
    KDeathUpKick=20
}
