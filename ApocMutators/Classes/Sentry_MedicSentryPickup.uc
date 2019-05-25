//================================================================================
// MedSentryGunPickup.
//================================================================================

class Sentry_MedicSentryPickup extends KFWeaponPickup;

#exec obj load file="SentryTechTex1.utx"
#exec obj load file="SentryTechAnim1.ukx"




simulated function PostBeginPlay()
{
  Super.PostBeginPlay();
  TweenAnim('Folded', 0.01);
}

defaultproperties
{
	 Weight=1.000000
	 cost=2500
	 AmmoCost=0
	 BuyClipSize=1
	 SpeedValue=20
	 RangeValue=50
	 Description="A heavy armed machine gun sentry bot you can purchase to aid you in the combat."
	 ItemName="Medic Sentry Bot"
	 ItemShortName="Medic Sentry Bot"
	 AmmoItemName="Medic Sentry Bot"
	 CorrespondingPerkIndex=0
	 EquipmentCategoryID=3
	 InventoryType=Class'ApocMutators.Sentry_MedicSentryWeapon'
	 PickupMessage="You picked up the Medic Sentry Bot"
	 PickupSound=Sound'KF_AA12Snd.AA12_Pickup'
	 PickupForce="AssaultRiflePickup"
	 DrawType=DT_Mesh
	 Mesh=SkeletalMesh'SentryTechAnim1.Weapon_DoomSentry'
	 Skins(2)=Texture'SentryTechTex1.Weapon_MedicSentryBot.MedicSentryBot_Skin2'
	 CollisionRadius=22.000000
	 CollisionHeight=23.000000
}
