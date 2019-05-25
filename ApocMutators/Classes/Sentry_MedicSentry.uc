//================================================================================
// Sentry_MedicSentry.
//================================================================================
class Sentry_MedicSentry extends Pawn
	Config(ApocMutators);

#exec OBJ LOAD FILE=KF_LAWSnd.uax
#exec obj load file="SentryTechTex1.utx"
#exec obj load file="SentryTechAnim1.ukx"
#exec obj load file="SentryTechSounds.uax"

var() config int HitDamage;
var() config int SentryHealth;
var(Sounds) array<Sound> FootStep;
var(Sounds) Sound VoicesList[16];
var(Sounds) Sound FiringSounds[5];
var Pawn OwnerPawn;
var byte RepAnimationAction;
var byte ClientAnimNum;
var Vector RepHitLocation;
var Emitter mTracer;
var Sentry_MedicSentryWeaponFlash WeaponFlash;
var transient float NextVoiceTimer;
var Sentry_MedicSentryWeapon WeaponOwner;
var transient Font HUDFontz[2];

replication
{
	reliable if (Role == ROLE_Authority)
		SentryHealth, RepAnimationAction, RepHitLocation;
}

function float GetHealth()
{
	return(float(Health) / HealthMax) * 100.0f;
}

final function SetOwningPlayer(Pawn Other, Sentry_MedicSentryWeapon W)
{
	//local KFPlayerReplicationInfo KFPRI;

	OwnerPawn = Other;
	PlayerReplicationInfo = Other.PlayerReplicationInfo;
	WeaponOwner = W;

	/*kyan: removed
	KFPRI = KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo);
	if (KFPRI != none)
	{
		if (KFPRI.ClientVeteranSkill == Class'SRVetFieldMedic')
		{
			default.HealthMax=800.000000;
			default.Health=800;
		}
		else
		{
			Default.HealthMax=800.000000;
			default.Health=800;
		}
	}*/
}

simulated function PostRender2D(Canvas C, float ScreenLocX, float ScreenLocY)
{
	local string S;
	local float XL;
	local float YL;
	local Vector D;

	if ((Health <= 0) || (PlayerReplicationInfo == None))
		return;

	D = C.Viewport.Actor.CalcViewLocation - Location;

	if (vector(C.Viewport.Actor.CalcViewRotation) Dot D > 0)
		return;

	XL = VSizeSquared(D);

	if ((XL > 1440000.0) || !FastTrace(C.Viewport.Actor.CalcViewLocation, Location))
		return;

	if (C.Viewport.Actor.PlayerReplicationInfo == PlayerReplicationInfo)
		//kyan: white color
		C.SetDrawColor(255, 255, 255, 255);
	else
		C.SetDrawColor(30, 154, 255, 255);

	if (Default.HUDFontz[0] == None)
	{
		Default.HUDFontz[0] = Font(DynamicLoadObject("ROFonts_Rus.ROArial7", Class'Font'));

		if (Default.HUDFontz[0] == None)
			Default.HUDFontz[0] = Font'DefaultFont';

		Default.HUDFontz[1] = Font(DynamicLoadObject("ROFonts_Rus.ROBtsrmVr12", Class'Font'));

		if (Default.HUDFontz[1] == None)
			Default.HUDFontz[1] = Font'DefaultFont';
	}

	if (C.ClipY < 1024)
		C.Font = Default.HUDFontz[0];
	else
		C.Font = Default.HUDFontz[1];

	C.Style = 5;

	//kyan: modified
	S = "[ Medic Sentry ]";
	C.TextSize(S, XL, YL);
	C.SetPos(ScreenLocX - XL * 0.5, ScreenLocY - YL * 3.25f);
	C.DrawTextClipped(S, false);
	S = "Owner: " @ PlayerReplicationInfo.PlayerName;
	C.TextSize(S, XL, YL);
	C.SetPos(ScreenLocX - XL * 0.5, ScreenLocY - YL * 2.0);
	C.DrawTextClipped(S, False);
	S = "Health: " @ int(FMax(((float(Health) / float(SentryHealth)) * float(100)), 1))
		@ "% (" @ Health @ "/" @ SentryHealth @ ")";
	C.TextSize(S, XL, YL);
	C.SetPos(ScreenLocX - XL * 0.5, ScreenLocY - YL * 0.75);
	C.DrawTextClipped(S, False);
}

