class Sentry_UA571DSentryPickup extends KFWeaponPickup;

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
     Description="A UA-571D Sentry Gun."
     ItemName="UA-571D Sentry Gun"
     ItemShortName="UA-571D Sentry Gun"
     AmmoItemName="UA-571D Sentry Gun"
     CorrespondingPerkIndex=2
     EquipmentCategoryID=3
     InventoryType=Class'ApocMutators.Sentry_UA571DSentryWeapon'
     PickupMessage="You got a UA-571D Sentry Gun"
     PickupSound=Sound'KF_AA12Snd.AA12_Pickup'
     PickupForce="AssaultRiflePickup"
     StaticMesh=StaticMesh'SentryTechStatics.Weapon_USCMSentry.USCMSentryLaptop_Pickup'
     Skins(0)=Combiner'SentryTechTex1.Weapon_USCMSentry.USCMSentryLaptopFinal'
     CollisionRadius=22.000000
     CollisionHeight=23.000000
}
