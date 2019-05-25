// Template class.
Class SRStatsBase extends KFSteamStatsAndAchievements
	Abstract;

var ClientPerkRepLink Rep;
var KFPlayerController PlayerOwner;
var bool bStatsReadyNow;

function int GetID();
function SetID( int ID );
function ChangeCharacter( string CN );
function ApplyCharacter( string CN );

function ServerSelectPerkName( name N );
function ServerSelectPerk( Class<SRVeterancyTypes> VetType );

function NotifyStatChanged();

defaultproperties
{
	bNetNotify=false
	bUsedCheats=true
	bFlushStatsToClient=false
	bInitialized=true
	RemoteRole=ROLE_None
}