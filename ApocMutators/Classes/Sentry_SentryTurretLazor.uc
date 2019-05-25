class Sentry_SentryTurretLazor extends Emitter
    Transient;

var Sentry_SentryTurret TurretOwner;
var BeamEmitter BM;

simulated function BeginPlay()
{
    TurretOwner = Sentry_SentryTurret(Owner);
    BM = BeamEmitter(Emitters[0]);
    LastRenderTime = Level.TimeSeconds;
    Tick(0);
}
simulated function Tick(float Delta)
{
    local vector X, HL, HN;

    if (TurretOwner == None)
        Destroy();
    else if ((Level.TimeSeconds-FMax(LastRenderTime, TurretOwner.LastRenderTime)) < 6.f)
    {
        SetLocation(TurretOwner.Location + (TurretOwner.LaserOffset >> TurretOwner.Rotation));
        if (Abs(TurretOwner.CurrentRot.Yaw) < 30 && Abs(TurretOwner.CurrentRot.Pitch) < 30)
            SetRotation(TurretOwner.Rotation);
        else SetRotation(TurretOwner.GetActualDirection());

        X = vector(Rotation);
        if (TurretOwner.Trace(HL, HN, Location + X * 3000, Location, true) == None)
            HL = Location + X * 3000;

        X.X = VSize(HL-Location);
        BM.BeamEndPoints[0].Offset.X.Min = X.X;
        BM.BeamEndPoints[0].Offset.X.Max = X.X;
    }
}

defaultproperties
{
     Begin Object Class=BeamEmitter Name=BeamEmitter0
         BeamEndPoints(0)=(offset=(X=(Min=800.000000,Max=800.000000)))
         DetermineEndPointBy=PTEP_Offset
         BeamTextureVScale=0.500000
         RotatingSheets=1
         FadeOut=True
         FadeIn=True
         ColorMultiplierRange=(Y=(Min=0.500000,Max=0.500000),Z=(Min=0.500000,Max=0.500000))
         FadeOutStartTime=0.050000
         FadeInEndTime=0.050000
         CoordinateSystem=PTCS_Relative
         MaxParticles=3
         StartSizeRange=(X=(Min=2.000000,Max=2.000000))
         Texture=Texture'KFX.TransTrailT'
         LifetimeRange=(Min=0.100000,Max=0.100000)
     End Object
     Emitters(0)=BeamEmitter'ApocMutators.Sentry_SentryTurretLazor.BeamEmitter0'

     bNoDelete=False
}
