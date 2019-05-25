// subclassing ROBallisticProjectile so we can do the ambient volume scaling
class RPGProj extends ROBallisticProjectile;

#exec OBJ LOAD FILE=ProjectileSounds.uax

// camera shakes //
var() vector ShakeRotMag;           // how far to rot view
var() vector ShakeRotRate;          // how fast to rot view
var() float  ShakeRotTime;          // how much time to rot the instigator's view
var() vector ShakeOffsetMag;        // max view offset vertically
var() vector ShakeOffsetRate;       // how fast to offset view vertically
var() float  ShakeOffsetTime;       // how much time to offset view

var() vector RotMag;            // how far to rot view
var() vector RotRate;           // how fast to rot view
var() float  RotTime;           // how much time to rot the instigator's view
var() vector OffsetMag;         // max view offset vertically
var() vector OffsetRate;        // how fast to offset view vertically
var() float  OffsetTime;        // how much time to offset view

var RPGTrail SmokeTrail;
var vector Dir;
var bool bRing,bHitWater,bWaterStart;

var()   sound   ExplosionSound; // The sound of the rocket exploding

var     bool    bDisintegrated; // This nade has been disintegrated by a siren scream.
var()   sound   DisintegrateSound;// The sound of this projectile disintegrating
var     bool    bDud;           // This rocket is a dud, it hit too soon
var()   float   ArmDistSquared; // Distance this rocket arms itself at
var   class<DamageType>    ImpactDamageType; // Damagetype of this rocket hitting something, but not exploding
var     int     ImpactDamage;   // How much damage to do if this rocket impacts something without exploding
var     bool    bHasExploded;

replication
{
    reliable if(Role == ROLE_Authority)
        bDud;
}

simulated function PostNetReceive()
{
    if( bHidden && !bDisintegrated )
    {
        Disintegrate(Location, vect(0,0,1));
    }
}

function Timer()
{
    Destroy();
}

function ShakeView()
{
    local Controller C;
    local PlayerController PC;
    local float Dist, Scale;

    for ( C=Level.ControllerList; C!=None; C=C.NextController )
    {
        PC = PlayerController(C);
        if ( PC != None && PC.ViewTarget != None )
        {
            Dist = VSize(Location - PC.ViewTarget.Location);
            if ( Dist < DamageRadius * 2.0)
            {
                if (Dist < DamageRadius)
                    Scale = 1.0;
                else
                    Scale = (DamageRadius*2.0 - Dist) / (DamageRadius);
                C.ShakeView(ShakeRotMag*Scale, ShakeRotRate, ShakeRotTime, ShakeOffsetMag*Scale, ShakeOffsetRate, ShakeOffsetTime);
            }
        }
    }
}

simulated function HitWall(vector HitNormal, actor Wall)
{
    // Use the instigator's location if it exists. This fixes issues with
    // the original location of the projectile being really far away from
    // the real Origloc due to it taking a couple of milliseconds to
    // replicate the location to the client and the first replicated location has
    // already moved quite a bit.
    if( Instigator != none )
    {
        OrigLoc = Instigator.Location;
    }

    if( !bDud && ((VSizeSquared(Location - OrigLoc) < ArmDistSquared) || OrigLoc == vect(0,0,0)) )
    {
        bDud = true;
        LifeSpan=1.0;
        Velocity = vect(0,0,0);
        SetPhysics(PHYS_Falling);
    }

    if( !bDud )
    {
        super(Projectile).HitWall(HitNormal,Wall);
    }
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
    local Controller C;
    local PlayerController  LocalPlayer;

    bHasExploded = True;

    // Don't explode if this is a dud
    if( bDud )
    {
        Velocity = vect(0,0,0);
        LifeSpan=1.0;
        SetPhysics(PHYS_Falling);
    }


    PlaySound(ExplosionSound,,2.0);
    if ( EffectIsRelevant(Location,false) )
    {
        Spawn(class'RPGExplosion',,,HitLocation + HitNormal*20,rotator(HitNormal));
        Spawn(ExplosionDecal,self,,HitLocation, rotator(-HitNormal));
    }

    BlowUp(HitLocation);
    Destroy();

    // Shake nearby players screens
    LocalPlayer = Level.GetLocalPlayerController();
    if ( (LocalPlayer != None) && (VSize(Location - LocalPlayer.ViewTarget.Location) < DamageRadius) )
        LocalPlayer.ShakeView(RotMag, RotRate, RotTime, OffsetMag, OffsetRate, OffsetTime);

    for ( C=Level.ControllerList; C!=None; C=C.NextController )
        if ( (PlayerController(C) != None) && (C != LocalPlayer)
            && (VSize(Location - PlayerController(C).ViewTarget.Location) < DamageRadius) )
            C.ShakeView(RotMag, RotRate, RotTime, OffsetMag, OffsetRate, OffsetTime);
}

