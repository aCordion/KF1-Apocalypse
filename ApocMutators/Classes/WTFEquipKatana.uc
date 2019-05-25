class WTFEquipKatana extends Katana;

var KFPlayerReplicationInfo KFPRI;
var bool LastZTState; // LastZedTimeState
var float NextIronTime;

replication
{
	reliable if (Role < ROLE_Authority)
		ZEDTime;
}

simulated function WeaponTick(float dt)
{
	Super.WeaponTick(dt);

	 //if we're in the same state as the last time we checked, no need to do anything right now, exit

	if (KFGameType(Level.Game) == None)
		return;

	if (KFGameType(Level.Game).bZEDTimeActive == LastZTState)
		return;

	  //*berserker only *
	 //doing the check here so it isn't running constantly-
  //    only checks when entering / exiting ZEDTime
	KFPRI = KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo);
	if (KFPRI == none || KFPRI.ClientVeteranSkill != Class'SRVetBerserker')
		return;

	 //record new state
	LastZTState = KFGameType(Level.Game).bZEDTimeActive;

	 //set movement speed
	if (KFGameType(Level.Game).bZEDTimeActive)
	{
		 //InventorySpeedModifier is a straight + to speed and it is unregulated outside of changing weapons!
		KFHumanPawn(Instigator).InventorySpeedModifier=500; // it is an INT
		Instigator.AccelRate=100000.0;
		KFHumanPawn(Instigator).ModifyVelocity(dt, Instigator.Velocity);
	}
	else
	{
		ResetMovement();
	}
}

function ResetMovement()
{
	local KFHumanPawn P;
	P = KFHumanPawn(Instigator);

	P.InventorySpeedModifier = ((P.default.GroundSpeed * P.BaseMeleeIncrease) - Weight * 2);
	P.AccelRate=P.Default.AccelRate;
	P.AirControl=P.Default.AirControl;
	P.AirSpeed=P.Default.AirSpeed;
	P.ModifyVelocity(Level.TimeSeconds, P.Velocity);
}

simulated function Weapon WeaponChange(byte F, bool bSilent)
{
	ResetMovement();
	return Super.WeaponChange(F, bSilent);
}

simulated function bool PutDown()
{
	ResetMovement();
	return Super.PutDown();
}

simulated function bool CanThrow()
{
	ResetMovement();
	return Super.CanThrow();
}

simulated function ClientWeaponThrown()
{
	ResetMovement();
	Super.ClientWeaponThrown();
}

function DropFrom(vector StartLocation)
{
	ResetMovement();
	Super.DropFrom(StartLocation);
}

simulated exec function ToggleIronSights()
{
	 //this functionality is available to berserkers only
	KFPRI = KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo);
	if (KFPRI == none || KFPRI.ClientVeteranSkill != Class'ApocMutators.SRVetBerserker')
		return;

	 //less restrictive than chainsaw / axe because we aren't actually doing an attack
	if (NextIronTime <= Level.TimeSeconds)
	{
		if (Instigator != none)
		{
			ZEDTime();

			NextIronTime=Level.TimeSeconds + 60.0;
		}
	}
}

simulated function ZEDTime()
{
	if (KFGameType(Level.Game) != None && KFGameType(Level.Game).bWaveInProgress)
	{
		KFGameType(Level.Game).DramaticEvent(1.0);
		if (Instigator.Health > 20)
			Instigator.Health = Instigator.Health - 20;
	}
}

simulated event RenderOverlays(Canvas Canvas)
{
	Super.RenderOverlays(Canvas);

	Canvas.Style = 255;

	 //Draw some text.
	Canvas.Font = Canvas.SmallFont;
	Canvas.SetDrawColor(200, 150, 0);

	Canvas.SetPos(Canvas.SizeX * 0.5, Canvas.SizeY * 0.1);
	if (Level.TimeSeconds < NextIronTime)
		Canvas.DrawText(String(Int(NextIronTime - Level.TimeSeconds)));
}

defaultproperties
{
	 ChopSlowRate=1.000000
	 FireModeClass(0)=Class'ApocMutators.WTFEquipKatanaFire'
	 FireModeClass(1)=Class'ApocMutators.WTFEquipKatanaFireB'
	 Description="A deadly weapon"
	 PickupClass=Class'ApocMutators.WTFEquipKatanaPickup'
}
