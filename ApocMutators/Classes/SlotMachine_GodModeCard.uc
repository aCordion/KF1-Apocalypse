Class SlotMachine_GodModeCard extends SlotMachine_SlotCard;

var() config float GodModeTime;

static function float ExecuteCard(Pawn Target)
{
    Target.Spawn(Class'SlotMachine_GodModeClient', Target);
    PlayerController(Target.Controller).ReceiveLocalizedMessage(Class'SlotMachine_GodModeMessage');
    return Default.GodModeTime;
}

static function FillPlayInfo(PlayInfo PlayInfo)
{
    Super.FillPlayInfo(PlayInfo);
    PlayInfo.AddSetting(default.CardGroup, "GodModeTime", Default.Class.Name $ "-Time", 1, 0, "Text", "8;1.00:999.00");
}
static function string GetDescriptionText(string PropName)
{
    switch(PropName)
    {
        case "GodModeTime": return "How player remains god mode.";
    }
    return Super.GetDescriptionText(PropName);
}

defaultproperties
{
     GodModeTime=40.000000
     Desireability=0.400000
     CardMaterial=Texture'KillingFloor2HUD.Achievements.Achievement_55'
}
