class WTFEquipSCAR19a extends SCARMK17AssaultRifle
	config(ApocMutators);

replication
{
	reliable if (Role < ROLE_Authority)
		ServerChangeAutoMode;
}

simulated function DoToggle()
{
	local PlayerController Player;
	local WTFEquipSCAR19Fire FM;
	local KFPlayerReplicationInfo KFPRI;
	local int MyAutoMode;
	local bool bIsCommando;

	if (Instigator == None)
		return;

	Player = Level.GetLocalPlayerController();
	if (Player == None)
		return;

	FM = WTFEquipSCAR19Fire(FireMode[0]);
	MyAutoMode = FM.AutoMode;
	MyAutoMode++;

	KFPRI = KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo);
	bIsCommando = (KFPRI != none && KFPRI.ClientVeteranSkill == Class'SRVetCommando');
	FM.SetAutoMode(MyAutoMode, bIsCommando); // 2nd param means YES / NO we are a commando: Super Auto will be available if we are a commando

	ServerChangeAutoMode(FM.AutoMode, FM.bWaitForRelease);
	Super(KFWeapon).DoToggle(); // just plays a sound
	Player.ReceiveLocalizedMessage(Class'ApocMutators.WTFEquipBulldogSwitchMessage', FM.AutoMode);
}

// Set the new fire mode on the server
function ServerChangeAutoMode(int NewMode, bool bSemiAuto)
{
	WTFEquipSCAR19Fire(FireMode[0]).AutoMode = NewMode;
	WTFEquipSCAR19Fire(FireMode[0]).bWaitForRelease = bSemiAuto;
}

defaultproperties
{
	 FireModeClass(0)=Class'ApocMutators.WTFEquipSCAR19Fire'
	 Description="A deadly weapon"
	 PickupClass=Class'ApocMutators.WTFEquipSCAR19Pickup'
	 ItemName="SCAR19"
}
