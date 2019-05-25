// A very simple AI!
Class Sentry_UA571FSentryAI extends AIController;

#exec obj load file="SentryTechTex1.utx"
#exec obj load file="SentryTechAnim1.ukx"
#exec obj load file="SentryTechStatics.usx"
#exec obj load file="SentryTechSounds.uax"



var Sentry_UA571FSentry Turret;
var transient float NextShotTime;

function Restart()
{
    Super.Restart();
    Turret = Sentry_UA571FSentry(Pawn);
    GoToState('Idle');
}

function bool SetEnemy( Pawn NewEnemy, optional bool bHateMonster, optional float MonsterHateChanceOverride )
{
    if (NewEnemy == None || NewEnemy.bDeleteMe || NewEnemy.Health <= 0 || Turret.SameSpeciesAs(NewEnemy) || !CanSpotEnemy(NewEnemy))
        Return False;
    Enemy = NewEnemy;
    Return True;
}
event SeeMonster(Pawn Seen)
{
    SeePlayer(Seen);
}
event HearNoise(float Loudness, Actor NoiseMaker)
{
    if (NoiseMaker != None && NoiseMaker.Instigator != None)
        SeePlayer(NoiseMaker.Instigator);
}

state Idle
{
    event SeePlayer(Pawn Seen)
    {
        if (SetEnemy(Seen))
            GoToState('AttackEnemy');
    }
    function BeginState()
    {
        Enemy = None;
        Pawn.AmbientSound = None;
        if (Turret.AnimRepNum != 0)
            Turret.PlayUnDeploy();
    }

Begin:
    Sleep(0.25);
    bIsPlayer = true;
}
State AttackEnemy
{
Ignores SeePlayer, SeeMonster, HearNoise;

    function BeginState()
    {
        if (Turret.AnimRepNum == 0)
        {
            SetTimer(0, False);
            Pawn.AmbientSound = Turret.AlarmNoiseSnd;
            Turret.PlayDeploy();
        }
        else BeginFiring();
    }
    final function BeginFiring()
    {
        NextShotTime = Level.TimeSeconds;
        if (Turret.AnimRepNum != 2)
            Turret.PlayFiringTurret();
        Timer();
    }
    function Timer()
    {
        local byte count;

        if (Enemy == None || Enemy.Health <= 0 || !CanSpotEnemy(Enemy))
        {
            GoToState('Searching');
            Return;
        }

        // Time it so at least 1 shot is fired for each 0.07 sec.
        while(NextShotTime <= Level.TimeSeconds)
        {
            Turret.FireAShot(Enemy.Location);
            if (++count == 5)
            {
                NextShotTime = Level.TimeSeconds + Turret.FireRateTime;
                break;
            }
            NextShotTime += Turret.FireRateTime;
        }
        SetTimer(NextShotTime-Level.TimeSeconds, false);
    }
    final function vector GetFireSpot()
    {
        local vector Spot;

        if (!FastTrace(Enemy.Location, Pawn.Location))
        {
            Spot = Enemy.Location + vect(0, 0, 0.95) * Enemy.CollisionHeight;
            if (FastTrace(Spot, Pawn.Location)) // Try head
                return Spot;
            Spot = Enemy.Location-vect(0, 0, 0.95) * Enemy.CollisionHeight;
            if (FastTrace(Spot, Pawn.Location)) // Try foot
                return Spot;
        }
        return Enemy.Location;
    }

Begin:
    Sleep(0.8);
    Pawn.AmbientSound = None;
    BeginFiring();
}

State Searching
{
    event SeePlayer(Pawn Seen)
    {
        if (SetEnemy(Seen))
            GoToState('AttackEnemy');
    }
    function BeginState()
    {
        Enemy = None;
        Pawn.AmbientSound = None;
    }
Begin:
    Sleep(0.2f);
    Turret.PlayIdleTurret();
    Sleep(8);
    GoToState('Idle');
}

function bool CanSpotEnemy(Pawn Other)
{
    if ((Normal(Other.Location-Pawn.Location) Dot vector(Pawn.Rotation)) < Pawn.PeripheralVision || !LineOfSightTo(Other))
        Return False;
    Return True;
}
function NotifyGotFlipped(bool bFlipNow)
{
    if (bFlipNow)
        GoToState('BecameFlipped');
}
State BecameFlipped
{
Ignores SeePlayer, SeeMonster, HearNoise;

    function NotifyGotFlipped(bool bFlipNow)
    {
        if (!bFlipNow && Turret.bHasGodMode)
        {
            Turret.Health = Turret.SentryHealth;
            GoToState('Searching');
        }
    }
    function BeginState()
    {
        local Controller C;

        Pawn.Health = 0;
        SetTimer(0.05, True);
        Pawn.AmbientSound = Turret.AlarmNoiseSnd;
        Timer();
        for (C=Level.ControllerList; C != None; C=C.NextController)
            C.NotifyKilled(None, Self, Pawn);
    }
    function EndState()
    {
    }
    function Timer()
    {
        if (Turret.AnimRepNum != 2)
            Turret.PlayFiringTurret();
        Turret.FireAShot(vector(Pawn.Rotation) * 500 + VRand() * 200 + Pawn.Location, vector(Pawn.Rotation) * 500 + VRand() * 200 + Pawn.Location);
    }
Begin:
    Sleep(4);
    Pawn.AmbientSound = None;
    SetTimer(0, False);
    Turret.PlayTurretDied();
    if (Turret.bNoAutoDestruct)
        Stop;
    Sleep(16);
    Pawn.Died(None, class'DamageType', Pawn.Location);
}

defaultproperties
{
}
