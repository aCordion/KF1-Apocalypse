//=============================================================================
// Patriarch Healing Wave Edit Mutator
// Made by FluX
// http://www.fluxiserver.co.uk
//=============================================================================
class PHWMut extends Mutator
    config(ApocMutators);

struct SpecialSquad
{
    var config array<string> ZedClass;
    var config array<int> NumZeds;
};

var globalconfig array<SpecialSquad> FinalSquads;

function PostBeginPlay()
{
    local int i;
    local KFGameType KF;

    KF = KFGameType(Level.Game);

    if (KF == none) {
        Destroy();
        return;
    }

    // replace final squads
    for( i=0; i<3; i++ )
    {
        KF.MonsterCollection.default.FinalSquads[i].ZedClass = FinalSquads[i].ZedClass;
        KF.MonsterCollection.default.FinalSquads[i].NumZeds = FinalSquads[i].NumZeds;
    }

}

defaultproperties
{
     FinalSquads(0)=(ZedClass=("KFChar.ZombieClot"),NumZeds=(4))
     FinalSquads(1)=(ZedClass=("KFChar.ZombieClot","KFChar.ZombieCrawler"),NumZeds=(3,1))
     FinalSquads(2)=(ZedClass=("KFChar.ZombieClot","KFChar.ZombieStalker","KFChar.ZombieCrawler"),NumZeds=(3,1,1))
     GroupName="KF-PHWMut"
     FriendlyName="Patriarch Healing Wave Edit Mutator"
     Description="This mutator allows you to change what the healing waves to the Patriarch should spawn. This can be configured to the your liking.|Made by FluX & King Sumo|http://www.fluxiserver.co.uk"
}
