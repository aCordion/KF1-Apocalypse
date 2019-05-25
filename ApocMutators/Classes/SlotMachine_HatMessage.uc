class SlotMachine_HatMessage extends SlotMachine_ToxicMessage;

var localized string FailedGiveStr;

static function string GetString(
    optional int Switch,
    optional PlayerReplicationInfo RelatedPRI_1,
    optional PlayerReplicationInfo RelatedPRI_2,
    optional Object OptionalObject)
{
    if (Switch == 0)
        return Default.Message;
    return Default.FailedGiveStr;
}

defaultproperties
{
     FailedGiveStr="You already had one santa hat!"
     Message="You were given a santa hat, hohoho!"
     DrawColor=(G=0,R=255)
}
