//================================================================================
// Sentry_MedicSentryWeapon.
//================================================================================

class Sentry_MedicSentryWeapon extends KFWeapon;


#exec obj load file="SentryTechTex1.utx"
#exec obj load file="SentryTechAnim1.ukx"

var Sentry_MedicSentry CurrentMedicSentry;
var bool bBeingDestroyed;
var bool bSentryDeployed;

replication
{
  reliable if ((Role == 4) && bNetOwner)
    bSentryDeployed;
}

simulated function Weapon WeaponChange(byte F, bool bSilent)
{
  if ((InventoryGroup == F) && !bSentryDeployed)
  {
    return self;
  } else {
    if (Inventory == None)
    {
      return None;
    } else {
      return Inventory.WeaponChange(F, bSilent);
    }
  }
}

function PlayIdle();

function bool CanAttack(Actor Other)
{
  return  !bSentryDeployed;
}

simulated function PostBeginPlay()
{
  Super.PostBeginPlay();
  TweenAnim('Folded', 0.01);
}

simulated event RenderOverlays(Canvas Canvas)
{
  local Rotator R;
  local Vector HL;
  local Vector HN;
  local Vector End;

  if (bSentryDeployed)
  {
    return;
  }
  R.Yaw = Instigator.Rotation.Yaw;
  End = vector(R)  * (Instigator.CollisionRadius + 70.0) + Instigator.Location;
  if (Instigator.Trace(HL, HN, End, Instigator.Location, False, vect(24.00, 24.00, 24.00)) != None)
  {
    End = HL;
  }
  SetLocation(End);
  SetRotation(R);
  bDrawingFirstPerson = True;
  Canvas.DrawActor(self, False, False);
  bDrawingFirstPerson = False;
}

simulated function ClientReload()
{
}

exec function ReloadMeNow()
{
}

simulated function AnimEnd(int Channel);

simulated function Destroyed()
{
  if (Role < 4)
  {
    if ((Instigator != None) && (Instigator.Controller != None) && (Instigator.Weapon == self))
    {
      bBeingDestroyed = True;
      Instigator.SwitchToLastWeapon();
    }
  }
  if ((Level.NetMode != 3) && (CurrentMedicSentry != None))
  {
    CurrentMedicSentry.WeaponOwner = None;
    CurrentMedicSentry.KilledBy(None);
    CurrentMedicSentry = None;
  }
  Super.Destroyed();
}

simulated function bool PutDown()
{
  if (bBeingDestroyed)
  {
    Instigator.ChangedWeapon();
    return True;
  } else {
    return Super.PutDown();
  }
}

simulated function float RateSelf()
{
  if (bBeingDestroyed || bSentryDeployed)
  {
    CurrentRating = -2.0;
  } else {
    CurrentRating = 50.0;
  }
  return CurrentRating;
}

simulated event ClientStartFire(int Mode)
{
  if (Pawn(Owner).Controller.IsInState('GameEnded') || Pawn(Owner).Controller.IsInState('RoundEnded'))
  {
    return;
  }
  ServerStartFire(Mode);
}

simulated event ClientStopFire(int Mode)
{
  ServerStopFire(Mode);
}

function bool BotFire(bool bFinished, optional name FiringMode)
{
  if (bSentryDeployed)
  {
    return False;
  }
  ServerStartFire(0);
  return True;
}

event ServerStartFire(byte Mode)
{
  local Rotator R;
  local Vector Spot;

  if ((Instigator != None) && (Instigator.Weapon != self))
  {
    if (Instigator.Weapon == None)
    {
      Instigator.ServerChangedWeapon(None, self);
    } else {
      Instigator.Weapon.SynchronizeWeapon(self);
    }
    return;
  }
  if (CurrentMedicSentry == None)
  {
    R.Yaw = Instigator.Rotation.Yaw;
    Spot = vector(R)  * (Instigator.CollisionRadius + 70.0) + Instigator.Location;
    if (FastTrace(Spot, Instigator.Location))
    {
      CurrentMedicSentry = Spawn(Class'Sentry_MedicSentry', , , Spot, R);
      if (CurrentMedicSentry != None)
      {
        if (PlayerController(Instigator.Controller) != None)
        {
          PlayerController(Instigator.Controller).ReceiveLocalizedMessage(Class'Sentry_MedicSentryMessage', 1);
        }
        CurrentMedicSentry.SetOwningPlayer(Instigator, self);
        bSentryDeployed = True;
        SellValue = 500;
        if (ThirdPersonActor != None)
        {
          InventoryAttachment(ThirdPersonActor).bFastAttachmentReplication = False;
          ThirdPersonActor.bHidden = True;
        }
        return;
      }
    }
    if (PlayerController(Instigator.Controller) != None)
    {
      PlayerController(Instigator.Controller).ReceiveLocalizedMessage(Class'Sentry_MedicSentryMessage', 0);
    }
  }
}

function AttachToPawn(Pawn P)
{
  Super.AttachToPawn(P);
  if (bSentryDeployed && (ThirdPersonActor != None))
  {
    InventoryAttachment(ThirdPersonActor).bFastAttachmentReplication = False;
    ThirdPersonActor.bHidden = True;
  }
}

function ServerStopFire(byte Mode)
{
}

defaultproperties
{
     MagCapacity=1
     HudImage=Texture'SentryTechTex1.Weapon_MedicSentryBot.MedicSentryBot_Hud'
     SelectedHudImage=Texture'SentryTechTex1.Weapon_MedicSentryBot.MedicSentryBot_Hud'
     Weight=1.000000
     bModeZeroCanDryFire=True
     TraderInfoTexture=Texture'SentryTechTex1.Weapon_MedicSentryBot.MedicSentryBot_Hud'
     FireModeClass(0)=Class'KFMod.NoFire'
     FireModeClass(1)=Class'KFMod.NoFire'
     SelectForce="SwitchToAssaultRifle"
     AIRating=0.550000
     CurrentRating=0.550000
     bCanThrow=False
     Description="A sentry bot which can be deployed to aid you in the combat."
     Priority=10
     InventoryGroup=5
     GroupOffset=6
     PickupClass=Class'ApocMutators.Sentry_MedicSentryPickup'
     PlayerViewOffset=(X=25.000000,Z=-25.000000)
     BobDamping=6.000000
     AttachmentClass=Class'ApocMutators.Sentry_MedicSentryAttachment'
     IconCoords=(X1=245,Y1=39,X2=329,Y2=79)
     ItemName="Medic Sentry Bot"
     Mesh=SkeletalMesh'SentryTechAnim1.Weapon_DoomSentry'
     Skins(2)=Texture'SentryTechTex1.Weapon_MedicSentryBot.MedicSentryBot_Skin2'
     AmbientGlow=35
}
