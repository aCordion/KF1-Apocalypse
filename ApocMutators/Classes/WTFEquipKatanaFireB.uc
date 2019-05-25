class WTFEquipKatanaFireB extends KatanaFireB;

function float GetFireSpeed()
{
    local float FS;
    FS = Super(KFMeleeFire).GetFireSpeed();
    
    if (KFGameType(Level.Game) == None)
        return FS;
        
    if (KFGameType(Level.Game).bZEDTimeActive)
    {
        Log("WTFEquipKatanaFireB: In ZEDTime, increasing fire speed");
        return FS * 2.0;
    }
    
    return FS;
}

defaultproperties
{
}
