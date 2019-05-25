//=============================================================================
// SRHumanPawn
//=============================================================================
class SRHumanPawn extends KFHumanPawn_Story;

var ClientPerkRepLink PerkLink;
var transient float CashTossTimer,LongTossCashTimer;
var transient byte LongTossCashCount;

// Override bad coding in StoryGame
simulated function Fire( optional float F )
{
    Super(Pawn).Fire(F);
}
function AddDefaultInventory()
{
	if( KFStoryGameInfo(Level.Game)!=none )
		Super.AddDefaultInventory();
	else Super(KFHumanPawn).AddDefaultInventory();
}

function ServerSellAmmo( Class<Ammunition> AClass );

final function bool HasWeaponClass( class<Inventory> IC )
{
	local Inventory I;
	
	for ( I=Inventory; I!=None; I=I.Inventory )
		if( I.Class==IC )
			return true;
	return false;
}
final function ClientPerkRepLink FindStats()
{
	local LinkedReplicationInfo L;

	if( Controller==None || Controller.PlayerReplicationInfo==None )
		return None;
	for( L=Controller.PlayerReplicationInfo.CustomReplicationInfo; L!=None; L=L.NextReplicationInfo )
		if( ClientPerkRepLink(L)!=None )
			return ClientPerkRepLink(L);
	return None;
}

