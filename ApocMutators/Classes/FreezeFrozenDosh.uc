class FreezeFrozenDosh extends CashPickup;

// fixes none reference issue -- PooSH
function GiveCashTo( Pawn Other )
{
	// You all love the mental-mad typecasting XD
	if( !bDroppedCash )
	{
		CashAmount = (rand(0.5 * default.CashAmount) + default.CashAmount) * (KFGameReplicationInfo(Level.GRI).GameDiff  * 0.5) ;
	}
	else if ( Other.PlayerReplicationInfo != none && DroppedBy != none && DroppedBy.PlayerReplicationInfo != none &&
			  ((DroppedBy.PlayerReplicationInfo.Score + float(CashAmount)) / Other.PlayerReplicationInfo.Score) >= 0.50 &&
			  PlayerController(DroppedBy) != none && KFSteamStatsAndAchievements(PlayerController(DroppedBy).SteamStatsAndAchievements) != none )
	{
		if ( Other.PlayerReplicationInfo != DroppedBy.PlayerReplicationInfo )
		{
			KFSteamStatsAndAchievements(PlayerController(DroppedBy).SteamStatsAndAchievements).AddDonatedCash(CashAmount);
		}
	}

	if( Other.Controller!=None && Other.Controller.PlayerReplicationInfo!=none )
	{
		Other.Controller.PlayerReplicationInfo.Score += CashAmount;
	}
	AnnouncePickup(Other);
	SetRespawn();
}

defaultproperties
{
     DrawScale=0.300000
     UV2Texture=None
}
