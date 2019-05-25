//=============================================================================
// The Trader menu with a tab for the store and the perks
//=============================================================================
class SRGUIBuyMenu extends GUIBuyMenu;

function bool NotifyLevelChange()
{
	bPersistent = false;
	return true;
}
function InitTabs()
{
	local SRKFTab_BuyMenu B;

	B = SRKFTab_BuyMenu(c_Tabs.AddTab(PanelCaption[0], string(Class'SRKFTab_BuyMenu'),, PanelHint[0]));
	c_Tabs.AddTab(PanelCaption[1], string(Class'SRKFTab_Perks'),, PanelHint[1]);

	SRBuyMenuFilter(BuyMenuFilter).SaleListBox = SRBuyMenuSaleList(B.SaleSelect.List);
}

defaultproperties
{
	Begin Object class=SRKFQuickPerkSelect Name=QS
		WinTop=0.011906
		WinLeft=0.008008
		WinWidth=0.316601
		WinHeight=0.082460
	End Object
	QuickPerkSelect=QS
	
	Begin Object Class=SRWeightBar Name=WeightB
		WinTop=0.945302
		WinLeft=0.055266
		WinWidth=0.443888
		WinHeight=0.053896
	End Object
	WeightBar=WeightB
	
	Begin Object class=SRBuyMenuFilter Name=SRFilter
		WinTop=0.051
		WinLeft=0.67
		WinWidth=0.305
		WinHeight=0.082460
		RenderWeight=0.5
	End Object
	BuyMenuFilter=SRFilter
}