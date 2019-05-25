class Shiver_ZombieShiver extends Shiver_ZombieShiverBase
	Config(ApocZEDPack);

struct SZEDInfo {
	var config int ForcedMinPlayers;
	var config int Health;
    var config int HeadHealth;
    var config float PlayerCountHealthScale;
    var config float PlayerNumHeadHealthScale;
};
var config SZEDInfo ZEDInfo;

function float NumPlayersHealthModifer()
{
    if (ZEDInfo.ForcedMinPlayers>0)
        return 1.0 + (ZEDInfo.ForcedMinPlayers - 1) * PlayerCountHealthScale;
    return Super.NumPlayersHealthModifer();
}

function float NumPlayersHeadHealthModifer()
{
    if (ZEDInfo.ForcedMinPlayers>0)
        return 1.0 + (ZEDInfo.ForcedMinPlayers - 1) * PlayerNumHeadHealthScale;
    return Super.NumPlayersHeadHealthModifer();
}

simulated function PostBeginPlay()
{
    if (ZEDInfo.Health>0 && Health!=ZEDInfo.Health)
    {
        Health = ZEDInfo.Health;
        HealthMax = ZEDInfo.Health;
    }

    if (ZEDInfo.HeadHealth>0 && HeadHealth!=ZEDInfo.HeadHealth)
        HeadHealth = ZEDInfo.HeadHealth;

    if (ZEDInfo.PlayerCountHealthScale>0 && PlayerCountHealthScale!=ZEDInfo.PlayerCountHealthScale)
        PlayerCountHealthScale = ZEDInfo.PlayerCountHealthScale;

    if (ZEDInfo.PlayerNumHeadHealthScale>0 && PlayerNumHeadHealthScale!=ZEDInfo.PlayerNumHeadHealthScale)
        PlayerNumHeadHealthScale = ZEDInfo.PlayerNumHeadHealthScale;
		
	Super.PostBeginPlay();

	if (Level.NetMode != NM_DedicatedServer)
	{
		MatAlphaSkin = ColorModifier(Level.ObjectPool.AllocateObject(class'ColorModifier'));
		if (MatAlphaSkin != none)
		{
			MatAlphaSkin.Color = class'Canvas'.static.MakeColor(255, 255, 255, 255);
			MatAlphaSkin.RenderTwoSided = false;
			MatAlphaSkin.AlphaBlend = true;
			MatAlphaSkin.Material = Skins[0];
			Skins[0] = MatAlphaSkin;
		}
	}
}

simulated function Destroyed()
{
	if (Level.NetMode != NM_DedicatedServer && MatAlphaSkin != none)
	{
		Skins[0] = default.Skins[0];
		Level.ObjectPool.FreeObject(MatAlphaSkin);
	}

	Super.Destroyed();
}

simulated function StopBurnFX()
{
	if (bBurnApplied)
	{
		MatAlphaSkin.Material = Texture'PatchTex.Common.ZedBurnSkin';
		Skins[0] = MatAlphaSkin;
	}

	Super.StopBurnFX();
}

function RangedAttack(Actor A)
{
	if (bShotAnim || Physics == PHYS_Swimming)
		return;
	else if (CanAttack(A))
	{
		bShotAnim = true;
		SetAnimAction('Claw');
		return;
	}
}

state Running
{
	function Tick(float Delta)
	{
		Global.Tick(Delta);
		if (RunUntilTime < Level.TimeSeconds)
			GotoState('');
		GroundSpeed = default.GroundSpeed * 2.5;
	}

	function BeginState()
	{
		RunUntilTime = Level.TimeSeconds + PeriodRunBase + FRand() * PeriodRunRan;
	}

	function EndState()
	{
		GroundSpeed = default.GroundSpeed;
		RunCooldownEnd = Level.TimeSeconds + PeriodRunCoolBase + FRand() * PeriodRunCoolRan;
	}

    function bool CanSpeedAdjust()
    {
        return false;
    }
}

function TakeDamage(int Damage, Pawn InstigatedBy, Vector Hitlocation, Vector momentum, class<DamageType> DamageType, optional int HitIndex)
{
	Velocity *= 0;
	Super.TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType, HitIndex);
}

simulated function HandleAnimation(float Delta)
{
	local float Alpha;

	// Handle head twitch
	if (NextHeadTime < Level.TimeSeconds)
	{
		CurHeadRot = NextHeadRot;
		NextHeadRot.Pitch = Rand(MaxTilt) - (MaxTilt * 0.5);
		NextHeadRot.Roll = Rand(MaxTurn) - (MaxTurn * 0.5);
		NextHeadTime = Level.TimeSeconds + MaxHeadTime;
	}

	Alpha = 1.0 - ((NextHeadTime - Level.TimeSeconds) / MaxHeadTime);
	SetBoneRotation('CHR_Head', CurHeadRot + (NextHeadRot - CurHeadRot) * Alpha);

	// Pick movement animation according to speed
	if (VSize(Velocity) > 130)
		MovementAnims[0] = RunAnim;
	else
		MovementAnims[0] = WalkAnim;
}

