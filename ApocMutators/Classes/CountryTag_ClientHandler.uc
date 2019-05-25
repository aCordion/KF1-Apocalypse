//=============================================================================
// ClientHandler.
// Make sure client isnt playing without his country tag.
//=============================================================================
class CountryTag_ClientHandler extends Info;

var PlayerController Client;
var CountryTagMut MasterHandler;
var bool bHasInitialized;
var string MyCountry,OldClientName;

function PostBeginPlay()
{
	SetTimer(0.1,false);
}
function Timer()
{
	if( Client==None )
	{
		Destroy();
		Return;
	}
	if( !bHasInitialized )
	{
		if( !GetClientCountry() )
			return;

		bHasInitialized = true;
		SetTimer(2+FRand(),True);
	}
	if( Client.PlayerReplicationInfo!=None && Client.PlayerReplicationInfo.PlayerName!=OldClientName )
	{
		OldClientName = MasterHandler.ParseCountryTag(Client.PlayerReplicationInfo.PlayerName,MyCountry);
		Client.PlayerReplicationInfo.PlayerName = OldClientName;
		Client.PlayerReplicationInfo.NetUpdateTime = Level.TimeSeconds - 1;
	}
}
final function bool GetClientCountry()
{
	local string IP;
	local int i,V;

	if( NetConnection(Client.Player)==None ) // Not a client.
	{
		Destroy();
		Return false;
	}
	IP = Client.GetPlayerNetworkAddress();
	IP = Left(IP,InStr(IP,":"));
	if( IP==MasterHandler.HostLanIpAddr )
		IP = MasterHandler.HostWanIpAddr;

	// Convert dotted IP-address into integer.
	i = InStr(IP,".");
	V = int(Left(IP,i))<<16;
	IP = Mid(IP,i+1);

	i = InStr(IP,".");
	V += int(Left(IP,i))<<8;
	IP = Mid(IP,i+1);

	i = InStr(IP,".");
	V += int(Left(IP,i));

	// Perform slow task.
	MyCountry = Class'CountryTag_Database'.Static.GetClientCountryTag(V);

	return true;
}

defaultproperties
{
}
