Class Sentry_SentryTurretSpawnPoint extends Triggers;

var() bool bTriggerOnceOnly, bEvilTurret, bInvulnerableTurret, bNeverKillTurret;
var() int SentryHealth, HitDamage;
var() Class<Sentry_SentryTurret> TurretClass;

event Trigger(Actor Other, Pawn EventInstigator)
{
    local Sentry_SentryTurret T;

    T = Spawn(TurretClass);
    if (T != None)
    {
        T.bNoAutoDestruct = bNeverKillTurret;
        T.bEvilTurret = bEvilTurret;
        T.bHasGodMode = bInvulnerableTurret;
        T.HitDamage = HitDamage;
        T.SentryHealth = SentryHealth;
        T.Health = SentryHealth;
    }
    if (bTriggerOnceOnly)
        Destroy();
}

defaultproperties
{
     bEvilTurret=True
     bInvulnerableTurret=True
     SentryHealth=400
     HitDamage=5
     TurretClass=Class'ApocMutators.Sentry_SentryTurretBad'
     DrawType=DT_Mesh
     Mesh=SkeletalMesh'ApocMutators.TurretMesh'
     Skins(0)=Texture'ApocMutators.Skins.Turret_01'
     bUnlit=True
     CollisionRadius=23.000000
     CollisionHeight=28.000000
     bCollideActors=False
}
