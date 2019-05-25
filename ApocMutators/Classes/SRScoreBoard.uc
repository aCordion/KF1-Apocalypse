class SRScoreBoard extends KFScoreBoard;

#exec TEXTURE IMPORT FILE="Assets\ServerPerks\Shield.pcx" NAME="I_AdminShield" GROUP="Icons" MIPS=0 MASKED=1

var bool bDrawLevelDigits;
var byte FrameCounter;
var localized string NotShownInfo,PlayerCountText,SpectatorCountText,AliveCountText,BotText;

simulated static final function Material GetCountryFlag( PlayerReplicationInfo PRI )
{
	if( PRI.Skins.Length!=1 )
	{
		PRI.Skins.Length = 1;
		if( Mid(PRI.PlayerName,4,1)=="]" )
			PRI.Skins[0] = Material(DynamicLoadObject("CountryFlagsTex."$Mid(PRI.PlayerName,1,3),Class'Material',true));
		else PRI.Skins[0] = Material(DynamicLoadObject("CountryFlagsTex."$Mid(PRI.PlayerName,1,2),Class'Material',true));
	}
	return PRI.Skins[0];
}
simulated static final function float DrawCountryName( Canvas C, PlayerReplicationInfo PRI, float X, float Y, optional byte MaxLen )
{
	local float XL,YL,Result;
	local Color Cl;
	local Material M;
	local string S;

	if( MaxLen>0 )
		S = Left(PRI.PlayerName,MaxLen);
	else S = PRI.PlayerName;
	if( Mid(S,0,1)=="[" )
	{
		if( Mid(S,4,1)=="]" )
		{
			M = GetCountryFlag(PRI);
			if( M!=None )
			{
				C.TextSize("ABC",XL,YL);
				Cl = C.DrawColor;
				C.DrawColor = Class'HudBase'.Default.WhiteColor;
				C.SetPos(X, Y+(YL*0.2));
				C.DrawTile(M, YL, YL, 0, 0, M.MaterialUSize(), M.MaterialVSize());
				X+=YL;
				S = Mid(S,5);
				C.DrawColor = Cl;
			}
		}
		else if( Mid(S,3,1)=="]" )
		{
			M = GetCountryFlag(PRI);
			if( M!=None )
			{
				C.TextSize("ABC",XL,YL);
				Cl = C.DrawColor;
				C.DrawColor = Class'HudBase'.Default.WhiteColor;
				C.SetPos(X, Y+(YL*0.2));
				C.DrawTile(M, YL, YL, 0, 0, M.MaterialUSize(), M.MaterialVSize());
				X+=YL;
				S = Mid(S,4);
				C.DrawColor = Cl;
			}
		}
	}
	C.SetPos(X, Y);
	C.DrawTextClipped(S,false);
	C.TextSize(S,Result,XL);
	return Result + YL;
}
simulated static final function TextSizeCountry( Canvas C, PlayerReplicationInfo PRI, out float XL, out float YL )
{
	local float XS;
	local Material M;
	local string S;

	XL = 0;
	S = PRI.PlayerName;
	if( Mid(S,0,1)=="[" )
	{
		if( Mid(S,4,1)=="]" )
		{
			M = GetCountryFlag(PRI);
			if( M!=None )
			{
				C.TextSize("ABC",XS,YL);
				XL = YL;
				S = Mid(S,5);
			}
		}
		else if( Mid(S,3,1)=="]" )
		{
			M = GetCountryFlag(PRI);
			if( M!=None )
			{
				C.TextSize("ABC",XS,YL);
				XL = YL;
				S = Mid(S,4);
			}
		}
	}
	C.TextSize(S,XS,YL);
	XL+=XS;
}

simulated static final function DrawProgressBar( Canvas C, float X, float Y, float XS, float YS, float Value )
{
	C.DrawColor.A = 64;
	C.SetPos(X, Y);
	C.DrawTileStretched(Texture'thinpipe_b',XS,YS);
	if( Value>0.f )
	{
		C.DrawColor.A = 150;
		C.SetPos(X,Y);
		C.DrawTileStretched(Texture'thinpipe_f',XS*Value,YS);
	}
}

