//=============================================================================
// SRGameRules
//=============================================================================
class SRGameRules extends GameRules;

function PostBeginPlay()
{
	if( Level.Game.GameRulesModifiers==None )
		Level.Game.GameRulesModifiers = Self;
	else Level.Game.GameRulesModifiers.AddGameRules(Self);
}

function AddGameRules(GameRules GR)
{
	if ( GR!=Self )
		Super.AddGameRules(GR);
}

function bool PreventDeath(Pawn Killed, Controller Killer, class<DamageType> damageType, vector HitLocation)
{
	local ClientPerkRepLink R;
	local SRCustomProgress S;

	if ( (NextGameRules != None) && NextGameRules.PreventDeath(Killed,Killer, damageType,HitLocation) )
		return true;

	if( xPlayer(Killer)!=None && Killed.Controller!=None && Killed.Controller!=Killer )
	{
		R = FindStatsFor(Killer);
		if( R!=None )
			for( S=R.CustomLink; S!=None; S=S.NextLink )
				S.NotifyPlayerKill(Killed,damageType);
	}
	if( xPlayer(Killed.Controller)!=None && Killer!=None && Killer.Pawn!=None )
	{
		R = FindStatsFor(Killed.Controller);
		if( R!=None )
			for( S=R.CustomLink; S!=None; S=S.NextLink )
				S.NotifyPlayerKilled(Killer.Pawn,damageType);
	}
	return false;
}
static final function ClientPerkRepLink FindStatsFor( Controller C )
{
	local LinkedReplicationInfo L;

	if( C.PlayerReplicationInfo==None )
		return None;
	for( L=C.PlayerReplicationInfo.CustomReplicationInfo; L!=None; L=L.NextReplicationInfo )
		if( ClientPerkRepLink(L)!=None )
			return ClientPerkRepLink(L);
	return None;
}
