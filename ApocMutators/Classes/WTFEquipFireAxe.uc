class WTFEquipFireAxe extends Axe;

#exec obj load file=WTFTex.utx
//#exec obj load file=WTFSledge.ukx

var float NextIronTime;
//var float NextReloadTime; // oh, I have plans...
//var mesh imposter;

replication
{
	reliable if (Role < ROLE_Authority)
		DoLunge;
}

/*
simulated function PostBeginPlay()
{
	// Weapon will handle FireMode instantiation
	Super.PostBeginPlay();

	imposter=SkeletalMesh'WTFSledge.Sledge';
	LinkMesh(imposter, true);
	BoneRefresh();
	SetDrawScale(50.0);
}
*/

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

simulated exec function ToggleIronSights()
{
	local KFPlayerReplicationInfo KFPRI;

	 //this functionality is available to berserkers only
	KFPRI = KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo);
	if (KFPRI == none || KFPRI.ClientVeteranSkill != Class'SRVetBerserker')
		return;

	if (
		NextIronTime <= Level.TimeSeconds &&
		!FireMode[0].bIsFiring && FireMode[0].NextFireTime < Level.TimeSeconds &&
		!FireMode[1].bIsFiring && FireMode[1].NextFireTime < Level.TimeSeconds
		)
	{
		if (Instigator != none && Instigator.Physics != PHYS_Falling)
		{
			DoLunge();
			if (ROLE < ROLE_AUTHORITY) // client-side fx, essentially
				FireMode[1].ModeDoFire();

			NextIronTime=Level.TimeSeconds + 3.0;
		}
	}
}

simulated function DoLunge()
{
	local rotator VR; // ViewRotation
	local vector DirMomentum;

	VR = Instigator.Controller.GetViewRotation();

	DirMomentum.X=325.0;
	DirMomentum.Y=0.0;
	DirMomentum.Z= 275.0; // 325.0; // default kfhumanpawn jump height
	VR.Pitch=0;

	FireMode[1].ModeDoFire();

	Instigator.AddVelocity(DirMomentum >> VR);
}

defaultproperties
{
	 BloodyMaterial=Texture'WTFTex.Fireaxe.Fireaxe_bloody'
	 FireModeClass(0)=Class'ApocMutators.WTFEquipFireAxeFire'
	 FireModeClass(1)=Class'ApocMutators.WTFEquipFireAxeFireB'
	 Description="A deadly weapon"
	 PickupClass=Class'ApocMutators.WTFEquipFireAxePickup'
	 AttachmentClass=Class'ApocMutators.WTFEquipFireAxeAttachment'
	 ItemName="FIRE Axe"
	 LightType=LT_None
	 LightSaturation=0
	 LightBrightness=100.000000
	 bDynamicLight=True
	 Skins(0)=Texture'WTFTex.Fireaxe.Fireaxe'
	 AmbientGlow=10
}
