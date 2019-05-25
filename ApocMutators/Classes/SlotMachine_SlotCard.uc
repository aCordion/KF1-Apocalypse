// Base class for all cards
Class SlotMachine_SlotCard extends Info
    Abstract
    Config(ApocMutators);

var() config float Desireability;
var() material CardMaterial;
var localized string CardGroup;

static function float ExecuteCard(Pawn Target)
{
    Target.ClientMessage("Card Get:" @ Default.Class);
    return 0;
}

static function DrawCard(Canvas C, float X, float Y, float XS, float YS, float Alpha)
{
    local Material M;
    local float S;

    M = Default.CardMaterial;
    if (M == None)
        return;
    if (Alpha == 0.5) // Middle, fullscreen.
    {
        C.SetPos(X, Y);
        C.DrawTile(M, XS, YS, 0, 0, M.MaterialUSize(), M.MaterialVSize());
    }
    else if (Alpha < 0.5) // Roll in.
    {
        C.SetPos(X, Y);
        S = M.MaterialVSize();
        Alpha *= 2.f;
        C.DrawTile(M, XS, YS * Alpha, 0, S-(Alpha * S), M.MaterialUSize(), Alpha * S);
    }
    else// Roll out.
    {
        Alpha = (Alpha-0.5f) * 2.f;
        C.SetPos(X, Y + Alpha * YS);
        S = M.MaterialVSize();
        C.DrawTile(M, XS, YS * (1.f-Alpha), 0, 0, M.MaterialUSize(), S-(Alpha * S));
    }
}

static function FillPlayInfo(PlayInfo PlayInfo)
{
    Super.FillPlayInfo(PlayInfo);
    PlayInfo.AddSetting(default.CardGroup, "Desireability", Default.Class.Name $ "-Desire", 1, 0, "Text", "8;0.01:100.00");
}
static function string GetDescriptionText(string PropName)
{
    switch(PropName)
    {
        case "Desireability":     return "How likely this card will be chosen.";
    }
    return "";
}

defaultproperties
{
     Desireability=1.000000
     CardGroup="Cards"
}
