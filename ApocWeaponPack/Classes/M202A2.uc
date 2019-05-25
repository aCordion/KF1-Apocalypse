class M202A2 extends M202A1;

#exec OBJ LOAD FILE=M202_T.utx
#exec OBJ LOAD FILE=M202_SM.usx
#exec OBJ LOAD FILE=M202_A.ukx

var         M202RocketAttachmentFirstPerson                    ERockets;

var()		class<InventoryAttachment>	RocketAttachmentClass;      // First person laser attachment class
var 		Actor 						RocketAttachment;           // First person laser attachment

simulated function PostBeginPlay()
{

	super.PostBeginPlay();

	if( Level.Netmode != NM_DedicatedServer)
		SpawnRocket();

}

simulated function SpawnRocket()
{
	local Rotator RotationVect;
	SetBoneScale (4, 0.0, 'Rocket01');
	SetBoneScale (5, 0.0, 'Rocket02');
	SetBoneScale (6, 0.0, 'Rocket03');
	SetBoneScale (7, 0.0, 'Rocket04');
	if ( RocketAttachment == none )
	{
		RocketAttachment = Spawn(RocketAttachmentClass,,,,);
		AttachToBone(RocketAttachment,'RocketBlock');
		RotationVect.Yaw=0;
		RotationVect.Pitch=-32768; //-16384; //looks 99% perfect
		RotationVect.Roll=-16384; // 6144; //+ is tilt wire towards player's back
		RocketAttachment.SetRelativeRotation(RotationVect);
/*			RotationVect = RocketAttachment. GetBoneRotation('RootER');
		log("RotationVect "$RotationVect);
		RotationVect.yaw = 32768;
		log("RotationVect2 "$RotationVect);
		RocketAttachment.SetBoneDirection('RootER',RotationVect);*/
	}
}

simulated function Notify_ShowMeRockets(int Kolvo)
{
	SetBoneScale (4, 0.0, 'Rocket01');
	SetBoneScale (5, 0.0, 'Rocket02');
	SetBoneScale (6, 0.0, 'Rocket03');
	SetBoneScale (7, 0.0, 'Rocket04');
	log("Kolvo "$Kolvo);
	if ( RocketAttachment != none )
	{
		if(Kolvo == 0)
		{
			RocketAttachment.SetBoneScale (0, 0.0, 'ERocket01');
			RocketAttachment.SetBoneScale (1, 0.0, 'ERocket02');
			RocketAttachment.SetBoneScale (2, 0.0, 'ERocket03');
			RocketAttachment.SetBoneScale (3, 0.0, 'ERocket04');
		}
		else
		if(Kolvo == 1)
		{
			RocketAttachment.SetBoneScale (0, 0.0, 'ERocket01');
			RocketAttachment.SetBoneScale (1, 0.0, 'ERocket02');
			RocketAttachment.SetBoneScale (2, 0.0, 'ERocket03');
			RocketAttachment.SetBoneScale (3, 1.0, 'ERocket04');
		}
		else
		if(Kolvo == 2)
		{
			RocketAttachment.SetBoneScale (0, 0.0, 'ERocket01');
			RocketAttachment.SetBoneScale (1, 0.0, 'ERocket02');
			RocketAttachment.SetBoneScale (2, 1.0, 'ERocket03');
			RocketAttachment.SetBoneScale (3, 1.0, 'ERocket04');
		}
		else
		if(Kolvo == 3)
		{
			RocketAttachment.SetBoneScale (0, 0.0, 'ERocket01');
			RocketAttachment.SetBoneScale (1, 1.0, 'ERocket02');
			RocketAttachment.SetBoneScale (2, 1.0, 'ERocket03');
			RocketAttachment.SetBoneScale (3, 1.0, 'ERocket04');
		}

		else
		if(Kolvo >= 4)
		{
			RocketAttachment.SetBoneScale (0, 1.0, 'ERocket01');
			RocketAttachment.SetBoneScale (1, 1.0, 'ERocket02');
			RocketAttachment.SetBoneScale (2, 1.0, 'ERocket03');
			RocketAttachment.SetBoneScale (3, 1.0, 'ERocket04');
		}
	}
}


simulated function WeaponTick(float dt)
{
    if( bAimingRifle && ForceZoomOutTime > 0 && Level.TimeSeconds - ForceZoomOutTime > 0 )
    {
	    ForceZoomOutTime = 0;

    	ZoomOut(false);

    	if( Role < ROLE_Authority)
			ServerZoomOut(false);
	}
	else
	{
		if( !bAimingRifle || (ForceZoomOutTime > 0 && Level.TimeSeconds - ForceZoomOutTime > 0) )
		{
			super.WeaponTick(dt);
		}
	}
}

// Force the weapon out of iron sights shortly after firing so the textured
// scope gets the same disadvantage as the 3d scope
simulated function bool StartFire(int Mode)
{
    if( super.StartFire(Mode) )
    {
	if(Mode==0)
	{
        	ForceZoomOutTime = Level.TimeSeconds + 0.4;
	}
	else
	{
		ForceZoomOutTime = Level.TimeSeconds + MagAmmoRemaining*FireMode[Mode].FireRate + 0.4;
	}
        return true;
    }

    return false;
}

defaultproperties
{
    ZoomMat=FinalBlend'M202_T.HUD.ScopeA2'
//    ScriptedTextureFallback=Combiner'KF_Weapons_Trip_T.hands.hands_1stP_military_cmb'
    HudImageRef="M202_T.HUD.M202_Black_unselected"
    SelectedHudImageRef="M202_T.HUD.M202_Black"
    TraderInfoTexture=texture'M202_T.HUD.Trader_M202_Black'
    FireModeClass(0)=Class'M202A2Fire'
    FireModeClass(1)=Class'M202A2AltFire'
    Description="The M202-A2"
    InventoryGroup=4
    GroupOffset=9
    PickupClass=Class'M202A2Pickup'
    AttachmentClass=Class'M202A2Attachment'
    ItemName="M202-A2"
    MeshRef="M202_A.M202"
    SkinRefs(1)="M202_T.items.M202_Color_BlackDT_sh"
    SkinRefs(2)="M202_T.HUD.PricelA2"
    ScopeTexMat=Texture'M202_T.HUD.PricelA2'
    RocketAttachmentClass=class'M202RocketAttachmentFirstPerson'
}