event PostBeginPlay()
{
	Super.PostBeginPlay();
	TweenAnim(IdleRestAnim, 0.01);

	if ((ControllerClass != None) && (Controller == None))
		Controller = Spawn(ControllerClass);

	if (Controller != None)
		Controller.Possess(self);

	Health = SentryHealth;
	HealthMax = SentryHealth;
}

simulated function PostNetBeginPlay()
{
	Super.PostNetBeginPlay();
	RepHitLocation = vect(0.00, 0.00, 0.00);

	if (Level.NetMode == 3)
	{
		bNetNotify = True;
		PostNetReceive();

		if (RepAnimationAction == 0)
			TweenAnim(IdleRestAnim, 0.01);
	}
}

simulated function PostNetReceive()
{
	if (ClientAnimNum != RepAnimationAction)
		SetAnimationNum(RepAnimationAction);

	if (RepHitLocation != vect(0.00, 0.00, 0.00))
	{
		ClientTraceFX();
		RepHitLocation = vect(0.00, 0.00, 0.00);
	}
}

simulated function Destroyed()
{
	if (Controller != None)
	{
		Controller.bIsPlayer = False;
		Controller.Destroy();
	}

	if (WeaponFlash != None)
		WeaponFlash.Destroy();

	if (mTracer != None)
		mTracer.Destroy();
}

simulated function SetAnimationNum(byte Num)
{
	RepAnimationAction = Num;

	switch(Num)
	{
	case 0:
		if (ClientAnimNum == 1)
		{
			if (Level.NetMode != 3)
				Speech(0);

			PlayAnim('Un_Fold');
		}
		else
		{
			PlayAnim('Ranged_Attack_End');
		}

		if (Level.NetMode != 3)
			SetTimer(0.0, False);

		if (WeaponFlash != None)
		{
			WeaponFlash.RemoveFX();
			WeaponFlash = None;
		}
		break;

	case 1:
		PlayAnim('Folded');
		break;

	case 2:
		LoopAnim('Ranged_Attack1', 1.62);

		if (Level.NetMode != 3)
			SetTimer(0.06, True);

		if (Level.NetMode != 1)
		{
			WeaponFlash = Spawn(Class'Sentry_MedicSentryWeaponFlash', self);
			AttachToBone(WeaponFlash, 'Barrel');
		}
		break;

	default:
	}

	ClientAnimNum = Num;
	bPhysicsAnimUpdate = False;
}

final simulated function name GetCurrentAnim()
{
	local name Anim;
	local float frame;
	local float Rate;

	GetAnimParams(0, Anim, frame, Rate);
	return Anim;
}

simulated function AnimEnd(int Channel)
{
	if ((RepAnimationAction != 0) || bPhysicsAnimUpdate)
		return;

	bPhysicsAnimUpdate = True;

	if (Controller != None)
		Controller.AnimEnd(Channel);
}

simulated function RunStep()
{
	PlaySound(FootStep[Rand(FootStep.Length)], SLOT_Misc, 1.5, , 350.0);
}

