class ApocZedZombiesMut extends Mutator
	config(ApocMutators);

struct SReplZEDs {
	var config byte StartWave, EndWave;
	var config float Chance;
	var config string From, To;
	var transient class<KFMonster> FromClass, ToClass;
};
var config array<SReplZEDs> ReplZEDs;

function PostBeginPlay()
{
	Super.PostBeginPlay();

	RagdollLifeSpanPatch();
	SetTimer(0.1, false);
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
	ReplZEDs(0)=(StartWave=2,EndWave=7,Chance=0.150000,From="ApocZEDPack.ZEDS_ZombieBloat",To="ApocZEDPack.Shafter_ZombieShafter")
	ReplZEDs(1)=(StartWave=2,EndWave=7,Chance=0.100000,From="ApocZEDPack.ZEDS_ZombieFleshPound",To="ApocZEDPack.Brute_ZombieBrute")
	ReplZEDs(2)=(StartWave=2,EndWave=7,Chance=0.150000,From="ApocZEDPack.ZEDS_ZombieGorefast",To="ApocZEDPack.GoreShank_ZombieGoreShank")
	ReplZEDs(3)=(StartWave=2,EndWave=7,Chance=0.150000,From="ApocZEDPack.ZEDS_ZombieHusk",To="ApocZEDPack.HellFire_ZombieHellFire")
	ReplZEDs(4)=(StartWave=2,EndWave=7,Chance=0.150000,From="ApocZEDPack.ZEDS_ZombieScrake",To="ApocZEDPack.Jason_ZombieJason")
	ReplZEDs(5)=(StartWave=2,EndWave=7,Chance=0.050000,From="ApocZEDPack.ZEDS_ZombieSiren",To="ApocZEDPack.Dread_Dread")
	ReplZEDs(6)=(StartWave=2,EndWave=7,Chance=0.150000,From="ApocZEDPack.ZEDS_ZombieStalker",To="ApocZEDPack.Shiver_ZombieShiver")
}
