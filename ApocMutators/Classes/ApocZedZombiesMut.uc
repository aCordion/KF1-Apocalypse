class ApocZedZombiesMut extends Mutator
	config(ApocMutators);

struct SReplZEDs {
	var config byte StartWave, EndWave;
	var config float Chance;
	var config string From, To;
	var transient class<KFMonster> FromClass, ToClass;
};
var config array<SReplZEDs> ReplZEDs;

var int CurrWaveNum;

function PostBeginPlay()
{
	Super.PostBeginPlay();

	RagdollLifeSpanPatch();

	CurrWaveNum = -1;
	SetTimer(1.0, true);
}

function RagdollLifeSpanPatch()
{
	local int i;

	for (i = 0; i < ReplZEDs.Length; i++)
	{
		ReplZEDs[i].FromClass = Class<KFMonster>(DynamicLoadObject(ReplZEDs[i].From, Class'Class'));
		ReplZEDs[i].ToClass = Class<KFMonster>(DynamicLoadObject(ReplZEDs[i].To, Class'Class'));

		if ( ReplZEDs[i].FromClass == none )
			ReplZEDs[i].FromClass.Default.RagdollLifeSpan = 3;

		if ( ReplZEDs[i].ToClass == none )
			ReplZEDs[i].ToClass.Default.RagdollLifeSpan = 3;
	}
}

function Timer()
{
	local KFGameType KF;
	local byte squad, squadMem, zedCounter, i, ii;
	local Class<KFMonster> MC;
	local bool bZed, bChance, bWave;

	KF = KFGameType(Level.Game);

	if ((KF != None) && (KF.WaveNum >= 0))
	{
		// check next wave
		if (KF.WaveNum == CurrWaveNum)
			return;
		CurrWaveNum = KF.WaveNum;

		// check end game
		if (KF.WaveNum > KF.FinalWave)
			Destroy();

		//normal squads
		for (squad=0; squad < KF.InitSquads.Length; squad++)
		{
			for (squadMem=0; squadMem < KF.InitSquads[squad].MSquad.Length; squadMem++)
			{
				for (zedCounter=0; zedCounter < ReplZEDs.Length; zedCounter++)
				{
					bZed = (String(KF.InitSquads[squad].MSquad[squadMem]) == ReplZEDs[zedCounter].From);
					bChance = (FRand() <= ReplZEDs[zedCounter].Chance);
					bWave = ((ReplZEDs[zedCounter].StartWave <= KF.WaveNum+1) && (KF.WaveNum+1 <= ReplZEDs[zedCounter].EndWave));

					if (bZed && bChance && bWave)
					{
						MC = Class<KFMonster>(DynamicLoadObject(ReplZEDs[zedCounter].To, Class'Class'));
						KF.InitSquads[squad].MSquad[squadMem]=MC;
					}
				}
			}
		}

		//special squads
		for (i=0;i < KF.SpecialSquads.Length;i++)
		{
			for (ii=0; ii < KF.SpecialSquads[i].ZedClass.Length;ii++)
			{
				for (zedCounter=0; zedCounter < ReplZEDs.Length; zedCounter++)
				{
					bZed = (KF.SpecialSquads[i].ZedClass[ii] == ReplZEDs[zedCounter].From);
					bChance = (FRand() <= ReplZEDs[zedCounter].Chance);
					bWave = ((ReplZEDs[zedCounter].StartWave <= KF.WaveNum+1) && (KF.WaveNum+1 <= ReplZEDs[zedCounter].EndWave));

					if (bZed && bChance && bWave)
					{
						KF.SpecialSquads[i].ZedClass[ii]=ReplZEDs[zedCounter].To;
					}
				}
			}
		}
	}
}

