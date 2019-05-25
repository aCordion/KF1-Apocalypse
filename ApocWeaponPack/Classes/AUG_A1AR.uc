class AUG_A1AR extends KFWeapon;

#exec OBJ LOAD FILE=AUG_A1_A.ukx

var color ChargeColor;

var float Range;
var float LastRangingTime;

var() Material ZoomMat;
var() Sound ZoomSound;
var bool bArrowRemoved;

var()       int         lenseMaterialID;

var()       float       scopePortalFOVHigh;
var()       float       scopePortalFOV;
var()       vector      XoffsetScoped;
var()       vector      XoffsetHighDetail;

var()       int         scopePitch;
var()       int         scopeYaw;
var()       int         scopePitchHigh;
var()       int         scopeYawHigh;

// 3d Scope vars
var   ScriptedTexture   ScopeScriptedTexture;
var   Shader            ScopeScriptedShader;
var   Material          ScriptedTextureFallback;

var     Combiner            ScriptedScopeCombiner;

var     texture             TexturedScopeTexture;
var     texture             ScopeTexutre;

var     bool                bInitializedScope;

//====================================================================
exec function pfov(int thisFOV)
{
    if( !class'ROEngine.ROLevelInfo'.static.RODebugMode() )
        return;

    scopePortalFOV = thisFOV;
}

exec function pPitch(int num)
{
    if( !class'ROEngine.ROLevelInfo'.static.RODebugMode() )
        return;

    scopePitch = num;
    scopePitchHigh = num;
}

exec function pYaw(int num)
{
    if( !class'ROEngine.ROLevelInfo'.static.RODebugMode() )
        return;

    scopeYaw = num;
    scopeYawHigh = num;
}

simulated exec function TexSize(int i, int j)
{
    if( !class'ROEngine.ROLevelInfo'.static.RODebugMode() )
        return;

    ScopeScriptedTexture.SetSize(i, j);
}

// Helper function for the scope system. The scope system checks here to see when it should draw the portal.
// if you want to limit any times the portal should/shouldn't be drawn, add them here.
// Ramm 10/27/03
simulated function bool ShouldDrawPortal()
{
//  local   name    thisAnim;
//  local   float   animframe;
//  local   float   animrate;
//
//  GetAnimParams(0, thisAnim,animframe,animrate);

//  if(bUsingSights && (IsInState('Idle') || IsInState('PostFiring')) && thisAnim != 'scope_shoot_last')
    if( bAimingRifle )
        return true;
    else
        return false;
}

simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    // Get new scope detail value from KFWeapon
    KFScopeDetail = class'KFMod.KFWeapon'.default.KFScopeDetail;

    UpdateScopeMode();
}

