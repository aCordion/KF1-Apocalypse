class SRTab_MidGameStats extends SRTab_Base;

var automated GUISectionBackground	i_BGPerks;
var	automated SRStatListBox	lb_PerkSelect;

function ShowPanel(bool bShow)
{
	local ClientPerkRepLink L;

	super.ShowPanel(bShow);

	if ( bShow )
	{
		L = Class'ClientPerkRepLink'.Static.FindStats(PlayerOwner());
		if ( L!=None )
			lb_PerkSelect.List.InitList(L);
	}
}

defaultproperties
{
	Begin Object class=GUISectionBackground Name=BGPerks
		WinWidth=0.96152
		WinHeight=0.796032
		WinLeft=0.019240
		WinTop=0.012063
		Caption="Stats"
		bFillClient=true
	End Object
	i_BGPerks=BGPerks

	Begin Object class=SRStatListBox Name=StatSelectList
		WinWidth=0.94152
		WinHeight=0.742836
		WinLeft=0.029240
		WinTop=0.057760
	End Object
	lb_PerkSelect=StatSelectList
}