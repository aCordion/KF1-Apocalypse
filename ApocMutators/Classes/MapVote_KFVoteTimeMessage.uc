class MapVote_KFVoteTimeMessage extends CriticalEventPlus;

var(Message) localized string TimeString[13];

static function string GetString(
    optional int Switch,
    optional PlayerReplicationInfo RelatedPRI_1,
    optional PlayerReplicationInfo RelatedPRI_2,
    optional Object OptionalObject)
{
    Return Default.TimeString[Switch];
}

defaultproperties
{
    TimeString(0)="1..."
    TimeString(1)="2..."
    TimeString(2)="3..."
    TimeString(3)="4..."
    TimeString(4)="5..."
    TimeString(5)="6..."
    TimeString(6)="7..."
    TimeString(7)="8..."
    TimeString(8)="9..."
    TimeString(9)="10..."
    TimeString(10)="20 seconds..."
    TimeString(11)="30 seconds left..."
    TimeString(12)="1 minute remains!"
    bIsConsoleMessage=False
    DrawColor=(B=50,G=50,R=255)
    PosY=0.040000
    FontSize=2
}
