class SlotMachine_CashMessage extends SlotMachine_ToxicMessage;

static function string GetString(
    optional int Switch, 
    optional PlayerReplicationInfo RelatedPRI_1, 
    optional PlayerReplicationInfo RelatedPRI_2, 
    optional Object OptionalObject)
{
    return "Won" @ Switch @ "pounds!";
}

defaultproperties
{
     DrawColor=(R=255)
}
