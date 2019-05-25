Class Sentry_SentryBotController extends AIController;

var Sentry_SentryBot Sentry_SentryBot;
var float MaxDistanceFromOwnerSq;
var bool bLostContactToPL;

function Restart()
{
    Enemy = None;
    Sentry_SentryBot = Sentry_SentryBot(Pawn);
    GoToState('WakeUp');
}

function SeeMonster(Pawn Seen)
{
    ChangeEnemy(Seen);
}

function HearNoise(float Loudness, Actor NoiseMaker)
{
    if (NoiseMaker != None && NoiseMaker.Instigator != None && FastTrace(NoiseMaker.Location, Pawn.Location))
        ChangeEnemy(NoiseMaker.Instigator);
}

function SeePlayer(Pawn Seen)
{
    ChangeEnemy(Seen);
}

function damageAttitudeTo(pawn Other, float Damage)
{
    ChangeEnemy(Other);
}

function bool MustReturnToOwner()
{
    if (Sentry_SentryBot == none || Sentry_SentryBot.OwnerPawn == none)
        return false; // no owner; roam free!

    return !LineOfSightTo(Sentry_SentryBot.OwnerPawn) || VSizeSquared(Sentry_SentryBot.Location - Sentry_SentryBot.OwnerPawn.Location) >= MaxDistanceFromOwnerSq;
}

function ChangeEnemy(Pawn Other)
{
    if (Other == None || Other.Health <= 0 || Other.Controller == None || Other == Enemy)
        return;
    if (Sentry_SentryBot.OwnerPawn == None && KFPawn(Other) != None)
    {
        Sentry_SentryBot.SetOwningPlayer(Other, None);
        return;
    }
    if (Monster(Other) == None)
        return;

    if (Enemy != None && Enemy.Health <= 0)
        Enemy = None;

    // Current enemy is visible, new one is not or current enemy is closer, then ignore new one.
    if (Enemy != None && ((LineOfSightTo(Enemy) && !LineOfSightTo(Other)) || VSizeSquared(Other.Location-Pawn.Location) > VSizeSquared(Enemy.Location-Pawn.Location)))
        return;

    Enemy = Other;
    EnemyChanged();
}

function EnemyChanged();

final function GoNextOrders()
{
    bIsPlayer = true; // Make sure it is set so zeds fight me.

    if (Sentry_SentryBot.OwnerPawn == None || Sentry_SentryBot.OwnerPawn.Health <= 0)
    {
        Sentry_SentryBot.OwnerPawn = None;
        Sentry_SentryBot.PlayerReplicationInfo = None;
    }

    
    if (Enemy != None && Enemy.Health >= 0 && !MustReturnToOwner())
    {
        GoToState('FightEnemy', 'Begin');
        return;
    }
    else Enemy = None;
    GoToState('FollowOwner', 'Begin');
}

function PawnDied(Pawn P)
{
    if (Pawn == P)
        Destroy();
}

State WakeUp
{
Ignores SeePlayer, HearNoise, SeeMonster;

Begin:
    Sentry_SentryBot.SetAnimationNum(1);
    WaitForLanding();
    Sentry_SentryBot.SetAnimationNum(0);
    Sleep(1.f);
    GoNextOrders();
}

State FightEnemy
{
    function EnemyChanged()
    {
        Sentry_SentryBot.Speech(2);
        if (Sentry_SentryBot.RepAnimationAction != 0)
            Sentry_SentryBot.SetAnimationNum(0);
        GoToState(, 'Begin');
    }

    function BeginState()
    {
        Sentry_SentryBot.Speech(2);
    }

    function EndState()
    {
        if (Sentry_SentryBot.RepAnimationAction != 0)
            Sentry_SentryBot.SetAnimationNum(0);
        Sentry_SentryBot.Speech(3);
    }

Begin:
    if (Enemy == None || Enemy.Health <= 0)
    {
BadEnemy:
        Enemy = None;
        GoNextOrders();
    }

    if (LineOfSightTo(Enemy))
        GoTo 'ShootEnemy';
        
    MoveTarget = FindPathToward(Enemy);
    if (MoveTarget == None || MustReturnToOwner())
        GoTo'BadEnemy';
    MoveToward(MoveTarget);
    GoTo'Begin';

ShootEnemy:
    if (MustReturnToOwner())
    {
        MoveTarget = FindPathToward(Sentry_SentryBot.OwnerPawn);
        if (MoveTarget == None)
            GoTo'BadEnemy';
        MoveToward(MoveTarget);
        GoTo'Begin';
    }
    Focus = Enemy;
    Pawn.Acceleration = vect(0, 0, 0);
    FinishRotation();
    Sentry_SentryBot.SetAnimationNum(2);
    while(Enemy != None && Enemy.Health > 0 && LineOfSightTo(Enemy) && !MustReturnToOwner())
    {
        Pawn.Acceleration = vect(0, 0, 0);
        if (Enemy.Controller != None)
            Enemy.Controller.damageAttitudeTo(Pawn, 5);
        Sleep(0.35f);
    }
    Sentry_SentryBot.SetAnimationNum(0);
    Sleep(0.45f);
    GoTo'Begin';
}

State FollowOwner
{
    function bool NotifyBump(Actor Other)
    {
        if (KFPawn(Other) != None) // Step aside from a player.
        {
            Destination = (Normal(Pawn.Location-Other.Location) + VRand() * 0.35) * (Other.CollisionRadius + 30.f + FRand() * 50.f) + Pawn.Location;
            GoToState(, 'StepAside');
        }
        return false;
    }
    final function CheckShopTeleport()
    {
        local ShopVolume S;

        foreach Pawn.TouchingActors(Class'ShopVolume', S)
        {
            if (!S.bCurrentlyOpen && S.TelList.Length > 0)
                S.TelList[Rand(S.TelList.Length)].Accept(Pawn, S);
            return;
        }
    }
Begin:
    CheckShopTeleport(); // Make sure not stuck inside trader.
    Disable('NotifyBump');
    if (!MustReturnToOwner())
    {
        if (bLostContactToPL)
        {
            Sentry_SentryBot.Speech(6);
            bLostContactToPL = false;
        }
Idle:
        Enable('NotifyBump');
        Focus = None;
        FocalPoint = VRand() * 20000.f + Pawn.Location;
        FocalPoint.Z = Pawn.Location.Z;
        Pawn.Acceleration = vect(0, 0, 0);
        Sleep(0.4f + FRand());
    }
    else if (ActorReachable(Sentry_SentryBot.OwnerPawn))
    {
        Enable('NotifyBump');
        MoveTo(Sentry_SentryBot.OwnerPawn.Location + VRand() * (Sentry_SentryBot.OwnerPawn.CollisionRadius + 80.f));
    }
    else
    {
        if (!bLostContactToPL)
        {
            Sentry_SentryBot.Speech(7);
            bLostContactToPL = true;
        }
        MoveTarget = FindPathToward(Sentry_SentryBot.OwnerPawn);
        if (MoveTarget != None)
            MoveToward(MoveTarget);
        else
        {
            Sentry_SentryBot.Speech(1);
            GoTo'Idle';
        }
    }
    GoNextOrders();
StepAside:
    MoveTo(Destination);
    GoNextOrders();
}

defaultproperties
{
     MaxDistanceFromOwnerSq=83333.000000
     bHunting=True
}
