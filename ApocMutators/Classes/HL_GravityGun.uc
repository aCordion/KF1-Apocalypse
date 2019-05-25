Class HL_GravityGun extends HL2WeaponNA;

var() color EnergyColor;
var() float GrabRange;
var() Sound HoldLoopSound;
var GravityGunGrab ProjGrabInfo;
var Actor GrabbedActor;
var float DragInTime;
var vector GrabStartPos;
var transient vector CarryDest;
var transient FX_GravityGunDot EnergyDots[3];
var transient FX_GravityGunBolts Bolts[2];
var transient float NextGrabCheckTime;

var bool bHasAttached,bDragIn,bCarryingPawn,bWasGrabbing,bTargetAquired,bHadTarget;
var() bool bIsOrganic;

replication
{
	reliable if( Role==ROLE_Authority && bNetOwner )
		bHasAttached,GrabbedActor;
}

simulated event RenderOverlays( Canvas Canvas )
{
    if (Instigator == None)
        return;
	if ( Instigator.Controller != None )
		Hand = Instigator.Controller.Handedness;
    if ((Hand < -1.0) || (Hand > 1.0))
        return;

	if( EnergyDots[0]==None )
	{
		EnergyDots[0] = Spawn(Class'FX_GravityGunDot');
		EnergyDots[0].SetDrawScale(0.3);
		AttachToBone(EnergyDots[0],'Muzzle');
		EnergyDots[1] = Spawn(Class'FX_GravityGunDot');
		EnergyDots[1].SetDrawScale(0.1);
		AttachToBone(EnergyDots[1],'Tip_A');
		EnergyDots[2] = Spawn(Class'FX_GravityGunDot');
		EnergyDots[2].SetDrawScale(0.1);
		AttachToBone(EnergyDots[2],'Tip_B');
		
		Bolts[0] = Spawn(Class'FX_GravityGunBolts');
		Bolts[0].SetColor(EnergyColor);
		AttachToBone(Bolts[0],'Tip_A');
		Bolts[1] = Spawn(Class'FX_GravityGunBolts');
		Bolts[1].SetColor(EnergyColor);
		AttachToBone(Bolts[1],'Tip_B');
		Bolts[0].SetRelativeRotation(rot(-10000,32768,0));
		Bolts[0].SetRelativeLocation(vect(0,0,0.5));
		Bolts[1].SetRelativeRotation(rot(6000,20000,0));
		Bolts[1].SetRelativeLocation(vect(0,-0.5,-0.5));

		bWasGrabbing = !bHasAttached; // Force update instantly.
		bHadTarget = !bTargetAquired;
		
		AnimBlendParams(1,1.f,,,'Prong_A');
		AnimBlendParams(2,1.f,,,'Prong_B');
	}
	if( bWasGrabbing!=bHasAttached )
	{
		bWasGrabbing = bHasAttached;
		Bolts[0].bHidden = !bHasAttached;
		Bolts[1].bHidden = !bHasAttached;
		EnergyDots[1].bHidden = !bHasAttached;
		EnergyDots[2].bHidden = !bHasAttached;
		
		if( bHasAttached )
		{
			Instigator.AmbientSound = HoldLoopSound;
			Instigator.SoundVolume = 128;
		}
		else
		{
			Instigator.AmbientSound = Instigator.Default.AmbientSound;
			Instigator.SoundVolume = Instigator.Default.SoundVolume;
		}
	}
	if( NextGrabCheckTime<Level.TimeSeconds )
	{
		NextGrabCheckTime = Level.TimeSeconds+0.5f;
		bTargetAquired = (FindGrabActor(Instigator.Location+Instigator.EyePosition(),Instigator.GetViewRotation(),true)!=None);
	}
	if( bHadTarget!=(bHasAttached || bTargetAquired) )
	{
		bHadTarget = (bHasAttached || bTargetAquired);
		if( bHadTarget )
		{
			PlayAnim('P_Open',1,0.15,1);
			PlayAnim('P_Open',1,0.15,2);
			PlaySound(Sound'physcannon_claws_open',SLOT_Misc,1.f);
		}
		else
		{
			PlayAnim('P_Shut',1,0.15,1);
			PlayAnim('P_Shut',1,0.15,2);
			PlaySound(Sound'physcannon_claws_close',SLOT_Misc,1.f);
		}
	}
	ColorModifier'PhysCanColorMod'.Color = EnergyColor;
	Super.RenderOverlays(Canvas);
}
function CarryPawn()
{
	CarryProjectile();
	bDragIn = true;
	DragInTime = 0.f;
	bCarryingPawn = true;
	GrabStartPos = GrabbedActor.Location;
}
function CarryProjectile()
{
	bCarryingPawn = false;
	Instigator.AmbientSound = HoldLoopSound;
	Instigator.SoundVolume = 128;
}
simulated function LostCarry()
{
	ProjGrabInfo = None;
	GrabbedActor = None;
	bHasAttached = false;
	if( Role==ROLE_Authority && Instigator!=None )
	{
		Instigator.AmbientSound = Instigator.Default.AmbientSound;
		Instigator.SoundVolume = Instigator.Default.SoundVolume;
	}
}
simulated function DropCarry()
{
	bHasAttached = false;
	if( Role==ROLE_Authority && ProjGrabInfo!=None )
		ProjGrabInfo.LaunchProjectile(vect(0,0,0));
	ProjGrabInfo = None;
	GrabbedActor = None;
	if( Instigator!=None )
	{
		Instigator.AmbientSound = Instigator.Default.AmbientSound;
		Instigator.SoundVolume = Instigator.Default.SoundVolume;
	}
}
function LaunchCarry( vector Dir )
{
	local GravityGunKillWatch K;

	bHasAttached = false;
	if( ProjGrabInfo!=None && ProjGrabInfo.GrabProj!=None )
		ProjGrabInfo.LaunchProjectile(Dir*FMax(ProjGrabInfo.GrabProj.Speed,800.f));
	else if( bCarryingPawn && GrabbedActor!=None && Pawn(GrabbedActor).Health>0 )
	{
		if( KFMonster(GrabbedActor)!=None )
			KFMonster(GrabbedActor).FlipOver();
		Pawn(GrabbedActor).AddVelocity(1600.f*Dir);
		if( bIsOrganic )
		{
			K = Spawn(Class'GravityGunKillWatch',,,GrabbedActor.Location);
			K.AttachTo(Pawn(GrabbedActor));
		}
	}
	Instigator.AmbientSound = Instigator.Default.AmbientSound;
	Instigator.SoundVolume = Instigator.Default.SoundVolume;
	ProjGrabInfo = None;
	GrabbedActor = None;
}

