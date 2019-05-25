/**
 * Dual-Magnum 44 with attached laser sights 
 *
 * @author PooSH, 2012
 */

class Weapon_DualMK23Laser extends Weapon_DualMK23Pistol
    Config(ApocMutators);

const LASER_None = 0;    
    
var         Weapon_LaserDot                Spot;                       // The first person laser site dot
var()       float                       SpotProjectorPullback;      // Amount to pull back the laser dot projector from the hit location
var         bool                        bLaserActive;               // The laser site is active
var         LaserBeamEffect             Beam;                       // Third person laser beam effect

var()       class<InventoryAttachment>  LaserAttachmentClass;      // First person laser attachment class
var         Actor                       LaserAttachment;           // First person laser attachment

var         byte                        LaserType;       //current laser type
var         class<LaserBeamEffect>      LaserBeamClass;  
var         class<Weapon_LaserDot>         LaserDotClass;

var         bool bCowboyMode;

                    

replication
{
    reliable if (bNetDirty && Role == ROLE_Authority)
        bCowboyMode;

    reliable if(Role < ROLE_Authority)
        ServerSetLaserType;
}

function SpawnBeam()
{
    if (Beam == None)
        Beam = Spawn(LaserBeamClass);
}

simulated function SpawnDot()
{
    if (Spot == None)
        Spot = Spawn(LaserDotClass, self);
    //set dot texture
    Spot.SetLaserColor(LaserType);        
}

simulated function PostBeginPlay()
{
    if (Role == ROLE_Authority) 
        SpawnBeam();
    super.PostBeginPlay();
}

simulated function Destroyed()
{
    if (Spot != None)
        Spot.Destroy();

    if (Beam != None)
        Beam.Destroy();

    if (LaserAttachment != None)
        LaserAttachment.Destroy();

    super.Destroyed();
}

// Use alt fire to switch laser type
simulated function AltFire(float F)
{
    if(ReadyToFire(0))
    {
        ToggleLaser();
    }
}

// Cowboys don't use moder stuff like laser sights
// If laser is turned on, cowboy mode will be prohibited until the next reload
//if player turned off laser before reloading, enable CobwoyMode again
function AddReloadedAmmo()
{
  bCowboyMode = ! bLaserActive;

  super.AddReloadedAmmo();
}

simulated function WeaponTick(float dt)
{
    local Vector StartTrace, EndTrace, X,Y,Z;
    local Vector HitLocation, HitNormal;
    local Actor Other;
    local vector MyEndBeamEffect;
    local coords C;

    super.WeaponTick(dt);

    if( Role == ROLE_Authority && Beam != none )
    {
        if( bIsReloading && WeaponAttachment(ThirdPersonActor) != none )
        {
            C = WeaponAttachment(ThirdPersonActor).GetBoneCoords('tip');
            X = C.XAxis;
            Y = C.YAxis;
            Z = C.ZAxis;
        }
        else
        {
            GetViewAxes(X,Y,Z);
        }

        // the to-hit trace always starts right in front of the eye
        StartTrace = Instigator.Location + Instigator.EyePosition() + X*Instigator.CollisionRadius;

        EndTrace = StartTrace + 65535 * X;

        Other = Trace(HitLocation, HitNormal, EndTrace, StartTrace, true);

        if (Other != None && Other != Instigator && Other.Base != Instigator )
        {
            MyEndBeamEffect = HitLocation;
        }
        else
        {
            MyEndBeamEffect = EndTrace;
        }

        Beam.EndBeamEffect = MyEndBeamEffect;
        Beam.EffectHitNormal = HitNormal;
    }
}

//bring Laser to current state, which is indicating by LaserType 
simulated function ApplyLaserState()
{
    if( !Instigator.IsLocallyControlled() ) return;
    if( Role < ROLE_Authority  ) {
        ServerSetLaserType(LaserType);
    }
    bLaserActive = LaserType != LASER_None;
    if ( bLaserActive ) bCowboyMode = false;

    if( Beam != none )
    {
        Weapon_LaserBeamEffect(Beam).SetLaserColor(LaserType);
        Beam.SetActive(LaserType != LASER_None);
    }

    if( bLaserActive ) {
        //spawn 1-st person laser attachment for weapon owner
        ConstantColor'ScrnTex.Laser.LaserColor'.Color = 
            class'ApocMutators.Weapon_M14EBRBattleRifle'.static.GetLaserColor(LaserType);
        
        if ( LaserAttachment == none ) {
            //MK23s Tip bone is rotated to the side, so change it
            SetBoneRotation('Tip_Right', rot(0, 16384, 0));
            
            LaserAttachment = Spawn(LaserAttachmentClass,self,,,);
            AttachToBone(LaserAttachment,'Tip_Right');
        }
        LaserAttachment.bHidden = false;
        SpawnDot();
    }
    else {
        if ( LaserAttachment != none ) 
            LaserAttachment.bHidden = true;
        if (Spot != None) 
            Spot.Destroy();
        
    }
}
// Toggle laser on or off
simulated function ToggleLaser()
{
    if( !Instigator.IsLocallyControlled() ) return;

    if (bLaserActive) LaserType = LASER_None;
    else LaserType = class'ApocMutators.Weapon_M14EBRBattleRifle'.default.LASER_Green;
    
    ApplyLaserState();
}

simulated function BringUp(optional Weapon PrevWeapon)
{
    if (Role == ROLE_Authority)
        SpawnBeam();
        
    ApplyLaserState();
    Super.BringUp(PrevWeapon);
}

