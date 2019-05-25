//=============================================================================
// HopMineLchr
//=============================================================================
class HopMineLchr extends M79GrenadeLauncher;

#exec OBJ LOAD FILE=HopMine_rc.ukx

var byte NumMinesOut;
var() byte MaximumMines;
var() localized string MinesText;

replication
{
	// Variables the server should send to the client.
	reliable if( Role==ROLE_Authority && bNetOwner )
		NumMinesOut;
}

final function AddMine( HopMineProj M )
{
	++NumMinesOut;
	M.WeaponOwner = Self;
	NetUpdateTime = Level.TimeSeconds-1;
}
final function RemoveMine( HopMineProj M )
{
	--NumMinesOut;
	M.WeaponOwner = None;
	NetUpdateTime = Level.TimeSeconds-1;
}
simulated function RenderOverlays( Canvas Canvas )
{
	Super.RenderOverlays(Canvas);
	Canvas.SetDrawColor(255,255,255,255);
	Canvas.Font = Canvas.MedFont;
	Canvas.SetPos(25,Canvas.ClipY*0.5);
	Canvas.DrawText(MinesText$NumMinesOut$"/"$MaximumMines,false);
}
function GiveTo(Pawn Other, optional Pickup Pickup)
{
	local HopMineProj P;

	Super.GiveTo(Other,Pickup);
	NumMinesOut = 0;
	foreach DynamicActors(Class'HopMineProj',P)
	{
		if( P.InstigatorController==Other.Controller && !P.bNeedsDetonate )
		{
			P.Instigator = Other;
			P.WeaponOwner = Self;
			++NumMinesOut;
		}
		else if( P.WeaponOwner==Self )
			P.WeaponOwner = None;
	}
}

defaultproperties
{
     MaximumMines=16
     MinesText="Mines: "
     HudImage=Texture'HopMine_rc.Icons.I_HopMine'
     SelectedHudImage=Texture'HopMine_rc.Icons.I_HopMine'
     TraderInfoTexture=Texture'HopMine_rc.Icons.I_HopMine'
     HudImageRef="HopMine_rc.Icons.I_HopMine"
     SelectedHudImageRef="HopMine_rc.Icons.I_HopMine"
     FireModeClass(0)=class'HopMineFire'
     Description="A Half-Life 2 hopmine launcher."
     PickupClass=class'HopMineLPickup'
     AttachmentClass=class'HopMineAttachment'
     ItemName="HopMine Launcher"
}
