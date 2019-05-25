Class SlotMachine_ReaperAI extends AIController;

var array<Pawn> Victims;
var byte KillAttempts;

final function bool IsInAttackRange(Actor A)
{
    local vector V;

    V = (A.Location-Pawn.Location);
    if (Abs(V.Z) > (80 + A.CollisionHeight))
        return false;
    V.Z = 0;
    return(VSize(V) < (140 + A.CollisionRadius));    
}

Auto state EnteredGame
{
Ignores SeePlayer, HearNoise;

Begin:
    Sleep(1.f);
    GoToState('HuntVictim');
}
State HuntVictim
{
    final function PickDestination()
    {
        while(Victims.Length > 0 && (Victims[0] == None || Victims[0].Health <= 0 || KillAttempts > 10))
        {
            KillAttempts = 0;
            Victims.Remove(0, 1);
        }

        if (Victims.Length == 0)
        {
            Pawn.Destroy();
            Destroy();
            return;
        }
        if (ActorReachable(Victims[0]))
        {
            MoveTarget = Victims[0];
            return;
        }
        MoveTarget = FindPathToward(Victims[0]);
        if (MoveTarget == None)
            MoveTarget = Victims[0];
    }
    function BeginState()
    {
        SetTimer(0.1, true);
    }
    function Timer()
    {
        if (Victims[0] != None && Victims[0].Health > 0 && IsInAttackRange(Victims[0]) && FastTrace(Victims[0].Location, Pawn.Location))
            GoToState('KillVictim');
    }
Begin:
    Pawn.bCollideWorld = true;
    PickDestination();
    Pawn.bCollideWorld = false;
    if (MoveTarget == None)
    {
        Sleep(0.5f);
        GoTo'Begin';
    }
    MoveToward(MoveTarget);
    GoTo'Begin';
}
State KillVictim
{
Begin:
    ++KillAttempts;
    FocalPoint = Victims[0].Location;
    SlotMachine_Reaper(Pawn).KillTarget(Victims[0]);
    while(SlotMachine_Reaper(Pawn).bAttackingAnim)
        Sleep(0.2f);
    Pawn.Velocity = vect(0, 0, 0);
    Pawn.Acceleration = vect(0, 0, 0);
    if (Victims[0] == None || Victims[0].Health <= 0)
        Sleep(1.f);
    Focus = None;
    GoToState('HuntVictim');
}

defaultproperties
{
}