// Make the projectile distintegrate, instead of explode
simulated function Disintegrate(vector HitLocation, vector HitNormal)
{
    bDisintegrated = true;
    bHidden = true;

    if( Role == ROLE_Authority )
    {
       SetTimer(0.1, false);
       NetUpdateTime = Level.TimeSeconds - 1;
    }

    PlaySound(DisintegrateSound,,2.0);

    if ( EffectIsRelevant(Location,false) )
    {
        Spawn(Class'KFMod.SirenNadeDeflect',,, HitLocation, rotator(vect(0,0,1)));
    }
}

simulated function PostBeginPlay()
{
    local rotator SmokeRotation;

    BCInverse = 1 / BallisticCoefficient;

    if ( Level.NetMode != NM_DedicatedServer)
    {
        SmokeTrail = Spawn(class'RPGTrail',self);
        SmokeTrail.SetBase(self);
        SmokeRotation.Pitch = 32768;
        SmokeTrail.SetRelativeRotation(SmokeRotation);
        // Corona = Spawn(class'KFRPGCorona',self);
    }

    OrigLoc = Location;

    if( !bDud )
    {
        Dir = vector(Rotation);
        Velocity = speed * Dir;
    }

    if (PhysicsVolume.bWaterVolume)
    {
        bHitWater = True;
        Velocity=0.6*Velocity;
    }
    super(Projectile).PostBeginPlay();
}

function TakeDamage( int Damage, Pawn InstigatedBy, Vector Hitlocation, Vector Momentum, class<DamageType> damageType, optional int HitIndex)
{
    if( damageType == class'SirenScreamDamage')
    {
        Disintegrate(HitLocation, vect(0,0,1));
    }
    else
    {
        if( !bDud )
        {
            Explode(HitLocation, vect(0,0,0));
        }
    }
}

simulated function Destroyed()
{
    if ( SmokeTrail != None )
    {
        SmokeTrail.HandleOwnerDestroyed();
    }

    if( !bHasExploded && !bHidden && !bDud )
        Explode(Location,vect(0,0,1));
    if( bHidden && !bDisintegrated )
        Disintegrate(Location,vect(0,0,1));

    Super.Destroyed();
}

