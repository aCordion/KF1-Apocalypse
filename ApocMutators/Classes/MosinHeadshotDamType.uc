class MosinHeadshotDamType extends MosinDamType
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
     bBulletHit=True
     FlashFog=(X=600.000000)
     VehicleDamageScaling=0.650000
}