/* Security checks - Drop carrying if weapon switching */
simulated function Tick( float Delta )
{
	if( bHasAttached )
	{
		if( Instigator==None || Instigator.Weapon!=Self )
			DropCarry();
		else if( bCarryingPawn )
		{
			CarryDest = Instigator.Location+Instigator.EyePosition()+vector(Instigator.Rotation)
				*(Instigator.CollisionRadius+GrabbedActor.CollisionRadius+20.f);

			if( GrabbedActor==None || Pawn(GrabbedActor).Health<=0 || !FastTrace(CarryDest,GrabbedActor.Location) )
				DropCarry();
			else
			{
				if( GrabbedActor.Physics!=PHYS_Falling && GrabbedActor.Physics!=PHYS_Flying )
					GrabbedActor.SetPhysics(PHYS_Falling);
					
				if( KFMonsterController(Pawn(GrabbedActor).Controller)!=None
				 && !Pawn(GrabbedActor).Controller.IsInState('ZombieRestFormation') )
					Pawn(GrabbedActor).Controller.GotoState('ZombieRestFormation');

				if( bDragIn )
				{
					GrabbedActor.Velocity = Normal(CarryDest-GrabStartPos)*600.f;
					DragInTime+=Delta*3.f;
					if( DragInTime>=1.f )
						bDragIn = false;
					else GrabbedActor.Move(GrabStartPos+(CarryDest-GrabStartPos)*DragInTime-GrabbedActor.Location);
				}
				else
				{
					GrabbedActor.Velocity = vect(0,0,0);
					GrabbedActor.Move(CarryDest-GrabbedActor.Location);
					GrabbedActor.SetRotation(Instigator.Rotation);
					if( VSize(GrabbedActor.Location-CarryDest)>100.f )
						DropCarry();
				}
			}
		}
	}
	Super.Tick(Delta);
}
simulated function Destroyed()
{
	local byte i;
	
	for( i=0; i<ArrayCount(EnergyDots); ++i )
		if( EnergyDots[i]!=None )
			EnergyDots[i].Destroy();
	for( i=0; i<ArrayCount(Bolts); ++i )
		if( Bolts[i]!=None )
			Bolts[i].Destroy();
	if( bHasAttached )
		DropCarry();
	Super.Destroyed();
}
simulated function bool PutDown()
{
	if( bHasAttached )
		DropCarry();
	return Super.PutDown();
}

