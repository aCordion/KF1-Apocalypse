Class ApocZedBalancePatchMut extends Mutator
    Config(ApocMutators);

var config float MinHealth;

function bool CheckReplacement(Actor Other, out byte bSuperRelevant)
{
    if (KFMonster(Other) != none)
    {
        if (KFMonster(Other).Health < MinHealth)
        {
            KFMonster(Other).Health = MinHealth;
            KFMonster(Other).HealthMax = KFMonster(Other).Health;
        }
    }

    return true;
}

defaultproperties
{
     GroupName="KF-ApocZedBalancePatchMut"
     FriendlyName="[APOC] ZED Balance Patch Mut"
     Description=""
}
