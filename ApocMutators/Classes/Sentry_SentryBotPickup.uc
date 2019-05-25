//=============================================================================
// SentryGun Pickup.
//=============================================================================
class Sentry_SentryBotPickup extends KFWeaponPickup;

#exec obj load file="SentryTechTex1.utx"
#exec obj load file="SentryTechAnim1.ukx"



simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	TweenAnim('Folded', 0.01f);
}

defaultproperties
{
	 Weight=3.000000
	 cost=3500
	 AmmoCost=0
	 BuyClipSize=1
	 PowerValue=100
	 SpeedValue=20
	 RangeValue=50
	 Description="A heavy armed machine gun sentry bot you can purchase to aid you in the combat."
	 ItemName="Sentry bot"
	 ItemShortName="Sentry bot"
	 AmmoItemName="Sentry bot"
	 CorrespondingPerkIndex=4
	 EquipmentCategoryID=3
	 InventoryType=Class'ApocMutators.Sentry_SentryBotWeapon'
	 PickupMessage="You got a Sentry bot."
	 PickupSound=Sound'KF_AA12Snd.AA12_Pickup'
	 PickupForce="AssaultRiflePickup"
	 DrawType=DT_Mesh
	 Mesh=SkeletalMesh'SentryTechAnim1.Weapon_DoomSentry'
	 CollisionRadius=22.000000
	 CollisionHeight=23.000000
}
