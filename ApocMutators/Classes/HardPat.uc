class HardPat extends ZEDS_ZombieBoss
	config(ApocMutators);

//kyan: add
var config float HardPatHealthModifier;

var transient float GiveUpTime;
var byte MissilesLeft;
var bool bValidBoss,bMovingChaingunAttack;
var float MGDamageLevels[4];

replication
{
	reliable if( ROLE==ROLE_AUTHORITY )
		bMovingChaingunAttack;
}

//kyan: add
function bool CheckReplacement(Actor Other, out byte bSuperRelevant)
{
    if (HardPat(Other) != none)
    {
        HardPat(Other).HealthMax = 30000;
        HardPat(Other).Health = 30000;
    }

    return true;
}

//kyan: add
final function bool CheckJumpReach( Actor A )
{
	local vector E,End,Dummy;

	E.X = FMin(CollisionRadius,A.CollisionRadius);
	E.Y = E.X;
	E.Z = FMin(CollisionHeight,A.CollisionHeight);

	End = (Location+A.Location)*0.5f;
	//End.Z = FMax(Location.Z,A.Location.Z)+350.f;
	End.Z = FMax(Location.Z,A.Location.Z) + (350.f * (FRand() * 3));
	return (Trace(Dummy,Dummy,End,Location,false,E)==None && A.Trace(Dummy,Dummy,End,A.Location,false,E)==None);
}

//kyan: add
final function float GetJumpHeight( Actor A )
{
	return (FMax(A.Location.Z-Location.Z,0.f)+1000.f);
}

//kyan: add
// Scales the health this Zed has by number of players
function float NumPlayersHealthModifer()
{
	local float AdjustedModifier;
	local int NumEnemies;
	local Controller C;

	AdjustedModifier = 1.0;

	For( C=Level.ControllerList; C!=None; C=C.NextController )
		if( C.bIsPlayer && C.Pawn!=None && C.Pawn.Health > 0 )
			NumEnemies++;

	if( NumEnemies > 1 )
		AdjustedModifier += (NumEnemies - 1) * PlayerCountHealthScale;

	return AdjustedModifier * HardPatHealthModifier;
}

//kyan: add
// Scales the head health this Zed has by number of players
function float NumPlayersHeadHealthModifer()
{
	local float AdjustedModifier;
	local int NumEnemies;
	local Controller C;

	AdjustedModifier = 1.0;

	For( C=Level.ControllerList; C!=None; C=C.NextController )
		if( C.bIsPlayer && C.Pawn!=None && C.Pawn.Health > 0 )
			NumEnemies++;

	if( NumEnemies > 1 )
		AdjustedModifier += (NumEnemies - 1) * PlayerNumHeadHealthScale;

	return AdjustedModifier * HardPatHealthModifier;
}

function bool MakeGrandEntry()
{
	bValidBoss = true;
	return Super.MakeGrandEntry();
}
function Died(Controller Killer, class<DamageType> damageType, vector HitLocation)
{
	if( bValidBoss )
		Super.Died(Killer,damageType,HitLocation);
	else Super(KFMonster).Died(Killer,damageType,HitLocation);
}

simulated function bool HitCanInterruptAction()
{
	return (!bWaitForAnim && !bShotAnim);
}

