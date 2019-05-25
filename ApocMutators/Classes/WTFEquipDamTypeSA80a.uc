class WTFEquipDamTypeSA80a extends KFProjectileWeaponDamageType
    abstract;

//kyan: del
/*
static function AwardKill(KFSteamStatsAndAchievements KFStatsAndAchievements, KFPlayerController Killer, KFMonster Killed);
static function AwardDamage(KFSteamStatsAndAchievements KFStatsAndAchievements, int Amount);
*/

defaultproperties
{
     WeaponClass=Class'ApocMutators.WTFEquipSA80a'
     DeathString="%k killed %o(SA80)."
     FemaleSuicide="%o shot herself in the foot."
     MaleSuicide="%o shot himself in the foot."
     bRagdollBullet=True
     KDamageImpulse=3000.000000
     KDeathVel=220.000000
     KDeathUpKick=4.000000
     bSniperWeapon=True
}
