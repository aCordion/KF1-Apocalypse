class WTFEquipM79CFIncindiaryProjFireField extends WTFEquipFTProj;

simulated function ProcessTouch(Actor Other, vector HitLocation);

//running every .2 seconds(5 times per second)
simulated function Timer()
{
    local Actor A;

    if (Role == ROLE_Authority && bHasLanded)
    {
        ForEach TouchingActors(class 'Actor', A)
        {
            if (A.IsA('Pawn'))
                if (Pawn(A).Health > 0)
                    A.TakeDamage(Damage, Instigator, A.Location, MomentumTransfer * Normal(Velocity), MyDamageType);
        }
    }
}

simulated singular function HitWall(vector HitNormal, actor Wall)
{
     //Landed(HitNormal);
}

simulated function Landed(vector HitNormal)
{
    if (bHasLanded)
        return; // sometimes Landed(...) gets called twice...

    bHasLanded=true;

    bProjTarget=false;
    SetCollisionSize(200.0, 25.0); // radius, height

    SetTimer(0.2, true);

    DestroyTrail();
    SetPhysics(PHYS_None);

    if (KFHumanPawn(Instigator) != none)
    {
        if (EffectIsRelevant(Location, false))
        {
            FF = Spawn(Class'ApocMutators.WTFEquipM79CFIncindiaryProjFireFieldEmitter', self);
            FF.LifeSpan = LifeSpan;
        }
    }
}

simulated function Destroyed()
{
    DestroyTrail();
    if (FF != none)
        FF.Destroy();
}

/* Utility Functions */

simulated function DestroyTrail()
{
    if (Trail != none)
    {
        Trail.mRegen=False;
        Trail.SetPhysics(PHYS_None);
    }

    if (FlameTrail != none)
    {
        FlameTrail.Kill();
        FlameTrail.SetPhysics(PHYS_None);
    }
}

defaultproperties
{
     Speed=100.000000
     MaxSpeed=100.000000
     Damage=5.0//90.0//24.000000
     DamageRadius=1.000000
     LifeSpan=10.000000
}
