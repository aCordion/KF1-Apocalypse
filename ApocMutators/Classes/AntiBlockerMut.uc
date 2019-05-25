class AntiBlockerMut extends Mutator;

var array<KFHumanPawn> PlayerList;
var bool bUnblocked;

function bool CheckReplacement(Actor Other, out byte bSuperRelevant)
{
	if (Other.IsA('KFHumanPawn'))
		PlayerList[PlayerList.Length] = KFHumanPawn(Other);

	return Super.CheckReplacement(Other, bSuperRelevant);
}

function Tick(float delta)
{
	local KFGameType KF;
	local KFHumanPawn AP;

	KF = KFGameType(Level.Game);
	if (KF == None) return;

	if (KF.bTradingDoorsOpen)
	{
		if (!bUnblocked)
		{
			foreach DynamicActors(class'KFHumanPawn', AP)
				PlayerList[PlayerList.Length] = AP;
			bUnblocked = true;

		}

		while (PlayerList.Length > 0) {
			PlayerList[0].bBlockActors = false;
			PlayerList.Remove(0, 1);
		}
	}
	else
	{
		if (bUnblocked) {
			foreach DynamicActors(class'KFHumanPawn', AP)
				PlayerList[PlayerList.Length] = AP;
			bUnblocked = false;
		}

		while (PlayerList.Length > 0) {
			PlayerList[0].bBlockActors = true;
			PlayerList.Remove(0, 1);
		}
	}
}

defaultproperties
{
	 GroupName="KF-AntiBlocker1.1"
	 FriendlyName="AntiBlocker 1.1"
	 Description="Disables player-to-player blocking during trader time."
}
