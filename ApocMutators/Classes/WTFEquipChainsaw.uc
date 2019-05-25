class WTFEquipChainsaw extends Chainsaw;

#exec obj load file=WTFTex.utx

var float NextIronTime;
//var float NextReloadTime; // oh, I have plans...

replication
{
	reliable if (Role < ROLE_Authority)
		DoLunge;
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

	DirMomentum.X=300.0;
	DirMomentum.Y=0.0;
	DirMomentum.Z= 275.0; // 325.0; // default kfhumanpawn jump height
	VR.Pitch=0;

	FireMode[1].ModeDoFire();

	Instigator.AddVelocity(DirMomentum >> VR);
}

defaultproperties
{
	 BloodyMaterial=Texture'WTFTex.Chainsaw.Chainsaw_bloody'
	 FireModeClass(0)=Class'ApocMutators.WTFEquipChainsawFire'
	 FireModeClass(1)=Class'ApocMutators.WTFEquipChainsawAltFire'
	 Description="A deadly weapon"
	 PickupClass=Class'ApocMutators.WTFEquipChainsawPickup'
	 AttachmentClass=Class'ApocMutators.WTFEquipChainsawAttachment'
	 Skins(0)=Texture'WTFTex.Chainsaw.Chainsaw'
	 Skins(1)=TexPanner'KF_Specimens_Trip_T.scrake_saw_panner'
}