function RangedAttack(Actor A)
{
	local float D;
	local bool bOnlyE;
	local bool bDesireChainGun;

	// Randomly make him want to chaingun more
	if( Controller.LineOfSightTo(A) && FRand() < 0.15 && LastChainGunTime<Level.TimeSeconds )
	{
		bDesireChainGun = true;
	}

	if ( bShotAnim )
	{
		if( !IsAnimating(ExpectingChannel) )
			bShotAnim = false;
		return;
	}
	D = VSize(A.Location-Location);
	bOnlyE = (Pawn(A)!=None && OnlyEnemyAround(Pawn(A)));
	if ( IsCloseEnuf(A) )
	{
		bShotAnim = true;

		//kyan: add
		if (FRand() < 0.50)
		{
			Acceleration = vect(0,0,0);
			SetAnimAction('PreFireMissile');

			HandleWaitForAnim('PreFireMissile');

			GoToState('FireMissile');
		}
		else
		{
			if( Health>1500 && Pawn(A)!=None && FRand() < 0.5 )
			{
				SetAnimAction('MeleeImpale');
			}
			else
			{
				SetAnimAction('MeleeClaw');
				//PlaySound(sound'Claw2s', SLOT_None); KFTODO: Replace this
			}
		}
	}
	else if( Level.TimeSeconds>LastSneakedTime )
	{
		if( FRand() < 0.3 )
		{
			// Wait another 20-40 to try this again
			LastSneakedTime = Level.TimeSeconds+20.f+FRand()*20;
			Return;
		}
		SetAnimAction('transition');
		GoToState('SneakAround');
	}
	else if( bChargingPlayer && (bOnlyE || D<200) )
		Return;
	else if( !bDesireChainGun && !bChargingPlayer && (D<300 || (D<700 && bOnlyE)) &&
		(Level.TimeSeconds - LastChargeTime > (5.0 + 5.0 * FRand())) )  // Don't charge again for a few seconds
	{
		SetAnimAction('transition');
		GoToState('Charging');
	}
	/*kyan: removed
	else if( LastMissileTime<Level.TimeSeconds && (D>500 || SyringeCount>=2) )*/
	//kyan: modified
	else if( LastMissileTime<Level.TimeSeconds)
	{
		/*kyan: removed
		if( !Controller.LineOfSightTo(A) || FRand() > 0.75 )*/
		//kyan: add
		if( !Controller.LineOfSightTo(A) || FRand() > 0.65 )
		{
			LastMissileTime = Level.TimeSeconds+FRand() * 5;
			Return;
		}

		LastMissileTime = Level.TimeSeconds + 10 + FRand() * 15;

		bShotAnim = true;
		Acceleration = vect(0,0,0);
		SetAnimAction('PreFireMissile');

		HandleWaitForAnim('PreFireMissile');

		GoToState('FireMissile');
	}
	else if ( !bWaitForAnim && !bShotAnim && LastChainGunTime<Level.TimeSeconds )
	{
		if ( !Controller.LineOfSightTo(A) || FRand()> 0.85 )
		{
			LastChainGunTime = Level.TimeSeconds+FRand()*4;
			Return;
		}

		LastChainGunTime = Level.TimeSeconds + 5 + FRand() * 10;

		bShotAnim = true;
		Acceleration = vect(0,0,0);
		SetAnimAction('PreFireMG');

		HandleWaitForAnim('PreFireMG');
		MGFireCounter = Rand(60) + 35*(SyringeCount+1);

		GoToState('FireChaingun');
	}
	//kyan: add
	else if ( D < 700.f && Controller.ActorReachable(A) && CheckJumpReach(A) && FRand() > 0.75)
	{
		Controller.MoveTarget = A;
		Acceleration = vect(0,0,0);
		SetPhysics(PHYS_Falling);
		Velocity = SuggestFallVelocity(A.Location+A.Velocity+vect(0,0,1)*(A.CollisionHeight+CollisionHeight),Location,GetJumpHeight(A),FMax(D*1.5f,200));
		PlaySound(JumpSound,SLOT_Interact);
		Controller.GoToState('ZombieHunt','Begin');
	}
}

