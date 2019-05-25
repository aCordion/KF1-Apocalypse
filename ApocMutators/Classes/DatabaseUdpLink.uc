Class DatabaseUdpLink extends UdpLink;

var string PendingLine;
var IpAddr A;
var ServerPerksMut Mut;
var array<StatsObject> ToSave;
var array<ServerStStats> PendingData;
var transient float NextReqTimer;
var bool bConnectionReady,bHasPendingLine;
var byte LoopCounter;

enum ENetID
{
	ID_None,
	ID_Open,
	ID_RequestPassword,
	ID_HeresPassword,
	ID_ConnectionClosed,
	ID_PasswordCorrect,
	ID_NewPlayer,
	ID_BadNewPlayer,
	ID_SendPlayerData,
	ID_UpdatePlayer,
	ID_KeepAlive,
};

function PostBeginPlay()
{
	Disable('Tick');
}
function BeginEvent()
{
	Mut.SaveAllStats = SaveAllStats;
	Mut.RequestStats = RequestStats;

	ReceiveMode = RMODE_Event;
	if( BindPort(Rand(8000)+8000,true)>0 )
		Resolve(Mut.RemoteDatabaseURL);
}
event Resolved( IpAddr Addr )
{
	A = Addr;
	A.Port = Mut.RemotePort;
	SendText(A,Chr(ENetID.ID_Open));
	Enable('Tick');
	NextReqTimer = Level.TimeSeconds+5.f;
}
function Tick( float Delta ) // Every 5 seconds, try to open connection again.
{
	if( !bConnectionReady && NextReqTimer<Level.TimeSeconds )
	{
		NextReqTimer = Level.TimeSeconds+5.f;
		SendText(A,Chr(ENetID.ID_Open));
	}
}
event ReceivedText( IpAddr Addr, string Text )
{
	local byte First;

	if( bHasPendingLine )
	{
		if( Asc(Right(Text,1))!=10 )
			PendingLine = PendingLine$Text;
		else
		{
			ReceivedPlayerData(PendingLine$Left(Text,Len(Text)-1));
			PendingLine = "";
			bHasPendingLine = false;
		}
		return;
	}
	First = Asc(Left(Text,1));
	Text = Mid(Text,1);
	// Level.Game.Broadcast(Self,"Receive:"@GetEnum(enum'ENetID',First)$":"@Text);
	switch( First )
	{
	case ENetID.ID_PasswordCorrect:
		bConnectionReady = true;
		break;
	case ENetID.ID_RequestPassword:
		bConnectionReady = false;
		SendText(A,Chr(ENetID.ID_HeresPassword)$Mut.RemotePassword);
		break;
	case ENetID.ID_ConnectionClosed:
		bConnectionReady = false;
		SendText(A,Chr(ENetID.ID_Open));
		break;
	case ENetID.ID_KeepAlive:
		SendText(A,Chr(ENetID.ID_KeepAlive));
		break;
	case ENetID.ID_NewPlayer:
		Mut.ReceivedPlayerID(Text);
		break;
	case ENetID.ID_SendPlayerData:
		if( Asc(Right(Text,1))!=10 )
		{
			PendingLine = Text;
			bHasPendingLine = true;
			break;
		}
		ReceivedPlayerData(Text);
		break;
	default:
	}
}

function SaveAllStats()
{
	local int i;

	ToSave = Mut.ActiveStats;
	for( i=0; i<ToSave.Length; ++i )
	{
		if( !ToSave[i].bStatsChanged )
			ToSave.Remove(i--,1);
	}
	if( ToSave.Length>0 )
		GoToState('SaveAll');
}
function RequestStats( ServerStStats Other )
{
	local int i;

	if( !bConnectionReady )
		return;
	SendText(A,Chr(ENetID.ID_NewPlayer)$Other.MyStatsObject.Name$"*"$Mut.GetSafeName(Other.PlayerOwner.PlayerReplicationInfo.PlayerName));
	for( i=0; i<PendingData.Length; ++i )
		if( PendingData[i]==Other )
			return;
	PendingData[PendingData.Length] = Other;
}
final function ReceivedPlayerData( string S )
{
	local int i,RID;

	i = InStr(S,"|");
	RID = int(Left(S,i));
	S = Mid(S,i+1);

	for( i=0; i<PendingData.Length; ++i )
	{
		if( PendingData[i]==None )
			PendingData.Remove(i--,1);
		else if( RID==PendingData[i].GetID() )
		{
			PendingData[i].GetData(S);
			PendingData.Remove(i,1);
			break;
		}
	}
}

State SaveAll
{
	function BeginState()
	{
		SetTimer(0.05,true);
	}
	function EndState()
	{
		SetTimer(0,false);
	}
	function Timer()
	{
		local StatsObject S;
		local string Line;

		if( !bConnectionReady )
			return;
		S = ToSave[0];
		S.bStatsChanged = false;
		Line = Chr(ENetID.ID_UpdatePlayer)$S.ID$"|"$S.GetSaveData()$Chr(10);
		while( Len(Line)>512 )
		{
			SendText(A,Left(Line,512));
			Line = Mid(Line,512);
		}
		SendText(A,Line);
		ToSave.Remove(0,1);
		if( ToSave.Length==0 )
			GoToState('');
	}
Begin:
	while( ++LoopCounter<150 )
	{
		if( Level.bLevelChange ) // Delay mapchange until all stats are uploaded.
			Level.NextSwitchCountdown = FMax(Level.NextSwitchCountdown,1.f);
		Sleep(0.5);
	}
}
