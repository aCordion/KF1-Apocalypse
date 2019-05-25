class SlotMachine_HGrenade extends Nade;

#exec AUDIO IMPORT file="Assets\SlotMachine\Hallelujah.WAV" NAME="Hallelujah" GROUP="FX"

var SlotMachine_HHGTrail HTrail;
var bool bDoneHale;

simulated function PostBeginPlay()
{
    if (Level.NetMode != NM_DedicatedServer)
        HTrail = Spawn(Class'SlotMachine_HHGTrail', Self);
    Super.PostBeginPlay();
}
simulated function Destroyed()
{
    if (HTrail != None)
        HTrail.Destroy();
    Super.Destroyed();
}

function TakeDamage(int Damage, Pawn InstigatedBy, Vector Hitlocation, Vector Momentum, Class<DamageType> damageType, optional int HitIndex);

function Timer()
{
    if (!bHidden)
    {
        if (!bDoneHale)
        {
            bDoneHale = true;
            PlaySound(Sound'Hallelujah', SLOT_Misc, 2.0);
            SetTimer(2.1, false);
        }
        else Explode(Location, vect(0, 0, 1));
    }
    else Destroy();
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
    local PlayerController  LocalPlayer;
    local Projectile P;
    local byte i;

    bHasExploded = True;
    BlowUp(HitLocation);

    // Shrapnel
    for (i=Rand(8); i < 20; i++)
    {
        P = Spawn(ShrapnelClass, , , , RotRand(True));
        if (P != None)
            P.RemoteRole = ROLE_None;
    }

    if (Level.NetMode != NM_DedicatedServer)
    {
        PlaySound(ExplodeSounds[0], SLOT_None, 2.0);
        PlaySound(ExplodeSounds[0], SLOT_Misc, 2.0);

        Spawn(Class'SlotMachine_HHGExplosion', , , HitLocation, rotator(vect(0, 0, 1)));
        if (EffectIsRelevant(Location, false))
            Spawn(ExplosionDecal, self, , HitLocation, rotator(-HitNormal));

        // Shake nearby players screens
        LocalPlayer = Level.GetLocalPlayerController();
        if ((LocalPlayer != None) && (VSize(Location - LocalPlayer.ViewTarget.Location) < (DamageRadius * 1.5)))
        {
            LocalPlayer.ClientFlash(10.f, vect(1, 1, 1));
            LocalPlayer.ShakeView(RotMag, RotRate, RotTime, OffsetMag, OffsetRate, OffsetTime);
        }
    }

    Destroy();
}

defaultproperties
{
     RotMag=(X=1600.000000,Y=1600.000000,Z=1600.000000)
     OffsetMag=(X=12.000000,Y=20.000000,Z=15.000000)
     OffsetRate=(X=400.000000,Y=400.000000,Z=400.000000)
     ExplodeSounds(0)=SoundGroup'Amb_Destruction.explosions.Expl_Brick_House01'
     ExplodeTimer=4.000000
     Speed=1500.000000
     Damage=3500.000000
     DamageRadius=3000.000000
     MomentumTransfer=1000000.000000
     MyDamageType=Class'ApocMutators.SlotMachine_DamTypeHHGren'
     StaticMesh=StaticMesh'ApocMutators.HHGrenadeSM'
     bAlwaysRelevant=True
     DrawScale=0.300000
     TransientSoundVolume=2.000000
     TransientSoundRadius=6000.000000
     CollisionRadius=4.000000
     CollisionHeight=4.000000
}
