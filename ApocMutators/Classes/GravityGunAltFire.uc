Class GravityGunAltFire extends GravityGunFire;

var() sound ChargeStartSnd,DropSnd,GrabSound;

function ModeHoldFire()
{
	if( HL_GravityGun(Weapon).bHasAttached )
	{
		HL_GravityGun(Weapon).DropCarry();

		Weapon.PlayOwnedSound(DropSnd,SLOT_Interact,TransientSoundVolume,,TransientSoundRadius,Default.FireAnimRate/FireAnimRate,false);
		if( Instigator.IsLocallyControlled() )
			Weapon.TweenAnim('Idle',0.1);
		if (bIsFiring)
			NextFireTime += MaxHoldTime + FireRate;
		else NextFireTime = Level.TimeSeconds + FireRate;
		Return;
	}
	if( Instigator.IsLocallyControlled() )
		PlayStartHold();
	Weapon.PlayOwnedSound(ChargeStartSnd,SLOT_Interact,TransientSoundVolume,,TransientSoundRadius,Default.FireAnimRate/FireAnimRate,false);
	if( Weapon.Role==ROLE_Authority )
		SetTimer(0.025,True);
}
function PlayStartHold()
{
	Weapon.PlayOwnedSound(ChargeStartSnd,SLOT_Interact,TransientSoundVolume,,TransientSoundRadius,Default.FireAnimRate/FireAnimRate,false);
	if ( Weapon.Mesh != None )
		Weapon.LoopAnim('HoldIdle',FireAnimRate,0.1);
}
function Timer()
{
	local Actor Other;
	local Vector Start;
	local GravityGunGrab G;

	Start = Instigator.Location + Instigator.EyePosition();
	Other = HL_GravityGun(Weapon).FindGrabActor(Start,AdjustAim(Start, AimError),bOrganicMode);

	if( Other!=None )
	{
		SetTimer(0,false);
		Weapon.PlayOwnedSound(GrabSound,SLOT_Interact,TransientSoundVolume,,TransientSoundRadius,Default.FireAnimRate/FireAnimRate,false);

		HL_GravityGun(Weapon).bHasAttached = true;
		HL_GravityGun(Weapon).GrabbedActor = Other;

		if( Pawn(Other)!=None )
			HL_GravityGun(Weapon).CarryPawn();
		else
		{
			G = Weapon.Spawn(Class'GravityGunGrab',Instigator,,Other.Location);
			G.Attachment = Instigator;
			if( Other.bNetTemporary )
			{
				G.GrabProjClass = Class<Projectile>(Other.Class);
				G.GrabProjInst = Other.Instigator;
			}
			G.GrabProj = Projectile(Other);
			G.ProjStartPosition = Other.Location;
			G.bReelInProjectile = true;
			G.CheckProjType();
			G.WeaponOwner = HL_GravityGun(Weapon);
			HL_GravityGun(Weapon).ProjGrabInfo = G;
			HL_GravityGun(Weapon).CarryProjectile();
		}
	}
}

event ModeDoFire()
{
	// server
	if (Weapon.Role == ROLE_Authority)
	{
		SetTimer(0,False);
		HoldTime = 0;	// if bot decides to stop firing, HoldTime must be reset first
		if ( (Instigator == None) || (Instigator.Controller == None) )
			return;

		if ( AIController(Instigator.Controller) != None )
			AIController(Instigator.Controller).WeaponFireAgain(BotRefireRate, true);

		Instigator.DeactivateSpawnProtection();
	}
	
	if( Instigator.IsLocallyControlled() )
		Weapon.TweenAnim('Idle',0.1);

	// set the next firing time. must be careful here so client and server do not get out of sync
	if (bIsFiring)
		NextFireTime += FireRate;
	else NextFireTime = Level.TimeSeconds + FireRate;
	HoldTime = 0;

	if (Instigator.PendingWeapon != Weapon && Instigator.PendingWeapon != None)
	{
		bIsFiring = false;
		Weapon.PutDown();
	}
}

function PlayPreFire();

defaultproperties
{
     ChargeStartSnd=Sound'HL2WeaponsS.PhysCannon.physcannon_tooheavy'
     DropSnd=Sound'HL2WeaponsS.PhysCannon.physcannon_drop'
     GrabSound=Sound'HL2WeaponsS.PhysCannon.physcannon_pickup'
     bOrganicMode=False
     bFireOnRelease=True
     FireRate=0.500000
}
