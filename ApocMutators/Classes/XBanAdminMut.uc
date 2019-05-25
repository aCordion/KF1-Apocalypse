//-----------------------------------------------------------------------------
//
//                eXtended Ban Mutator
//                   XBanMut_v02
//
//                    v 0.02b
//
// created:     16.01.2007
// last mod:      22.01.2007
//
//
//                             (C) 2007 by Radu "radix" Colceriu
//
//
//
// - the  purpose of this mutator is to improve a litle the kick / ban commands
//  by adding log functionality.
//
// commands:
//
// admin < xkick / xkickban / xsession> < user / id> [(int)reason_code] [(string)reason_text]
//
// admin xlist
//
// -(...) : parameter type.
// - < ...> : not optional parameter
// - [...] : optional parameter(will be filled with defaut values :
//            reason_code : 0
//            reason_text : "no description"
//        If the reason_code is present but the reason_text is not available
//        the reson_text will be looked up in the provided translation table.
//        if the lookup fails the reason_text will be filled with the text
//        "no description"
//
// - the reason_codes:
//        predefined(codes 0 - 99) :
//            0: "no description"
//            1: "TK"
//            2: "offensive name"
//            3: "exploiting"
//            4: "spawn killing"
//            5: "other"(require a custom description)
//
// - the xlist command will list in the console the reasons table.
//
// - the xhelp display some help iinformations :P
//
// -  the command is working like the standard kick / ban / kickban commands
//    but is logging the admin id / name the target(nOOb) id / name, time, reason,
//    and reason description in a text file.
//        The file format is(CSV):
//
//    datetime; admin name; map name; nOOb name; nOObid; kick / kickban / session;
//    reson code;reason description
//
// - all the texts written to the log file will be parsed for ";" and invalid
//    characters and replaced with #
//
//
//
// Change Log:
//
//    16.01.2007     - Writing the requirements / analysis / base code
//
//
//
//
//
// Planning:
//
//-----------------------------------------------------------------------------


class XBanAdminMut extends Mutator;

event PreBeginPlay(){
	super.PreBeginPlay();
	if (Level.Game.AccessControl!=none)
		Level.Game.AccessControl.AdminClass = class'ApocMutators.XBanAdmin';
}



function PostBeginPlay()
{
	super.PostBeginPlay();
	Log("XBanMut is starting...");
}

defaultproperties
{
	 GroupName="KF-XBanAdminMut"
	 FriendlyName="Extended Kick / Ban Mutator(b02)"
	 Description="Here will come some 1337 description about the mutator:P  v02b"
}
