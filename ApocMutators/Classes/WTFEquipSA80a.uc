//=============================================================================
// SA80 Ported by YoYoBatty
// Made 2010 May 31
//=============================================================================
class WTFEquipSA80a extends KFWeapon
        config(ApocMutators);

#exec obj load file=KillingFloorWeapons.utx
#exec obj load file=WTFTex.utx

var transient float LastFOV;
var() bool zoomed;
var color ChargeColor;
var float ZoomLevel;
var float Range;
var float LastRangingTime;
var float LastRangeFound;
var() Material ZoomMat;
var() Sound ZoomSound;

function bool RecommendRangedAttack()
{
    return true;
}

function bool RecommendLongRangedAttack()
{
    return true;
}

function float SuggestAttackStyle()
{
    return -1.0;
}

exec function SwitchModes()
{
  DoToggle();
}

simulated event RenderOverlays(Canvas Canvas)
{
    local PlayerController PC;

    PC = PlayerController(Instigator.Controller);

    if (PC == None)
        return;

    if (LastFOV != PC.DesiredFOV)
        PlaySound(ZoomSound, SLOT_Misc, 0.1, , , , false);

    LastFOV = PC.DesiredFOV;

    if (PC.DesiredFOV == PC.DefaultFOV || (Level.bClassicView && PC.DesiredFOV == 90))
    {
        Super.RenderOverlays(Canvas);
        zoomed=false;
    }
    else
    {
        SetZoomBlendColor(Canvas);

         //Black-out either side of the main zoom circle.
        Canvas.Style = ERenderStyle.STY_Normal;
        Canvas.SetPos(0, 0);
        Canvas.DrawTile(Texture'WTFTex.SA80.sa80cross',(Canvas.SizeX - Canvas.SizeY) / 2, Canvas.SizeY, 0.0, 0.0, 8, 8);
        Canvas.SetPos(Canvas.SizeX, 0);
        Canvas.DrawTile(Texture'WTFTex.SA80.sa80cross', -(Canvas.SizeX - Canvas.SizeY) / 2, Canvas.SizeY, 0.0, 0.0, 8, 8);

         //The view through the scope itself.
        Canvas.Style = 255;
        Canvas.SetPos((Canvas.SizeX - Canvas.SizeY) / 2, 0);
        Canvas.DrawTile(ZoomMat, Canvas.SizeY, Canvas.SizeY, 0.0, 0.0, 512, 512); // last 2 were 512

         //Draw some text.
        Canvas.Font = Canvas.SmallFont;
        Canvas.SetDrawColor(200, 150, 0);

        Canvas.SetPos(Canvas.SizeX * 0.1, Canvas.SizeY * 0.05);
        Canvas.DrawText("Adapted to KF from original Killing Floor Mut");

        Canvas.SetPos(Canvas.SizeX * 0.1, Canvas.SizeY * 0.07);
        Canvas.DrawText("by YoYoBatty of Forums.TripWireInteractive.com");

        zoomed = true;
    }
}


function float GetAIRating()
{
    local Bot B;


    B = Bot(Instigator.Controller);
    if ((B == None) || (B.Enemy == None))
        return AIRating;

    return(AIRating + 0.0003 * FMin(VSize(B.Enemy.Location - Instigator.Location), 1000));
}

function byte BestMode()
{
    return 0;
}


simulated function BringUp(optional Weapon PrevWeapon)
{
    if (PlayerController(Instigator.Controller) != None)
    {
        LastFOV = PlayerController(Instigator.Controller).DesiredFOV;
    }
    Super.BringUp(PrevWeapon);
}

simulated function bool PutDown()
{
    if (Instigator.Controller.IsA('PlayerController'))
        PlayerController(Instigator.Controller).EndZoom();
    if (Super.PutDown())
    {
        GotoState('');
        return true;
    }
    return false;
}

simulated function SetZoomBlendColor(Canvas c)
{
    local Byte    val;
    local Color   clr;
    local Color   fog;

    clr.R = 255;
    clr.G = 255;
    clr.B = 255;
    clr.A = 255;

    if (Instigator.Region.Zone.bDistanceFog)
    {
        fog = Instigator.Region.Zone.DistanceFogColor;
        val = 0;
        val = Max(val, fog.R);
        val = Max(val, fog.G);
        val = Max(val, fog.B);

        if (val > 128)
        {
            val -= 128;
            clr.R -= val;
            clr.G -= val;
            clr.B -= val;
        }
    }
    c.DrawColor = clr;
}

defaultproperties
{
     ZoomMat=Texture'WTFTex.SA80.sa80cross'
     MagCapacity=5
     ReloadRate=2.556667
     ReloadAnim="Reload"
     ReloadAnimRate=0.700000
     Weight=7.000000
     bHasAimingMode=True
     bModeZeroCanDryFire=True
     SleeveNum=0
     PlayerIronSightFOV=36.000000
     ZoomedDisplayFOV=36.000000
     FireModeClass(0)=Class'ApocMutators.WTFEquipSA80Fire'
     FireModeClass(1)=Class'ApocMutators.WTFEquipSA80Zoom'
     PutDownAnim="PutDown"
     SelectSound=Sound'KFPlayerSound.getweaponout'
     SelectForce="SwitchToAssaultRifle"
     AIRating=0.600000
     CurrentRating=0.600000
     bShowChargingBar=True
     Description="a deadly weapon."
     EffectOffset=(X=100.000000,Y=26.000000,Z=-11.000000)
     DisplayFOV=70.000000
     Priority=26
     CenteredOffsetY=0.000000
     CenteredRoll=0
     InventoryGroup=3
     GroupOffset=1
     PickupClass=Class'ApocMutators.WTFEquipSA80Pickup'
     PlayerViewOffset=(X=2.000000,Y=12.000000,Z=-12.000000)
     PlayerViewPivot=(Pitch=400)
     BobDamping=6.000000
     AttachmentClass=Class'ApocMutators.WTFEquipSA80Attachment'
     IconCoords=(X1=245,Y1=39,X2=329,Y2=79)
     ItemName="SA80 Sniper Rifle"
     Mesh=SkeletalMesh'WTFAnims.L85'
     DrawScale=0.900000
     TransientSoundVolume=1.250000
}
