class Sentry_DamTypeUSCMSentry extends KFProjectileWeaponDamageType
    abstract;

// 경험치 막음
static function AwardDamage(KFSteamStatsAndAchievements KFStatsAndAchievements, int Amount)
{
}
    
defaultproperties
{
    WeaponClass=Class'ApocMutators.Sentry_USCMSentryWeapon'
    DeathString="%o was turned into swiss cheese by %k."
    FemaleSuicide="%o was shot and killed by her own turret."
    MaleSuicide="%o was shot and killed by his own turret."

    bRagdollBullet=True
    bBulletHit=True
    FlashFog=(X=600.000000)
    VehicleDamageScaling=0.700000

    KDamageImpulse=10000.000000
    KDeathVel=300.000000
    KDeathUpKick=100.000000

    bIsPowerWeapon=True
}
