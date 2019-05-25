/**
 * M14EBR version with 2 laser sight modes (green/red)
 * and slightly increased headshot multiplier to 1-headshot kill 6p HoE Husks and Sirens
 *
 * @see Weapon_DamTypeM14EBR
 * @author PooSH, 2012
 */

class Weapon_M14EBRBattleRifle extends M14EBRBattleRifle
    Config(ApocMutators);

var const byte LASER_None;
var const byte LASER_Red;
var const byte LASER_Green;
var const byte LASER_Blue;
var const byte LASER_Orange;
var() globalconfig byte LASER_Count;

var()	byte 							LaserType; 	  //current laser type
var     class<LaserBeamEffect>         	LaserBeamClass;  
var     class<LaserDot>                	LaserDotClass;

replication
{
	reliable if(Role < ROLE_Authority)
		ServerSetLaserType, LaserType;
}

function SpawnBeam()
{
	if (Beam == None)
		Beam = Spawn(LaserBeamClass);
}

simulated function SpawnDot()
{
	if (Spot == None)
		Spot = Spawn(LaserDotClass, self);
	//set dot texture
	Weapon_LaserDot(Spot).SetLaserColor(LaserType);		
}

simulated function PostBeginPlay()
{
	super.PostBeginPlay();

	if (Role == ROLE_Authority) 
		SpawnBeam();
        
    LASER_Count = clamp(LASER_Count, 1, 4);
}

// Use alt fire to switch laser type
simulated function AltFire(float F)
{
	//try to allow switching laser while reloading too
	//if(ReadyToFire(0))
	//{
		ToggleLaser();
	//}
}

static function color GetLaserColor(byte aLaserType)
{
	switch (aLaserType) {
		case default.LASER_Green:
			return class'Canvas'.static.MakeColor(0, 255, 0);
		case default.LASER_Blue:
			// original blue is too dark, so make it a bit lighter 
			return class'Canvas'.static.MakeColor(0, 150, 255);
		case default.LASER_Orange:
			return class'Canvas'.static.MakeColor(255, 150, 0);

	}
	return class'Canvas'.static.MakeColor(255, 0, 0); //red
}

//bring Laser to current state, which is indicating by LaserType 
simulated function ApplyLaserState()
{
	bLaserActive = LaserType != LASER_None;
	if( Role < ROLE_Authority  ) {
		ServerSetLaserType(LaserType);
	}

	if( Beam != none )
	{
		Weapon_LaserBeamEffect(Beam).SetLaserColor(LaserType);
		Beam.SetActive(LaserType != LASER_None);
	}

	if( bLaserActive ) {
		//spawn 1-st person laser attachment for weapon owner
		ConstantColor'ScrnTex.Laser.LaserColor'.Color = GetLaserColor(LaserType);
		//LaserAttachment.Destroy();
		if ( LaserAttachment == none ) {
			LaserAttachment = Spawn(LaserAttachmentClass,,,,);
			AttachToBone(LaserAttachment,'LightBone');
		}
		LaserAttachment.bHidden = false;

		SpawnDot();
	}
	else {
		LaserAttachment.bHidden = true;
		if (Spot != None) { 	
			Spot.Destroy();
		}
	}
}
// Toggle laser modes: RED/GREEN/OFF
simulated function ToggleLaser()
{
	if( !Instigator.IsLocallyControlled() ) return;

	if (!bLaserActive) LaserType = LASER_None;
	LaserType++;
	if (LaserType > LASER_Count) LaserType = LASER_None;

	ApplyLaserState();
}

simulated function BringUp(optional Weapon PrevWeapon)
{
	if (Role == ROLE_Authority)
		SpawnBeam();
		
	ApplyLaserState();
	Super.BringUp(PrevWeapon);
}

simulated function TurnOffLaser()
{
	if( !Instigator.IsLocallyControlled() )
		return;

		if( Role < ROLE_Authority  ) {
			ServerSetLaserType(LASER_None);
		}

		bLaserActive = false;
		//don't change Laser type here, because we need to restore it state 
		//when next time weapon will be bringed up
		LaserAttachment.bHidden = true;

		if( Beam != none ) {
			Beam.SetActive(false);
		}

		if (Spot != None) {
			Spot.Destroy();
		}
}



// Set the new fire mode on the server
function ServerSetLaserType(byte NewLaserType)
{
	if (NewLaserType == LASER_None) 
		bLaserActive = false;
		
	SpawnBeam();
	Weapon_LaserBeamEffect(Beam).SetLaserColor(NewLaserType);
	Beam.SetActive(NewLaserType != LASER_None);

	if( NewLaserType != LASER_None )
	{
		bLaserActive = true;
		SpawnDot();
	}
	else
	{
		bLaserActive = false;
		if (Spot != None) {
			Spot.Destroy();
		}
	}
}

	

defaultproperties
{
     LASER_Red=1
     LASER_Green=2
     Laser_Blue=3
     Laser_Orange=4
     LASER_Count=4
     LaserBeamClass=Class'ApocMutators.Weapon_LaserBeamEffect'
     LaserDotClass=Class'ApocMutators.Weapon_LaserDot'
     LaserAttachmentClass=Class'ApocMutators.Weapon_LaserAttachmentFirstPerson'
     FireModeClass(0)=Class'ApocMutators.Weapon_M14EBRFire'
     Description="Updated M14 Enhanced Battle Rifle - Semi Auto variant. Equipped with a laser sight. A special lens allows to change laser's color on the fly."
     PickupClass=Class'ApocMutators.Weapon_M14EBRPickup'
     ItemName="M14EBR"
}
