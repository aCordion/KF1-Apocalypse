//-----------------------------------------------------------
// Written by Marco
//-----------------------------------------------------------
class Doom3KFMut extends Mutator
	Config(ApocMonsters);

#exec obj load file="KFChar.u"

var() config float MinSpawnDelay, MaxSpawnDelay, BossWaveReduction,
	BossWaveRate, BossStartWaves, BossPerPlayerHP;
var() config bool bSpawnSuperMonsters, bAddSentryToTrader;
var() config array<string> LargeMaps, LargeBosses, NormalBosses,
	PatReplacement, LargePatReplacement;

/*kyan: removed
var() config array<string> MonsterClasses;*/

var bool bHasInit;
var int SuperMonWave, LastScannedWave;
var array< class<KFMonster> > Bosses;
/*kyan: removed
var array< class<KFMonster> > Doom3Mobs;*/
var KFGameType KF;
var float ProgressPct;

var const array< class<Actor> > PrecacheClasses;
var int MaxMonsters;

function PostBeginPlay()
{
	local int i;
	local bool bBig;
	local class<KFMonster> M;

	KF = KFGameType(Level.Game);

	if (KF==None)
	{
		Error("This mutator is only for KFGameType!");
	}
	else
	{
		if (LargeMaps.Length>0)
		{
			for (i=(LargeMaps.Length-1); i >= 0; --i)
			{
				if (LargeMaps[i] ~= string(Outer.Name))
				{
					bBig = true;
					break;
				}
			}
		}
		else
		{
			bBig = true;
		}

		if (!bBig)
		{
			if (PatReplacement.Length>0 && PatReplacement[0] != "None")
				KF.EndGameBossClass = PatReplacement[Rand(PatReplacement.Length)];
		}
		else
		{
			if (LargePatReplacement.Length>0 && LargePatReplacement[0] != "None")
				KF.EndGameBossClass = LargePatReplacement[Rand(LargePatReplacement.Length)];

			if (bSpawnSuperMonsters)
			{
				for (i=0; i<LargeBosses.Length; ++i)
				{
					M = LoadClass(LargeBosses[i]);

					if (M != None)
						Bosses[Bosses.Length] = M;
				}
			}
		}

		if (InStr(KF.EndGameBossClass, ".")==-1)
			KF.EndGameBossClass = string(Class.Outer.Name)$"."$KF.EndGameBossClass;

		if (bSpawnSuperMonsters)
		{
			for (i=0; i<NormalBosses.Length; ++i)
			{
				M = LoadClass(NormalBosses[i]);

				if (M != None)
					Bosses[Bosses.Length] = M;
			}
		}

		/*kyan: removed
		for (i=0; i<MonsterClasses.Length; ++i)
		{
			M = LoadClass(MonsterClasses[i]);
			if (M != None)
				Doom3Mobs[Doom3Mobs.Length] = M;
		}*/

		SetTimer(3, true);

		/*kyan: test
		TryToAddBoss();*/
	}
}

final function class<KFMonster> LoadClass(string S)
{
	if (InStr(S, ".")==-1)
		S = string(class.Outer.Name)$"."$S;

	return Class<KFMonster>(DynamicLoadObject(S, class'class'));
}

function Timer()
{
	/* kyan: test
	if (Level.Game.GetNumPlayers() <= 6)
		return;*/

	if (!bHasInit)
	{
		bHasInit = true;
		SuperMonWave = (KF.FinalWave * BossStartWaves);

		if (bAddSentryToTrader)
		{
			if (KF.KFLRules != None)
				KF.KFLRules.Destroy();

			KF.KFLRules = Spawn(Class'Doom3KF_KFDoom3LevelRules');
		}
	}

	if (LastScannedWave != KF.WaveNum)
	{
		if (!KF.bWaveInProgress)
		{
			MaxMonsters = 0;
			return;
		}

		if (MaxMonsters==0 && KF.TotalMaxMonsters>0)
			MaxMonsters = KF.TotalMaxMonsters;

		//kyan: add
		//if (KFGameType(Level.Game).TotalMaxMonsters > 20)
		if (KFGameType(Level.Game).TotalMaxMonsters > (MaxMonsters/2))
			return;

		if (KF.WaveNum<KF.FinalWave)
			ProgressPct = FClamp(float(KF.WaveNum+2)/float(KF.FinalWave), 0.1f, 1.f);
		else
			ProgressPct = 2.f;

		/*kyan: removed
		if (KF.WaveNum==2)
			Doom3Mobs.Remove(0, 1);*/ // Remove boney.

		LastScannedWave = KF.WaveNum;

		if (bSpawnSuperMonsters && FRand()<BossWaveRate
			&& KF.WaveNum >= SuperMonWave && KF.WaveNum<KF.FinalWave)
		{
			TryToAddBoss();

			/*kyan: add
			if (Level.Game.GetNumPlayers() >= 16)
				TryToAddBoss();*/
		}
	}
}

