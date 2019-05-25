class ForceGameStartMut extends Mutator
	config(ApocMutators);

var config int waitingInterval;
var int startWaiting;
var bool firstPlayerArrived;

function PostBeginPlay()
{
	startWaiting=Level.TimeSeconds;
	firstPlayerArrived=false;
	SetTimer(5.0,true);
}

function Timer()
{
	local int playersN;

	if (!Level.Game.bWaitingToStartMatch)
		return;


	playersN=PlayersNumber();
	if(playersN==0)
		return;
	if(playersN>0 && !firstPlayerArrived)
	{
		firstPlayerArrived=true;
		startWaiting=Level.TimeSeconds;
		return;
	}

	if(Level.TimeSeconds-startWaiting<waitingInterval)
		return;

	Level.Game.StartMatch();
}

function int PlayersNumber()
{
	local int N;
	local Controller C;
	N=0;
	for( C = Level.ControllerList; C != None; C = C.nextController )
	{
		if( C.IsA('PlayerController') && C.PlayerReplicationInfo.PlayerID>0 && C.PlayerReplicationInfo.bWaitingPlayer)
		{
			N++;
		}
	}
	return N;
}

defaultproperties
{
	 waitingInterval=180
	 bAddToServerPackages=True
	 GroupName="ForceGameStartMut"
	 FriendlyName="ForceGameStartMut"
	 Description="Forces game start if some players are not ready for a long period of time"
}
