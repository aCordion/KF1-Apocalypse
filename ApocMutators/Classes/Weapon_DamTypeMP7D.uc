class Weapon_DamTypeMP7D extends DamTypeMP7M;

static function AwardKill(KFSteamStatsAndAchievements KFStatsAndAchievements, KFPlayerController Killer, KFMonster Killed )
{
	local SRStatsBase stats;
	
	stats = SRStatsBase(KFStatsAndAchievements);
	if( stats !=None && stats.Rep!=None )
		stats.Rep.ProgressCustomValue(Class'ApocMutators.Weapon_PistolKillProgress',1);
}

static function AwardDamage(KFSteamStatsAndAchievements KFStatsAndAchievements, int Amount)
{
	local SRStatsBase stats;
	
	stats = SRStatsBase(KFStatsAndAchievements);
	if( stats !=None && stats.Rep!=None )
		stats.Rep.ProgressCustomValue(Class'ApocMutators.Weapon_PistolDamageProgress',Amount);
}

defaultproperties
{
     bSniperWeapon=False
     WeaponClass=Class'ApocMutators.Weapon_DualDeagle'
}