simulated function bool AnimNeedsWait(name TestAnim)
{
	if( TestAnim == 'FireMG' )
		return !bMovingChaingunAttack;
	return Super.AnimNeedsWait(TestAnim);
}
simulated final function rotator GetBoneTransRot()
{
	local rotator R;

	R.Yaw = 24576+Rotation.Yaw;
	R.Pitch = 16384+Rotation.Pitch;
	return R;
}
simulated function int DoAnimAction( name AnimName )
{
	if( AnimName=='FireMG' && bMovingChaingunAttack )
	{
		AnimBlendParams(1, 1.0, 0.0,, FireRootBone, True);
		//SetBoneDirection(FireRootBone,GetBoneTransRot(),,1,1);
		PlayAnim('FireMG',, 0.f, 1);
		return 1;
	}
	else if( AnimName=='FireEndMG' )
	{
		//SetBoneDirection(FireRootBone,rot(0,0,0),,0,0);
		AnimBlendParams(1, 0);
	}
	return Super.DoAnimAction( AnimName );
}
simulated function AnimEnd(int Channel)
{
	local name  Sequence;
	local float Frame, Rate;

	if( Level.NetMode==NM_Client && bMinigunning )
	{
		GetAnimParams( Channel, Sequence, Frame, Rate );

		if( Sequence != 'PreFireMG' && Sequence != 'FireMG' )
		{
			//SetBoneDirection(FireRootBone,rot(0,0,0),,0,0);
			Super(KFMonster).AnimEnd(Channel);
			return;
		}

		if( bMovingChaingunAttack )
			DoAnimAction('FireMG');
		else
		{
			PlayAnim('FireMG');
			bWaitForAnim = true;
			bShotAnim = true;
			IdleTime = Level.TimeSeconds;
		}
	}
	else
	{
		//SetBoneDirection(FireRootBone,rot(0,0,0),,0,0);
		Super(KFMonster).AnimEnd(Channel);
	}
}

// Fix: Don't spawn needle before last stage.
simulated function NotifySyringeA()
{
	if( Level.NetMode!=NM_Client )
	{
		if( SyringeCount<3 )
			SyringeCount++;
		if( Level.NetMode!=NM_DedicatedServer )
			 PostNetReceive();
	}
	if( Level.NetMode!=NM_DedicatedServer )
		DropNeedle();
}
simulated function NotifySyringeC()
{
	if( Level.NetMode!=NM_DedicatedServer )
	{
		CurrentNeedle = Spawn(Class'BossHPNeedle');
		CurrentNeedle.Velocity = vect(-45,300,-90) >> Rotation;
		DropNeedle();
	}
}

simulated function ZombieCrispUp() // Don't become crispy.
{
	bAshen = true;
	bCrispified = true;
	SetBurningBehavior();
}