final function rotator GetRandDir()
{
	local rotator R;

	R.Yaw = Rand(65536);
	return R;
}

final function bool TestSpot(out VolumeColTester T, vector P, class<Actor> A)
{
	if (T==None)
	{
		T = Spawn(Class'VolumeColTester', , , P);

		if (T==None)
			return false;

		T.SetCollisionSize(A.Default.CollisionRadius, A.Default.CollisionHeight);
		T.bCollideWhenPlacing = True;
	}

	return T.SetLocation(P);
}

final function TryToAddBoss()
{
	local NavigationPoint N;
	local array<NavigationPoint> Candinates;
	local byte i;
	local int j;
	local class<KFMonster> TryMonster;
	local VolumeColTester Tst;

	if (Bosses.Length==0)
		return;

	for (N=Level.NavigationPointList; N != None; N=N.NextNavigationPoint)
		if (FRand()<0.5 && PathNode(N) != None)
			Candinates[Candinates.Length] = N;

	if (Candinates.Length==0)
		return;

	i = Rand(Bosses.Length);
	TryMonster = Bosses[i];
	Bosses.Remove(i, 1);

	for (i=0; i<30; i++) // Give it 30 tries
	{
		j = Rand(Candinates.Length);
		N = Candinates[j];

		// Try twice..
		if (TestSpot(Tst, N.Location, TryMonster)
			|| TestSpot(Tst,
						N.Location + vect(0, 0, 1) * (TryMonster.Default.CollisionHeight - N.CollisionHeight),
						TryMonster))
		{
			Spawn(class'Doom3KF_BossDemonSpawn', , , Tst.Location, GetRandDir()).DM = TryMonster;
			break;
		}

		// Remove candinate entry, and try random next...
		Candinates.Remove(j, 1);

		if (Candinates.Length==0)
			break;
	}

	Tst.Destroy();
}

static function FillPlayInfo(PlayInfo PlayInfo)
{
	Super.FillPlayInfo(PlayInfo);
	PlayInfo.AddSetting(default.RulesGroup, "bAddSentryToTrader", "Doom3KF_Sentry bot buyable", 0, 0, "Check");
	PlayInfo.AddSetting(default.RulesGroup, "bSpawnSuperMonsters", "Super monsters", 0, 0, "Check");
	PlayInfo.AddSetting(default.RulesGroup, "MinSpawnDelay", "Minimum Spawn Delay", 0, 1, "Text", "8;0.1:800.0");
	PlayInfo.AddSetting(default.RulesGroup, "MaxSpawnDelay", "Maximum Spawn Delay", 0, 1, "Text", "8;0.1:800.0");
	PlayInfo.AddSetting(default.RulesGroup, "BossWaveReduction", "BossWave Reduction", 0, 1, "Text", "6;0.0:1.0");
	PlayInfo.AddSetting(default.RulesGroup, "BossWaveRate", "BossWave rate", 0, 1, "Text", "6;0.0:1.0");
	PlayInfo.AddSetting(default.RulesGroup, "BossStartWaves", "BossWaves start", 0, 1, "Text", "6;0.0:1.0");
	PlayInfo.AddSetting(default.RulesGroup, "BossPerPlayerHP", "Boss Per Player HP", 0, 1, "Text", "6;0.0:1.0");
}

static event string GetDescriptionText(string PropName)
{
	switch(PropName)
	{
	case "bAddSentryToTrader":
		return "Add sentry bot to trader as buyable weapon.";
	case "bSpawnSuperMonsters":
		return "In later waves, add sometimes a boss monster.";
	case "MinSpawnDelay":
	case "MaxSpawnDelay":
		return "Minimum/Maximum time delay for adding in Doom 3 monster squads.";
	case "BossWaveReduction":
		return "Reduced percent in wave size on a boss wave (0.0 = no other zeds, 1.0 = full wave).";
	case "BossWaveRate":
		return "In percent, how big chance in later waves the wave is a boss wave (1.0 = always).";
	case "BossStartWaves":
		return "In percent, how many waves until boss waves start (1.0 = final wave, 0.0 = first wave).";
	case "BossPerPlayerHP":
		return "In percent, how much additional health bosses get per additional player (0.0 = none, 1.0 = double).";
	default:
		return Super.GetDescriptionText(PropName);
	}
}

