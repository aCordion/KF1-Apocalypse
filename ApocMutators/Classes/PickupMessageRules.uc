//-----------------------------------------------------------
// By Nanomo at killingfloorarg.com, thanks for read!
//-----------------------------------------------------------
class PickupMessageRules extends GameRules;

function bool OverridePickupQuery(Pawn Other, Pickup item, out byte bAllowPickup)
{
	local Inventory I;
	local KFWeaponPickup Weapon;
	local string WeaponName;
	local string PlayerName;
	local string Msg;

	Weapon = KFWeaponPickup(Item);

	if (Weapon != None)
	{
		I = Other.FindInventoryType(Weapon.InventoryType);

		if (I == None)
		{
			WeaponName=Weapon.ItemName;
			PlayerName=Other.GetHumanReadableName();

			Msg="@ð@"; // Green Color
			Msg $= Repl(class'PickupMessageMut'.Default.StringReplace, "%KFARGWeapon%", WeaponName);
			Msg=Repl(Msg, "%KFARGPlayerName%", PlayerName);
			Level.Game.Broadcast(None, Msg);
		}
	}

	return Super.OverridePickupQuery(Other, Item, bAllowPickup);
}

defaultproperties
{
}

