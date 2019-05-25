Class SlotMachine_ChimeraCard extends SlotMachine_SlotCard;

var config float ChimeraLifeSpan;

static function float ExecuteCard(Pawn Target)
{
    local Controller C;
    local KFGameType K;

    K = KFGameType(Target.Level.Game);
    if (K != None && !K.bWaveBossInProgress && !K.bWaveInProgress)
    {
        PlayerController(Target.Controller).ReceiveLocalizedMessage(Class'SlotMachine_NoMonstersMessage');
        return 0;
    }

    for (C=Target.Level.ControllerList; C != None; C=C.nextController)
        if (C.Class == Class'SlotMachine_ChimeraController' && C.Pawn != None)
        {
            PlayerController(Target.Controller).ReceiveLocalizedMessage(Class'SlotMachine_ChimeraSummonMessage', 1);
            return 0;
        }
    if (TryToSpawnChimera(Target.Level))
        Target.BroadcastLocalizedMessage(Class'SlotMachine_ChimeraSummonMessage', , Target.PlayerReplicationInfo);
    return 0;
}

// Spawn Chimera out of sight for players.
static final function bool TryToSpawnChimera(LevelInfo Map)
{
    local NavigationPoint N, BestN;
    local float Desire, Best;
    local Controller C;
    local byte i;
    local SlotMachine_UChimera UC;

    for (i=0; i < 6; ++i)
    {
        BestN = None;
        for (N=Map.NavigationPointList; N != None; N=N.nextNavigationPoint)
        {
            Desire = FRand() * 1000.f;
            for (C=Map.ControllerList; C != None; C=C.nextController)
                if (C.bIsPlayer && C.Pawn != None && C.Pawn.Health > 0 && VSizeSquared(C.Pawn.Location-N.Location) < 4000000.f)
                {
                    Desire += 250.f;
                    if (Map.FastTrace(C.Pawn.Location, N.Location))
                        Desire += 500.f;
                }
            if (BestN == None || Desire < Best)
            {
                BestN = N;
                Best = Desire;
            }
        }
        if (BestN == None)
            return false;
        UC = Map.Spawn(Class'SlotMachine_UChimera', , , BestN.Location, BestN.Rotation);
        if (UC == None)
            continue;
        SlotMachine_ChimeraController(UC.Controller).DisappearTimer = Map.TimeSeconds + Default.ChimeraLifeSpan;
        return true;
    }
    return false;
}

static function FillPlayInfo(PlayInfo PlayInfo)
{
    Super.FillPlayInfo(PlayInfo);
    PlayInfo.AddSetting(default.CardGroup, "ChimeraLifeSpan", Default.Class.Name $ "-ChimeraLifeSpan", 1, 0, "Text", "8;1.00:999.00");
}
static function string GetDescriptionText(string PropName)
{
    switch(PropName)
    {
        case "ChimeraLifeSpan": return "How many monsters spawn.";
    }
    return Super.GetDescriptionText(PropName);
}

defaultproperties
{
     ChimeraLifeSpan=120.000000
     Desireability=0.100000
     CardMaterial=Texture'UChimera_rc.Skins.I_Chimera'
}
