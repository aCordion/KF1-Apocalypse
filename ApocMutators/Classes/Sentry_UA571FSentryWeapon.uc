class Sentry_UA571FSentryWeapon extends KFWeapon
    Config(ApocMutators);

#exec obj load file="SentryTechTex1.utx"
#exec obj load file="SentryTechAnim1.ukx"
#exec obj load file="SentryTechStatics.usx"
#exec obj load file="SentryTechSounds.uax"

var Sentry_UA571FSentry CurrentSentry;
var transient float NextWhineTimer;
var bool bBeingDestroyed; // We've thrown the last bomb and this explosive is about to be destroyed
var bool bSentryDeployed;
var Class<Sentry_UA571FSentry> SentryClass;
var config bool bStationaryTurret;

replication
{
    // Variables the server should send to the client.
    reliable if (Role == ROLE_Authority && bNetOwner)
        bSentryDeployed;
}

simulated function Weapon WeaponChange(byte F, bool bSilent)
{
    if (InventoryGroup == F && !bSentryDeployed)
        return self;
    else if (Inventory == None)
        return None;
    else return Inventory.WeaponChange(F, bSilent);
}

function PlayIdle();

function bool CanAttack(Actor Other)
{
    return !bSentryDeployed; // Always ready to fire if not deployed yet.
}

simulated event RenderOverlays(Canvas Canvas)
{
    local rotator R;
    local vector HL, HN, End;

    if (bSentryDeployed)
        return;
    R.Yaw = Instigator.Rotation.Yaw;
    End = vector(R) * (Instigator.CollisionRadius + 70.f) + Instigator.Location;
    if (Instigator.Trace(HL, HN, End, Instigator.Location, false, vect(24, 24, 24)) != None)
        End = HL;
    SetLocation(End);
    SetRotation(R);
    bDrawingFirstPerson = true;
    Canvas.DrawActor(self, false, false);
    bDrawingFirstPerson = false;
}

simulated function ClientReload()
{
}
exec function ReloadMeNow()
{
}

simulated function AnimEnd(int channel);

simulated function Destroyed()
{
    if (Role < ROLE_Authority)
    {
        // Hack to switch to another weapon on the client when we throw the Sentry_UA571FSentry bot is destroyed.
        if (Instigator != none && Instigator.Controller != none && Instigator.Weapon == Self)
        {
            bBeingDestroyed = true;
            Instigator.SwitchToLastWeapon();
        }
    }
    if (Level.NetMode != NM_Client && CurrentSentry != None)
    {
        CurrentSentry.WeaponOwner = None;
        CurrentSentry.KilledBy(None);
        CurrentSentry = None;
    }
    super.Destroyed();
}

simulated function bool PutDown()
{
    if (bBeingDestroyed)
    {
        Instigator.ChangedWeapon();
        return true;
    }
    else return super.PutDown();
}

// need to figure out modified rating based on enemy / tactical situation
simulated function float RateSelf()
{
    if (bBeingDestroyed || bSentryDeployed)
        CurrentRating = -2;
    else CurrentRating = 50.f;
    return CurrentRating;
}

simulated event ClientStartFire(int Mode)
{
    if (Pawn(Owner).Controller.IsInState('GameEnded') || Pawn(Owner).Controller.IsInState('RoundEnded'))
        return;
    ServerStartFire(Mode);
}

simulated event ClientStopFire(int Mode)
{
    ServerStopFire(Mode);
}

function bool BotFire(bool bFinished, optional name FiringMode)
{
    if (bSentryDeployed)
        return false;
    ServerStartFire(0);
    return true;
}

event ServerStartFire(byte Mode)
{
    local rotator R;
    local vector Spot;

    if ((Instigator != None) && (Instigator.Weapon != self))
    {
        if (Instigator.Weapon == None)
            Instigator.ServerChangedWeapon(None, self);
        else
            Instigator.Weapon.SynchronizeWeapon(self);
        return;
    }

    if (CurrentSentry == None)
    {
        R.Yaw = Instigator.Rotation.Yaw;
        Spot = vector(R) * (Instigator.CollisionRadius + 70.f) + Instigator.Location;
        if (FastTrace(Spot, Instigator.Location))
        {
            if (bStationaryTurret)
                CurrentSentry = Spawn(Class'Sentry_UA571FSentryStationary', , , Spot, R);
            else
                CurrentSentry = Spawn(Class'Sentry_UA571FSentry', , , Spot, R);
            if (CurrentSentry != None)
            {
                if (PlayerController(Instigator.Controller) != None)
                    PlayerController(Instigator.Controller).ReceiveLocalizedMessage(Class'Sentry_UA571FSentryMessageTurret', 1);
                CurrentSentry.SetOwningPlayer(Instigator, Self);
                bSentryDeployed = true;
                SellValue /= 1.3; // No refunds after deployed.
                if (ThirdPersonActor != None)
                {
                    InventoryAttachment(ThirdPersonActor).bFastAttachmentReplication = false;
                    ThirdPersonActor.bHidden = true;
                }
                return;
            }
        }
        if (PlayerController(Instigator.Controller) != None)
            PlayerController(Instigator.Controller).ReceiveLocalizedMessage(Class'Sentry_UA571FSentryMessageTurret', 0);
    }
}

function AttachToPawn(Pawn P)
{
    Super.AttachToPawn(P);
    if (bSentryDeployed && ThirdPersonActor != None)
    {
        InventoryAttachment(ThirdPersonActor).bFastAttachmentReplication = false;
        ThirdPersonActor.bHidden = true;
    }
}

function ServerStopFire(byte Mode)
{
}

function WeaponTick(float dt)
{
    if (!bSentryDeployed && NextWhineTimer < Level.TimeSeconds)
    {
        NextWhineTimer = Level.TimeSeconds + 5 + FRand() * 10.f;
//     Instigator.PlaySound(Sound'GTurretPickup', SLOT_Misc, 2.f, , 350.f);
    }
}

defaultproperties
{
     SentryClass=Class'ApocMutators.Sentry_UA571FSentry'
     bStationaryTurret=True
     MagCapacity=1
     Weight=1.000000
     bModeZeroCanDryFire=True
     SleeveNum=0
     TraderInfoTexture=Texture'SentryTechTex1.Weapon_USCMSentry.Trader_SentryGun'
     MeshRef="SentryTechAnim1.Weapon_USCMSentryLaptop"
     SkinRefs(1)="SentryTechTex1.Weapon_BaseTurret.SentryLaptopFinal"
     HudImageRef="SentryTechTex1.Weapon_BaseTurret.SentryGun_Unselected"
     SelectedHudImageRef="SentryTechTex1.Weapon_BaseTurret.SentryGun_Selected"
     FireModeClass(0)=Class'KFMod.NoFire'
     FireModeClass(1)=Class'KFMod.NoFire'
     SelectForce="SwitchToAssaultRifle"
     AIRating=0.550000
     CurrentRating=0.550000
     bCanThrow=False
     Description="A turret which can be deployed to aid you in the combat."
     Priority=10
     InventoryGroup=5
     GroupOffset=6
     PickupClass=Class'ApocMutators.Sentry_UA571FSentryPickup'
     PlayerViewOffset=(X=25.000000,Z=-25.000000)
     BobDamping=6.000000
     AttachmentClass=Class'ApocMutators.Sentry_UA571FSentryAttachment'
     IconCoords=(X1=245,Y1=39,X2=329,Y2=79)
     ItemName="UA-571F Sentry Gun"
     AmbientGlow=35
}
