class SRPerkSelectListBox extends KFPerkSelectListBox;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	DefaultListClass = string(Class'SRPerkSelectList');
	Super.InitComponent(MyController,MyOwner);
}

defaultproperties
{
}
