class WTFZombiesHateriarchController extends BossZombieController;

var WTFZombiesHateriarch Hate;

function Restart()
{
    Super.Restart(); // sets KFM first
    Hate=WTFZombiesHateriarch(KFM); // set this up so we can call his special functionality
    if (Hate == None)
        Log("WTFZombiesHateriarchController: Restart(): god dammit...couldn't set Hate reference.");
}

//TODO: actually try to evaluate threats here based on what weapon the SeenPlayer has out
//        don't thoughtlessly change enemies each time we see a new player- pick out the most dangerous one
event SeePlayer(Pawn SeenPlayer)
{
    if (((ChooseAttackCounter < 2) || (ChooseAttackTime != Level.TimeSeconds)) && SetEnemy(SeenPlayer))
        WhatToDoNext(3);
    if (Enemy == SeenPlayer)
    {
        VisibleEnemy = Enemy;
        EnemyVisibilityTime = Level.TimeSeconds;
        bEnemyIsVisible = true;
    }
    FireWeaponAt(SeenPlayer); // immediate action, checks for a valid target(uses enemy if specified one isn't valid) and calls rangedattack()
}

//This is the function by which my custom WTFZombiesAIWarnSpot warns approaching ZEDS
//    about the mine hazard it is attached to
function bool FireWeaponAt(Actor A)
{
    if (!LineOfSightTo(A))
        return false;

     //from MonsterController FireWeaponAt(...)
    if (A == None)
        A = Enemy;
    if (A == None)
        return false;
        
     //These two will be specially set by the Hateriarch's Code
  //    this is so that he's not constantly facing towards the player regardless of which way he's walking
  //    because it looks dumb
     //if he is able to attack 'A' at this time
  // Target = A;
     //Focus = A;
     //Hate.RangedAttack() also handles melee attacks
    Hate.RangedAttack(A);
    
    return true;
}

/*
    RUNNING FOR MY FREAKIN' LIFE HERE!
    overridden to allow Startle, because we need to avoid mines, especially when running for our life
*/
State SyrRetreat
{
Ignores HearNoise, DamageAttitudeTo, Tick, EnemyChanged, SeePlayer;

    function Timer();
}

/*
    DEALING WITH DOORS
*/
//called by KFMonsterController.Tick()
function BreakUpDoor(KFDoorMover Other, bool bTryDistanceAttack) // I have came up to a door, break it!
{
    TargetDoor = Other;
    GotoState('DoorSmashing');
}
state DoorSmashing
{
ignores EnemyNotVisible, SeeMonster;

    function AttackDoor()
    {
        Target = TargetDoor;
        KFM.DoorAttack(Target);
    }

Begin:
    WaitForLanding();

KeepMoving:
    While(TargetDoor != none && !TargetDoor.bHidden && TargetDoor.bSealed && !TargetDoor.bZombiesIgnore)
    {
        AttackDoor();
        MoveToward(TargetDoor);
        Sleep(0.5);
    }
    WhatToDoNext(152);
}

/*
    MINE AVOIDANCE
*/
//overridden to always fear, regardless of skill level or random chance
function FearThisSpot(AvoidMarker aSpot)
{
    super(Controller).FearThisSpot(aSpot);
}

/*
    STARTLED
*/
//if something is telling us to stay away, stay the hell away
//no random chance or skill-based evaluation to ignore- always take notice
function Startle(Actor Feared)
{
    StartleActor = Feared;
    GotoState('Startled');
}
state Startled
{
    ignores EnemyNotVisible;

    function Startle(Actor Feared)
    {
        GoalString = "STARTLED!";
        StartleActor = Feared;
        BeginState();
    }

    function BeginState()
    {
        // FIXME - need FindPathAwayFrom()
        Pawn.Acceleration = Pawn.Location - StartleActor.Location;
        Pawn.Acceleration.Z = 0;
        Pawn.bIsWalking = false;
        Pawn.bWantsToCrouch = false;
        if (Pawn.Acceleration == vect(0, 0, 0))
            Pawn.Acceleration = VRand();
        Pawn.Acceleration = Pawn.AccelRate * Normal(Pawn.Acceleration);
    }
Begin:
    Sleep(0.5);
    WhatToDoNext(11);
    Goto('Begin');
}

/*
    INITIAL STATE
    entered after hateriarch does the grand entrance
*/
//overridden to actually get the freakin' hateriarch to the players quickly
//...unlike what the state I'm overridding accomplished(nothing)
state InitialHunting
{
     //based off of MonsterController
     //overridden to always have an enemy right off the bat
     //and(via the original PickDestination() in MonsterController) start moving towards them now
    function PickDestination()
    {
        local Controller C;
        
         //Log("WTFZombiesHateriarchController: InitialHunting: PickDestination()");
        
        for (C=Level.ControllerList; C != None; C=C.NextController)
        {
            if (PlayerController(C) != None)
            {
                if (C.Pawn != None && C.Pawn.IsA('KFHumanPawn') && C.Pawn.Health > 0)
                {
                     //Log("WTFZombiesHateriarchController: InitialHunting: PickDestination(): found an enemy");
                    Enemy=C.Pawn;
                    break;
                }
            }
        }

        Super.PickDestination();
    }
}

/*
    GENERIC MOVING TOWARDS ENEMY STATE
*/
state ZombieCharge
{
    function bool StrafeFromDamage(float Damage, Class<DamageType> DamageType, bool bFindDest)
    {
        return false;
    }

    // I suspect this function causes bloats to get confused
    function bool TryStrafe(vector sideDir)
    {
        return false;
    }

     //from UT's MonsterController
    event bool NotifyBump(actor Other)
    {
        if (Other == Enemy)
        {
             //NO!
            FireWeaponAt(Enemy);
            return false;
        }
        return Global.NotifyBump(Other);
    }

    function Timer()
    {
        Disable('NotifyBump');
        Target = Enemy;
        TimedFireWeaponAtEnemy();
    }

WaitForAnim:

    if (Monster(Pawn).bShotAnim)
    {
        Goto('Moving');
    }
    if (!FindBestPathToward(Enemy, false, true))
        GotoState('ZombieRestFormation');
Moving:
    MoveToward(Enemy);
    WhatToDoNext(17);
    if (bSoaking)
        SoakStop("STUCK IN CHARGING!");
}

defaultproperties
{
}
