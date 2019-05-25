class WTFZombiesBroodmotherController extends CrawlerController;

function ZombieMoan()
{
    Super(KFMonsterController).ZombieMoan();

    //kyan: removed
    //WTFZombiesBroodmother(KFM).SpawnBroodlings();
}

defaultproperties
{
     CombatStyle=-1.000000
}