/* HurtRadius()
 Hurt locally authoritative actors within the radius.
*/
simulated function HurtRadius( float DamageAmount, float DamageRadius, class<DamageType> DamageType, float Momentum, vector HitLocation )
{
    local actor Victims;
    local float damageScale, dist;
    local vector dirs;
    local int NumKilled;
    local KFMonster KFMonsterVictim;
    local Pawn P;
    local KFPawn KFP;
    local array<Pawn> CheckedPawns;
    local int i;
    local bool bAlreadyChecked;


    if ( bHurtEntry )
        return;

    bHurtEntry = true;

    foreach CollidingActors (class 'Actor', Victims, DamageRadius, HitLocation)
    {
        // don't let blast damage affect fluid - VisibleCollisingActors doesn't really work for them - jag
        if( (Victims != self) && (Hurtwall != Victims) && (Victims.Role == ROLE_Authority) && !Victims.IsA('FluidSurfaceInfo')
         && ExtendedZCollision(Victims)==None )
        {
            dirs = Victims.Location - HitLocation;
            dist = FMax(1,VSize(dirs));
            dirs = dirs/dist;
            damageScale = 1 - FMax(0,(dist - Victims.CollisionRadius)/DamageRadius);
            if ( Instigator == None || Instigator.Controller == None )
                Victims.SetDelayedDamageInstigatorController( InstigatorController );
            if ( Victims == LastTouched )
                LastTouched = None;

            P = Pawn(Victims);

            if( P != none )
            {
                for (i = 0; i < CheckedPawns.Length; i++)
                {
                    if (CheckedPawns[i] == P)
                    {
                        bAlreadyChecked = true;
                        break;
                    }
                }

                if( bAlreadyChecked )
                {
                    bAlreadyChecked = false;
                    P = none;
                    continue;
                }

                KFMonsterVictim = KFMonster(Victims);

                if( KFMonsterVictim != none && KFMonsterVictim.Health <= 0 )
                {
                    KFMonsterVictim = none;
                }

                KFP = KFPawn(Victims);

                if( KFMonsterVictim != none )
                {
                    damageScale *= KFMonsterVictim.GetExposureTo(HitLocation/*Location + 15 * -Normal(PhysicsVolume.Gravity)*/);
                }
                else if( KFP != none )
                {
                    damageScale *= KFP.GetExposureTo(HitLocation/*Location + 15 * -Normal(PhysicsVolume.Gravity)*/);
                }

                CheckedPawns[CheckedPawns.Length] = P;

                if ( damageScale <= 0)
                {
                    P = none;
                    continue;
                }
                else
                {
                    //Victims = P;
                    P = none;
                }
            }


            Victims.TakeDamage
            (
                damageScale * DamageAmount,
                Instigator,
                Victims.Location - 0.5 * (Victims.CollisionHeight + Victims.CollisionRadius) * dirs,
                (damageScale * Momentum * dirs),
                DamageType
            );
            if (Vehicle(Victims) != None && Vehicle(Victims).Health > 0)
                Vehicle(Victims).DriverRadiusDamage(DamageAmount, DamageRadius, InstigatorController, DamageType, Momentum, HitLocation);

            if( Role == ROLE_Authority && KFMonsterVictim != none && KFMonsterVictim.Health <= 0 )
            {
                NumKilled++;
            }
        }
    }
    if ( (LastTouched != None) && (LastTouched != self) && (LastTouched.Role == ROLE_Authority) && !LastTouched.IsA('FluidSurfaceInfo') )
    {
        Victims = LastTouched;
        LastTouched = None;
        dirs = Victims.Location - HitLocation;
        dist = FMax(1,VSize(dirs));
        dirs = dirs/dist;
        damageScale = FMax(Victims.CollisionRadius/(Victims.CollisionRadius + Victims.CollisionHeight),1 - FMax(0,(dist - Victims.CollisionRadius)/DamageRadius));
        if ( Instigator == None || Instigator.Controller == None )
            Victims.SetDelayedDamageInstigatorController(InstigatorController);
        Victims.TakeDamage
        (
            damageScale * DamageAmount,
            Instigator,
            Victims.Location - 0.5 * (Victims.CollisionHeight + Victims.CollisionRadius) * dirs,
            (damageScale * Momentum * dirs),
            DamageType
        );
        if (Vehicle(Victims) != None && Vehicle(Victims).Health > 0)
            Vehicle(Victims).DriverRadiusDamage(DamageAmount, DamageRadius, InstigatorController, DamageType, Momentum, HitLocation);
    }

    if( Role == ROLE_Authority )
    {
        if( NumKilled >= 4 )
        {
            KFGameType(Level.Game).DramaticEvent(0.05);
        }
        else if( NumKilled >= 2 )
        {
            KFGameType(Level.Game).DramaticEvent(0.03);
        }
    }

    bHurtEntry = false;
}

