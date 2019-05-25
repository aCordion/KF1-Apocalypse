class SlotMachine_BloatCard extends SlotMachine_MonsterSpawnCard;

static function float ExecuteCard(Pawn Target)
{
	local Controller C;

	for (C=Target.Level.ControllerList; C != None; C=C.nextController)
		if (C.bIsPlayer && C.Pawn != Target && C.Pawn != None && C.Pawn.Health > 0 && PlayerController(C) != None)
			PlayerController(C).ReceiveLocalizedMessage(default.SpawnMessage, 0, Target.Controller.PlayerReplicationInfo);

	return super.ExecuteCard(Target);
}

defaultproperties
{
	 SpawnMessage=Class'ApocMutators.SlotMachine_BloatMessage'
	 MonsterClass=Class'ApocMutators.WTFZombiesBloatzilla'
	 NumMonsters=3
	 CardMaterial=Texture'KillingFloorHUD.Achievements.Achievement_30'
}