/* kyan: removed
Auto state AddingD3Squads
{
	final function AddDoom3Mob()
	{
		local class<KFMonster> DC;
		local byte i;

		for (i=Rand(4); i<4; ++i)
		{
			DC = Doom3Mobs[Min(FRand()*ProgressPct*(Doom3Mobs.Length+2), Doom3Mobs.Length-1)];

			if (DC==None)
				continue;

			KF.NextSpawnSquad[KF.NextSpawnSquad.Length] = DC;
		}

		i = KF.NextSpawnSquad.Length;

		if (i>6)
			KF.NextSpawnSquad.Remove(6, i-6);

		KF.LastZVol = KF.FindSpawningVolume();
		KF.LastSpawningVolume = KF.LastZVol;
	}

Begin:
	while(ProgressPct<=1.f && !KF.bGameEnded)
	{
		Sleep(RandRange(MinSpawnDelay, MaxSpawnDelay));

		if (!KF.bWaveInProgress || KF.TotalMaxMonsters<=0)
			continue;

		AddDoom3Mob();
	}
}*/

function GetServerDetails(out GameInfo.ServerResponseLine ServerState)
{
	// append the mutator name.
	local int i;

	i = ServerState.ServerInfo.Length;
	ServerState.ServerInfo.Length = i+2;
	ServerState.ServerInfo[i].Key = "Mutator";
	ServerState.ServerInfo[i].Value = string(Class.Name);
	ServerState.ServerInfo[++i].Key = "Doom 3 Bosses";
	ServerState.ServerInfo[i].Value = Eval(bSpawnSuperMonsters, "true", "false");
}

function bool CheckReplacement(Actor Other, out byte bSuperRelevant)
{
	if (Doom3KF_Doom3Controller(Other) != None)
		Doom3KF_Doom3Controller(Other).bCanTele = true;

	return true;
}

function Mutate(string MutateString, PlayerController Sender)
{
	if (MutateString ~= "MakeBig" || MutateString ~= "MakeLarge")
	{
		if (Level.NetMode==NM_StandAlone || Sender.PlayerReplicationInfo.bAdmin)
		{
			MakeBigMap();
			Sender.ClientMessage(string(Outer.Name)@"has been made large map.");
		}

		return;
	}
	else if (MutateString ~= "MakeSmall")
	{
		if (Level.NetMode==NM_StandAlone || Sender.PlayerReplicationInfo.bAdmin)
		{
			MakeSmallMap();
			Sender.ClientMessage(string(Outer.Name)@"has been made small map.");
		}

		return;
	}
	else if (NextMutator != None)
	{
		NextMutator.Mutate(MutateString, Sender);
	}
}

final function MakeBigMap()
{
	local int i;

	for (i=(LargeMaps.Length-1); i >= 0; --i)
		if (LargeMaps[i] ~= string(Outer.Name))
			return;

	LargeMaps[LargeMaps.Length] = string(Outer.Name);
	SaveConfig();
}

final function MakeSmallMap()
{
	local int i;

	for (i=(LargeMaps.Length-1); i >= 0; --i)
	{
		if (LargeMaps[i] ~= string(Outer.Name))
		{
			LargeMaps.Remove(i, 1);
			SaveConfig();

			return;
		}
	}
}

simulated function UpdatePrecacheMaterials()
{
	local int i, j;
	local class<Actor> A;

	for (i=0; i<PrecacheClasses.Length; ++i)
	{
		A = PrecacheClasses[i];

		for (j=0; j<A.Default.Skins.Length; ++j)
			if (A.Default.Skins[j] != None)
				Level.AddPrecacheMaterial(A.default.Skins[j]);
	}
}