function ServerBuyWeapon( Class<Weapon> WClass, float Weight )
{
	local float Price;
	local Inventory I;

	if( !CanBuyNow() || Class<KFWeapon>(WClass)==None || Class<KFWeaponPickup>(WClass.Default.PickupClass)==None || HasWeaponClass(WClass) )
		Return;

	// Validate if allowed to buy that weapon.
	if( PerkLink==None )
		PerkLink = FindStats();
	if( PerkLink!=None && !PerkLink.CanBuyPickup(Class<KFWeaponPickup>(WClass.Default.PickupClass)) )
		return;

	Price = class<KFWeaponPickup>(WClass.Default.PickupClass).Default.Cost;

	if ( KFPlayerReplicationInfo(PlayerReplicationInfo).ClientVeteranSkill != none )
		Price *= KFPlayerReplicationInfo(PlayerReplicationInfo).ClientVeteranSkill.static.GetCostScaling(KFPlayerReplicationInfo(PlayerReplicationInfo), WClass.Default.PickupClass);

	Weight = Class<KFWeapon>(WClass).Default.Weight;

	if( WClass==class'DualDeagle' || WClass==class'GoldenDualDeagle' || WClass==class'Dual44Magnum' || WClass==class'DualMK23Pistol' || WClass==class'DualFlareRevolverPickup' || WClass.Default.DemoReplacement!=None )
	{
		if ( (WClass==class'DualDeagle' && HasWeaponClass(class'Deagle'))
		 || (WClass==class'GoldenDualDeagle' && HasWeaponClass(class'GoldenDeagle'))
		 || (WClass==class'Dual44Magnum' && HasWeaponClass(class'Magnum44Pistol'))
		 || (WClass==class'DualMK23Pistol' && HasWeaponClass(class'MK23Pistol'))
		 || (WClass==class'DualFlareRevolverPickup' && HasWeaponClass(class'FlareRevolver'))
		 || (WClass.Default.DemoReplacement!=None && HasWeaponClass(WClass.Default.DemoReplacement)) )
		{
			if( WClass==class'DualDeagle' )
				Weight-=class'Deagle'.Default.Weight;
			else if( WClass==class'GoldenDualDeagle' )
				Weight-=class'GoldenDeagle'.Default.Weight;
			else if( WClass==class'Dual44Magnum' )
				Weight-=class'Magnum44Pistol'.Default.Weight;
			else if( WClass==class'DualMK23Pistol' )
				Weight-=class'MK23Pistol'.Default.Weight;
			else if( WClass==class'DualFlareRevolverPickup' )
				Weight-=class'FlareRevolverPickup'.Default.Weight;
			else Weight-=class<KFWeapon>(WClass.Default.DemoReplacement).Default.Weight;
			Price*=0.5f;
		}
	}
	else if( WClass==class'Single' || WClass==class'Deagle' || WClass==class'GoldenDeagle' || WClass==class'Magnum44Pistol' || WClass==class'MK23Pistol' || WClass==class'FlareRevolverPickup' )
	{
		if ( (WClass==class'Deagle' && HasWeaponClass(class'DualDeagle'))
		 || (WClass==class'GoldenDeagle' && HasWeaponClass(class'GoldenDualDeagle'))
		 || (WClass==class'Magnum44Pistol' && HasWeaponClass(class'Dual44Magnum'))
		 || (WClass==class'MK23Pistol' && HasWeaponClass(class'DualMK23Pistol'))
		 || (WClass==class'Single' && HasWeaponClass(class'Dualies'))
		 || (WClass==class'FlareRevolverPickup' && HasWeaponClass(class'DualFlareRevolver')) )
			return; // Has the dual weapon.
	}
	else // Check for custom dual weapon mode
	{
		for ( I=Inventory; I!=None; I=I.Inventory )
			if( Weapon(I)!=None && Weapon(I).DemoReplacement==WClass )
				return;
	}

	Price = int(Price); // Truncuate price.

	if ( (Weight>0 && !CanCarry(Weight)) || PlayerReplicationInfo.Score<Price )
		Return;

	I = Spawn(WClass);
	if ( I != none )
	{
		if ( KFGameType(Level.Game) != none )
			KFGameType(Level.Game).WeaponSpawned(I);

		KFWeapon(I).UpdateMagCapacity(PlayerReplicationInfo);
		KFWeapon(I).FillToInitialAmmo();
		KFWeapon(I).SellValue = Price * 0.75;
		I.GiveTo(self);
		PlayerReplicationInfo.Score -= Price;
        ClientForceChangeWeapon(I);
    }
	else ClientMessage("Error: Weapon failed to spawn.");

	SetTraderUpdate();
}
function ServerSellWeapon( Class<Weapon> WClass )
{
	local Inventory I;
	local Weapon NewWep;
	local float Price;

	if ( !CanBuyNow() || Class<KFWeapon>(WClass) == none || Class<KFWeaponPickup>(WClass.Default.PickupClass)==none
		|| Class<KFWeapon>(WClass).Default.bKFNeverThrow )
	{
		SetTraderUpdate();
		Return;
	}

	for ( I = Inventory; I != none; I = I.Inventory )
	{
		if ( I.Class==WClass )
		{
			if ( KFWeapon(I) != none && KFWeapon(I).SellValue != -1 )
				Price = KFWeapon(I).SellValue;
			else
			{
				Price = (class<KFWeaponPickup>(WClass.default.PickupClass).default.Cost * 0.75);

				if ( KFPlayerReplicationInfo(PlayerReplicationInfo).ClientVeteranSkill != none )
					Price *= KFPlayerReplicationInfo(PlayerReplicationInfo).ClientVeteranSkill.static.GetCostScaling(KFPlayerReplicationInfo(PlayerReplicationInfo), WClass.Default.PickupClass);
			}

			if ( I.Class==Class'Dualies' )
			{
				NewWep = Spawn(class'Single');
				Price*=2.f;
			}
			else if ( I.Class==Class'DualDeagle' )
				NewWep = Spawn(class'Deagle');
			else if ( I.Class==Class'GoldenDualDeagle' )
				NewWep = Spawn(class'GoldenDeagle');
			else if ( I.Class==Class'Dual44Magnum' )
				NewWep = Spawn(class'Magnum44Pistol');
			else if ( I.Class==Class'DualMK23Pistol' )
				NewWep = Spawn(class'MK23Pistol');
			else if( Weapon(I).DemoReplacement!=None )
				NewWep = Spawn(Weapon(I).DemoReplacement);
			if( NewWep!=None )
			{
				Price *= 0.5f;
				NewWep.GiveTo(self);
			}

			if ( I==Weapon || I==PendingWeapon )
			{
				ClientCurrentWeaponSold();
			}

			PlayerReplicationInfo.Score += int(Price);

			I.Destroy();

			SetTraderUpdate();

			if ( KFGameType(Level.Game)!=none )
				KFGameType(Level.Game).WeaponDestroyed(WClass);
			return;
		}
	}
}

simulated function AddBlur(Float BlurDuration, float Intensity)
{
	if( KFPC!=none && Viewport(KFPC.Player)!=None )
		Super.AddBlur(BlurDuration,Intensity);
}
simulated function DoHitCamEffects(vector HitDirection, float JarrScale, float BlurDuration, float JarDurationScale )
{
	if( KFPC!=none && Viewport(KFPC.Player)!=None )
		Super.DoHitCamEffects(HitDirection,JarrScale,BlurDuration,JarDurationScale);
}
simulated function StopHitCamEffects()
{
	if( KFPC!=none && Viewport(KFPC.Player)!=None )
		Super.StopHitCamEffects();
}

exec function TossCash( int Amount )
{
	// To fix cash tossing exploit.
	if( CashTossTimer<Level.TimeSeconds && (LongTossCashTimer<Level.TimeSeconds || LongTossCashCount<20) )
	{
		Super.TossCash(50);

		CashTossTimer = Level.TimeSeconds+0.1f;
		if( LongTossCashTimer<Level.TimeSeconds )
		{
			LongTossCashTimer = Level.TimeSeconds+5.f;
			LongTossCashCount = 0;
		}
		else ++LongTossCashCount;
	}
}

