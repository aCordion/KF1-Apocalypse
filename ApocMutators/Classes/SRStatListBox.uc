class SRStatListBox extends GUIListBoxBase;

var SRStatList List;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	DefaultListClass = string(Class'SRStatList');
	Super.InitComponent(MyController,MyOwner);
	List = SRStatList(AddComponent(DefaultListClass));
	if (List == None)
	{
		Warn(Class$".InitComponent - Could not create default list ["$DefaultListClass$"]");
		return;
	}
	InitBaseList(List);
}

function int GetIndex()
{
	return List.Index;
}

defaultproperties
{
}