defaultproperties
{
	 MinSpawnDelay=5.000000
	 MaxSpawnDelay=50.000000
	 BossWaveReduction=0.400000
	 BossWaveRate=0.450000
	 BossStartWaves=0.400000
	 BossPerPlayerHP=0.400000
	 bSpawnSuperMonsters=True
	 bAddSentryToTrader=True
	 LargeBosses(0)="Doom3KF_Cyberdemon"
	 LargeBosses(1)="Doom3KF_Guardian"
	 LargeBosses(2)="Doom3KF_HunterBerserk"
	 LargeBosses(3)="Doom3KF_HunterHellTime"
	 NormalBosses(0)="Doom3KF_Sabaoth"
	 NormalBosses(1)="Doom3KF_Vagary"
	 NormalBosses(2)="Doom3KF_Maledict"
	 NormalBosses(3)="Doom3KF_HunterInvul"
	 /*
	 MonsterClasses(0)="Doom3KF_Boney"
	 MonsterClasses(1)="Doom3KF_FatZombie"
	 MonsterClasses(2)="Doom3KF_Imp"
	 MonsterClasses(3)="Doom3KF_Tick"
	 MonsterClasses(4)="Doom3KF_Trite"
	 MonsterClasses(5)="Doom3KF_Sawyer"
	 MonsterClasses(6)="Doom3KF_Pinky"
	 MonsterClasses(7)="Doom3KF_Maggot"
	 MonsterClasses(8)="Doom3KF_LostSoul"
	 MonsterClasses(9)="Doom3KF_Cherub"
	 MonsterClasses(10)="Doom3KF_Cacodemon"
	 MonsterClasses(11)="Doom3KF_Wraith"
	 MonsterClasses(12)="Doom3KF_Revenant"
	 MonsterClasses(13)="Doom3KF_Vulgar"
	 MonsterClasses(14)="Doom3KF_Commando"
	 MonsterClasses(15)="Doom3KF_Mancubus"
	 MonsterClasses(16)="Doom3KF_Archvile"
	 MonsterClasses(17)="Doom3KF_Bruiser"
	 MonsterClasses(18)="Doom3KF_Forgotten"
	 MonsterClasses(19)="Doom3KF_HellKnight"
	 */
	 PatReplacement(0)="None"
	 LargePatReplacement(0)="none"
	 ProgressPct=0.100000
	 PrecacheClasses(0)=Class'Doom3KF_CyberDemon'
	 PrecacheClasses(1)=Class'Doom3KF_Guardian'
	 PrecacheClasses(2)=Class'Doom3KF_HunterBerserk'
	 PrecacheClasses(3)=Class'Doom3KF_HunterHellTime'
	 PrecacheClasses(4)=Class'Doom3KF_Sabaoth'
	 PrecacheClasses(5)=Class'Doom3KF_Vagary'
	 PrecacheClasses(6)=Class'Doom3KF_Maledict'
	 PrecacheClasses(7)=Class'Doom3KF_HunterInvul'
	 /*
	 PrecacheClasses(8)=Class'Doom3KF_Boney'
	 PrecacheClasses(9)=Class'Doom3KF_FatZombie'
	 PrecacheClasses(10)=Class'Doom3KF_Imp'
	 PrecacheClasses(11)=Class'Doom3KF_Tick'
	 PrecacheClasses(12)=class'Doom3KF_Trite'
	 PrecacheClasses(13)=Class'Doom3KF_Sawyer'
	 PrecacheClasses(14)=Class'Doom3KF_Pinky'
	 PrecacheClasses(15)=Class'Doom3KF_Maggot'
	 PrecacheClasses(16)=Class'Doom3KF_LostSoul'
	 PrecacheClasses(17)=Class'Doom3KF_Cherub'
	 PrecacheClasses(18)=Class'Doom3KF_Cacodemon'
	 PrecacheClasses(19)=Class'Doom3KF_Wraith'
	 PrecacheClasses(20)=Class'Doom3KF_Revenant'
	 PrecacheClasses(21)=Class'Doom3KF_Vulgar'
	 PrecacheClasses(22)=Class'Doom3KF_Commando'
	 PrecacheClasses(23)=Class'Doom3KF_Mancubus'
	 PrecacheClasses(24)=Class'Doom3KF_Archvile'
	 PrecacheClasses(25)=Class'Doom3KF_Bruiser'
	 PrecacheClasses(26)=Class'Doom3KF_Forgotten'
	 PrecacheClasses(27)=Class'Doom3KF_HellKnight'
	 PrecacheClasses(28)=Class'Doom3KF_Sentry'
	 */
	 bAddToServerPackages=True
	 GroupName="KF-MonsterMut"
	 FriendlyName="Doom 3 Monsters Mode v0.4!"
	 Description="Do invasion of doom 3 creatures."
	 RulesGroup="DoomIII"
	 bAlwaysRelevant=True
	 RemoteRole=ROLE_SimulatedProxy
	 NetUpdateFrequency=1.000000
}