state KnockDown
{
	Ignores RangedAttack;
}
state FireChaingun
{
	function BeginState()
	{
		Super.BeginState();

		/*kyan: removed
		bMovingChaingunAttack = (SyringeCount>=2);
		bChargingPlayer = (SyringeCount>=3 && FRand()<0.4f);*/

		//kyan: modified
		bMovingChaingunAttack = (SyringeCount>=0);
		bChargingPlayer = (SyringeCount>=0 && FRand()<0.4f);

		bCanStrafe = true;
	}
	function EndState()
	{
		bChargingPlayer = false;
		Super.EndState();
		bMovingChaingunAttack = false;
		bCanStrafe = false;
	}
	function Tick( float Delta )
	{
		Super(KFMonster).Tick(Delta);

		/*kyan: removed
		if( bChargingPlayer )
			GroundSpeed = OriginalGroundSpeed * 2.3;
		else GroundSpeed = OriginalGroundSpeed * 1.15;*/

		//kyan: modified
		if( bChargingPlayer )
			GroundSpeed = OriginalGroundSpeed * 1.80;//2.00;
		else GroundSpeed = OriginalGroundSpeed * 1.50;//1.15;//1.25;

		//kyan: add
		switch (SyringeCount)
		{
		case 0: MGDamage = MGDamageLevels[0]; break;
		case 1: MGDamage = MGDamageLevels[1]; break;
		case 2: MGDamage = MGDamageLevels[2]; break;
		case 3: MGDamage = MGDamageLevels[3]; break;
		}
	}

	function AnimEnd( int Channel )
	{
		if( MGFireCounter <= 0 )
		{
			bShotAnim = true;
			Acceleration = vect(0,0,0);
			SetAnimAction('FireEndMG');
			HandleWaitForAnim('FireEndMG');
			GoToState('');
		}
		else if( bMovingChaingunAttack )
		{
			if( bFireAtWill && Channel!=1 )
				return;
			if( Controller.Target!=None )
				Controller.Focus = Controller.Target;
			bShotAnim = false;
			bFireAtWill = True;
			SetAnimAction('FireMG');
		}
		else
		{
			if ( Controller.Enemy != none )
			{
				if ( Controller.LineOfSightTo(Controller.Enemy) && FastTrace(GetBoneCoords('tip').Origin,Controller.Enemy.Location))
				{
					MGLostSightTimeout = 0.0;
					Controller.Focus = Controller.Enemy;
					Controller.FocalPoint = Controller.Enemy.Location;
				}
				else
				{
					MGLostSightTimeout = Level.TimeSeconds + (0.25 + FRand() * 0.35);
					Controller.Focus = None;
				}
				Controller.Target = Controller.Enemy;
			}
			else
			{
				MGLostSightTimeout = Level.TimeSeconds + (0.25 + FRand() * 0.35);
				Controller.Focus = None;
			}

			if( !bFireAtWill )
			{
				MGFireDuration = Level.TimeSeconds + (0.75 + FRand() * 0.5);
			}
			else if ( FRand() < 0.03 && Controller.Enemy != none && PlayerController(Controller.Enemy.Controller) != none )
			{
				// Randomly send out a message about Patriarch shooting chain gun(3% chance)
				PlayerController(Controller.Enemy.Controller).Speech('AUTO', 9, "");
			}

			bFireAtWill = True;
			bShotAnim = true;
			Acceleration = vect(0,0,0);

			SetAnimAction('FireMG');
			bWaitForAnim = true;
		}
	}
	function TakeDamage( int Damage, Pawn InstigatedBy, Vector Hitlocation, Vector Momentum, class<DamageType> damageType, optional int HitIndex)
	{
		local float EnemyDistSq, DamagerDistSq;

		global.TakeDamage(Damage,instigatedBy,hitlocation,vect(0,0,0),damageType);
		if( bMovingChaingunAttack || Health<=0 )
			return;

		// if someone close up is shooting us, just charge them
		if( InstigatedBy != none )
		{
			DamagerDistSq = VSizeSquared(Location - InstigatedBy.Location);

			if( (ChargeDamage > 200 && DamagerDistSq < (500 * 500)) || DamagerDistSq < (100 * 100) )
			{
				SetAnimAction('transition');
				GoToState('Charging');
				return;
			}
		}

		if( Controller.Enemy != none && InstigatedBy != none && InstigatedBy != Controller.Enemy )
		{
			EnemyDistSq = VSizeSquared(Location - Controller.Enemy.Location);
			DamagerDistSq = VSizeSquared(Location - InstigatedBy.Location);
		}

		if( InstigatedBy != none && (DamagerDistSq < EnemyDistSq || Controller.Enemy == none) )
		{
			MonsterController(Controller).ChangeEnemy(InstigatedBy,Controller.CanSee(InstigatedBy));
			Controller.Target = InstigatedBy;
			Controller.Focus = InstigatedBy;

			if( DamagerDistSq < (500 * 500) )
			{
				SetAnimAction('transition');
				GoToState('Charging');
			}
		}
	}

Begin:
	While( True )
	{
		if( !bMovingChaingunAttack )
			Acceleration = vect(0,0,0);

		if( MGLostSightTimeout > 0 && Level.TimeSeconds > MGLostSightTimeout )
		{
			Acceleration = vect(0,0,0);
			bShotAnim = true;
			Acceleration = vect(0,0,0);
			SetAnimAction('FireEndMG');
			HandleWaitForAnim('FireEndMG');
			GoToState('');
		}

		if( MGFireCounter <= 0 )
		{
			bShotAnim = true;
			Acceleration = vect(0,0,0);
			SetAnimAction('FireEndMG');
			HandleWaitForAnim('FireEndMG');
			GoToState('');
		}

		// Give some randomness to the patriarch's firing (constantly fire after first stage passed)
		if( Level.TimeSeconds > MGFireDuration && SyringeCount==0 )
		{
			if( AmbientSound != MiniGunSpinSound )
			{
				SoundVolume=185;
				SoundRadius=200;
				AmbientSound = MiniGunSpinSound;
			}
			Sleep(0.5 + FRand() * 0.75);
			MGFireDuration = Level.TimeSeconds + (0.75 + FRand() * 0.5);
		}
		else
		{
			if( bFireAtWill )
				FireMGShot();
			Sleep(0.05);
		}
	}
}