simulated event UpdateScoreBoard(Canvas Canvas)
{
	local PlayerReplicationInfo PRI, OwnerPRI;
	local KFPlayerReplicationInfo KFPRI;
	local KF_StoryPRI StoryPRI;
	local int i, FontReduction, NetXPos, PlayerCount, HeaderOffsetY, HeadFoot, MessageFoot, PlayerBoxSizeY, BoxSpaceY, NameXPos, BoxTextOffsetY, OwnerOffset, HealthXPos, BoxXPos,KillsXPos, TitleYPos, BoxWidth, VetXPos, NotShownCount;
	local float XL,YL;
	local float deathsXL, KillsXL, NetXL, HealthXL, MaxNamePos, KillWidthX, CashXPos, TimeXPos, PProgressXS, StoryIconXPos;
	local Material VeterancyBox,StarBox;
	local string S;
	local byte Stars;
	local KF_StoryObjective CurrentObj;
	local Font LvlFont,OrgFont;

	if( ++FrameCounter>250 )
	{
		FrameCounter = 0;
		bDrawLevelDigits = FALSE;
	}
	OwnerPRI = KFPlayerController(Owner).PlayerReplicationInfo;
	OwnerOffset = -1;

	for ( i = 0; i < GRI.PRIArray.Length; i++)
	{
		PRI = GRI.PRIArray[i];
		if ( !PRI.bOnlySpectator )
		{
			if( !PRI.bOutOfLives && KFPlayerReplicationInfo(PRI).PlayerHealth>0 )
				++HeadFoot;
			if ( PRI == OwnerPRI )
				OwnerOffset = i;
			PlayerCount++;
		}
		else ++NetXPos;
	}

	// First, draw title.
	if(KF_StoryGRI(GRI) != none)
	{
		CurrentObj = KF_StoryGRI(GRI).GetCurrentObjective();
		if(CurrentObj != none)
			S = CurrentObj.HUD_Header.Header_Text;
	}
	else S = WaveString @ (InvasionGameReplicationInfo(GRI).WaveNumber + 1);
	S = SkillLevel[Clamp(InvasionGameReplicationInfo(GRI).BaseDifficulty, 0, 7)] $ " | " $ S $ " | " $ Level.Title $ " | " $ FormatTime(GRI.ElapsedTime);

	Canvas.Font = class'ROHud'.static.GetSmallMenuFont(Canvas);
	Canvas.TextSize(S, XL,YL);
	Canvas.DrawColor = HUDClass.default.RedColor;
	Canvas.Style = ERenderStyle.STY_Normal;

	HeaderOffsetY = Canvas.ClipY * 0.11;
	Canvas.SetPos(0.5 * (Canvas.ClipX - XL), HeaderOffsetY);
	Canvas.DrawTextClipped(S);

	// Second title line
	S = PlayerCountText@PlayerCount@SpectatorCountText@NetXPos@AliveCountText@HeadFoot;
	Canvas.TextSize(S, XL,YL);
	HeaderOffsetY+=YL;
	Canvas.SetPos(0.5 * (Canvas.ClipX - XL), HeaderOffsetY);
	Canvas.DrawTextClipped(S);
	HeaderOffsetY+=(YL*3.f);

	// Select best font size and box size to fit as many players as possible on screen
	if ( Canvas.ClipX < 600 )
		i = 4;
	else if ( Canvas.ClipX < 800 )
		i = 3;
	else if ( Canvas.ClipX < 1000 )
		i = 2;
	else if ( Canvas.ClipX < 1200 )
		i = 1;
	else i = 0;

	Canvas.Font = class'ROHud'.static.LoadMenuFontStatic(i);
	Canvas.TextSize("Test", XL, YL);
	PlayerBoxSizeY = 1.2 * YL;
	BoxSpaceY = 0.25 * YL;

	while( ((PlayerBoxSizeY+BoxSpaceY)*PlayerCount)>(Canvas.ClipY-HeaderOffsetY) )
	{
		if( ++i>=5 || ++FontReduction>=3 ) // Shrink font, if too small then break loop.
		{
			// We need to remove some player names here to make it fit.
			NotShownCount = PlayerCount-int((Canvas.ClipY-HeaderOffsetY)/(PlayerBoxSizeY+BoxSpaceY))+1;
			PlayerCount-=NotShownCount;
			break;
		}
		Canvas.Font = class'ROHud'.static.LoadMenuFontStatic(i);
		Canvas.TextSize("Test", XL, YL);
		PlayerBoxSizeY = 1.2 * YL;
		BoxSpaceY = 0.25 * YL;
	}
	if( bDrawLevelDigits )
	{
		LvlFont = class'ROHud'.static.LoadMenuFontStatic(i+2);
		OrgFont = Canvas.Font;
	}

	HeadFoot = 7 * YL;
	MessageFoot = 1.5 * HeadFoot;

	BoxWidth = 0.9 * Canvas.ClipX;
	BoxXPos = 0.5 * (Canvas.ClipX - BoxWidth);
	BoxWidth = Canvas.ClipX - 2 * BoxXPos;
	VetXPos = BoxXPos + 0.0001 * BoxWidth;
	NameXPos = BoxXPos + 0.145 * BoxWidth;
	StoryIconXPos = BoxXPos + 0.48 * BoxWidth;
	KillsXPos = BoxXPos + 0.55 * BoxWidth;
	CashXPos = BoxXPos + 0.65 * BoxWidth;
	HealthXpos = BoxXPos + 0.75 * BoxWidth;
	TimeXPos = BoxXPos + 0.87 * BoxWidth;
	NetXPos = BoxXPos + 0.996 * BoxWidth;
	PProgressXS = BoxWidth * 0.1f;

	// draw background boxes
	Canvas.Style = ERenderStyle.STY_Alpha;
	Canvas.DrawColor = HUDClass.default.WhiteColor;
	Canvas.DrawColor.A = 128;

	for ( i = 0; i < PlayerCount; i++ )
	{
		Canvas.SetPos(BoxXPos, HeaderOffsetY + (PlayerBoxSizeY + BoxSpaceY) * i);
		Canvas.DrawTileStretched( BoxMaterial, BoxWidth, PlayerBoxSizeY);
	}
	if( NotShownCount>0 ) // Add box for not shown players.
	{
		Canvas.DrawColor = HUDClass.default.RedColor;
		Canvas.SetPos(BoxXPos, HeaderOffsetY + (PlayerBoxSizeY + BoxSpaceY) * PlayerCount);
		Canvas.DrawTileStretched( BoxMaterial, BoxWidth, PlayerBoxSizeY);
		Canvas.DrawColor = HUDClass.default.WhiteColor;
	}

	// Draw headers
	TitleYPos = HeaderOffsetY - 1.1 * YL;
	Canvas.TextSize(HealthText, HealthXL, YL);
	Canvas.TextSize(DeathsText, DeathsXL, YL);
	Canvas.TextSize(KillsText, KillsXL, YL);
	Canvas.TextSize(NetText, NetXL, YL);

	Canvas.DrawColor = HUDClass.default.WhiteColor;
	Canvas.SetPos(NameXPos, TitleYPos);
	Canvas.DrawTextClipped(PlayerText);

	Canvas.SetPos(KillsXPos - 0.5 * KillsXL, TitleYPos);
	Canvas.DrawTextClipped(KillsText);

	Canvas.TextSize(PointsText, XL, YL);
	Canvas.SetPos(CashXPos - 0.5 * XL, TitleYPos);
	Canvas.DrawTextClipped(PointsText);

	Canvas.TextSize(TimeText, XL, YL);
	Canvas.SetPos(TimeXPos - 0.5 * XL, TitleYPos);
	Canvas.DrawTextClipped(TimeText);

	Canvas.SetPos(HealthXPos - 0.5 * HealthXL, TitleYPos);
	Canvas.DrawTextClipped(HealthText);

	Canvas.Style = ERenderStyle.STY_Normal;
	Canvas.DrawColor = HUDClass.default.WhiteColor;
	Canvas.SetPos(0.5 * Canvas.ClipX, HeaderOffsetY + 4);

	Canvas.DrawColor = HUDClass.default.WhiteColor;
	Canvas.SetPos(NetXPos - NetXL, TitleYPos);
	Canvas.DrawTextClipped(NetText);

	BoxTextOffsetY = HeaderOffsetY + 0.5 * (PlayerBoxSizeY - YL);

	Canvas.DrawColor = HUDClass.default.WhiteColor;
	MaxNamePos = Canvas.ClipX;
	Canvas.ClipX = KillsXPos - 4.f;

	for ( i = 0; i < PlayerCount; i++ )
	{
		if( i == OwnerOffset )
		{
			Canvas.DrawColor.G = 0;
			Canvas.DrawColor.B = 0;
		}
		else
		{
			Canvas.DrawColor.G = 255;
			Canvas.DrawColor.B = 255;
		}
		DrawCountryName(Canvas,GRI.PRIArray[i],NameXPos,(PlayerBoxSizeY + BoxSpaceY)*i + BoxTextOffsetY);
	}
	if( NotShownCount>0 ) // Draw not shown info
	{
		Canvas.DrawColor.G = 255;
		Canvas.DrawColor.B = 0;
		Canvas.SetPos(NameXPos, (PlayerBoxSizeY + BoxSpaceY)*PlayerCount + BoxTextOffsetY);
		Canvas.DrawText(NotShownCount@NotShownInfo,true);
	}

	Canvas.ClipX = MaxNamePos;
	Canvas.DrawColor = HUDClass.default.WhiteColor;

	Canvas.Style = ERenderStyle.STY_Normal;

	// Draw the player informations.
	for ( i = 0; i < PlayerCount; i++ )
	{
		PRI = GRI.PRIArray[i];
		KFPRI = KFPlayerReplicationInfo(PRI);
		StoryPRI = KF_StoryPRI(PRI);
		Canvas.DrawColor = HUDClass.default.WhiteColor;

		// Display admin.
		if( PRI.bAdmin && !bDrawLevelDigits )
		{
			Canvas.SetPos(BoxXPos - PlayerBoxSizeY, (PlayerBoxSizeY + BoxSpaceY) * i + HeaderOffsetY + PlayerBoxSizeY*0.25);
			XL = PlayerBoxSizeY*0.5;
			Canvas.DrawTile(Texture'I_AdminShield', XL, XL, 0, 0, Texture'I_AdminShield'.USize, Texture'I_AdminShield'.VSize);
		}

		// display Story Icon
		if ( StoryPRI != none )
		{
			StarBox = StoryPRI.GetFloatingIconMat();
			if ( StarBox != none )
			{
				Canvas.SetPos(StoryIconXPos, (PlayerBoxSizeY + BoxSpaceY) * i + HeaderOffsetY + 1 );
				Canvas.DrawTile(StarBox, PlayerBoxSizeY*0.8, PlayerBoxSizeY*0.8, 0, 0, StarBox.MaterialUSize(), StarBox.MaterialVSize());
			}
		}

		// Display perks.
		if ( KFPRI!=None && Class<SRVeterancyTypes>(KFPRI.ClientVeteranSkill)!=none )
		{
			Stars = Class<SRVeterancyTypes>(KFPRI.ClientVeteranSkill).Static.PreDrawPerk(Canvas
				,KFPRI.ClientVeteranSkillLevel,VeterancyBox,StarBox);

			if ( VeterancyBox != None )
			{
				YL = HeaderOffsetY+(PlayerBoxSizeY+BoxSpaceY)*i;
				DrawPerkWithStars(Canvas,VetXPos,YL,PlayerBoxSizeY,Stars,VeterancyBox,StarBox);
				if( bDrawLevelDigits )
				{
					Canvas.SetPos(BoxXPos,YL);
					Canvas.Font = LvlFont;
					Canvas.DrawColor = HUDClass.default.GoldColor;
					S = "Lv"$string(KFPRI.ClientVeteranSkillLevel);
					Canvas.TextSize(S,XL,YL);
					Canvas.CurX-=(XL*1.025);
					Canvas.CurY+=(PlayerBoxSizeY-YL)*0.5;
					Canvas.DrawTextClipped(S);
					Canvas.Font = OrgFont;
				}
			}
			Canvas.DrawColor = HUDClass.default.WhiteColor;

			// Draw perk progress
			if( !PRI.bBot && KFPRI.ThreeSecondScore>=0 )
			{
				YL = float(KFPRI.ThreeSecondScore) / 10000.f;
				DrawProgressBar(Canvas,KillsXPos-PProgressXS*1.5,HeaderOffsetY + (PlayerBoxSizeY + BoxSpaceY) * i + PlayerBoxSizeY*0.4,PProgressXS,PlayerBoxSizeY*0.2,FClamp(YL,0.f,1.f));
				Canvas.DrawColor.A = 255;
			}

            //kyan: add
            Canvas.SetPos((VetXPos + 30.0f),(PlayerBoxSizeY + BoxSpaceY) * i + BoxTextOffsetY);
            Canvas.DrawTextClipped("Lv" @ Stars);
		}

		// draw kills
		if( KFPRI!=None )
		{
			Canvas.TextSize(KFPRI.Kills, KillWidthX, YL);
			Canvas.SetPos(KillsXPos - 0.5 * KillWidthX, (PlayerBoxSizeY + BoxSpaceY) * i + BoxTextOffsetY);
			Canvas.DrawTextClipped(KFPRI.Kills);
		}

		// draw cash
		S = string(int(PRI.Score));
		Canvas.TextSize(S, XL, YL);
		Canvas.SetPos(CashXPos-XL*0.5f, (PlayerBoxSizeY + BoxSpaceY)*i + BoxTextOffsetY);
		Canvas.DrawText(S,true);

		// draw time
		if( GRI.ElapsedTime<PRI.StartTime ) // Login timer error, fix it.
			GRI.ElapsedTime = PRI.StartTime;
		S = FormatTime(GRI.ElapsedTime-PRI.StartTime);
		Canvas.TextSize(S, XL, YL);
		Canvas.SetPos(TimeXPos-XL*0.5f, (PlayerBoxSizeY + BoxSpaceY)*i + BoxTextOffsetY);
		Canvas.DrawText(S,true);

		// Draw ping
		if ( !GRI.bMatchHasBegun )
		{
			if ( PRI.bReadyToPlay )
				S = ReadyText;
			else S = NotReadyText;
		}
		else if( !PRI.bBot )
			S = string(PRI.Ping*4);
		else S = BotText;
		Canvas.TextSize(S, XL, YL);
		Canvas.SetPos(NetXPos-XL, (PlayerBoxSizeY + BoxSpaceY) * i + BoxTextOffsetY);
		Canvas.DrawTextClipped(S);

		// draw healths
		if ( PRI.bOutOfLives || KFPRI==None || KFPRI.PlayerHealth<=0 )
		{
			Canvas.DrawColor = HUDClass.default.RedColor;
			S = OutText;
		}
		else
		{
			if( KFPRI.PlayerHealth>=90 )
				Canvas.DrawColor = HUDClass.default.GreenColor;
			else if( KFPRI.PlayerHealth>=50 )
				Canvas.DrawColor = HUDClass.default.GoldColor;
			else Canvas.DrawColor = HUDClass.default.RedColor;
			S = KFPlayerReplicationInfo(PRI).PlayerHealth@HealthyString;
		}
		Canvas.TextSize(S, XL, YL);
		Canvas.SetPos(HealthXpos - 0.5 * XL, (PlayerBoxSizeY + BoxSpaceY) * i + BoxTextOffsetY);
		Canvas.DrawTextClipped(S);
	}
}

