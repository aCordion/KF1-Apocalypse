class MosinDamType extends KFProjectileWeaponDamageType
	abstract;

static function ScoredHeadshot(KFSteamStatsAndAchievements KFStatsAndAchievements, class<KFMonster> MonsterClass, bool bLaserSightedM14EBRKill)
{
	super.ScoredHeadshot( KFStatsAndAchievements, MonsterClass, bLaserSightedM14EBRKill );

	if ( KFStatsAndAchievements != none )
	{
     	KFStatsAndAchievements.AddHeadshotsWithSPSOrM14( MonsterClass );
	}
}

defaultproperties
{
     HeadShotDamageMult=1.000000
     bSniperWeapon=True
     WeaponClass=Class'MosinNagant'
     DeathString="%k killed %o (Mosin Nagant)."
     FemaleSuicide="%o shot herself in the foot."
     MaleSuicide="%o shot himself in the foot."
     bRagdollBullet=True
	 bThrowRagdoll=True
     KDamageImpulse=10000.000000
     KDeathVel=300.000000
     KDeathUpKick=100.000000
}