state FireMissile
{
	function RangedAttack(Actor A)
	{
		/*kyan: removed
		if( SyringeCount>=2 )
		{*/
			Controller.Target = A;
			Controller.Focus = A;
		/*kyan: removed
		}*/
	}
	function BeginState()
	{
		MissilesLeft = SyringeCount+Rand(SyringeCount);
		Acceleration = vect(0,0,0);
	}

	function AnimEnd( int Channel )
	{
		local vector Start;
		local Rotator R;

		Start = GetBoneCoords('tip').Origin;
		if( Controller.Target==None )
			Controller.Target = Controller.Enemy;

		if ( !SavedFireProperties.bInitialized )
		{
			SavedFireProperties.AmmoClass = MyAmmo.Class;
			SavedFireProperties.ProjectileClass = Class'HardPatBossLAWProj';
			SavedFireProperties.WarnTargetPct = 0.15;
			SavedFireProperties.MaxRange = 10000;
			SavedFireProperties.bTossed = False;
			SavedFireProperties.bLeadTarget = True;
			SavedFireProperties.bInitialized = true;
		}
		SavedFireProperties.bInstantHit = (SyringeCount<1);
		SavedFireProperties.bTrySplash = (SyringeCount>=2);

		R = AdjustAim(SavedFireProperties,Start,100);
		PlaySound(RocketFireSound,SLOT_Interact,2.0,,TransientSoundRadius,,false);
		Spawn(Class'HardPatBossLAWProj',,,Start,R);

		bShotAnim = true;
		Acceleration = vect(0,0,0);
		SetAnimAction('FireEndMissile');
		HandleWaitForAnim('FireEndMissile');

		// Randomly send out a message about Patriarch shooting a rocket(5% chance)
		if ( FRand() < 0.05 && Controller.Enemy != none && PlayerController(Controller.Enemy.Controller) != none )
		{
			PlayerController(Controller.Enemy.Controller).Speech('AUTO', 10, "");
		}

		if( MissilesLeft==0 )
			GoToState('');
		else
		{
			--MissilesLeft;
			GoToState(,'SecondMissile');
		}
	}
Begin:
	while ( true )
	{
		Acceleration = vect(0,0,0);
		Sleep(0.1);
	}
SecondMissile:
	Acceleration = vect(0,0,0);
	Sleep(0.5f);
	AnimEnd(0);
}

State Escaping // Added god-mode.
{
	Ignores TakeDamage,RangedAttack;

	function BeginState()
	{
		GiveUpTime = Level.TimeSeconds+20.f+FRand()*20.f;
		Super.BeginState();
		bBlockActors = false;
	}
	function EndState()
	{
		Super.EndState();
		if( Health>0 )
			bBlockActors = true;
	}
	function Tick( float Delta )
	{
		if( Level.TimeSeconds>GiveUpTime )
		{
			BeginHealing();
			return;
		}
		if( !bChargingPlayer )
		{
			bChargingPlayer = true;
			if( Level.NetMode!=NM_DedicatedServer )
				PostNetReceive();
		}
		GroundSpeed = OriginalGroundSpeed * 2.5;
		Global.Tick(Delta);
	}
}

