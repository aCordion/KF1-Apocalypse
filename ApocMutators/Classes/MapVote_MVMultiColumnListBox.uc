//==================================================================== 
// Modified by Marco.
//==================================================================== 
class MapVote_MVMultiColumnListBox extends MapVoteMultiColumnListBox;

function InternalOnClick(GUIContextMenu Sender, int Index)
{
     if (Sender != None)
    {
        if (NotifyContextSelect(Sender, Index))
            return;

        switch(Index)
        {
        case 0:
            if (MapVotingPage(MenuOwner) != none)
                MapVotingPage(MenuOwner).SendVote(self);
            break;

        case 1:
            Controller.OpenMenu(string(Class'MapVote_MVMapInfoPage'), MapVoteMultiColumnList(List).GetSelectedMapName());
            break;
        case 2:
            if (MapVote_KFMapVotingPageX(MenuOwner) != none)
                MapVote_KFMapVotingPageX(MenuOwner).SendAdminSwitch(self);
            break;
        }
    }
}
function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    DefaultListClass = string(Class'MapVote_MVMultiColumnList');
    Super.InitComponent(MyController, MyOwner);
    if (PlayerOwner().PlayerReplicationInfo.bAdmin)
        ContextMenu.AddItem("Admin Force Map");
}
function LoadList(VotingReplicationInfo LoadVRI)
{
    local int i;

    ListArray.Length = LoadVRI.GameConfig.Length;
    for (i=0; i < LoadVRI.GameConfig.Length; i++)
    {
        ListArray[i] = new class'MapVote_MVMultiColumnList';
        ListArray[i].LoadList(LoadVRI, i);
    }
    if (LoadVRI.CurrentGameConfig < ListArray.Length)
        ChangeGameType(LoadVRI.CurrentGameConfig); // Fix for bug in initial maplist selection.
    else ChangeGameType(0);
}

defaultproperties
{
}
