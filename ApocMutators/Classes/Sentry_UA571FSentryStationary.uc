// Written by Marco
Class Sentry_UA571FSentryStationary extends Sentry_UA571FSentry
    CacheExempt;

    #exec obj load file="SentryTechTex1.utx"
#exec obj load file="SentryTechAnim1.ukx"
#exec obj load file="SentryTechStatics.usx"
#exec obj load file="SentryTechSounds.uax"
    
    
    
var bool bInitialLanded;

replication
{
    // Variables the server should send to the client.
    reliable if (bNetInitial && Role == ROLE_Authority)
        bInitialLanded;
}

simulated final function bool MoveDown(float Distance)
{
    local vector Ex, HL, HN, End;

    Ex.X = CollisionRadius;
    Ex.Y = CollisionRadius;
    Ex.Z = CollisionHeight;
    End = Location;
    End.Z += Distance;

    if (Trace(HL, HN, End, Location, false, Ex) != None)
    {
        MoveSmooth(HL-Location);
        return false;
    }
    else return MoveSmooth(End-Location);
}
simulated final function SetFloorOrientation()
{
    local vector X, Y, Z;
    local rotator R;
    local vector Ex, HL, HN;

    Ex.X = CollisionRadius;
    Ex.Y = CollisionRadius;
    Ex.Z = CollisionHeight;
    if (Trace(HL, HN, Location-vect(0, 0, 10), Location, true, Ex) == None)
        HN = vect(0, 0, 1);

    R.Yaw = Rotation.Yaw;
    if (HN.Z > 0.997f || HN.Z <= 0.2f)
    {
        SetRotation(R);
        return;
    }

    // Fast dummy method for making it adjust to ground direction.
    GetAxes(R, X, Y, Z);
    X = Normal(X-HN * (X Dot HN));
    Y = Normal(Y-HN * (Y Dot HN));
    Z = (X Cross Y);
    SetRotation(OrthoRotation(X, Y, Z));
}
simulated function Tick(float Delta)
{
    if (!bInitialLanded)
    {
        if (!MoveDown(-700.f * Delta))
        {
            SetFloorOrientation();
            bInitialLanded = true;
        }
    }
    Super.Tick(Delta);
}

defaultproperties
{
     Physics=PHYS_None
     NetUpdateFrequency=18.000000
     bCollideWorld=True
     KParams=None

}
