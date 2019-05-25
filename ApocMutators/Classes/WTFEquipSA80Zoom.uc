class WTFEquipSA80Zoom extends KFFire;

var int CurrentZoom;
var float NextZoomTime;

//zoom in / out
event ModeDoFire()
{
    local PlayerController PC;
    
    if (!AllowFire())
        return;
    
    if (KFWeap.bAimingRifle)
    {
        PC = PlayerController(Instigator.Controller);
        
        NextZoomTime = Level.TimeSeconds + 0.3; // checked in AllowFire()
        
         //zoom IN
        CurrentZoom = CurrentZoom - 20;
        
         //OH GOD I CAN SEE FOREVER! ...zoom back out :P
        if (CurrentZoom <= 0)
        {
            CurrentZoom = 42.60; // default matches level of zoom that happens after switching to ironsights
        }

        Log("CurrentZoom is "  $  String(CurrentZoom));
        PlayerController(instigator.controller).SetFOV(CurrentZoom);
    }
}

function DrawMuzzleFlash(Canvas Canvas)
{
}

function FlashMuzzleFlash()
{
}

function StartMuzzleSmoke()
{
}

event ModeHoldFire()
{
}

simulated function bool AllowFire()
{
    return(Level.TimeSeconds > NextZoomTime);
}

function ServerPlayFiring()
{
}

function PlayPreFire()
{
}

function PlayFiring()
{
}

function PlayFireEnd()
{
}

function float MaxRange()
{
    return 0;
}

defaultproperties
{
     CurrentZoom=42
     bModeExclusive=False
}
