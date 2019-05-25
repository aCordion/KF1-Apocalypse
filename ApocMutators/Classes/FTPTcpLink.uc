Class FTPTcpLink extends TcpLink;

var array<ServerStStats> PendingLoaders;
var array<StatsObject> ToSave;
var ServerPerksMut Mut;
var IpAddr SiteAddress;
var FTPDataConnection DataConnection;
var transient float WelcomeTimer;
var array<string> TotalList;
var MessagingSpectator WebAdminController;
var bool bConnectionBroken,bFullVerbose,bUploadAllStats,bTotalUpload,bFileInProgress,bLogAllCommands,bCheckedWeb;

function BeginEvent()
{
	Mut.SaveAllStats = SaveAllStats;
	Mut.RequestStats = RequestStats;
	if( Mut.bDebugDatabase )
	{
		bLogAllCommands = true;
		bFullVerbose = true;
	}

	LinkMode = MODE_Line;
	ReceiveMode = RMODE_Event;
	Resolve(Mut.RemoteDatabaseURL);
}
final function ReportError( string InEr )
{
	if( !bConnectionBroken )
	{
		Level.Game.Broadcast(Self,"FTP Error: "$InEr);
		Log("FTP Error: "$InEr,Class.Name);
	}
	bConnectionBroken = true;
	GoToState('ErrorState');
}
event Resolved( IpAddr Addr )
{
	SiteAddress = Addr;
	SiteAddress.Port = Mut.RemotePort;
	GoToState('Idle');
}
event ResolveFailed()
{
	ReportError("Couldn't resolve address, aborting...");
}
event Closed()
{
	ReportError("Connection was closed by FTP server!");
}
final function DebugLog( string Str )
{
	if( !bCheckedWeb )
	{
		bCheckedWeb = true;
		foreach AllActors(class'MessagingSpectator',WebAdminController)
			break;
	}
	if( WebAdminController!=None )
		WebAdminController.ClientMessage(Str,'FTP');
	Log(Str,'FTP');
}
event ReceivedLine( string Text )
{
	if( bLogAllCommands )
		DebugLog("ReceiveFTP "$GetStateName()$":"@Text);
	ProcessResponse(int(Left(Text,3)),Mid(Text,4));
}
final function SendFTPLine( string Text )
{
	if( bLogAllCommands )
		DebugLog("SendFTP "$GetStateName()$":"@Text);
	SendText(Text);
}

function SaveAllStats()
{
	local int i;

	if( bTotalUpload )
		return;
	ToSave = Mut.ActiveStats;
	for( i=0; i<ToSave.Length; ++i )
	{
		if( !ToSave[i].bStatsChanged )
			ToSave.Remove(i--,1);
	}
	if( ToSave.Length>0 )
		bUploadAllStats = true;
}
function RequestStats( ServerStStats Other )
{
	local int i;
	
	if( bTotalUpload )
		return;
	for( i=0; i<PendingLoaders.Length; ++i )
	{
		if( PendingLoaders[i]==None )
			PendingLoaders.Remove(i--,1);
		else if( PendingLoaders[i]==Other )
			return;
	}
	PendingLoaders[PendingLoaders.Length] = Other;
}
final function FullUpload()
{
	TotalList = GetPerObjectNames("ServerPerksStat","StatsObject",9999999);
	bTotalUpload = true;
	bUploadAllStats = true;
	bFullVerbose = true;
	HasMoreStats();
	SaveAllStats();
}
final function bool HasMoreStats()
{
	local byte i;
	local int j;
	
	if( TotalList.Length==0 )
		return false;
	j = ToSave.Length;
	for( i=0; i<Min(20,TotalList.Length); ++i )
	{
		ToSave.Length = j+1;
		ToSave[j] = new(None,TotalList[i]) Class'StatsObject';
		++j;
	}
	TotalList.Remove(0,20);
	return true;
}
final function CheckNextCommand()
{
	while( PendingLoaders.Length>0 && PendingLoaders[0]==None )
		PendingLoaders.Remove(0,1);

	if( bUploadAllStats || (bTotalUpload && HasMoreStats()) )
		GoToState('UploadStats','Begin');
	else if( PendingLoaders.Length>0 )
		GoToState('DownloadStats','Begin');
	else
	{
		if( bFullVerbose )
			Level.Game.Broadcast(Self,"FTP: All done!");
		if( Mut.FTPKeepAliveSec>0 && !Level.Game.bGameEnded )
			GoToState('KeepAlive');
		else GoToState('EndConnection');
	}
}
function ProcessResponse( int Code, string Line )
{
	switch( Code )
	{
	case 220: // Welcome
		if( WelcomeTimer<Level.TimeSeconds )
		{
			SendFTPLine("USER "$Mut.RemoteFTPUser);
			WelcomeTimer = Level.TimeSeconds+0.2;
		}
		break;
	case 331: // Password required
		SendFTPLine("PASS "$Mut.RemotePassword);
		break;
	case 230: // User logged in.
		if( Mut.RemoteFTPDir!="" )
			SendFTPLine("CWD "$Mut.RemoteFTPDir);
		else SendFTPLine("TYPE A");
		break;
	case 250: // CWD command successful.
		SendFTPLine("TYPE A");
		break;
	case 200: // Type set to A
		CheckNextCommand();
		break;
	case 226: // File successfully transferred
	case 150: // Opening ASCII mode data connection
		break;
	case 421: // No transfer timeout: closing control connection
		if( bFullVerbose )
			Level.Game.Broadcast(Self,"FTP: Connection timed out, reconnecting!");
		GoToState('EndConnection');
		break;
	default:
		if( bFullVerbose )
			Level.Game.Broadcast(Self,"FTP: Unknown FTP code '"$Code$"': "$Line);
		Log("Unknown FTP code '"$Code$"': "$Line,Class.Name);
	}
}
function DataReceived();

