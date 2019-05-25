class SlotMachine_UseTriggerCatcher extends ExtendedZCollision;

var() int MaxYawDiff;
var transient float LastMessageTimer;

function UsedBy(Pawn user)
{
    local int YawDif;

    YawDif = (user.GetViewRotation().Yaw-rotator(Owner.Location-user.Location).Yaw) & 65535;
    if (YawDif > MaxYawDiff && YawDif < (65536-MaxYawDiff) && FastTrace(user.Location, Owner.Location))
        return;
    Owner.PlaySound(Sound'ucroar', SLOT_Talk, 1.4f, , 1000.f);
    Owner.PlaySound(Sound'ucbutton', SLOT_Pain, 2.f, , 700.f);
    Pawn(Owner).Died(user.Controller, Class'SlotMachine_DamTypeShutDown', user.Location);
}

function Touch(Actor Other)
{
    if (Pawn(Other) == None || Pawn(Other).Health <= 0)
        Return;

    // Warn the Chimera of players presense
    Pawn(Owner).Controller.SeePlayer(Pawn(Other));

    // Send a string message to the toucher.
    if (PlayerController(Pawn(Other).Controller) != none && LastMessageTimer < Level.TimeSeconds)
    {
        LastMessageTimer = Level.TimeSeconds + 0.6;
        PlayerController(Pawn(Other).Controller).ReceiveLocalizedMessage(class'SlotMachine_ChimeraMessage', 6);
    }
}

defaultproperties
{
     MaxYawDiff=10000
     bHardAttach=True
     CollisionRadius=5.000000
     CollisionHeight=50.000000
     bProjTarget=False
}