function PlayDyingAnimation(class<DamageType> DamageType, vector HitLoc)
{
	local vector shotDir, hitLocRel, deathAngVel, shotStrength;
	local float maxDim;
	local string RagSkelName;
	local KarmaParamsSkel skelParams;
	local bool PlayersRagdoll;
	local PlayerController pc;

	if ( Level.NetMode != NM_DedicatedServer )
	{
		// Is this the local player's ragdoll?
		if(OldController != None)
			pc = PlayerController(OldController);
		if( pc != none && pc.ViewTarget == self )
			PlayersRagdoll = true;

		// In low physics detail, if we were not just controlling this pawn,
		// and it has not been rendered in 3 seconds, just destroy it.
		if( !PlayersRagdoll && (Level.TimeSeconds-LastRenderTime)>3 )
		{
			GoTo'NonRagdoll';
			return;
		}

		// Try and obtain a rag-doll setup. Use optional 'override' one out of player record first, then use the species one.
		if( RagdollOverride != "")
			RagSkelName = RagdollOverride;
		else if(Species != None)
			RagSkelName = Species.static.GetRagSkelName( GetMeshName() );
		else RagSkelName = "Male1"; // Otherwise assume it is Male1 ragdoll were after here.

		KMakeRagdollAvailable();

		if( KIsRagdollAvailable() && RagSkelName != "" )
		{
			skelParams = KarmaParamsSkel(KParams);
			skelParams.KSkeleton = RagSkelName;

			// Stop animation playing.
			StopAnimating(true);

			if( DamageType != None )
			{
				if ( DamageType.default.bLeaveBodyEffect )
					TearOffMomentum = vect(0,0,0);

				if( DamageType.default.bKUseOwnDeathVel )
				{
					RagDeathVel = DamageType.default.KDeathVel;
					RagDeathUpKick = DamageType.default.KDeathUpKick;
				}
			}

			// Set the dude moving in direction he was shot in general
			shotDir = Normal(GetTearOffMomemtum());
			shotStrength = RagDeathVel * shotDir;

			// Calculate angular velocity to impart, based on shot location.
			hitLocRel = TakeHitLocation - Location;

			// We scale the hit location out sideways a bit, to get more spin around Z.
			hitLocRel.X *= RagSpinScale;
			hitLocRel.Y *= RagSpinScale;

			// If the tear off momentum was very small for some reason, make up some angular velocity for the pawn
			if( VSize(GetTearOffMomemtum()) < 0.01 )
			{
				//Log("TearOffMomentum magnitude of Zero");
				deathAngVel = VRand() * 18000.0;
			}
			else deathAngVel = RagInvInertia * (hitLocRel Cross shotStrength);

			// Set initial angular and linear velocity for ragdoll.
			// Scale horizontal velocity for characters - they run really fast!
			if ( DamageType.Default.bRubbery )
				skelParams.KStartLinVel = vect(0,0,0);
			if ( Damagetype.default.bKUseTearOffMomentum )
				skelParams.KStartLinVel = GetTearOffMomemtum() + Velocity;
			else
			{
				skelParams.KStartLinVel.X = 0.6 * Velocity.X;
				skelParams.KStartLinVel.Y = 0.6 * Velocity.Y;
				skelParams.KStartLinVel.Z = 1.0 * Velocity.Z;
				skelParams.KStartLinVel += shotStrength;
			}
			// If not moving downwards - give extra upward kick
			if( !DamageType.default.bLeaveBodyEffect && !DamageType.Default.bRubbery && (Velocity.Z > -10) )
				skelParams.KStartLinVel.Z += RagDeathUpKick;

			if ( DamageType.Default.bRubbery )
			{
				Velocity = vect(0,0,0);
				skelParams.KStartAngVel = vect(0,0,0);
			}
			else
			{
				skelParams.KStartAngVel = deathAngVel;

				// Set up deferred shot-bone impulse
				maxDim = Max(CollisionRadius, CollisionHeight);

				skelParams.KShotStart = TakeHitLocation - (1 * shotDir);
				skelParams.KShotEnd = TakeHitLocation + (2*maxDim*shotDir);
				skelParams.KShotStrength = RagShootStrength;
			}

			// If this damage type causes convulsions, turn them on here.
			if(DamageType != None && DamageType.default.bCauseConvulsions)
			{
				RagConvulseMaterial=DamageType.default.DamageOverlayMaterial;
				skelParams.bKDoConvulsions = true;
			}

			// Turn on Karma collision for ragdoll.
			KSetBlockKarma(true);

			// Set physics mode to ragdoll.
			// This doesn't actaully start it straight away, it's deferred to the first tick.
			SetPhysics(PHYS_KarmaRagdoll);

			// If viewing this ragdoll, set the flag to indicate that it is 'important'
			if( PlayersRagdoll )
				skelParams.bKImportantRagdoll = true;

			skelParams.bRubbery = DamageType.Default.bRubbery;
			bRubbery = DamageType.Default.bRubbery;

			skelParams.KActorGravScale = RagGravScale;

			return;
		}
		// jag
	}

NonRagdoll:
	// non-ragdoll death fallback
	LifeSpan = 0.2f;
}