State SneakAround
{
	function BeginState()
	{
		super.BeginState();
		SneakStartTime = Level.TimeSeconds+10.f+FRand()*15.f;
	}
	function EndState()
	{
		super.EndState();
		LastSneakedTime = Level.TimeSeconds+20.f+FRand()*30.f;
		if( Controller!=None && Controller.IsInState('PatFindWay') )
			Controller.GoToState('ZombieHunt');
	}
	function TakeDamage( int Damage, Pawn InstigatedBy, Vector Hitlocation, Vector Momentum, class<DamageType> damageType, optional int HitIndex)
	{
		global.TakeDamage(Damage,instigatedBy,hitlocation,vect(0,0,0),damageType);
		if( Health<=0 )
			return;

		// if someone close up is shooting us, just charge them
		if( InstigatedBy!=none && VSizeSquared(Location - InstigatedBy.Location)<62500 )
			GoToState('Charging');
		}

Begin:
	CloakBoss();

	/*kyan: removed
	if( SyringeCount>=2 && FRand()<0.6 )*/
	//kyan: modified
	if( SyringeCount>=0 && FRand()<0.6 )
		HardPatController(Controller).FindPathAround();
	While( true )
	{
		Sleep(0.5);

		if( !bCloaked && !bShotAnim )
			CloakBoss();
		if( !Controller.IsInState('PatFindWay') )
		{
			if( Level.TimeSeconds>SneakStartTime )
				GoToState('');
			if( !Controller.IsInState('WaitForAnim') && !Controller.IsInState('ZombieHunt') )
				Controller.GoToState('ZombieHunt');
		}
		else SneakStartTime = Level.TimeSeconds+30.f;
	}
}

//kyan add
// State of doing a radial damaging attack that we do when poeple are trying to melee exploit
state RadialAttack
{
	Ignores RangedAttack;

	function bool ShouldChargeFromDamage()
	{
		return false;
	}

	function Tick( float Delta )
	{
		Acceleration = vect(0,0,0);

		//DrawDebugSphere( Location, 150, 12, 0, 255, 0);

		global.Tick(Delta);
	}

	function ClawDamageTarget()
	{
		local vector PushDir;
		local float UsedMeleeDamage;
		local bool bDamagedSomeone, bDamagedThisHit;
		local KFHumanPawn P;
		local Actor OldTarget;
		local float RadialDamageBase;

		MeleeRange = 150;

		if(Controller!=none && Controller.Target!=none)
			PushDir = (damageForce * Normal(Controller.Target.Location - Location));
		else
			PushDir = damageForce * vector(Rotation);


		OldTarget = Controller.Target;

		CurrentDamtype = ZombieDamType[0];

		// Damage all players within a radius
		foreach DynamicActors(class'KFHumanPawn', P)
		{
			if ( VSize(P.Location - Location) < MeleeRange)
			{
				Controller.Target = P;

				// This attack cuts through shields, so crank up the damage if they have a lot of shields
				if( P.ShieldStrength >= 50 )
				{
					RadialDamageBase = 240;
				}
				else
				{
					RadialDamageBase = 120;
				}

				// Randomize the damage a bit so everyone gets really hurt, but only some poeple die
				UsedMeleeDamage = (RadialDamageBase - (RadialDamageBase * 0.55)) + (RadialDamageBase * (FRand() * 0.45));
				//log("UsedMeleeDamage = "$UsedMeleeDamage);

				bDamagedThisHit =  MeleeDamageTarget(UsedMeleeDamage, damageForce * Normal(P.Location - Location));
				if( !bDamagedSomeone && bDamagedThisHit )
				{
					bDamagedSomeone = true;
				}
				MeleeRange = 150;
			}
		}

		Controller.Target = OldTarget;

		MeleeRange = Default.MeleeRange;


		if ( bDamagedSomeone )
		{
			// Maybe cause zedtime when the patriarch does his radial attack
			KFGameType(Level.Game).DramaticEvent(0.3);
			PlaySound(MeleeAttackHitSound, SLOT_Interact, 2.0);
		}
	}

	function EndState()
	{
		NumLumberJacks = 0;
		NumNinjas = 0;
	}

Begin:
	// Don't let the zed move and play the radial attack
	bShotAnim = true;
	Acceleration = vect(0,0,0);
	SetAnimAction('RadialAttack');
	KFMonsterController(Controller).bUseFreezeHack = True;
	HandleWaitForAnim('RadialAttack');
	Sleep(GetAnimDuration('RadialAttack'));
	// TODO: this sleep is here to allow for playing the taunt sound. Take it out when the animation is extended with the taunt - Ramm
	//Sleep(2.5);
	GotoState('');
}