// Handles initializing and swithing between different scope modes
simulated function UpdateScopeMode()
{
    if (Level.NetMode != NM_DedicatedServer && Instigator != none && Instigator.IsLocallyControlled() &&
        Instigator.IsHumanControlled() )
    {
        if( KFScopeDetail == KF_ModelScope )
        {
            scopePortalFOV = default.scopePortalFOV;
            ZoomedDisplayFOV = default.ZoomedDisplayFOV;
            //bPlayerFOVZooms = false;
            if (bUsingSights)
            {
                PlayerViewOffset = XoffsetScoped;
            }

            if( ScopeScriptedTexture == none )
            {
                ScopeScriptedTexture = ScriptedTexture(Level.ObjectPool.AllocateObject(class'ScriptedTexture'));
            }

            ScopeScriptedTexture.FallBackMaterial = ScriptedTextureFallback;
            ScopeScriptedTexture.SetSize(1024,1024);
            ScopeScriptedTexture.Client = Self;

            if( ScriptedScopeCombiner == none )
            {
                // Construct the Combiner
                ScriptedScopeCombiner = Combiner(Level.ObjectPool.AllocateObject(class'Combiner'));
                ScriptedScopeCombiner.Material1 = ScopeTexutre;
                ScriptedScopeCombiner.FallbackMaterial = Shader'ScopeShaders.Zoomblur.LensShader';
                ScriptedScopeCombiner.CombineOperation = CO_Multiply;
                ScriptedScopeCombiner.AlphaOperation = AO_Use_Mask;
                ScriptedScopeCombiner.Material2 = ScopeScriptedTexture;
            }

            if( ScopeScriptedShader == none )
            {
                // Construct the scope shader
                ScopeScriptedShader = Shader(Level.ObjectPool.AllocateObject(class'Shader'));
                ScopeScriptedShader.Diffuse = ScriptedScopeCombiner;
                ScopeScriptedShader.SelfIllumination = ScriptedScopeCombiner;
                ScopeScriptedShader.FallbackMaterial = Shader'ScopeShaders.Zoomblur.LensShader';
            }

            bInitializedScope = true;
        }
        else if( KFScopeDetail == KF_ModelScopeHigh )
        {
            scopePortalFOV = scopePortalFOVHigh;
            ZoomedDisplayFOV = default.ZoomedDisplayFOVHigh;
            //bPlayerFOVZooms = false;
            if (bUsingSights)
            {
                PlayerViewOffset = XoffsetHighDetail;
            }

            if( ScopeScriptedTexture == none )
            {
                ScopeScriptedTexture = ScriptedTexture(Level.ObjectPool.AllocateObject(class'ScriptedTexture'));
            }
            ScopeScriptedTexture.FallBackMaterial = ScriptedTextureFallback;
            ScopeScriptedTexture.SetSize(1024,1024);
            ScopeScriptedTexture.Client = Self;

            if( ScriptedScopeCombiner == none )
            {
                // Construct the Combiner
                ScriptedScopeCombiner = Combiner(Level.ObjectPool.AllocateObject(class'Combiner'));
                ScriptedScopeCombiner.Material1 = ScopeTexutre;
                ScriptedScopeCombiner.FallbackMaterial = Shader'ScopeShaders.Zoomblur.LensShader';
                ScriptedScopeCombiner.CombineOperation = CO_Multiply;
                ScriptedScopeCombiner.AlphaOperation = AO_Use_Mask;
                ScriptedScopeCombiner.Material2 = ScopeScriptedTexture;
            }

            if( ScopeScriptedShader == none )
            {
                // Construct the scope shader
                ScopeScriptedShader = Shader(Level.ObjectPool.AllocateObject(class'Shader'));
                ScopeScriptedShader.Diffuse = ScriptedScopeCombiner;
                ScopeScriptedShader.SelfIllumination = ScriptedScopeCombiner;
                ScopeScriptedShader.FallbackMaterial = Shader'ScopeShaders.Zoomblur.LensShader';
            }

            bInitializedScope = true;
        }
        else if (KFScopeDetail == KF_TextureScope)
        {
            ZoomedDisplayFOV = default.ZoomedDisplayFOV;
            PlayerViewOffset.X = default.PlayerViewOffset.X;
            //bPlayerFOVZooms = true;

            bInitializedScope = true;
        }
    }
}

simulated event RenderTexture(ScriptedTexture Tex)
{
    local rotator RollMod;

    RollMod = Instigator.GetViewRotation();
    //RollMod.Roll -= 16384;

//  Rpawn = ROPawn(Instigator);
//  // Subtract roll from view while leaning - Ramm
//  if (Rpawn != none && rpawn.LeanAmount != 0)
//  {
//      RollMod.Roll += rpawn.LeanAmount;
//  }

    if(Owner != none && Instigator != none && Tex != none && Tex.Client != none)
        Tex.DrawPortal(0,0,Tex.USize,Tex.VSize,Owner,(Instigator.Location + Instigator.EyePosition()), RollMod,  scopePortalFOV );
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

    if( Instigator.Region.Zone.bDistanceFog )
    {
        fog = Instigator.Region.Zone.DistanceFogColor;
        val = 0;
        val = Max( val, fog.R);
        val = Max( val, fog.G);
        val = Max( val, fog.B);
        if( val > 128 )
        {
            val -= 128;
            clr.R -= val;
            clr.G -= val;
            clr.B -= val;
        }
    }
    c.DrawColor = clr;
}


