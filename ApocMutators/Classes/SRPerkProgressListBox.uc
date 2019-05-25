class SRPerkProgressListBox extends KFPerkProgressListBox;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	DefaultListClass = string(Class'SRPerkProgressList');
	Super.InitComponent(MyController,MyOwner);
}

defaultproperties
{
}