function TakeDamage( int Damage, Pawn InstigatedBy, Vector Hitlocation, Vector Momentum, class<DamageType> damageType, optional int HitIndex)
{
	local float DamagerDistSq;
	local float UsedPipeBombDamScale;
	local KFHumanPawn P;
	local int NumPlayersSurrounding;
	local bool bDidRadialAttack;

	//log(GetStateName()$" Took damage. Health="$Health$" Damage = "$Damage$" HealingLevels "$HealingLevels[SyringeCount]);

	// Check for melee exploiters trying to surround the patriarch
	if( Level.TimeSeconds - LastMeleeExploitCheckTime > 1.0 && (class<DamTypeMelee>(damageType) != none
		|| class<KFProjectileWeaponDamageType>(damageType) != none) )
	{
		LastMeleeExploitCheckTime = Level.TimeSeconds;
		NumLumberJacks = 0;
		NumNinjas = 0;

		foreach DynamicActors(class'KFHumanPawn', P)
		{
			// look for guys attacking us within 3 meters
			if ( VSize(P.Location - Location) < 150 )
			{
				NumPlayersSurrounding++;

				if( P != none && P.Weapon != none )
				{
					if( Axe(P.Weapon) != none || Chainsaw(P.Weapon) != none )
					{
						NumLumberJacks++;
					}
					else if( Katana(P.Weapon) != none )
					{
						NumNinjas++;
					}
				}

				if( !bDidRadialAttack && NumPlayersSurrounding >= 3 )
				{
					if (FRand() < 0.50) // 50%
					{
						bShotAnim = true;
						bDidRadialAttack = true;
						Acceleration = vect(0,0,0);
						GoToState('FireMissile');
					}
					else
					{
						bDidRadialAttack = true;
						GotoState('RadialAttack');
					}
					break;
				}
			}
		}
	}

	if ( class<DamTypeCrossbow>(damageType) == none && class<DamTypeCrossbowHeadShot>(damageType) == none )
	{
		bOnlyDamagedByCrossbow = false;
	}

	// Scale damage from the pipebomb down a bit if lots of pipe bomb damage happens
	// at around the same times. Prevent players from putting all thier pipe bombs
	// in one place and owning the patriarch in one blow.
	if ( class<DamTypePipeBomb>(damageType) != none )
	{
	   UsedPipeBombDamScale = FMax(0,(1.0 - PipeBombDamageScale));

	   PipeBombDamageScale += 0.075;

	   if( PipeBombDamageScale > 1.0 )
	   {
		   PipeBombDamageScale = 1.0;
	   }

	   Damage *= UsedPipeBombDamScale;
	}

	super.TakeDamage(Damage,instigatedBy,hitlocation,Momentum,damageType);

	if( Level.TimeSeconds - LastDamageTime > 10 )
	{
		ChargeDamage = 0;
	}
	else
	{
		LastDamageTime = Level.TimeSeconds;
		ChargeDamage += Damage;
	}

	if( ShouldChargeFromDamage() && ChargeDamage > 200 )
	{
		// If someone close up is shooting us, just charge them
		if( InstigatedBy != none )
		{
			DamagerDistSq = VSizeSquared(Location - InstigatedBy.Location);

			if( DamagerDistSq < (700 * 700) )
			{
				SetAnimAction('transition');
				ChargeDamage=0;
				LastForceChargeTime = Level.TimeSeconds;
				GoToState('Charging');
				return;
			}
		}
	}

	if( Health<=0 || SyringeCount==3 || IsInState('Escaping') || IsInState('KnockDown') || IsInState('RadialAttack') || bDidRadialAttack/*|| bShotAnim*/ )
		Return;

	if( (SyringeCount==0 && Health<HealingLevels[0]) || (SyringeCount==1 && Health<HealingLevels[1]) || (SyringeCount==2 && Health<HealingLevels[2]) )
	{
		//log(GetStateName()$" Took damage and want to heal!!! Health="$Health$" HealingLevels "$HealingLevels[SyringeCount]);

		/*
		bShotAnim = true;
		Acceleration = vect(0,0,0);
		SetAnimAction('KnockDown');
		HandleWaitForAnim('KnockDown');
		KFMonsterController(Controller).bUseFreezeHack = True;
		GoToState('KnockDown');
		*/
		BeginHealing();
	}
}