simulated function Tick(float Delta)
{
	Super.Tick(Delta);

	if (Health > 0 && !bBurnApplied)
	{
		if (Level.NetMode != NM_DedicatedServer)
			HandleAnimation(Delta);

		// Handle targetting
		if (Level.NetMode != NM_Client && !bDecapitated)
		{
			if (Controller == none || Controller.Target == none || !Controller.LineOfSightTo(Controller.Target))
			{
				if (bCanSeeTarget)
					bCanSeeTarget = false;
			}
			else
			{
				if (!bCanSeeTarget)
				{
					bCanSeeTarget = true;
					SeeTargetTime = Level.TimeSeconds;
				}
				else if (Level.TimeSeconds > SeeTargetTime + PeriodSeeTarget)
				{
					if (VSize(Controller.Target.Location - Location) < MaxTeleportDist)
					{
						if (VSize(Controller.Target.Location - Location) > MinTeleportDist || !Controller.ActorReachable(Controller.Target))
						{
							if (CanTeleport())
								StartTelePort();
						}
						else
						{
							if (CanRun())
								GotoState('Running');
						}
					}
				}
			}
		}
	}

	// Handle client-side teleport variables
	if (!bBurnApplied)
	{
		if (Level.NetMode != NM_DedicatedServer && OldFadeStage != FadeStage)
		{
			OldFadeStage = FadeStage;

			if (FadeStage == 2)
				AlphaFader = 0;
			else
				AlphaFader = 255;
		}

		// Handle teleporting
		if (FadeStage == 1) // Fade out (pre-teleport)
		{
			AlphaFader = FMax(AlphaFader - Delta * 512, 0);

			if (Level.NetMode != NM_Client && AlphaFader == 0)
			{
				SetCollision(true, true);
				FlashTeleport();
				SetCollision(false, false);
				FadeStage = 2;
			}
		}
		else if (FadeStage == 2) // Fade in (post-teleport)
		{
			AlphaFader = FMin(AlphaFader + Delta * 512, 255);

			if (Level.NetMode != NM_Client && AlphaFader == 255)
			{
				FadeStage = 0;
				SetCollision(true, true);
				GotoState('Running');
			}
		}

		if (Level.NetMode != NM_DedicatedServer && ColorModifier(Skins[0]) != none)
			ColorModifier(Skins[0]).Color.A = AlphaFader;
	}
}

function bool CanTeleport()
{
	return (Physics == PHYS_Walking && !bFlashTeleporting && LastFlashTime + 7.5 < Level.TimeSeconds);
}

function bool CanRun()
{
	return (!bFlashTeleporting && !IsInState('Running') && RunCooldownEnd < Level.TimeSeconds);
}

function StartTeleport()
{
	FadeStage = 1;
	AlphaFader = 255;
	SetCollision(false, false);
	bFlashTeleporting = true;
}

function FlashTeleport()
{
	local Actor Target;
	local vector OldLoc;
	local vector NewLoc;
	local vector HitLoc;
	local vector HitNorm;
	local rotator RotOld;
	local rotator RotNew;
	local float LandTargetDist;
	local int iEndAngle;
	local int iAttempts;

	if (Controller == none || Controller.Target == none)
		return;

	Target = Controller.Target;
	RotOld = rotator(Target.Location - Location);
	RotNew = RotOld;
	OldLoc = Location;

	for (iEndAngle = 0; iEndAngle < MaxTeleportAngles; iEndAngle++)
	{
		RotNew = RotOld;
		RotNew.Yaw += iEndAngle * (65536 / MaxTelePortAngles);

		for (iAttempts = 0; iAttempts < MaxTeleportAttempts; iAttempts++)
		{
			LandTargetDist = Target.CollisionRadius + CollisionRadius +
				MinLandDist + (MaxLandDist - MinLandDist) * (iAttempts / (MaxTeleportAttempts - 1.0));

			NewLoc = Target.Location - vector(RotNew) * LandTargetDist; // Target.Location - Location
			NewLoc.Z = Target.Location.Z;

			if (Trace(HitLoc, HitNorm, NewLoc + vect(0, 0, -500), NewLoc) != none)
				NewLoc.Z = HitLoc.Z + CollisionHeight;

			// Try a new location
			if (SetLocation(NewLoc))
			{
				SetPhysics(PHYS_Walking);

				if (Controller.PointReachable(Target.Location))
				{
					Velocity = vect(0, 0, 0);
					Acceleration = vect(0, 0, 0);
					SetRotation(rotator(Target.Location - Location));

					PlaySound(Sound'ShiverS.WarpGroup', SLOT_Interact, 4.0);
					Controller.GotoState('');
					MonsterController(Controller).WhatToDoNext(0);
					goto Teleported;
				}
			}

			// Reset location
			SetLocation(OldLoc);
		}
	}

Teleported:

	bFlashTeleporting = false;
	LastFlashTime = Level.TimeSeconds;
}

function Died(Controller Killer, class<DamageType> damageType, vector HitLocation)
{
	// (!)
    Super.Died(Killer, damageType, HitLocation);
}

function RemoveHead()
{
	if (IsInState('Running'))
		GotoState('');
	Super(KFMonster).RemoveHead();
}

function PlayTakeHit(vector HitLocation, int Damage, class<DamageType> DamType)
{
	if (Level.TimeSeconds - LastPainSound > MinTimeBetweenPainSounds)
	{
		LastPainSound = Level.TimeSeconds;
		PlaySound(HitSound[0], SLOT_Pain, 1.25,,400);
	}

	if (!IsInState('Running') && Level.TimeSeconds - LastPainAnim > MinTimeBetweenPainAnims)
	{
		PlayDirectionalHit(HitLocation);
		LastPainAnim = Level.TimeSeconds;
	}
}

simulated function int DoAnimAction( name AnimName )
{
	if (AnimName=='Claw' || AnimName=='Claw2' || AnimName=='Claw3')
	{
		AnimBlendParams(1, 1.0, 0.1,, FireRootBone);
		PlayAnim(AnimName,, 0.1, 1);
		return 1;
	}

	return Super.DoAnimAction(AnimName);
}

defaultproperties
{
}