/**
 * Handles all the functionality for zooming in including
 * setting the parameters for the weapon, pawn, and playercontroller
 *
 * @param bAnimateTransition whether or not to animate this zoom transition
 */
simulated function ZoomIn(bool bAnimateTransition)
{
    super(BaseKFWeapon).ZoomIn(bAnimateTransition);

    bAimingRifle = True;

    if( KFHumanPawn(Instigator)!=None )
        KFHumanPawn(Instigator).SetAiming(True);

    if( Level.NetMode != NM_DedicatedServer && KFPlayerController(Instigator.Controller) != none )
    {
        if( AimInSound != none )
        {
            PlayOwnedSound(AimInSound, SLOT_Interact,,,,, false);
        }
    }
}

/**
 * Handles all the functionality for zooming out including
 * setting the parameters for the weapon, pawn, and playercontroller
 *
 * @param bAnimateTransition whether or not to animate this zoom transition
 */
simulated function ZoomOut(bool bAnimateTransition)
{
    super.ZoomOut(bAnimateTransition);

    bAimingRifle = False;

    if( KFHumanPawn(Instigator)!=None )
        KFHumanPawn(Instigator).SetAiming(False);

    if( Level.NetMode != NM_DedicatedServer && KFPlayerController(Instigator.Controller) != none )
    {
        if( AimOutSound != none )
        {
            PlayOwnedSound(AimOutSound, SLOT_Interact,,,,, false);
        }
        KFPlayerController(Instigator.Controller).TransitionFOV(KFPlayerController(Instigator.Controller).DefaultFOV,0.0);
    }
}

simulated function WeaponTick(float dt)
{
    super.WeaponTick(dt);

    if( bAimingRifle && ForceZoomOutTime > 0 && Level.TimeSeconds - ForceZoomOutTime > 0 )
    {
        ForceZoomOutTime = 0;

        ZoomOut(false);

        if( Role < ROLE_Authority)
            ServerZoomOut(false);
    }
}


/**
 * Called by the native code when the interpolation of the first person weapon to the zoomed position finishes
 */
simulated event OnZoomInFinished()
{
    local name anim;
    local float frame, rate;

    GetAnimParams(0, anim, frame, rate);

    if (ClientState == WS_ReadyToFire)
    {
        // Play the iron idle anim when we're finished zooming in
        if (anim == IdleAnim)
        {
           PlayIdle();
        }
    }

    if( Level.NetMode != NM_DedicatedServer && KFPlayerController(Instigator.Controller) != none &&
        KFScopeDetail == KF_TextureScope )
    {
        KFPlayerController(Instigator.Controller).TransitionFOV(PlayerIronSightFOV,0.0);
    }
}

simulated function bool CanZoomNow()
{
    Return (!FireMode[0].bIsFiring && Instigator!=None && Instigator.Physics!=PHYS_Falling);
}

