//-----------------------------------------------------------
// MapVote_KFMapVotingPageX - Modification by Marco
//-----------------------------------------------------------
class MapVote_KFMapVotingPageX extends ROMapVotingPage;

// Also allow admins force mapswitch.
final function SendAdminSwitch(GUIComponent Sender)
{
	local int MapIndex, GameConfigIndex;

	if (Sender == lb_VoteCountListBox.List)
	{
		MapIndex = MapVoteCountMultiColumnList(lb_VoteCountListBox.List).GetSelectedMapIndex();
		if (MapIndex >= 0)
			GameConfigIndex = MapVoteCountMultiColumnList(lb_VoteCountListBox.List).GetSelectedGameConfigIndex();
	}
	else
	{
		MapIndex = MapVoteMultiColumnList(lb_MapListBox.List).GetSelectedMapIndex();
		if (MapIndex >= 0)
			GameConfigIndex = int(co_GameType.GetExtra());
	}
	if (MapIndex >= 0)
		MVRI.SendMapVote(MapIndex, -(GameConfigIndex + 1)); // Send with negative game index to indicate admin switch.
}

// Allow admins vote like all other players.
function SendVote(GUIComponent Sender)
{
	local int MapIndex, GameConfigIndex;

	if (Sender == lb_VoteCountListBox.List)
	{
		MapIndex = MapVoteCountMultiColumnList(lb_VoteCountListBox.List).GetSelectedMapIndex();
		if (MapIndex >= 0)
			GameConfigIndex = MapVoteCountMultiColumnList(lb_VoteCountListBox.List).GetSelectedGameConfigIndex();
	}
	else
	{
		MapIndex = MapVoteMultiColumnList(lb_MapListBox.List).GetSelectedMapIndex();
		if (MapIndex >= 0)
			GameConfigIndex = int(co_GameType.GetExtra());
	}
	if (MapIndex >= 0)
	{
		if (MVRI.MapList[MapIndex].bEnabled)
			MVRI.SendMapVote(MapIndex, GameConfigIndex);
		else PlayerOwner().ClientMessage(lmsgMapDisabled);
	}
}

defaultproperties
{
	Begin Object Class=MapVote_MVMultiColumnListBox Name=MapListBox
		HeaderColumnPerc(0)=0.500000
		HeaderColumnPerc(1)=0.150000
		HeaderColumnPerc(2)=0.150000
		HeaderColumnPerc(3)=0.200000
		bVisibleWhenEmpty=True
		OnCreateComponent=MapListBox.InternalOnCreateComponent
		StyleName="ServerBrowserGrid"
		WinTop=0.371020
		WinLeft=0.020000
		WinWidth=0.960000
		WinHeight=0.293104
		bBoundToParent=True
		bScaleToParent=True
		OnRightClick=MapListBox.InternalOnRightClick
	End Object
	lb_MapListBox=MapVote_MVMultiColumnListBox'ApocMutators.MapVote_KFMapVotingPageX.MapListBox'

	Begin Object Class=MapVote_MVCountColumnListBox Name=VoteCountListBox
		HeaderColumnPerc(0)=0.300000
		HeaderColumnPerc(1)=0.300000
		HeaderColumnPerc(2)=0.200000
		HeaderColumnPerc(3)=0.200000
		bVisibleWhenEmpty=True
		OnCreateComponent=VoteCountListBox.InternalOnCreateComponent
		WinTop=0.052930
		WinLeft=0.020000
		WinWidth=0.960000
		WinHeight=0.223770
		bBoundToParent=True
		bScaleToParent=True
		OnRightClick=VoteCountListBox.InternalOnRightClick
	End Object
	lb_VoteCountListBox=MapVote_MVCountColumnListBox'ApocMutators.MapVote_KFMapVotingPageX.VoteCountListBox'

	Begin Object Class=moComboBox Name=GameTypeCombo
		CaptionWidth=0.350000
		Caption="Select Game Type:"
		OnCreateComponent=GameTypeCombo.InternalOnCreateComponent
		WinTop=0.334309
		WinLeft=0.199219
		WinWidth=0.757809
		WinHeight=0.037500
		bScaleToParent=True
	End Object
	co_GameType=moComboBox'ApocMutators.MapVote_KFMapVotingPageX.GameTypeCombo'
}
