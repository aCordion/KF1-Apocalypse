class SlotMachine_HeadMessage extends SlotMachine_ToxicMessage;

var localized string SmallHeadStr;

static function string GetString(
    optional int Switch, 
    optional PlayerReplicationInfo RelatedPRI_1, 
    optional PlayerReplicationInfo RelatedPRI_2, 
    optional Object OptionalObject)
{
    if (Switch == 0)
        return Default.Message;
    return Default.SmallHeadStr;
}

defaultproperties
{
     SmallHeadStr="You felt an extreme head shrinking!"
     Message="Your head just grew in size!"
     DrawColor=(R=255)
}