simulated function Actor FindGrabActor( vector Start, rotator Dir, bool bOrganicMode )
{
	local Vector X;
	local Actor Other,Best;
	local float D,BestD;
	local HL_GravityGun GG;
	local bool bPawns;

	X = Vector(Dir);
	bPawns = (bOrganicMode || bIsOrganic);

	foreach CollidingActors(Class'Actor',Other,GrabRange,Start+X*GrabRange*0.5)
	{
		if( Other!=Instigator && ((bPawns && Pawn(Other)!=None && KFPawn(Other)==None && Vehicle(Other)==None && Pawn(Other).Health>0
		&& (Monster(Other)==None || !Monster(Other).bBoss))
		|| (Projectile(Other)!=None && FlakChunk(Other)==None && ShotgunBullet(Other)==None && BioGlob(Other)==None))
		 && VSize(Other.Location-Start)<GrabRange )
		{
			D = Normal(Other.Location-Start) Dot X;
			if( D<0.6 )
				continue;
			D = (2000.f-VSize(Other.Location-Start))*(D-0.5f);
			if( (Best==None || D>BestD) && Instigator.FastTrace(Other.Location,Start) )
			{
				// At final stage, make sure nobody is carrying this projectile/specimen already.
				foreach DynamicActors(Class'HL_GravityGun',GG)
					if( GG.GrabbedActor==Other )
						break;
				if( GG!=None )
					continue;
				Best = Other;
				BestD = D;
			}
		}
	}
	return Best;
}

defaultproperties
{
     EnergyColor=(G=64,R=128,A=255)
     GrabRange=600.000000
     HoldLoopSound=Sound'HL2WeaponsS.PhysCannon.hold_loop'
     FlashBoneName="Bip01_R_Hand"
     HudImage=Texture'HL2WeaponsA.Icons.I_GravGun'
     SelectedHudImage=Texture'HL2WeaponsA.Icons.I_GravGun'
     Weight=5.000000
     StandardDisplayFOV=75.000000
     TraderInfoTexture=Texture'HL2WeaponsA.Icons.I_GravGun'
     FireModeClass(0)=Class'ApocMutators.GravityGunFire'
     FireModeClass(1)=Class'ApocMutators.GravityGunAltFire'
     Description="A Zero Point Energy Manipulator."
     Priority=50
     InventoryGroup=4
     GroupOffset=5
     PickupClass=Class'ApocMutators.HL_GravityGunPickup'
     PlayerViewPivot=(Yaw=-16384)
     AttachmentClass=Class'ApocMutators.GravityGunAttachment'
     ItemName="Zero Point Energy Manipulator"
     Mesh=SkeletalMesh'HL2WeaponsA.HL_PhysCannon'
     SoundRadius=40.000000
}
