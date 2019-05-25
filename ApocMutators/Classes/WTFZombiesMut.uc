class WTFZombiesMut extends Mutator;

//NormalSquad Mods
//also used to mod special squads
const NS_NUM_NEW = 40;
var String NSOld[NS_NUM_NEW];
var String NSNew[NS_NUM_NEW];
var Float NSChance[NS_NUM_NEW];

function PostBeginPlay()
{
	//kyan: modified
	SetTimer(5.0, true);

	Super.PostBeginPlay();
}

function Timer()
{
	local KFGameType KF;
	local byte squad, squadMem, replaceCounter, i, ii;
	local Class<KFMonster> MC;

	KF = KFGameType(Level.Game);

	//kyan: modified
	if ((KF != None) && (KF.WaveNum >= 2))
	{
		//kyan: removed
		//KF.EndGameBossClass="ApocMutators.WTFZombiesHateriarch";

		//normal squads
		for (squad=0; squad < KF.InitSquads.Length; squad++)
		{
			for (squadMem=0; squadMem < KF.InitSquads[squad].MSquad.Length; squadMem++)
			{
				for (replaceCounter=0; replaceCounter < NS_NUM_NEW; replaceCounter++)
				{
					if (String(KF.InitSquads[squad].MSquad[squadMem]) == NSOld[replaceCounter]
						&& FRand() <= NSChance[replaceCounter])
					{
						MC = Class<KFMonster>(DynamicLoadObject(NSNew[replaceCounter], Class'Class'));
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
				for (replaceCounter=0; replaceCounter < NS_NUM_NEW; replaceCounter++)
				{
					if (KF.SpecialSquads[i].ZedClass[ii] == NSOld[replaceCounter]
						&& FRand() <= NSChance[replaceCounter])
					{
						KF.SpecialSquads[i].ZedClass[ii]=NSNew[replaceCounter];
					}
				}
			}
		}

		//kyan: add
		SetTimer(0, false);
	}

	//Destroy();
}

defaultproperties
{
	 NSOld(0)="ApocZEDPack.ZEDS_ZombieClot"
	 NSOld(1)="ApocZEDPack.ZEDS_ZombieCrawler"
	 NSOld(2)="ApocZEDPack.ZEDS_ZombieCrawler"
	 NSOld(3)="ApocZEDPack.ZEDS_ZombieBloat"
	 NSOld(4)="ApocZEDPack.ZEDS_ZombieHusk"
	 NSOld(5)="ApocZEDPack.ZEDS_ZombieGorefast"
	 NSOld(6)="ApocZEDPack.ZEDS_ZombieScrake"
	 NSOld(7)="ApocZEDPack.ZEDS_ZombieFleshPound"
	 NSOld(8)="ApocZEDPack.ZEDS_CIRCUS_ZombieClot"
	 NSOld(9)="ApocZEDPack.ZEDS_CIRCUS_ZombieCrawler"
	 NSOld(10)="ApocZEDPack.ZEDS_CIRCUS_ZombieCrawler"
	 NSOld(11)="ApocZEDPack.ZEDS_CIRCUS_ZombieBloat"
	 NSOld(12)="ApocZEDPack.ZEDS_CIRCUS_ZombieHusk"
	 NSOld(13)="ApocZEDPack.ZEDS_CIRCUS_ZombieGorefast"
	 NSOld(14)="ApocZEDPack.ZEDS_CIRCUS_ZombieScrake"
	 NSOld(15)="ApocZEDPack.ZEDS_CIRCUS_ZombieFleshPound"
	 NSOld(16)="ApocZEDPack.ZEDS_HALLOWEEN_ZombieClot"
	 NSOld(17)="ApocZEDPack.ZEDS_HALLOWEEN_ZombieCrawler"
	 NSOld(18)="ApocZEDPack.ZEDS_HALLOWEEN_ZombieCrawler"
	 NSOld(19)="ApocZEDPack.ZEDS_HALLOWEEN_ZombieBloat"
	 NSOld(20)="ApocZEDPack.ZEDS_HALLOWEEN_ZombieHusk"
	 NSOld(21)="ApocZEDPack.ZEDS_HALLOWEEN_ZombieGorefast"
	 NSOld(22)="ApocZEDPack.ZEDS_HALLOWEEN_ZombieScrake"
	 NSOld(23)="ApocZEDPack.ZEDS_HALLOWEEN_ZombieFleshPound"
	 NSOld(24)="ApocZEDPack.ZEDS_HALLOWEEN_2011_ZombieClot"
	 NSOld(25)="ApocZEDPack.ZEDS_HALLOWEEN_2011_ZombieCrawler"
	 NSOld(26)="ApocZEDPack.ZEDS_HALLOWEEN_2011_ZombieCrawler"
	 NSOld(27)="ApocZEDPack.ZEDS_HALLOWEEN_2011_ZombieBloat"
	 NSOld(28)="ApocZEDPack.ZEDS_HALLOWEEN_2011_ZombieHusk"
	 NSOld(29)="ApocZEDPack.ZEDS_HALLOWEEN_2011_ZombieGorefast"
	 NSOld(30)="ApocZEDPack.ZEDS_HALLOWEEN_2011_ZombieScrake"
	 NSOld(31)="ApocZEDPack.ZEDS_HALLOWEEN_2011_ZombieFleshPound"
	 NSOld(32)="ApocZEDPack.ZEDS_XMAS__ZombieClot"
	 NSOld(33)="ApocZEDPack.ZEDS_XMAS__ZombieCrawler"
	 NSOld(34)="ApocZEDPack.ZEDS_XMAS__ZombieCrawler"
	 NSOld(35)="ApocZEDPack.ZEDS_XMAS__ZombieBloat"
	 NSOld(36)="ApocZEDPack.ZEDS_XMAS__ZombieHusk"
	 NSOld(37)="ApocZEDPack.ZEDS_XMAS__ZombieGorefast"
	 NSOld(38)="ApocZEDPack.ZEDS_XMAS__ZombieScrake"
	 NSOld(39)="ApocZEDPack.ZEDS_XMAS__ZombieFleshPound"
	 NSNew(0)="ApocMutators.WTFZombiesMetalClot"
	 NSNew(1)="ApocMutators.WTFZombiesBroodmother"
	 NSNew(2)="ApocMutators.WTFZombiesLeaper"
	 NSNew(3)="ApocMutators.WTFZombiesBloatzilla"
	 NSNew(4)="ApocMutators.WTFZombiesIncinerator"
	 NSNew(5)="ApocMutators.WTFZombiesGoreallyfast"
	 NSNew(6)="ApocMutators.WTFZombiesMauler"
	 NSNew(7)="ApocMutators.WTFZombiesMeatPounder"
	 NSNew(8)="ApocMutators.WTFZombiesMetalClot"
	 NSNew(9)="ApocMutators.WTFZombiesBroodmother"
	 NSNew(10)="ApocMutators.WTFZombiesLeaper"
	 NSNew(11)="ApocMutators.WTFZombiesBloatzilla"
	 NSNew(12)="ApocMutators.WTFZombiesIncinerator"
	 NSNew(13)="ApocMutators.WTFZombiesGoreallyfast"
	 NSNew(14)="ApocMutators.WTFZombiesMauler"
	 NSNew(15)="ApocMutators.WTFZombiesMeatPounder"
	 NSNew(16)="ApocMutators.WTFZombiesMetalClot"
	 NSNew(17)="ApocMutators.WTFZombiesBroodmother"
	 NSNew(18)="ApocMutators.WTFZombiesLeaper"
	 NSNew(19)="ApocMutators.WTFZombiesBloatzilla"
	 NSNew(20)="ApocMutators.WTFZombiesIncinerator"
	 NSNew(21)="ApocMutators.WTFZombiesGoreallyfast"
	 NSNew(22)="ApocMutators.WTFZombiesMauler"
	 NSNew(23)="ApocMutators.WTFZombiesMeatPounder"
	 NSNew(24)="ApocMutators.WTFZombiesMetalClot"
	 NSNew(25)="ApocMutators.WTFZombiesBroodmother"
	 NSNew(26)="ApocMutators.WTFZombiesLeaper"
	 NSNew(27)="ApocMutators.WTFZombiesBloatzilla"
	 NSNew(28)="ApocMutators.WTFZombiesIncinerator"
	 NSNew(29)="ApocMutators.WTFZombiesGoreallyfast"
	 NSNew(30)="ApocMutators.WTFZombiesMauler"
	 NSNew(31)="ApocMutators.WTFZombiesMeatPounder"
	 NSNew(32)="ApocMutators.WTFZombiesMetalClot"
	 NSNew(33)="ApocMutators.WTFZombiesBroodmother"
	 NSNew(34)="ApocMutators.WTFZombiesLeaper"
	 NSNew(35)="ApocMutators.WTFZombiesBloatzilla"
	 NSNew(36)="ApocMutators.WTFZombiesIncinerator"
	 NSNew(37)="ApocMutators.WTFZombiesGoreallyfast"
	 NSNew(38)="ApocMutators.WTFZombiesMauler"
	 NSNew(39)="ApocMutators.WTFZombiesMeatPounder"
	 NSChance(0)=0.200000
	 NSChance(1)=0.200000
	 NSChance(2)=0.200000
	 NSChance(3)=0.200000
	 NSChance(4)=0.200000
	 NSChance(5)=0.200000
	 NSChance(6)=0.200000
	 NSChance(7)=0.500000
	 NSChance(8)=0.200000
	 NSChance(9)=0.200000
	 NSChance(10)=0.200000
	 NSChance(11)=0.200000
	 NSChance(12)=0.200000
	 NSChance(13)=0.200000
	 NSChance(14)=0.200000
	 NSChance(15)=0.500000
	 NSChance(16)=0.200000
	 NSChance(17)=0.200000
	 NSChance(18)=0.200000
	 NSChance(19)=0.200000
	 NSChance(20)=0.200000
	 NSChance(21)=0.200000
	 NSChance(22)=0.200000
	 NSChance(23)=0.500000
	 NSChance(24)=0.200000
	 NSChance(25)=0.200000
	 NSChance(26)=0.200000
	 NSChance(27)=0.200000
	 NSChance(28)=0.200000
	 NSChance(29)=0.200000
	 NSChance(30)=0.200000
	 NSChance(31)=0.500000
	 NSChance(32)=0.200000
	 NSChance(33)=0.200000
	 NSChance(34)=0.200000
	 NSChance(35)=0.200000
	 NSChance(36)=0.200000
	 NSChance(37)=0.200000
	 NSChance(38)=0.200000
	 NSChance(39)=0.500000
	 bAddToServerPackages=True
	 GroupName="KF-WTFZombiesMut"
	 FriendlyName="WTFv1.4: WTFZombiesMut"
	 Description="Different variations of zombies appear during the game."
	 bAlwaysRelevant=True
	 RemoteRole=ROLE_SimulatedProxy
}