simulated event RenderOverlays(Canvas Canvas)
{
    local int m;
    local PlayerController PC;

    if (Instigator == None)
        return;

    // Lets avoid having to do multiple casts every tick - Ramm
    PC = PlayerController(Instigator.Controller);

    if(PC == None)
        return;

    if(!bInitializedScope && PC != none )
    {
          UpdateScopeMode();
    }

    // draw muzzleflashes/smoke for all fire modes so idle state won't
    // cause emitters to just disappear
    Canvas.DrawActor(None, false, true); // amb: Clear the z-buffer here

    for (m = 0; m < NUM_FIRE_MODES; m++)
    {
        if (FireMode[m] != None)
        {
            FireMode[m].DrawMuzzleFlash(Canvas);
        }
    }


    SetLocation( Instigator.Location + Instigator.CalcDrawOffset(self) );
    SetRotation( Instigator.GetViewRotation() + ZoomRotInterp);

    PreDrawFPWeapon();  // Laurent -- Hook to override things before render (like rotation if using a staticmesh)

    if(bAimingRifle && PC != none && (KFScopeDetail == KF_ModelScope || KFScopeDetail == KF_ModelScopeHigh))
    {
        if (ShouldDrawPortal())
        {
            if ( ScopeScriptedTexture != none )
            {
                Skins[LenseMaterialID] = ScopeScriptedShader;
                ScopeScriptedTexture.Client = Self;   // Need this because this can get corrupted - Ramm
                ScopeScriptedTexture.Revision = (ScopeScriptedTexture.Revision +1);
            }
        }

        bDrawingFirstPerson = true;
        Canvas.DrawBoundActor(self, false, false,DisplayFOV,PC.Rotation,rot(0,0,0),Instigator.CalcZoomedDrawOffset(self));
        bDrawingFirstPerson = false;
    }
    // Added "bInIronViewCheck here. Hopefully it prevents us getting the scope overlay when not zoomed.
    // Its a bit of a band-aid solution, but it will work til we get to the root of the problem - Ramm 08/12/04
    else if( KFScopeDetail == KF_TextureScope && PC.DesiredFOV == PlayerIronSightFOV && bAimingRifle)
    {
        Skins[LenseMaterialID] = ScriptedTextureFallback;

        SetZoomBlendColor(Canvas);

        //Black-out either side of the main zoom circle.
        Canvas.Style = ERenderStyle.STY_Normal;
        Canvas.SetPos(0, 0);
        Canvas.DrawTile(ZoomMat, (Canvas.SizeX - Canvas.SizeY) / 2, Canvas.SizeY, 0.0, 0.0, 8, 8);
        Canvas.SetPos(Canvas.SizeX, 0);
        Canvas.DrawTile(ZoomMat, -(Canvas.SizeX - Canvas.SizeY) / 2, Canvas.SizeY, 0.0, 0.0, 8, 8);

        //The view through the scope itself.
        Canvas.Style = 255;
        Canvas.SetPos((Canvas.SizeX - Canvas.SizeY) / 2,0);
        Canvas.DrawTile(ZoomMat, Canvas.SizeY, Canvas.SizeY, 0.0, 0.0, 1024, 1024);

        //Draw some useful text.
        Canvas.Font = Canvas.MedFont;
        Canvas.SetDrawColor(200,150,0);

        Canvas.SetPos(Canvas.SizeX * 0.16, Canvas.SizeY * 0.43);
        Canvas.DrawText(" "); //Canvas.DrawText("Zoom: 2.50");

        Canvas.SetPos(Canvas.SizeX * 0.16, Canvas.SizeY * 0.47);
    }
    else
    {
        Skins[LenseMaterialID] = ScriptedTextureFallback;
        bDrawingFirstPerson = true;
        Canvas.DrawActor(self, false, false, DisplayFOV);
        bDrawingFirstPerson = false;
    }
}

//=============================================================================
// Scopes
//=============================================================================

//------------------------------------------------------------------------------
// SetScopeDetail(RO) - Allow the players to change scope detail while ingame.
//  Changes are saved to the ini file.
//------------------------------------------------------------------------------
//simulated exec function SetScopeDetail()
//{
//  if( !bHasScope )
//      return;
//
//  if (KFScopeDetail == KF_ModelScope)
//      KFScopeDetail = KF_TextureScope;
//  else if ( KFScopeDetail == KF_TextureScope)
//      KFScopeDetail = KF_ModelScopeHigh;
//  else if ( KFScopeDetail == KF_ModelScopeHigh)
//      KFScopeDetail = KF_ModelScope;
//
//  AdjustIngameScope();
//  class'KFMod.KFWeapon'.default.KFScopeDetail = KFScopeDetail;
//  class'KFMod.KFWeapon'.static.StaticSaveConfig();        // saves the new scope detail value to the ini
//}