simulated final function DrawPerkWithStars( Canvas C, float X, float Y, float Scale, int Stars, Material PerkIcon, Material StarIcon )
{
	C.SetPos(X,Y);
	C.DrawTile(PerkIcon, Scale, Scale, 0, 0, PerkIcon.MaterialUSize(), PerkIcon.MaterialVSize());
}

simulated function bool InOrder( PlayerReplicationInfo P1, PlayerReplicationInfo P2 )
{
	local KFPlayerReplicationInfo P11,P22;

	if( P1.bOnlySpectator )
		return P2.bOnlySpectator;
	else if ( P2.bOnlySpectator )
		return true;

	if( P1.Kills < P2.Kills )
		return false;
	else if( P1.Kills==P2.Kills )
	{
		P11 = KFPlayerReplicationInfo(P1);
		P22 = KFPlayerReplicationInfo(P2);
		if( P11==None || P22==None )
		{
			// Go for dosh
			if( P1.Score < P2.Score )
				return false;
			else if( P1.Score == P2.Score)
				return (P1.PlayerName<P2.PlayerName); // Go for name.
		}
		else
		{
			// Kills is equal, go for assists.
			if( P11.KillAssists < P22.KillAssists )
				return false;
			else if( P11.KillAssists==P22.KillAssists )
			{
				// Go for dosh
				if( P1.Score < P2.Score )
					return false;
				else if( P1.Score == P2.Score)
					return (P1.PlayerName<P2.PlayerName); // Go for name.
			}
		}
	}
	return true;
}

defaultproperties
{
	NotShownInfo="player names not shown"
	HealthyString="HP"
	PlayerCountText="Players:"
	SpectatorCountText="| Spectators:"
	AliveCountText="| Alive players:"
	BotText="BOT"
}