simulated function PostBeginPlay()
{
	super.PostBeginPlay();

	if( Role < ROLE_Authority )
	{
		return;
	}

	// Difficulty Scaling
	if (Level.Game != none)
	{
		//log(self$" Beginning ground speed "$default.GroundSpeed);

		// If you are playing by yourself,  reduce the MG damage
		if( Level.Game.NumPlayers == 1 )
		{
			if( Level.Game.GameDifficulty < 2.0 )
			{
				MGDamage = default.MGDamage * 0.375;
			}
			else if( Level.Game.GameDifficulty < 4.0 )
			{
				MGDamage = default.MGDamage * 0.75;
			}
			else if( Level.Game.GameDifficulty < 5.0 )
			{
				MGDamage = default.MGDamage * 1.15;
			}
			else // Hardest difficulty
			{
				MGDamage = default.MGDamage * 1.3;
			}
		}
		else
		{
			if( Level.Game.GameDifficulty < 2.0 )
			{
				MGDamage = default.MGDamage * 0.375;
			}
			else if( Level.Game.GameDifficulty < 4.0 )
			{
				MGDamage = default.MGDamage * 1.0;
			}
			else if( Level.Game.GameDifficulty < 5.0 )
			{
				MGDamage = default.MGDamage * 1.15;
			}
			else // Hardest difficulty
			{
				MGDamage = default.MGDamage * 1.3;
			}
		}
	}

	HealingLevels[0] = Health/1.25; // Around 5600 HP
	HealingLevels[1] = Health/1.5f; // Around 3500 HP
	HealingLevels[2] = Health/2.0f; // Around 2187 HP
//  log("Health = "$Health);
//  log("HealingLevels[0] = "$HealingLevels[0]);
//  log("HealingLevels[1] = "$HealingLevels[1]);
//  log("HealingLevels[2] = "$HealingLevels[2]);

	HealingAmount = Health/4; // 1750 HP
//  log("HealingAmount = "$HealingAmount);
}

defaultproperties
{
	ControllerClass=Class'ApocMutators.HardPatController'
	LODBias=4.000000

	//kyan: add
	EventClasses(0)="ApocMutators.HardPat"
	EventClasses(1)="ApocMutators.HardPat"
	EventClasses(2)="ApocMutators.HardPat"
	EventClasses(3)="ApocMutators.HardPat"
	MenuName="Hard Patriarch"

	GroundSpeed=130.000000
	WaterSpeed=130.000000
	Health=30000//4000
	HealthMax=30000//4000
	HeadHealth=30000//30000
	PlayerCountHealthScale=0.7//0.7//0.25//0.75
	PlayerNumHeadHealthScale=0.5//0.5//0.25//0.75
	HealingLevels(0)=15500//10000//15500
	HealingLevels(1)=12500//10000//12500
	HealingLevels(2)=10000//10000//10000
	HealingAmount=20000
	MeleeDamage=30//75
	ClawMeleeDamageRange=75//50//50
	ImpaleMeleeDamageRange=35//75//45
	MGDamage=2.0//5.0//6.0
	MGDamageLevels(0)=1.0
	MGDamageLevels(1)=1.1
	MGDamageLevels(2)=1.2
	MGDamageLevels(3)=1.3
	JumpZ=320.000000
	HardPatHealthModifier=3.0
}
