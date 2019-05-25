class WTFZombiesLeaper extends ZEDS_ZombieCrawler;

//#exec obj load file=PlayerSounds.uax

function bool DoPounce()
{
    if (bIsCrouched || bWantsToCrouch || (Physics != PHYS_Walking))
        return false;

    Velocity = Normal(Controller.Target.Location-Location) * PounceSpeed;
    Velocity.Z = JumpZ;
    SetPhysics(PHYS_Falling);
    ZombieSpringAnim();
    bPouncing=true;
    return true;
}

defaultproperties
{
     PounceSpeed=660.000000
     GroundSpeed=180.000000
     WaterSpeed=170.000000
     MenuName="Leaper"
     ControllerClass=Class'ApocMutators.WTFZombiesLeaperController'
}