function Timer()
{
	local Vector X;
	local Vector HL;
	local Vector HN;
	local Actor A;
	local Actor res;
	local KFPlayerReplicationInfo KFPRI;

	KFPRI = KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo);

	if (Controller == None)
		return;

	if (Controller.Enemy != None)
		X = Normal(Controller.Enemy.Location - Location);
	else
		X = vector(Rotation);

	X = Normal(X + VRand() * 0.04);

	if (KFPRI.ClientVeteranSkill != Class'SRVetFieldMedic')
	{
		A = None;
	}
	else
	{
		foreach TraceActors(Class'Actor', res, HL, HN, Location + X * 8000.0, Location)
		{
			if ((res != self)
			  && ((res == Level) || res.bBlockActors || res.bProjTarget || res.bWorldGeometry)
			  && (KFPawn(res) == None)
			  && (KFBulletWhipAttachment(res) == None)
			  && (Sentry_MedicSentry(res) == None))
			{
				A = res;
			}
		}
	}

	if (A != None && KFHumanPawn(A) != None)
	{
		KFHumanPawn(A).Health += HitDamage;

		/*kyan: removed
		if (KFHumanPawn(A).Health > KFPlayerReplicationInfo(KFHumanPawn(A).PlayerReplicationInfo).default.PlayerHealth)
		{
			KFHumanPawn(A).Health = KFPlayerReplicationInfo(KFHumanPawn(A).PlayerReplicationInfo).default.PlayerHealth;
		}

		if ((OwnerPawn != None) && (KFPlayerReplicationInfo(OwnerPawn.PlayerReplicationInfo).ClientVeteranSkill.Default.PerkIndex == 0))
		{
			KFSteamStatsAndAchievements(KFPlayerReplicationInfo(OwnerPawn.PlayerReplicationInfo).SteamStatsAndAchievements).AddDamageHealed(HitDamage);
		}*/

		//kyan: modified
		if (KFHumanPawn(A).Health > KFHumanPawn(A).HealthMax)
			KFHumanPawn(A).Health = KFHumanPawn(A).HealthMax;

		/*
		if (OwnerPawn != None && OwnerPawn != KFHumanPawn(A))
			KFSteamStatsAndAchievements(KFPlayerReplicationInfo(OwnerPawn.PlayerReplicationInfo).SteamStatsAndAchievements)
				.AddDamageHealed(HitDamage);
		*/
	}
	else
	{
		if (A == None)
			HL = Location + X * 8000.0;
	}

	if (Level.NetMode != 0)
	{
		if (VSize(RepHitLocation - HL) < 2.0)
			RepHitLocation += VRand() * 2.0;
		else
			RepHitLocation = HL;
	}

	if (Level.NetMode != 1 && A != none)
		TraceFX(A, HL, HN);
}

final simulated function ClientTraceFX()
{
	local Vector HL;
	local Vector HN;
	local Actor A;

	if (A == None)
		HL = RepHitLocation;

	TraceFX(A, HL, HN);
}

simulated function Explode(Vector HitLocation, Vector HitNormal)
{
	SetPhysics(PHYS_none);

	if (Level.NetMode != 1)
		Spawn(Class'ROBulletHitEffect', , , Location, rotator(-HitNormal));

	BlowUp(HitLocation);
	Destroy();
}

simulated function BlowUp(Vector HitLocation)
{
	if (Role == 4)
		MakeNoise(1.0);
}

simulated function TraceFX(Actor A, Vector HL, Vector HN)
{
	PlaySound(FiringSounds[Rand(5)], SLOT_Pain, 2.5, , 550.0);

	if ((A != None) && (Pawn(A) == None) && (ExtendedZCollision(A) == None))
	   Spawn(Class'ROBulletHitEffect', , , HL, rotator(-HN));
}

function TakeDamage(
	int Damage,
	Pawn instigatedBy,
	Vector HitLocation,
	Vector Momentum,
	Class<DamageType> DamageType,
	optional int HitIndex)
{
	if (KFHumanPawn(instigatedBy) != None)
		return;

	Super.TakeDamage(Damage, instigatedBy, HitLocation, Momentum, DamageType, HitIndex);
	Speech(4);
}