//------------------------------------------------------------------------------
// AdjustIngameScope(RO) - Takes the changes to the ScopeDetail variable and
//  sets the scope to the new detail mode. Called when the player switches the
//  scope setting ingame, or when the scope setting is changed from the menu
//------------------------------------------------------------------------------
simulated function AdjustIngameScope()
{
    local PlayerController PC;

    // Lets avoid having to do multiple casts every tick - Ramm
    PC = PlayerController(Instigator.Controller);

    if( !bHasScope )
        return;

    switch (KFScopeDetail)
    {
        case KF_ModelScope:
            if( bAimingRifle )
                DisplayFOV = default.ZoomedDisplayFOV;
            if ( PC.DesiredFOV == PlayerIronSightFOV && bAimingRifle )
            {
                if( Level.NetMode != NM_DedicatedServer && KFPlayerController(Instigator.Controller) != none )
                {
                    KFPlayerController(Instigator.Controller).TransitionFOV(KFPlayerController(Instigator.Controller).DefaultFOV,0.0);
}
            }
            break;

        case KF_TextureScope:
            if( bAimingRifle )
                DisplayFOV = default.ZoomedDisplayFOV;
            if ( bAimingRifle && PC.DesiredFOV != PlayerIronSightFOV )
            {
                if( Level.NetMode != NM_DedicatedServer && KFPlayerController(Instigator.Controller) != none )
                {
                    KFPlayerController(Instigator.Controller).TransitionFOV(PlayerIronSightFOV,0.0);
                }
            }
            break;

        case KF_ModelScopeHigh:
            if( bAimingRifle )
            {
                if( ZoomedDisplayFOVHigh > 0 )
                    DisplayFOV = default.ZoomedDisplayFOVHigh;
                else
                    DisplayFOV = default.ZoomedDisplayFOV;
            }
            if ( bAimingRifle && PC.DesiredFOV == PlayerIronSightFOV )
            {
                if( Level.NetMode != NM_DedicatedServer && KFPlayerController(Instigator.Controller) != none )
                {
                    KFPlayerController(Instigator.Controller).TransitionFOV(KFPlayerController(Instigator.Controller).DefaultFOV,0.0);
                }
            }
            break;
    }

    // Make any chagned to the scope setup
    UpdateScopeMode();
}

simulated event Destroyed()
{
    if (ScopeScriptedTexture != None)
    {
        ScopeScriptedTexture.Client = None;
        Level.ObjectPool.FreeObject(ScopeScriptedTexture);
        ScopeScriptedTexture=None;
    }

    if (ScriptedScopeCombiner != None)
    {
        ScriptedScopeCombiner.Material2 = none;
        Level.ObjectPool.FreeObject(ScriptedScopeCombiner);
        ScriptedScopeCombiner = none;
    }

    if (ScopeScriptedShader != None)
    {
        ScopeScriptedShader.Diffuse = none;
        ScopeScriptedShader.SelfIllumination = none;
        Level.ObjectPool.FreeObject(ScopeScriptedShader);
        ScopeScriptedShader = none;
    }

    Super.Destroyed();
}

simulated function PreTravelCleanUp()
{
    if (ScopeScriptedTexture != None)
    {
        ScopeScriptedTexture.Client = None;
        Level.ObjectPool.FreeObject(ScopeScriptedTexture);
        ScopeScriptedTexture=None;
    }

    if (ScriptedScopeCombiner != None)
    {
        ScriptedScopeCombiner.Material2 = none;
        Level.ObjectPool.FreeObject(ScriptedScopeCombiner);
        ScriptedScopeCombiner = none;
    }

    if (ScopeScriptedShader != None)
    {
        ScopeScriptedShader.Diffuse = none;
        ScopeScriptedShader.SelfIllumination = none;
        Level.ObjectPool.FreeObject(ScopeScriptedShader);
        ScopeScriptedShader = none;
    }
}

simulated function AltFire(float F)
{
    if(ReadyToFire(0))
    {
        DoToggle();
    }
}

simulated function DoToggle ()
{
    local PlayerController Player;

    Player = Level.GetLocalPlayerController();
    if ( Player!=None )
    {
        //PlayOwnedSound(sound'Inf_Weapons_Foley.stg44_firemodeswitch01',SLOT_None,2.0,,,,false);
        FireMode[0].bWaitForRelease = !FireMode[0].bWaitForRelease;
        if ( FireMode[0].bWaitForRelease )
            Player.ReceiveLocalizedMessage(class'KFmod.BullpupSwitchMessage',0);
        else Player.ReceiveLocalizedMessage(class'KFmod.BullpupSwitchMessage',1);
    }
    Super.DoToggle();

    ServerChangeFireMode(FireMode[0].bWaitForRelease);
}

