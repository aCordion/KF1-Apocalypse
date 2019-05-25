//=============================================================================
// CtryTags.                            Coded by Marco (2012)
//=============================================================================
class CountryTagMut extends Mutator
    Config(ApocMutators);

var() config string CountryTagParsing,HostLanIpAddr,HostWanIpAddr;

// Main function.
function bool CheckReplacement(Actor Other, out byte bSuperRelevant)
{
    if( Other.IsA('PlayerController') )
        AddHandler(PlayerController(Other));
    return true;
}

final function AddHandler( PlayerController PC )
{
    local CountryTag_ClientHandler C;

    C = Spawn(class'CountryTag_ClientHandler');
    C.Client = PC;
    C.MasterHandler = self;
}

final function string ParseCountryTag( string InName, string InTag )
{
    local int i;

    i = InStr(CountryTagParsing,"%tag");
    InTag = Left(CountryTagParsing,i)$InTag$Mid(CountryTagParsing,i+4);
    i = InStr(InTag,"%name");
    return Left(InTag,i)$InName$Mid(InTag,i+5);
}

defaultproperties
{
    GroupName="KF-CountryTags"
    FriendlyName="Country Tags"
    Description="Add player country tags."

    CountryTagParsing="[%tag] %name"
    HostLanIpAddr="127.0.0.1"
    HostWanIpAddr="1.1.1.1"
}