simulated function bool PutDown()
{
    if (Beam != None)
    {
        Beam.Destroy();
    }

    TurnOffLaser();

    return super.PutDown();
}

simulated function DetachFromPawn(Pawn P)
{
    TurnOffLaser();

    Super.DetachFromPawn(P);

    if (Beam != None)
    {
        Beam.Destroy();
    }
}

simulated function TurnOffLaser()
{
    if( !Instigator.IsLocallyControlled() )
        return;

        if( Role < ROLE_Authority  ) {
            ServerSetLaserType(LASER_None);
        }

        bLaserActive = false;
        //don't change Laser type here, because we need to restore it state 
        //when next time weapon will be brought up
        if ( LaserAttachment != none )
            LaserAttachment.bHidden = true;

        if( Beam != none ) {
            Beam.SetActive(false);
        }

        if (Spot != None) {
            Spot.Destroy();
        }
}



// Set the new fire mode on the server
function ServerSetLaserType(byte NewLaserType)
{
    LaserType = NewLaserType;
    bLaserActive = NewLaserType != LASER_None;
    if ( bLaserActive ) bCowboyMode = false;

    SpawnBeam();
    Weapon_LaserBeamEffect(Beam).SetLaserColor(NewLaserType);
    Beam.SetActive(NewLaserType != LASER_None);

    if( NewLaserType != LASER_None )
    {
        bLaserActive = true;
        SpawnDot();
    }
    else
    {
        bLaserActive = false;
        if (Spot != None) {
            Spot.Destroy();
        }
    }
}


//copy-pasted from M14EBR
simulated function RenderOverlays( Canvas Canvas )
{
    local int m;
    local Vector StartTrace, EndTrace;
    local Vector HitLocation, HitNormal;
    local Actor Other;
    local vector X,Y,Z;
    local coords C;

    if (Instigator == None)
        return;

    if ( Instigator.Controller != None )
        Hand = Instigator.Controller.Handedness;

    if ((Hand < -1.0) || (Hand > 1.0))
        return;

    // draw muzzleflashes/smoke for all fire modes so idle state won't
    // cause emitters to just disappear
    for (m = 0; m < NUM_FIRE_MODES; m++)
    {
        if (FireMode[m] != None)
        {
            FireMode[m].DrawMuzzleFlash(Canvas);
        }
    }

    SetLocation( Instigator.Location + Instigator.CalcDrawOffset(self) );
    SetRotation( Instigator.GetViewRotation() + ZoomRotInterp);

    // Handle drawing the laser beam dot
    if (Spot != None)
    {
        StartTrace = Instigator.Location + Instigator.EyePosition();
        GetViewAxes(X, Y, Z);

        //move spot on weapon recoil too -- PooSH
        if( Instigator.IsLocallyControlled() && (bIsReloading || FireMode[0].bIsFiring) )
        {
            C = GetBoneCoords('Tip_Right');
            X = C.XAxis;
            Y = C.YAxis;
            Z = C.ZAxis;
        }

        EndTrace = StartTrace + 65535 * X;

        Other = Trace(HitLocation, HitNormal, EndTrace, StartTrace, true);

        if (Other != None && Other != Instigator && Other.Base != Instigator )
        {
            EndBeamEffect = HitLocation;
        }
        else
        {
            EndBeamEffect = EndTrace;
        }

        Spot.SetLocation(EndBeamEffect - X*SpotProjectorPullback);

        if(  Pawn(Other) != none )
        {
            Spot.SetRotation(Rotator(X));
            Spot.SetDrawScale(Spot.default.DrawScale * 0.5);
        }
        else if( HitNormal == vect(0,0,0) )
        {
            Spot.SetRotation(Rotator(-X));
            Spot.SetDrawScale(Spot.default.DrawScale);
        }
        else
        {
            Spot.SetRotation(Rotator(-HitNormal));
            Spot.SetDrawScale(Spot.default.DrawScale);
        }
    }

    //PreDrawFPWeapon();    // Laurent -- Hook to override things before render (like rotation if using a staticmesh)

    bDrawingFirstPerson = true;
    Canvas.DrawActor(self, false, false, DisplayFOV);
    bDrawingFirstPerson = false;
}

//copy-pasted from M14EBR
exec function SwitchModes()
{
    DoToggle();
}

//copy-pasted from M14EBR
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

function bool HandlePickupQuery( pickup Item )
{
    //skip ckeck for a single pistol
	return Super(KFWeapon).HandlePickupQuery(Item);
}

function DropFrom(vector StartLocation)
{
    //just drop this weapon, don't split it on single guns
    super(KFWeapon).DropFrom(StartLocation);
}
    
function GiveTo( pawn Other, optional Pickup Pickup )
{
    Super(KFWeapon).GiveTo(Other, Pickup);
}

defaultproperties
{
     LaserAttachmentClass=Class'ApocMutators.Weapon_LaserAttachmentFirstPerson'
     LaserBeamClass=Class'ApocMutators.Weapon_LaserBeamEffect'
     LaserDotClass=Class'ApocMutators.Weapon_LaserDot'
     bCowboyMode=True
     Weight=5.000000
     Description="Yeah! One in each hand! Now with laser attachment."
     DemoReplacement=None
     InventoryGroup=4
     PickupClass=Class'ApocMutators.Weapon_DualMK23LaserPickup'
     ItemName="Laser Dual MK23"
}
