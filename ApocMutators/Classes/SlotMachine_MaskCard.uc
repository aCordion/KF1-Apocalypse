Class SlotMachine_MaskCard extends SlotMachine_SantaHatCard;

static function float ExecuteCard(Pawn Target)
{
    if (Vehicle(Target) != None)
    {
        Target = Vehicle(Target).Driver;
        if (Target == None)
            return 0;
    }
    PlayerController(Target.Controller).ReceiveLocalizedMessage(Class'SlotMachine_MaskMessage', GiveHat(Target, Rand(4) + 1));
    return 0;
}

defaultproperties
{
     CardMaterial=Texture'ApocMutators.I_Pumpkin'
}
