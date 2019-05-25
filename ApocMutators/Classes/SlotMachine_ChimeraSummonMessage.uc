class SlotMachine_ChimeraSummonMessage extends SlotMachine_PipeSelfDestMessage;

var localized string NoSummonText, KilledText;

static function string GetString(
    optional int Sw, 
    optional PlayerReplicationInfo RelatedPRI_1, 
    optional PlayerReplicationInfo RelatedPRI_2, 
    optional Object OptionalObject)
{
    local string S;

    switch(Sw)
    {
    case 0:
        S = Default.Message;
        break;
    case 1:
        return Default.NoSummonText;
    case 2:
        S = Default.KilledText;
        break;
    }
    if (RelatedPRI_1 != None)
        return RelatedPRI_1.PlayerName @ S;
    return "Somebody" @ S;
}

defaultproperties
{
     NoSummonText="Ultimate Chimera is already out there"
     KilledText="killed the Ultimate Chimera!"
     Message="summoned the Ultimate Chimera!"
     Lifetime=5
}
