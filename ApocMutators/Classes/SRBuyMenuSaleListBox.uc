//-----------------------------------------------------------
//
//-----------------------------------------------------------
class SRBuyMenuSaleListBox extends KFBuyMenuSaleListBox;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	DefaultListClass = string(Class'SRBuyMenuSaleList');
	Super.InitComponent(MyController,MyOwner);
}
function GUIBuyable GetSelectedBuyable()
{
	return SRBuyMenuSaleList(List).GetSelectedBuyable();
}

defaultproperties
{
}
