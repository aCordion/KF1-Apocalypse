Class SlotMachine_SlotsMachine extends HudOverlay;

#exec Texture Import File=Assets\SlotMachine\Failure.pcx Name=I_Fail Group="Icons" Mips=Off MASKED=1
#exec AUDIO IMPORT file="Assets\SlotMachine\alarm2.wav" NAME="FailAlarm" GROUP="FX"

var HUD InitHUD;
var Class<SlotMachine_SlotCard> Cards[3], ForcedWin, DoubleWin;
var float CardRollTimer[3], CardShowTime, NextAllowedTime;
var int CardIndex[3], LoadIndex, TotalKills, LastUsedIndex;
var SlotMachineMut Mut;
var byte CardNum, RenderCards, EndCardsState;

var array< class<SlotMachine_SlotCard> > CardsList;

var bool bDrawCards;

replication
{
    // Functions server can call.
    reliable if (Role == ROLE_Authority)
        ClientGiveCard, ClientEndCards, ClientSetCard;
}

simulated function BeginPlay()
{
    Disable('Tick');
    if (Level.NetMode != NM_DedicatedServer)
        SetTimer(0.1, true);
}
simulated function Timer()
{
    local PlayerController PC;

    PC = Level.GetLocalPlayerController();
    if (Level.NetMode == NM_Client)
    {
        if (PC.MyHUD == None)
            return;
Ok:
        Enable('Tick');
        InitHUD = PC.MyHUD;
        InitHUD.Overlays[InitHUD.Overlays.Length] = Self;
End:
        SetTimer(0, false);
        return;
    }
    else if (PC == None || Owner != PC)
        GoTo'End';
    else if (PC.MyHUD != None)
        GoTo'Ok';
}

simulated function Tick(float Delta)
{
    local byte i;
    local bool bUpdated;

    if (bDrawCards)
    {
        if (CardShowTime > 7)
            CardShowTime-=Delta;
        for (i=0; i < RenderCards; ++i)
        {
            if (CardRollTimer[i] > 0)
            {
                if (CardRollTimer[i] > 1.7)
                    CardRollTimer[i]-=Delta * 3.f;
                else CardRollTimer[i]-=Delta;
                bUpdated = true;
            }
        }
        if (!bUpdated)
        {
            CardShowTime-=Delta;
            if (CardShowTime <= 0.f)
                bDrawCards = false;
            else if (EndCardsState == 0 && RenderCards == 3 && CardShowTime < 6)
            {
                if (Cards[0] == Cards[1] && Cards[1] == Cards[2])
                    EndCardsState = 1;
                else
                {
                    EndCardsState = 2;
                    if (Level.GetLocalPlayerController().Pawn != None)
                        Level.GetLocalPlayerController().Pawn.PlaySound(Sound'FailAlarm', SLOT_None, 2);
                }
            }
        }
    }
}

simulated function Render(Canvas C)
{
    if (!bDrawCards || C.ViewPort.Actor.IsSpectating())
        return; // Don't draw.

    C.SetDrawColor(255, 255, 255, 255);
    C.Style = ERenderStyle.STY_Alpha;
    DrawCards(C);
}

simulated final function DrawCards(Canvas C)
{
    local float XS, YS, X, Y, XPos, A, Merge;
    local byte i;
    local int j, n;

    XS = C.ClipX * 0.07;
    YS = XS * 1.3f;
    Y = C.ClipY * 0.001f;

    if (CardShowTime > 7)
    {
        A = 8-CardShowTime;
        Y = -YS * (1.f-A) + Y * A;
    }
    else if (CardShowTime < 1)
        Y = -YS * (1.f-CardShowTime) + Y * CardShowTime;

    X = C.ClipX * 0.5f-XS * 1.5-3.f;
    if (EndCardsState == 1)
    {
        Merge = FMax(CardShowTime-5.f, 0.f);
        X += (XS + 3.f) * (1.f-Merge);
    }

    for (i=0; i < RenderCards; ++i)
    {
        if (Cards[i] == None)
            continue;
        if (EndCardsState == 1)
            XPos = X + (XS + 3.f) * i * Merge;
        else XPos = X + (XS + 3.f) * i;
        A = CardRollTimer[i];
        if (A <= 0.f)
            Cards[i].Static.DrawCard(C, XPos, Y, XS, YS, 0.5);
        else
        {
            if (A > 5.f)
                A = 5.f + (A-5.f) * 3.f;
            j = CardIndex[i];
            while(true)
            {
                // Recourse card indexes until ends up to those 2 to render.
                n = j + 1;
                if (n == CardsList.Length)
                    n = 0;
                if (A < 1.f)
                {
                    A = (1.f-A) * 0.5f;
                    CardsList[j].Static.DrawCard(C, XPos, Y, XS, YS, A);
                    CardsList[n].Static.DrawCard(C, XPos, Y, XS, YS, 0.5f + A);
                    break;
                }
                j = n;
                A-=1.f;
            }
        }
    }
    if (EndCardsState == 2)
    {
        C.SetPos(X, Y);
        C.DrawRect(texture'I_Fail', XS * 3 + 6.f, YS);
    }
}