simulated function ProcessTouch(Actor Other, Vector HitLocation)
{
    if ( Other == none || Other == Instigator || Other.Base == Instigator  )
        return;

    // Use the instigator's location if it exists. This fixes issues with
    // the original location of the projectile being really far away from
    // the real Origloc due to it taking a couple of milliseconds to
    // replicate the location to the client and the first replicated location has
    // already moved quite a bit.
    if( Instigator != none )
    {
        OrigLoc = Instigator.Location;
    }

    if( !bDud && ((VSizeSquared(Location - OrigLoc) < ArmDistSquared) || OrigLoc == vect(0,0,0)) )
    {
        if( Role == ROLE_Authority )
        {
            AmbientSound=none;
            PlaySound(Sound'ProjectileSounds.PTRD_deflect04',,2.0);
            Other.TakeDamage( ImpactDamage, Instigator, HitLocation, Normal(Velocity), ImpactDamageType );
        }

        bDud = true;
        Velocity = vect(0,0,0);
        LifeSpan=1.0;
        SetPhysics(PHYS_Falling);
    }

    if( !bDud )
    {
       Explode(HitLocation,Normal(HitLocation-Other.Location));
    }
}

simulated function Tick( float DeltaTime )
{
    if( bDud && Physics == PHYS_Falling )
    {
        SetRotation(Rotator(Normal(Velocity)));
    }
}

simulated function Landed( vector HitNormal )
{
    SetPhysics(PHYS_None);

    if( !bDud )
    {
       Explode(Location,HitNormal);
    }
    else
    {
       Destroy();
    }
}

defaultproperties
{
     ShakeRotMag=(X=512.000000,Y=400.000000)
     ShakeRotRate=(X=3000.000000,Y=3000.000000)
     ShakeRotTime=6.000000
     ShakeOffsetMag=(X=20.000000,Y=30.000000,Z=30.000000)
     ShakeOffsetRate=(X=300.000000,Y=300.000000,Z=300.000000)
     ShakeOffsetTime=3.500000
     RotMag=(X=700.000000,Y=700.000000,Z=700.000000)
     RotRate=(X=12500.000000,Y=12500.000000,Z=12500.000000)
     RotTime=6.000000
     OffsetMag=(X=5.000000,Y=10.000000,Z=7.000000)
     OffsetRate=(X=300.000000,Y=300.000000,Z=300.000000)
     OffsetTime=3.500000
     ExplosionSound=Sound'RPG7DT_A.RPGExplode'
     DisintegrateSound=Sound'Inf_Weapons.panzerfaust60.faust_explode_distant02'
     ArmDistSquared=250000.000000
     ImpactDamageType=Class'DamTypeRpgRocketImpact'
     ImpactDamage=250
     AmbientVolumeScale=5.000000
     bTrueBallistics=False
     Speed=3000.000000
     MaxSpeed=4000.000000
     Damage=950.000000
     DamageRadius=600.000000
     MomentumTransfer=2000.000000
     MyDamageType=Class'DamTypeRPG'
     ExplosionDecal=Class'ROEffects.RocketMarkDirt'
     LightHue=25
     LightSaturation=100
     LightBrightness=200.000000
     LightRadius=15.000000
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'RPG7DT_A.Rocket'
     AmbientSound=Sound'RPG7DT_A.RPGFly'
     LifeSpan=10.000000
     DrawScale=0.700000
     bUnlit=False
     SoundVolume=192
     SoundRadius=128.000000
     TransientSoundVolume=2.000000
     TransientSoundRadius=500.000000
     bNetNotify=True
     bBlockHitPointTraces=False
     ForceRadius=300.000000
     ForceScale=10.000000
}
