Class SlotMachine_UHGrenade extends SlotMachine_HGrenade;

#exec AUDIO IMPORT file="Assets\SlotMachine\UnholyBlowup.WAV" NAME="UnholyBlowup" GROUP="FX"

simulated function Explode(vector HitLocation, vector HitNormal)
{
    bHasExploded = True;

    if (Level.NetMode != NM_DedicatedServer)
        PlaySound(Sound'UnholyBlowup', SLOT_None, 2.0);
    if (Level.NetMode != NM_Client)
        Spawn(Class'SlotMachine_BlackHoleProj');

    Destroy();
}

defaultproperties
{
     Skins(0)=Texture'ApocMutators.UnholyGrenade'
}
