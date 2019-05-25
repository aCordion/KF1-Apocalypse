class WTFZombiesMetalClot extends ZEDS_ZombieClot;

/*
#exec obj load file=PlayerSounds.uax
#exec obj load file=KF_Freaks_Trip.ukx
#exec obj load file=KF_Specimens_Trip_T.utx
*/

#exec obj load file=WTFTex.utx

simulated function ZombieCrispUp()
{
    bAshen = true;
    bCrispified = true;

    SetBurningBehavior();

    if (Level.NetMode == NM_DedicatedServer || class'GameInfo'.static.UseLowGore())
    {
        Return;
    }

    // Metal Clot doesn't show skin changes from burns for right now
    /*
    Skins[0]=Texture 'PatchTex.Common.ZedBurnSkin';
    Skins[1]=Texture 'PatchTex.Common.ZedBurnSkin';
    Skins[2]=Texture 'PatchTex.Common.ZedBurnSkin';
    Skins[3]=Texture 'PatchTex.Common.ZedBurnSkin';
    */
}

defaultproperties
{
     HeadHealth=910.000000
     GroundSpeed=100.000000
     WaterSpeed=100.000000
     HealthMax=910.000000
     Health=910
     MenuName="Metal Clot"
     Skins(0)=Texture'WTFTex.WTFZombies.IronClot'
}