function Died(Controller Killer, Class<DamageType> DamageType, Vector HitLocation)
{
	PlayerReplicationInfo = None;

	if (WeaponOwner != None)
	{
		if ((OwnerPawn != None) && (PlayerController(OwnerPawn.Controller) != None))
			PlayerController(OwnerPawn.Controller).ReceiveLocalizedMessage(Class'Sentry_MedicSentryMessage', 2);

		WeaponOwner.CurrentMedicSentry = None;
		WeaponOwner.Destroy();
		WeaponOwner = None;
	}

	if (Controller != None)
		Controller.bIsPlayer = False;

	PlaySound(VoicesList[3], SLOT_Talk, 2.5, , 450.0);
	Super.Died(Killer, DamageType, HitLocation);
}

simulated event PlayDying(Class<DamageType> DamageType, Vector HitLoc)
{
	AmbientSound = None;
	GotoState('Dying');
	bReplicateMovement = False;
	bTearOff = True;
	Velocity += TearOffMomentum;
	SetPhysics(PHYS_Falling);
	bPlayedDeath = True;
	PlayAnim('Fold');

	if (WeaponFlash != None)
	{
		WeaponFlash.RemoveFX();
		WeaponFlash = None;
	}
}

final function Speech(byte Num)
{
	local Sound S;

	if (NextVoiceTimer > Level.TimeSeconds)
		return;

	NextVoiceTimer = Level.TimeSeconds + 1.0 + FRand() * 2.0;

	switch(Num)
	{
	case 0: S = VoicesList[0]; break;
	case 1: S = VoicesList[1 + Rand(2)]; break;
	case 2: S = VoicesList[4 + Rand(2)]; break;
	case 3: S = VoicesList[6]; break;
	case 4: S = VoicesList[7 + Rand(4)]; break;
	case 5: S = VoicesList[11]; break;
	case 6: S = VoicesList[12]; break;
	case 7: S = VoicesList[13 + Rand(3)]; break;
	default:
	}

	PlaySound(S, SLOT_Talk, 2.5f, , 450.f);
}

simulated function HurtRadius(
	float DamageAmount,
	float DamageRadius,
	Class<DamageType> DamageType,
	float Momentum, Vector HitLocation)
{
	local Actor Victims;
	local float damageScale;
	local float dist;
	local Vector Dir;
	local int NumKilled;
	local KFMonster KFMonsterVictim;
	local Pawn P;

	if (bHurtEntry)
		return;

	bHurtEntry = True;

	if (OwnerPawn != None)
		P = OwnerPawn;
	else
		P = self;

	foreach CollidingActors(Class'Actor', Victims, DamageRadius, HitLocation)
	{
		if ((Victims != self)
		  && (Victims.Role == 4)
		  && !Victims.IsA('FluidSurfaceInfo')
		  && (ExtendedZCollision(Victims) == None)
		  && (KFPawn(Victims) == None)
		  && (Sentry_MedicSentry(Victims) == None))
		{
			Dir = Victims.Location - HitLocation;
			dist = FMax(1.0, VSize(Dir));
			Dir = Dir / dist;
			damageScale = 1.0 - FMax(0.0,(dist - Victims.CollisionRadius) / DamageRadius);
			KFMonsterVictim = KFMonster(Victims);

			if ((KFMonsterVictim != None) && (KFMonsterVictim.Health <= 0))
				KFMonsterVictim = None;

			if (KFMonsterVictim != None)
				damageScale *= KFMonsterVictim.GetExposureTo(HitLocation);

			if (damageScale <= 0)
			{
				continue;
			}
			else
			{
				Victims.TakeDamage(
					int(damageScale * DamageAmount),
					P,
					Victims.Location - 0.5  * (Victims.CollisionHeight + Victims.CollisionRadius) * Dir,
					damageScale * Momentum * Dir,
					DamageType);

				if ((Role == 4) && (KFMonsterVictim != None) && (KFMonsterVictim.Health <= 0))
				{
					NumKilled++;
				}
			}
		}
	}

	if (Role == 4)
	{
		if (NumKilled >= 4)
		{
			KFGameType(Level.Game).DramaticEvent(0.05);
		}
		else
		{
			if (NumKilled >= 2)
				KFGameType(Level.Game).DramaticEvent(0.03);
		}
	}

	bHurtEntry = False;
}

