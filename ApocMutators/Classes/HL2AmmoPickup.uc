class HL2AmmoPickup extends KFAmmoPickup
	Abstract;

var KFGameType KFG;

function PostBeginPlay()
{
	// Add to KFGameType.AmmoPickups array
	KFG = KFGameType(Level.Game);
	if ( KFG!=none )
		KFG.AmmoPickups[KFG.AmmoPickups.Length] = self;
}
function Destroyed()
{
	local int i;

	Super.Destroyed();
	if ( KFG!=none )
	{
		// Remove from the list again.
		for( i=(KFG.AmmoPickups.Length-1); i>=0; --i )
			if( KFG.AmmoPickups[i]==Self || KFG.AmmoPickups[i]==None )
				KFG.AmmoPickups.Remove(i,1);
	}
}

state Pickup
{
	function SetRespawn()
	{
		GotoState('Sleeping', 'Begin');
		if ( KFG!=none )
			KFG.AmmoPickedUp(self);
	}
	
	// When touched by an actor.
	function Touch(Actor Other)
	{
		local Inventory Copy;

		if( ValidTouch(Other) )
		{
			Copy = SpawnCopy(Pawn(Other));
			AnnouncePickup(Pawn(Other));
			if ( Copy != None )
				Copy.PickupFunction(Pawn(Other));
			SetRespawn();
		}
	}
}

defaultproperties
{
     DrawScale=1.300000
     PrePivot=(Y=0.000000,Z=0.000000)
}
