class SlotMachine_TeamFatalityMessage extends SlotMachine_ToxicMessage;

static function string GetString(
    optional int Switch,
    optional PlayerReplicationInfo RelatedPRI_1,
    optional PlayerReplicationInfo RelatedPRI_2,
    optional Object OptionalObject)
{
    return Default.Message @ Eval(RelatedPRI_1 != None, RelatedPRI_1.PlayerName, "someone") $ "!";
}

defaultproperties
{
     Message="You had all your armor and health taken away by"
     Lifetime=6
     DrawColor=(G=0,R=200)
}