state Dying
{
	ignores
		Trigger,
		Bump,
		HitWall,
		HeadVolumeChange,
		PhysicsVolumeChange,
		Falling,
		BreathTimer,
		TakeDamage,
		Landed,
		SetAnimationNum,
		Timer;

	simulated function EndState()
	{
		local Emitter E;

		if (Level.NetMode != NM_DedicatedServer)
		{
			E = Spawn(Class'PanzerfaustHitConcrete_simple');

			if (E != None)
				E.RemoteRole = ROLE_None;

			PlaySound(SoundGroup'KF_LAWSnd.Rocket_Explode', SLOT_Pain, 2.5, , 800.0);
		}

		HurtRadius(400.0, 500.0, Class'DamTypeFrag', 100000.0, Location);
	}

	simulated function BeginState()
	{
		local int i;

		LifeSpan = 1.75;
		SetPhysics(PHYS_Falling);
		SetCollision(False);

		if (Controller != None)
			Controller.Destroy();

		if (Controller != None)
			Controller.Destroy();

		for (i = 0; i < Attached.length; i++)
			if (Attached[i] != None)
				Attached[i].PawnBaseDied();
	}

Begin:
}

defaultproperties
{
	HitDamage=4
	SentryHealth=800
	FootStep(0)=Sound'SentryTechSounds.Weapon_DoomSentry.DoomSentry_sstep_01'
	FootStep(1)=Sound'SentryTechSounds.Weapon_DoomSentry.DoomSentry_sstep_02'
	FootStep(2)=Sound'SentryTechSounds.Weapon_DoomSentry.DoomSentry_sstep_03'
	FootStep(3)=Sound'SentryTechSounds.Weapon_DoomSentry.DoomSentry_sstep_04'
	VoicesList(0)=Sound'SentryTechSounds.Weapon_DoomSentry.DoomSentry_activate_01'
	VoicesList(1)=Sound'SentryTechSounds.Weapon_DoomSentry.DoomSentry_cant_reach_player_01'
	VoicesList(2)=Sound'SentryTechSounds.Weapon_DoomSentry.DoomSentry_cant_reach_player_02'
	VoicesList(3)=Sound'SentryTechSounds.Weapon_DoomSentry.DoomSentry_destroyed_01'
	VoicesList(4)=Sound'SentryTechSounds.Weapon_DoomSentry.DoomSentry_fight_enemy_02'
	VoicesList(5)=Sound'SentryTechSounds.Weapon_DoomSentry.DoomSentry_sight_enemy_01'
	VoicesList(6)=Sound'SentryTechSounds.Weapon_DoomSentry.DoomSentry_lost_target_01'
	VoicesList(7)=Sound'SentryTechSounds.Weapon_DoomSentry.DoomSentry_pain_01'
	VoicesList(8)=Sound'SentryTechSounds.Weapon_DoomSentry.DoomSentry_pain_02'
	VoicesList(9)=Sound'SentryTechSounds.Weapon_DoomSentry.DoomSentry_pain_03'
	VoicesList(10)=Sound'SentryTechSounds.Weapon_DoomSentry.DoomSentry_pain_04'
	VoicesList(11)=Sound'SentryTechSounds.Weapon_DoomSentry.DoomSentry_shutdown_01'
	VoicesList(12)=Sound'SentryTechSounds.Weapon_DoomSentry.DoomSentry_sight_friendly_01'
	VoicesList(13)=Sound'SentryTechSounds.Weapon_DoomSentry.DoomSentry_wait_for_player_01'
	VoicesList(14)=Sound'SentryTechSounds.Weapon_DoomSentry.DoomSentry_wait_for_player_02'
	VoicesList(15)=Sound'SentryTechSounds.Weapon_DoomSentry.DoomSentry_wait_for_player_03'
	FiringSounds(0)=SoundGroup'KF_MP7Snd.Medicgun_Fire'
	bScriptPostRender=True
	SightRadius=6500.000000
	PeripheralVision=-1.000000
	GroundSpeed=380.000000
	JumpZ=390.000000
	BaseEyeHeight=0.000000
	EyeHeight=0.000000
	HealthMax=800.000000
	Health=800
	ControllerClass=Class'ApocMutators.Sentry_MedicSentryController'
	HitDamageType=class'ApocMutators.Sentry_DamTypeMedicSentry'
	bPhysicsAnimUpdate=True
	MovementAnims(0)="Walk"
	MovementAnims(1)="Walk"
	MovementAnims(2)="Walk"
	MovementAnims(3)="Walk"
	TurnLeftAnim="TurnL"
	TurnRightAnim="TurnR"
	SwimAnims(0)="Walk"
	SwimAnims(1)="Walk"
	SwimAnims(2)="Walk"
	SwimAnims(3)="Walk"
	CrouchAnims(0)="Walk"
	CrouchAnims(1)="Walk"
	CrouchAnims(2)="Walk"
	CrouchAnims(3)="Walk"
	WalkAnims(0)="Walk"
	WalkAnims(1)="Walk"
	WalkAnims(2)="Walk"
	WalkAnims(3)="Walk"
	AirAnims(0)="Walk"
	AirAnims(1)="Walk"
	AirAnims(2)="Walk"
	AirAnims(3)="Walk"
	TakeoffAnims(0)="Walk"
	TakeoffAnims(1)="Walk"
	TakeoffAnims(2)="Walk"
	TakeoffAnims(3)="Walk"
	LandAnims(0)="Walk"
	LandAnims(1)="Walk"
	LandAnims(2)="Walk"
	LandAnims(3)="Walk"
	DoubleJumpAnims(0)="Walk"
	DoubleJumpAnims(1)="Walk"
	DoubleJumpAnims(2)="Walk"
	DoubleJumpAnims(3)="Walk"
	DodgeAnims(0)="Walk"
	DodgeAnims(1)="Walk"
	DodgeAnims(2)="Walk"
	DodgeAnims(3)="Walk"
	AirStillAnim="Walk"
	TakeoffStillAnim="Walk"
	CrouchTurnRightAnim="Walk"
	CrouchTurnLeftAnim="Walk"
	IdleCrouchAnim="Idle_Stand"
	IdleSwimAnim="Idle_Stand"
	IdleWeaponAnim="Idle_Stand"
	IdleRestAnim="Idle_Stand"
	IdleChatAnim="Idle_Stand"
	bStasis=False
	Physics=PHYS_Falling
	Mesh=SkeletalMesh'SentryTechAnim1.Weapon_DoomSentry'
	PrePivot=(Z=-25.000000)
	Skins(0)=Texture'SentryTechTex1.Weapon_DoomSentry.SentrySpistonDiffuse'
	Skins(1)=Texture'SentryTechTex1.Weapon_DoomSentry.SentryFlapDiffuse'
	Skins(2)=Texture'SentryTechTex1.Weapon_MedicSentryBot.MedicSentryBot_Skin2'
	Skins(3)=Shader'SentryTechTex1.Weapon_DoomSentry.InvisibleWeaponsFlash'
	Skins(4)=Shader'SentryTechTex1.Weapon_DoomSentry.InvisibleWeaponsFlash'
	Skins(5)=Shader'SentryTechTex1.Weapon_DoomSentry.InvisibleWeaponsFlash'
	Skins(6)=Shader'SentryTechTex1.Weapon_DoomSentry.InvisibleWeaponsFlash'
	Skins(7)=Shader'SentryTechTex1.Weapon_DoomSentry.InvisibleWeaponsFlash'
	Skins(8)=Shader'SentryTechTex1.Weapon_DoomSentry.InvisibleWeaponsFlash'
	CollisionRadius=20.000000
	CollisionHeight=23.000000
	Mass=400.000000
	bBlockActors=False
}
