class SlotMachine_PipeSelfDestBMessage extends SlotMachine_PipeSelfDestMessage;

static function string GetString(
    optional int Switch, 
    optional PlayerReplicationInfo RelatedPRI_1, 
    optional PlayerReplicationInfo RelatedPRI_2, 
    optional Object OptionalObject)
{
    if (RelatedPRI_1 != None)
        return RelatedPRI_1.PlayerName @ Default.Message;
    return "Somebody" @ Default.Message;
}

defaultproperties
{
     Message="made Total Pipebomb annihilation!"
     Lifetime=5
}
