Class SlotMachine_HolyGrenadeCard extends SlotMachine_SlotCard;

#exec obj load file="HHMesh.usx" Package="ApocMutators"

var config float UnholyGrenadeRatio;

static function float ExecuteCard(Pawn Target)
{
    local Inventory I;

    if (Vehicle(Target) != None)
    {
        Target = Vehicle(Target).Driver;
        if (Target == None)
            return 0;
    }
    I = Target.FindInventoryType(Class'SlotMachine_HolyHandGrenade');
    if (I == None)
    {
        if (FRand() < (Default.UnholyGrenadeRatio / 100.f))
            I = Target.Spawn(Class'SlotMachine_UnHolyHandGrenade');
        else I = Target.Spawn(Class'SlotMachine_HolyHandGrenade');
        if (I != None)
        {
            I.GiveTo(Target);
            Weapon(I).ClientWeaponSet(true);
        }
    }
    PlayerController(Target.Controller).ReceiveLocalizedMessage(Class'SlotMachine_HolyGrenadeMessage');
    return 0;
}

static function FillPlayInfo(PlayInfo PlayInfo)
{
    Super.FillPlayInfo(PlayInfo);
    PlayInfo.AddSetting(default.CardGroup, "UnholyGrenadeRatio", Default.Class.Name $ "-UnholyRatio", 1, 0, "Text", "8;0.00:100.00");
}
static function string GetDescriptionText(string PropName)
{
    switch(PropName)
    {
        case "UnholyGrenadeRatio": return "How big chance is there to get Unholy Hand Grenade.";
    }
    return Super.GetDescriptionText(PropName);
}

defaultproperties
{
     UnholyGrenadeRatio=8.000000
     Desireability=0.080000
     CardMaterial=Texture'ApocMutators.I_HolyGrenade'
}
