// Created by Marco
class MapVote_MVLikePage extends LargeWindow;

var automated GUILabel l_Text;
var automated GUIButton b_Like, b_Dislike;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    Super.InitComponent(MyController, MyOwner);
    b_Like.Caption = MakeColorCode(Class'Canvas'.Static.MakeColor(64, 255, 64)) $ b_Like.Caption;
    b_Dislike.Caption = MakeColorCode(Class'Canvas'.Static.MakeColor(255, 64, 64)) $ b_Dislike.Caption;
}

function bool LikeClick(GUIComponent Sender)
{
    MapVote_KFVotingReplicationInfo(PlayerOwner().VoteReplicationInfo).SendMapLike(Sender == b_Like);
    Controller.CloseMenu();
    return false;
}

defaultproperties
{
     Begin Object Class=GUILabel Name=LikeInfo
         Caption="Did you like this map?"
         TextAlign=TXTA_Center
         TextColor=(G=255,R=255)
         WinTop=0.200000
         WinLeft=0.100000
         WinWidth=0.800000
         WinHeight=0.400000
     End Object
     l_Text=GUILabel'ApocMutators.MapVote_MVLikePage.LikeInfo'

     Begin Object Class=GUIButton Name=LikeButton
         Caption="Like"
         WinTop=0.530000
         WinLeft=0.380000
         WinWidth=0.110000
         WinHeight=0.075000
         OnClick=MapVote_MVLikePage.LikeClick
         OnKeyEvent=LikeButton.InternalOnKeyEvent
     End Object
     b_Like=GUIButton'ApocMutators.MapVote_MVLikePage.LikeButton'

     Begin Object Class=GUIButton Name=DislikeButton
         Caption="Dislike"
         WinTop=0.530000
         WinLeft=0.510000
         WinWidth=0.110000
         WinHeight=0.075000
         OnClick=MapVote_MVLikePage.LikeClick
         OnKeyEvent=DislikeButton.InternalOnKeyEvent
     End Object
     b_Dislike=GUIButton'ApocMutators.MapVote_MVLikePage.DislikeButton'

     WindowName="Map review"
     bRequire640x480=False
     WinTop=0.350000
     WinLeft=0.300000
     WinWidth=0.400000
     WinHeight=0.300000
     bAcceptsInput=False
}
