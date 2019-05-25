class SlotMachine_MaskMessage extends SlotMachine_HatMessage;

static function string GetString(
    optional int Switch,
    optional PlayerReplicationInfo RelatedPRI_1,
    optional PlayerReplicationInfo RelatedPRI_2,
    optional Object OptionalObject)
{
    if (Switch == 0 && FRand() < 0.05)
        return "You've become the masked man, join the dark side of the force!";
    return Super.GetString(Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
}

defaultproperties
{
     FailedGiveStr="You already had one mask!"
     Message="You were given a mask!"
     DrawColor=(B=255,G=255)
}
