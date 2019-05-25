Class SlotMachine_SantaHatCard extends SlotMachine_SlotCard;

#exec obj load file="Meshes.usx" Package="ApocMutators"

static function float ExecuteCard(Pawn Target)
{
    if (Vehicle(Target) != None)
    {
        Target = Vehicle(Target).Driver;
        if (Target == None)
            return 0;
    }
    PlayerController(Target.Controller).ReceiveLocalizedMessage(Class'SlotMachine_HatMessage', GiveHat(Target, 0));
    return 0;
}
static final function int GiveHat(Pawn Target, byte Index)
{
    local SlotMachine_PawnHatModel PH;

    foreach Target.DynamicActors(Class'SlotMachine_PawnHatModel', PH)
        if (PH.HatMatches(Target, Index))
            return 1;
    PH = Target.Spawn(Class'SlotMachine_PawnHatModel');
    PH.PawnOwner = Target;
    PH.SetModel(Index);
    return 0;
}

defaultproperties
{
     CardMaterial=Texture'ApocMutators.I_Santa'
}