defaultproperties
{
	bAddToServerPackages=True
	GroupName="KF-ApocZedZombiesMut"
	FriendlyName="[Apoc] ZED Zombies"
	Description="Different variations of zombies appear during the game."
	bAlwaysRelevant=True
	RemoteRole=ROLE_SimulatedProxy
	ReplZEDs(0)=(StartWave=1,EndWave=7,Chance=0.100000,From="ApocZEDPack.ZEDS_ZombieClot",To="ApocZEDPack.ZEDS_ZombieScrake")
	ReplZEDs(1)=(StartWave=2,EndWave=7,Chance=0.300000,From="ApocZEDPack.ZEDS_ZombieClot",To="ApocMutators.WTFZombiesMetalClot")
	ReplZEDs(2)=(StartWave=2,EndWave=7,Chance=0.300000,From="ApocZEDPack.ZEDS_ZombieCrawler",To="ApocMutators.WTFZombiesBroodmother")
	ReplZEDs(3)=(StartWave=2,EndWave=7,Chance=0.300000,From="ApocZEDPack.ZEDS_ZombieCrawler",To="ApocMutators.WTFZombiesLeaper")
	ReplZEDs(4)=(StartWave=2,EndWave=7,Chance=0.300000,From="ApocZEDPack.ZEDS_ZombieClot",To="ApocZEDPack.GoreShank_ZombieGoreShank")
	ReplZEDs(5)=(StartWave=2,EndWave=7,Chance=0.300000,From="ApocZEDPack.ZEDS_ZombieGorefast",To="ApocZEDPack.ZEDS_ZombieScrake")
	ReplZEDs(6)=(StartWave=3,EndWave=7,Chance=0.300000,From="ApocZEDPack.ZEDS_ZombieGorefast",To="ApocMutators.WTFZombiesGoreallyfast")
	ReplZEDs(7)=(StartWave=3,EndWave=7,Chance=0.300000,From="ApocZEDPack.ZEDS_ZombieBloat",To="ApocMutators.WTFZombiesBloatzilla")
	ReplZEDs(8)=(StartWave=3,EndWave=7,Chance=0.300000,From="ApocZEDPack.ZEDS_ZombieHusk",To="ApocMutators.WTFZombiesIncinerator")
	ReplZEDs(9)=(StartWave=3,EndWave=7,Chance=0.300000,From="ApocZEDPack.ZEDS_ZombieScrake",To="ApocZEDPack.ZEDS_ZombieFleshPound")
	ReplZEDs(10)=(StartWave=4,EndWave=7,Chance=0.300000,From="ApocZEDPack.ZEDS_ZombieScrake",To="ApocMutators.WTFZombiesMauler")
	ReplZEDs(11)=(StartWave=4,EndWave=7,Chance=1.300000,From="ApocZEDPack.ZEDS_ZombieFleshPound",To="ApocMutators.WTFZombiesMeatPounder")
	ReplZEDs(12)=(StartWave=4,EndWave=7,Chance=0.300000,From="ApocZEDPack.ZEDS_ZombieBloat",To="ApocZEDPack.Shafter_ZombieShafter")
	ReplZEDs(13)=(StartWave=5,EndWave=7,Chance=0.300000,From="ApocZEDPack.ZEDS_ZombieStalker",To="ApocZEDPack.Shiver_ZombieShiver")
	ReplZEDs(14)=(StartWave=5,EndWave=7,Chance=0.300000,From="ApocZEDPack.ZEDS_ZombieHusk",To="ApocZEDPack.HellFire_ZombieHellFire")
	ReplZEDs(15)=(StartWave=5,EndWave=7,Chance=0.300000,From="ApocZEDPack.ZEDS_ZombieScrake",To="ApocZEDPack.Jason_ZombieJason")
	ReplZEDs(16)=(StartWave=5,EndWave=7,Chance=0.300000,From="ApocZEDPack.ZEDS_ZombieFleshPound",To="ApocZEDPack.Brute_ZombieBrute")
	ReplZEDs(17)=(StartWave=5,EndWave=7,Chance=0.300000,From="ApocZEDPack.ZEDS_ZombieFleshPound",To="ApocZEDPack.MutantZombieFleshpound")
}
