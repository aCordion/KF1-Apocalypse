class SlotMachine_ToxicMessage extends LocalMessage;

var localized string Message;

static function string GetString(
    optional int Switch,
    optional PlayerReplicationInfo RelatedPRI_1,
    optional PlayerReplicationInfo RelatedPRI_2,
    optional Object OptionalObject)
{
    return Default.Message;
}

defaultproperties
{
     Message="You spilled vomit all over your face!"
     bIsUnique=True
     bFadeMessage=True
     Lifetime=4
     DrawColor=(B=0,R=0)
     StackMode=SM_Down
     PosY=0.800000
}
