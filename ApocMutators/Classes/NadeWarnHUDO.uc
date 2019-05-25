//=============================================================================
// Nade Warn HUD Overlay by Phada
//=============================================================================
class NadeWarnHUDO extends HUDOverlay;

const WARN_RADIUS = 500; // was 480 before update #3, grenade damage radius = 420
var NadeWarnMut Mut;
var Texture NadeTex;
var Font DangerFont;
var float SwitchColorTime;

simulated function Render(Canvas C) { // network support and optimizations by Marco
	local Pawn P;
	local Grenade G;
	local bool bIsMyNade;

	P = HUD(Owner).PawnOwner;
	if (P != None && P.Health > 0) {
		foreach P.VisibleCollidingActors(class'Grenade', G, WARN_RADIUS, P.Location, true) {
			if(Level.NetMode == NM_Client && !G.bTravel) { // Use bTravel on client side to check whatever its been initialized.
				G.bTravel = true;
				G.SetTimer(G.ExplodeTimer, false);
			}
			bIsMyNade = (G.Instigator == P);
			if ((!Mut.bOwnNadeOnly || bIsMyNade) && (!bIsMyNade || G.TimerCounter >= Mut.WarnDelay))
				DrawNadeIcon(C, G.Location);
			}
		}
	}

simulated function DrawNadeIcon(Canvas C, vector NadeLoc) {
	local vector ScreenLoc, CameraLoc, NadeDir;
	local rotator CameraRot;
	local float TexSize, TexAdjust;

	ScreenLoc = C.WorldToScreen(NadeLoc);
	C.GetCameraLocation(CameraLoc, CameraRot);
	NadeDir = NadeLoc - CameraLoc;
	if (NadeDir dot vector(CameraRot) > 0) { // in front
		TexSize = 64 * (3 - (VSize(NadeDir) / WARN_RADIUS * 2.4)); // scaled by distance from x3 to x0.6
		TexAdjust = TexSize / 2;
		C.Style = ERenderStyle.STY_Alpha;
		C.SetPos(ScreenLoc.X-TexAdjust, ScreenLoc.Y-TexAdjust);
		C.SetDrawColor(255, 255, 255, Mut.NadeAlpha);
		C.DrawTile(NadeTex, TexSize, TexSize, 0, 0, 64, 64);
		if (Mut.bShowDanger)
			DrawDangerWord(C, ScreenLoc, TexAdjust);
	}
}

simulated function DrawDangerWord(Canvas C, vector ScreenLoc, float TexAdjust) {
	local float TextWidth, TextHeight, TextXPos, TextYPos;

	if (ScreenLoc.X > -TexAdjust && ScreenLoc.X < (C.SizeX + TexAdjust)
	&& ScreenLoc.Y > -TexAdjust && ScreenLoc.Y < (C.SizeY + TexAdjust)) { // make sure the icon is inside the screen
		C.Font = DangerFont;
		C.StrLen("DANGER", TextWidth, TextHeight);
		TextXPos = ScreenLoc.X + TexAdjust; // right
		TextYPos = ScreenLoc.Y - TexAdjust; // upper pos
		if (ScreenLoc.X > (C.SizeX - TexAdjust - TextWidth)) // too to the right
			TextXpos = ScreenLoc.X - TexAdjust - TextWidth;
		if (ScreenLoc.Y < (TexAdjust + TextHeight)) // too to the top
			TextYPos = ScreenLoc.Y + TexAdjust;
		else if (ScreenLoc.Y > (C.SizeY - TexAdjust - TextHeight)) // too to the bottom
			TextYPos -= TextHeight;
		C.SetPos(TextXPos, TextYPos);
		if (Level.TimeSeconds < SwitchColorTime) // red/yellow color blink
			C.SetDrawColor(255, 200, 0);
		else {
			C.SetDrawColor(255, 0, 0);
			if (Level.TimeSeconds > SwitchColorTime + 0.15)
				SwitchColorTime = Level.TimeSeconds + 0.15;
		}
		c.DrawText("DANGER");
	}
}

defaultproperties
{
	 NadeTex=Texture'KillingFloorHUD.HUD.Hud_Grenade'
	 DangerFont=Font'ROFontsTwo.ROArial14DS'
}