function float AssessThreatTo(KFMonsterController  Monster, optional bool CheckDistance)
{
    local float ThreatRating;
    local Inventory CurInv;
    local KF_StoryInventoryItem StoryInv;

    ThreatRating = FMax(Super(KFHumanPawn).AssessThreatTo(Monster,CheckDistance),0.1f);

    /* Factor in story Items which adjust your desirability to ZEDs */
    for ( CurInv = Inventory; CurInv != none; CurInv = CurInv.Inventory )
    {
        StoryInv = KF_StoryInventoryItem(CurInv);
        if(StoryInv != none)
            ThreatRating *= StoryInv.AIThreatModifier;
    }

    return ThreatRating;
}

simulated final function int GetFloorSurface()
{
	local int SurfaceTypeID;
	local actor A;
	local vector HL,HN,Start,End;
	local material FloorMat;

	if ( (Base!=None) && (!Base.IsA('LevelInfo')) && (Base.SurfaceType!=0) )
		SurfaceTypeID = Base.SurfaceType;
	else
	{
		Start = Location - Vect(0,0,1)*CollisionHeight;
		End = Start - Vect(0,0,16);
		A = Trace(hl,hn,End,Start,false,,FloorMat);
		if (FloorMat !=None)
			SurfaceTypeID = FloorMat.SurfaceType;
	}
	return SurfaceTypeID;
}
simulated function Sound GetSound(xPawnSoundGroup.ESoundType soundType)
{
	local int SurfaceTypeID;

	if( SoundGroupClass==None )
		SoundGroupClass = Class'KFMaleSoundGroup';
	if( soundType == EST_Land || soundType == EST_Jump )
		SurfaceTypeID = GetFloorSurface();
	return SoundGroupClass.static.GetSound(soundType, SurfaceTypeID);
}

// The player wants to switch to weapon group number F.
simulated function SwitchWeapon(byte F)
{
    local Weapon DesiredWeap;
    local bool AllowSwitch;

	// Fixed script warnings.
	if( Weapon!=None && Weapon.Inventory!=None )
		DesiredWeap = Weapon.Inventory.WeaponChange(F, false);
    if(DesiredWeap == none && Inventory!=None )
        DesiredWeap = Inventory.WeaponChange(F, true);

    if(DesiredWeap != none)
        AllowSwitch = AllowHoldWeapon(DesiredWeap);

    if( AllowSwitch )
        Super(KFPawn).SwitchWeapon(F);
}

simulated function tick(float DeltaTime)
{
	local KF_StoryPRI PRI;

	super(KFPawn).Tick(DeltaTime);

	if( IsLocallyControlled() && !bUsingHitBlur && BlurFadeOutTime > 0 )
	{
		BlurFadeOutTime	-= DeltaTime;
		DeltaTime = BlurFadeOutTime/StartingBlurFadeOutTime * CurrentBlurIntensity;

		if( BlurFadeOutTime <= 0 )
		{
			BlurFadeOutTime = 0;
			StopHitCamEffects();
		}
		else if( bUseBlurEffect && KFPC!=none && !KFPC.PostFX_IsReady() )
		{
			if( CameraEffectFound != none )
				UnderWaterBlur(CameraEffectFound).BlurAlpha = Lerp( DeltaTime, 255, UnderWaterBlur(CameraEffectFound).default.BlurAlpha );
			else KFPC.SetBlur(DeltaTime);
		}
    }

	/* Replicated Location stuff - for tracking this pawn's position to display icons when its not relevant */
	PRI = KF_StoryPRI(PlayerReplicationInfo);
	if(PRI != none && PRI.GetFloatingIconMat() != none)
	{
		if(Role == Role_Authority)  // server authoritative
		{
			if(PRI.GetOwnerPawn() != self)
			{
				PRI.SetOwnerPawn(self);
				PRI.NetUpdateTime = Level.TimeSeconds - 1;
			}
			KF_StoryPRI(PlayerReplicationInfo).SetReplicatedPawnLoc(GetHoverIconPosition());
		}
		else if(bDeleteMe || bPendingDelete) // simulated proxy.
		{
			PRI.SetOwnerPawn(none);
			PRI.NetUpdateTime = Level.TimeSeconds - 1;
		}
	}
}
