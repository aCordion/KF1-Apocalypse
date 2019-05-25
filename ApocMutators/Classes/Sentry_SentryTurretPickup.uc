//=============================================================================
// Sentry_SentryTurretPickup.
//=============================================================================
class Sentry_SentryTurretPickup extends KFWeaponPickup;

defaultproperties
{
     Weight=1.000000
     cost=3500
     AmmoCost=0
     BuyClipSize=1
     PowerValue=100
     SpeedValue=10
     RangeValue=25
     Description="A turret made by the Aperture Science."
     ItemName="Sentry Turret"
     ItemShortName="Sentry Turret"
     AmmoItemName="Sentry Turret"
     CorrespondingPerkIndex=3
     EquipmentCategoryID=3
     InventoryType=Class'ApocMutators.Sentry_SentryTurretWeapon'
     PickupMessage="You got a Sentry Turret."
     PickupSound=Sound'KF_AA12Snd.AA12_Pickup'
     PickupForce="AssaultRiflePickup"
     StaticMesh=StaticMesh'ApocMutators.pickups.PTurretMesh'
     Skins(0)=Texture'ApocMutators.Skins.Turret_01_inactive'
     CollisionRadius=22.000000
     CollisionHeight=23.000000
}
