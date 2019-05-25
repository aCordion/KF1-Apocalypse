class ApocZedDreadManager extends Info;

const ZedWave = 2;

var KFGameType KF;
var int MaxMonsters;
var int LastScannedWave;
var int LastScannedWave2;
var int LastScannedWave3;

function PostBeginPlay()
{
    KF = KFGameType(Level.Game);
    SetTimer(3, true);
}

function Timer()
{
    local int i;
    local int ZedNum;
    local int PlayerCount;
    local Controller C;

    if (LastScannedWave != KF.WaveNum)
    {
        if (!KF.bWaveInProgress)
        {
            MaxMonsters = 0;
            return;
        }

        if (MaxMonsters==0 && KF.TotalMaxMonsters>0)
            MaxMonsters = KF.TotalMaxMonsters;

        if (KF.TotalMaxMonsters > (MaxMonsters-MaxMonsters/4))
            return;

        LastScannedWave = KF.WaveNum;

        if (ZedWave<=KF.WaveNum && KF.WaveNum<KF.FinalWave)
        {
            for ( C = Level.ControllerList; C != None; C = C.NextController )
                if ( C.bIsPlayer && (C.Pawn != None) )
                    PlayerCount++;

            //ZedNum = max(1, PlayerCount-(PlayerCount/3));//max(1, PlayerCount-1);
            ZedNum = max(1, PlayerCount-1);

            for (i=0; i<ZedNum; i++)
                AddDread();

            return;
        }
    }

    if (LastScannedWave2 != KF.WaveNum)
    {
        if (!KF.bWaveInProgress)
        {
            MaxMonsters = 0;
            return;
        }

        if (MaxMonsters==0 && KF.TotalMaxMonsters>0)
            MaxMonsters = KF.TotalMaxMonsters;

        if (KF.TotalMaxMonsters > (MaxMonsters-(MaxMonsters/4)*2))
            return;

        LastScannedWave2 = KF.WaveNum;

        if (ZedWave<=KF.WaveNum && KF.WaveNum<KF.FinalWave)
        {
            for ( C = Level.ControllerList; C != None; C = C.NextController )
                if ( C.bIsPlayer && (C.Pawn != None) )
                    PlayerCount++;

            //ZedNum = max(1, (PlayerCount/2));//max(1, PlayerCount-1);
            ZedNum = max(1, PlayerCount-1);

            for (i=0; i<ZedNum; i++)
                AddDread();

            return;
        }
    }

    if (LastScannedWave3 != KF.WaveNum)
    {
        if (!KF.bWaveInProgress)
        {
            MaxMonsters = 0;
            return;
        }

        if (MaxMonsters==0 && KF.TotalMaxMonsters>0)
            MaxMonsters = KF.TotalMaxMonsters;

        if (KF.TotalMaxMonsters > (MaxMonsters-(MaxMonsters/4)*3))
            return;

        LastScannedWave3 = KF.WaveNum;

        if (ZedWave<=KF.WaveNum && KF.WaveNum<KF.FinalWave)
        {
            for ( C = Level.ControllerList; C != None; C = C.NextController )
                if ( C.bIsPlayer && (C.Pawn != None) )
                    PlayerCount++;

            //ZedNum = max(1, (PlayerCount/3));//max(1, PlayerCount-1);
            ZedNum = max(1, PlayerCount-1);

            for (i=0; i<ZedNum; i++)
                AddDread();

            return;
        }
    }
}

final function AddDread()
{
    KF.NextSpawnSquad.Insert(0,1);
    KF.NextSpawnSquad[0] = Class'ApocZEDPack.Dread_Dread';

    KF.LastZVol = KF.FindSpawningVolume();
    KF.LastSpawningVolume = KF.LastZVol;
}

defaultproperties
{
}
