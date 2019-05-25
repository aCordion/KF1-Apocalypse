//-----------------------------------------------------------
//
//-----------------------------------------------------------
class Weapon_Litesaber extends KFMeleeGun;

#exec OBJ LOAD FILE=KF_Weapons2_Trip.ukx

simulated function BeginPlay()
{
	LinkSkelAnim(MeshAnimation'katana_anim');
	Super.BeginPlay();
}

simulated function Timer()
{
	Super.Timer();
	if (Instigator != None && ClientState == WS_Hidden)
	{
		LightType = LT_None;
	}
	else
		LightType = LT_SubtlePulse;
}

/*function WeaponFire
{
	local KFPlayerReplicationInfo KFPRI;
	
	KFPRI = KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo);
	if (KFPRI != none)
	{
		if (KFPRI.ClientVeteranSkill == Class'Jedi')
	     FireModeClass(0)=Class'daforcev01.litesaberfire';
		 FireModeClass(1)=Class'daforcev01.litesaberfireB';
	}
	else
	     FireModeClass(0)=Class'kfmod.katanafire';
		 FireModeClass(1)=Class'kfmod.katanafireB';
		
	return Super.Weapon;
}*/

defaultproperties
{
     weaponRange=90.000000
     bSpeedMeUp=True
     Weight=3.000000
     StandardDisplayFOV=75.000000
     TraderInfoTexture=Texture'KillingFloor2HUD.Trader_Weapon_Icons.Trader_Katana'
     bIsTier3Weapon=True
     HudImageRef="KillingFloor2HUD.WeaponSelect.katana_unselected"
     SelectedHudImageRef="KillingFloor2HUD.WeaponSelect.Katana"
     FireModeClass(0)=Class'ApocMutators.Weapon_LitesaberFire'
     FireModeClass(1)=Class'ApocMutators.Weapon_LitesaberFireB'
     SelectSound=Sound'daforce.SaberOn'
     AIRating=0.400000
     CurrentRating=0.600000
     Description="An incredibly hot sword."
     DisplayFOV=75.000000
     Priority=110
     GroupOffset=4
     PickupClass=Class'ApocMutators.Weapon_LitesaberPickup'
     BobDamping=8.000000
     AttachmentClass=Class'ApocMutators.Weapon_LitesaberAttachment'
     IconCoords=(X1=246,Y1=80,X2=332,Y2=106)
     ItemName="Lite Saber"
     LightType=LT_None
     LightHue=170
     LightSaturation=155
     LightBrightness=200.000000
     LightRadius=5.000000
     bDynamicLight=True
     Mesh=SkeletalMesh'daforce.LiteSaberMesh1'
     Skins(0)=Combiner'KF_Weapons2_Trip_T.Special.MP_7_cmb'
     Skins(2)=Shader'daforce.LiteSaberSHD'
     bUnlit=True
}
