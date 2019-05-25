class WTFZombiesGoreallyFast extends ZEDS_ZombieGoreFast;

#exec obj load file=WTFTex.utx

//charge from farther away
function RangedAttack(Actor A)
{
    Super.RangedAttack(A);
    if (!bShotAnim && !bDecapitated && VSize(A.Location-Location) <= 1400)
        GoToState('RunningState');
}

defaultproperties
{
     GroundSpeed=260.000000
     WaterSpeed=200.000000
     MenuName="Goreallyfast"
     Skins(0)=Texture'WTFTex.WTFZombies.Goreallyfast'
}
