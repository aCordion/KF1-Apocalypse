class Sentry_USCMSentryPickup extends KFWeaponPickup;

#exec obj load file="SentryTechTex1.utx"
#exec obj load file="SentryTechAnim1.ukx"
#exec obj load file="SentryTechStatics.usx"
#exec obj load file="SentryTechSounds.uax"

defaultproperties
{
     Weight=1.000000
     cost=3500
     AmmoCost=0
     BuyClipSize=1
     PowerValue=100
     SpeedValue=10
     RangeValue=25
     Description="A USCM Sentry Gun."
     ItemName="USCM Sentry Gun"
     ItemShortName="USCM Sentry Gun"
     AmmoItemName="USCM Sentry Gun"
     CorrespondingPerkIndex=1
     EquipmentCategoryID=3
     InventoryType=Class'ApocMutators.Sentry_USCMSentryWeapon'
     PickupMessage="You got a USCM Sentry Gun"
     PickupSound=Sound'KF_AA12Snd.AA12_Pickup'
     PickupForce="AssaultRiflePickup"
     StaticMesh=StaticMesh'SentryTechStatics.Weapon_USCMSentry.USCMSentryLaptop_Pickup'
     Skins(0)=Combiner'SentryTechTex1.Weapon_USCMSentry.USCMSentryLaptopFinal'
     CollisionRadius=22.000000
     CollisionHeight=23.000000
}