simulated function Destroyed()
{
    local int i;

    if (InitHUD != None)
    {
        for (i=(InitHUD.Overlays.Length-1); i >= 0; --i)
            if (InitHUD.Overlays[i] == Self)
            {
                InitHUD.Overlays.Remove(i, 1);
                break;
            }
        InitHUD = None;
    }
}

simulated function ClientGiveCard(byte i, Class<SlotMachine_SlotCard> Card)
{
    local int j;

    for (j=0; j < CardsList.Length; ++j)
        if (CardsList[j] == Card)
        {
            CardIndex[i] = j;
            break;
        }
    Cards[i] = Card;
    CardRollTimer[i] = 10 + 5 * FRand();
    RenderCards = Max(RenderCards, i + 1);
    bDrawCards = true;
    if (CardShowTime > 0)
    {
        if (CardShowTime < 1)
            CardShowTime = 8-CardShowTime;
        else CardShowTime = FMax(7, CardShowTime);
    }
    else CardShowTime = 8;
}
simulated function ClientEndCards()
{
    RenderCards = 0;
    bDrawCards = false;
    EndCardsState = 0;
    CardShowTime = 0;
}
simulated function ClientSetCard(int i, Class<SlotMachine_SlotCard> Card)
{
    if (CardsList.Length < (i + 1))
        CardsList.Length = i + 1;
    CardsList[i] = Card;
}

function DrawNextCard()
{
    if (CardNum == 0) // First card, check if always win.
    {
        ForcedWin = None;
        DoubleWin = None;

        if (FRand() < (Mut.AlwaysWinChance / 100.f))
            ForcedWin = PickRandomCard(); // Force all to this card.
        else if (FRand() < 0.3)
            DoubleWin = PickRandomCard(); // Force 2 matching cards.
    }
    if (DoubleWin != None && CardNum < 2)
        Cards[CardNum] = DoubleWin;
    else if (ForcedWin == None)
        Cards[CardNum] = PickRandomCard();
    else Cards[CardNum] = ForcedWin;

    ClientGiveCard(CardNum, Cards[CardNum]);
    if (++CardNum >= 3)
    {
        TotalKills = 0;
        GoToState('GiveClientAward');
    }
    else if (Mut.PerSlotPauseTime > 0)
        NextAllowedTime = Level.TimeSeconds + Mut.PerSlotPauseTime;
}
final function Class<SlotMachine_SlotCard> PickRandomCard()
{
    local float Desire;
    local int i;

    for (i=(CardsList.Length-1); i >= 0; --i)
    {
        if (i == LastUsedIndex)
            Desire += CardsList[i].Default.Desireability * 0.25f;
        else Desire += CardsList[i].Default.Desireability;
    }
    if (Desire <= 0)
        return CardsList[Rand(CardsList.Length)];
    Desire *= FRand();
    for (i=(CardsList.Length-1); i >= 0; --i)
    {
        if (i == LastUsedIndex)
            Desire-=CardsList[i].Default.Desireability * 0.25f;
        else Desire-=CardsList[i].Default.Desireability;
        if (Desire <= 0.f)
            return CardsList[i];
    }
    return CardsList[Rand(CardsList.Length)];
}
final function int GetCardIndex(Class<SlotMachine_SlotCard> C)
{
    local int i;

    for (i=(CardsList.Length-1); i >= 0; --i)
        if (CardsList[i] == C)
            return i;
    return -1;
}

State LoadingClient
{
Ignores DrawNextCard;

Begin:
    Sleep(5.f);
    if (Owner == None)
        stop;
    for (LoadIndex=0; LoadIndex < CardsList.Length; ++LoadIndex)
    {
        ClientSetCard(LoadIndex, CardsList[LoadIndex]);
        Sleep(0.001f);
    }
    Sleep(0.5);
    GoToState('');
}
State GiveClientAward
{
Ignores DrawNextCard;

Begin:
    Sleep(8.f);
    ClientEndCards();
    if (Cards[0] == Cards[1] && Cards[1] == Cards[2])
    {
        if (CardsList.Length > 1)
            LastUsedIndex = GetCardIndex(Cards[0]);
        if (Owner != None && Controller(Owner).Pawn != None)
            Sleep(Cards[0].Static.ExecuteCard(Controller(Owner).Pawn));
    }
    Sleep(Mut.AfterRoundPauseTime);
    CardNum = 0;
    TotalKills = 0;
    GoToState('');
}

defaultproperties
{
     LastUsedIndex=-1
     bOnlyRelevantToOwner=True
     bSkipActorPropertyReplication=True
     RemoteRole=ROLE_SimulatedProxy
}
