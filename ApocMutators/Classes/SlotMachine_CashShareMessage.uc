class SlotMachine_CashShareMessage extends SlotMachine_ToxicMessage;

static function string GetString(
    optional int Switch, 
    optional PlayerReplicationInfo RelatedPRI_1, 
    optional PlayerReplicationInfo RelatedPRI_2, 
    optional Object OptionalObject)
{
    return "You've shared" @ Switch @ "pounds with your team!";
}

defaultproperties
{
     DrawColor=(R=255)
}