function ServerChangeFireMode(bool bNewWaitForRelease)
{
    FireMode[0].bWaitForRelease = bNewWaitForRelease;
}

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

function float GetAIRating()
{
    local Bot B;

    B = Bot(Instigator.Controller);
    if ( (B == None) || (B.Enemy == None) )
        return AIRating;

    return AIRating;
}

function byte BestMode()
{
    return 0;
}
//======================================================================
defaultproperties
{
     ZoomMat=FinalBlend'AUG_A1_A.AUG_A1_T.AUG-A1_scope_FB'
     lenseMaterialID=4
     scopePortalFOVHigh=17.000000
     scopePortalFOV=17.000000
     ScriptedTextureFallback=Texture'AUG_A1_A.AUG_A1_T.alpha_lens_64x64'
     ZoomedDisplayFOVHigh=70.000000
     bHasScope=True
     MagCapacity=40
     ReloadRate=3.500000
     ReloadAnim="Reload"
     ReloadAnimRate=1.000000
     WeaponReloadAnim="Reload_BullPup"
     HudImage=Texture'AUG_A1_A.AUG_A1_T.AUG_A1_Unselected'
     SelectedHudImage=Texture'AUG_A1_A.AUG_A1_T.AUG_A1_Selected'
     Weight=6.000000
     bHasAimingMode=True
     IdleAimAnim="Idle_Iron"
     StandardDisplayFOV=65.000000
     bModeZeroCanDryFire=True
     SleeveNum=0
     TraderInfoTexture=Texture'AUG_A1_A.AUG_A1_T.trader_AUG_A1'
     PlayerIronSightFOV=32.000000
     ZoomedDisplayFOV=70.000000
     FireModeClass(0)=Class'AUG_A1ARFire'
     FireModeClass(1)=Class'KFMod.NoFire'
     PutDownAnim="PutDown"
     SelectSound=Sound'AUG_A1_A.AUG_A1_SND.aug_draw'
     SelectForce="SwitchToAssaultRifle"
     AIRating=0.650000
     CurrentRating=0.650000
     Description="Steyr AUG (Armee Universal Gewehr - армейская универсальная винтовка) - комплекс стрелкового оружия, выпущенный в 1977 году австрийской компанией Steyr-Daimler-Puch (ныне Штайр Манли́хер AG & Co KG ). Принят на вооружение такими странами, как Австрия, Новая Зеландия, Люксембург и Ирландия. В Австралии винтовка выпускается по лицензии под маркой F88. Имеет сменные стволы разной длины: основной 508 мм, а также укороченные стволы 350 мм и 407 мм и тяжелый ствол 621 мм."
     DisplayFOV=65.000000
     Priority=170
     CustomCrosshair=11
     CustomCrossHairTextureName="Crosshairs.HUD.Crosshair_Cross5"
     InventoryGroup=4
     GroupOffset=3
     PickupClass=Class'AUG_A1ARPickup'
     PlayerViewOffset=(X=15.000000,Y=12.000000,Z=-2.000000)
     BobDamping=5.000000
     AttachmentClass=Class'AUG_A1ARAttachment'
     IconCoords=(X1=253,Y1=146,X2=333,Y2=181)
     ItemName="Steyr AUG A1"
     Mesh=SkeletalMesh'AUG_A1_A.AUG_A1_mesh'
     Skins(0)=Texture'KF_Weapons3_Trip_T.hands.Priest_Hands_1st_P'
     Skins(1)=Texture'AUG_A1_A.AUG_A1_T.body'
     Skins(2)=Texture'AUG_A1_A.AUG_A1_T.mag'
     Skins(3)=Texture'AUG_A1_A.AUG_A1_T.Rec'
     Skins(4)=Texture'AUG_A1_A.AUG_A1_T.alpha_lens_64x64'
     ScopeTexutre=Texture'AUG_A1_A.AUG_A1_T.AUG-A1_scope'
}