final function bool OpenDataConnection( string S, bool bUpload )
{
	local int i,j;
	local IpAddr A;

	A = SiteAddress;
	
	// Get destination port
	S = Mid(S,InStr(S,"(")+1);
	for( i=0; i<4; ++i ) // Skip IP address
		S = Mid(S,InStr(S,",")+1);
	i = InStr(S,",");
	A.Port = int(Left(S,i))*256 + int(Mid(S,i+1));
	
	// Now attempt to bind port and open connection.
	for( j=0; j<20; ++j )
	{
		if( DataConnection!=None )
			DataConnection.Destroy();
		DataConnection = Spawn(Class'FTPDataConnection',Self);
		DataConnection.bUpload = bUpload;
		DataConnection.BindPort(500+Rand(5000),true);
		if( DataConnection.OpenNoSteam(A) )
			return true;
	}
	DataConnection.Destroy();
	DataConnection = None;
	ReportError("Couldn't bind port for upload data connection!");
	return false;
}

function Timer()
{
	ReportError("FTP connection timed out!");
}

state Idle
{
Ignores Timer;

	final function StartConnection()
	{
		local int i;
		
		for( i=0; i<40; ++i )
		{
			BindPort(500+Rand(5000),true);
			if( OpenNoSteam(SiteAddress) )
			{
				GoToState('InitConnection');
				return;
			}
		}
		ReportError("Port couldn't be bound or connection failed to open!");
	}
	function SaveAllStats()
	{
		Global.SaveAllStats();
		if( bUploadAllStats )
			StartConnection();
	}
	function RequestStats( ServerStStats Other )
	{
		Global.RequestStats(Other);
		StartConnection();
	}
Begin:
	Sleep(0.1f);
	if( bUploadAllStats || PendingLoaders.Length>0 )
		StartConnection();
}
state InitConnection
{
	function BeginState()
	{
		SetTimer(10,false);
	}
	event Closed()
	{
		ReportError("Connection was closed by FTP server!");
	}
}
state ConnectionBase
{
	event Closed()
	{
		GoToState('Idle');
	}
Begin:
	while( true )
	{
		if( bUploadAllStats && Level.bLevelChange ) // Delay mapchange until all stats are uploaded.
			Level.NextSwitchCountdown = FMax(Level.NextSwitchCountdown,1.f);
		Sleep(0.5);
	}
}
state EndConnection extends ConnectionBase
{
	function BeginState()
	{
		SendFTPLine("QUIT");
		Close();
		SetTimer(4,false);
	}
}
state KeepAlive extends ConnectionBase
{
Ignores Timer;

	function SaveAllStats()
	{
		Global.SaveAllStats();
		if( bUploadAllStats )
			StartConnection();
	}
	function RequestStats( ServerStStats Other )
	{
		Global.RequestStats(Other);
		StartConnection();
	}
	final function StartConnection()
	{
		CheckNextCommand();
	}
Begin:
	while( true )
	{
		if( bUploadAllStats || PendingLoaders.Length>0 )
			StartConnection();
		Sleep(Mut.FTPKeepAliveSec);
		SendFTPLine("NOOP");
	}
}
state UploadStats extends ConnectionBase
{
	function BeginState()
	{
		bUploadAllStats = false;
		SetTimer(10,false);
	}
	function SaveAllStats();
	
	final function InitDataConnection( string S )
	{
		if( bFullVerbose )
			Level.Game.Broadcast(Self,"FTP: Upload stats for "$ToSave[0].PlayerName$" ("$(ToSave.Length-1+TotalList.Length)$" remains)");
		if( OpenDataConnection(S,true) )
		{
			DataConnection.Data = ToSave[0].GetSaveData();
			SendFTPLine("STOR "$ToSave[0].Name$".txt");
			bFileInProgress = true;
		}
	}
	final function NextPackage()
	{
		ToSave.Remove(0,1);
		if( ToSave.Length==0 )
			CheckNextCommand();
		else SendFTPLine("PASV");
	}
	function ProcessResponse( int Code, string Line )
	{
		switch( Code )
		{
		case 200: // Type set to A
			// SendFTPLine("PASV");
			break;
		case 227: // Entering passive mode
			if( !bFileInProgress )
				InitDataConnection(Line);
			break;
		case 150: // Opening ASCII mode data connection for file
			SetTimer(60,false);
			if( DataConnection!=None )
				DataConnection.BeginUpload();
			break;
		case 226: // File transfer completed.
			if( bFileInProgress )
			{
				SetTimer(10,false);
				bFileInProgress = false;
				NextPackage();
			}
			break;
		default:
			Global.ProcessResponse(Code,Line);
		}
	}
Begin:
	SendFTPLine("PASV");
	while( true )
	{
		if( Level.bLevelChange ) // Delay mapchange until all stats are uploaded.
		{
			bFullVerbose = true;
			Level.NextSwitchCountdown = FMax(Level.NextSwitchCountdown,1.f);
		}
		Sleep(0.5);
	}
}
state DownloadStats extends ConnectionBase
{
	function BeginState()
	{
		SetTimer(10,false);
	}
	final function InitDataConnection( string S )
	{
		while( PendingLoaders.Length>0 && PendingLoaders[0]==None )
			PendingLoaders.Remove(0,1);
		if( PendingLoaders.Length==0 )
		{
			CheckNextCommand();
			return;
		}

		if( bFullVerbose )
			Level.Game.Broadcast(Self,"FTP: Download stats for "$PendingLoaders[0].MyStatsObject.PlayerName$" ("$(PendingLoaders.Length-1)$" remains)");

		if( OpenDataConnection(S,false) )
		{
			DataConnection.OnCompleted = DataReceived;
			SendFTPLine("RETR "$PendingLoaders[0].MyStatsObject.Name$".txt");
			bFileInProgress = true;
		}
	}
	function DataReceived()
	{
		bFileInProgress = false;
		if( PendingLoaders[0]!=None )
		{
			if( DataConnection!=None )
				PendingLoaders[0].GetData(DataConnection.Data);
			else PendingLoaders[0].GetData("");
		}
		PendingLoaders.Remove(0,1);
		while( PendingLoaders.Length>0 && PendingLoaders[0]==None )
			PendingLoaders.Remove(0,1);

		if( bUploadAllStats ) // Saving has higher priority.
			GoToState('UploadStats');
		else if( PendingLoaders.Length>0 )
			SendFTPLine("PASV");
		else CheckNextCommand();
	}
	function ProcessResponse( int Code, string Line )
	{
		switch( Code )
		{
		case 200: // Type set to A
			// SendFTPLine("PASV");
			break;
		case 227: // Entering passive mode
			if( !bFileInProgress )
				InitDataConnection(Line);
			break;
		case 150: // Opening ASCII mode data connection for file
			SetTimer(60,false);
			break;
		case 550: // No such file or directory
			SetTimer(10,false);
			if( bFileInProgress )
			{
				if( DataConnection!=None )
					DataConnection.Destroy();
				DataReceived();
			}
			break;
		default:
			Global.ProcessResponse(Code,Line);
		}
	}
Begin:
	SendFTPLine("PASV");
	while( true )
	{
		if( bUploadAllStats && Level.bLevelChange ) // Delay mapchange until all stats are uploaded.
		{
			bFullVerbose = true;
			Level.NextSwitchCountdown = FMax(Level.NextSwitchCountdown,1.f);
		}
		Sleep(0.5);
	}
}
state ErrorState
{
Ignores SaveAllStats,RequestStats;
Begin:
	Sleep(1.f);
	Mut.RespawnNetworkLink();
}

defaultproperties
{
}