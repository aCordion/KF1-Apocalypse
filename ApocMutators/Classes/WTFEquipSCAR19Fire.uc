class WTFEquipSCAR19Fire extends SCARMK17Fire;

//0 = auto
//1 = super auto
//2 = semi auto
var int AutoMode;

function SetAutoMode(int NewMode, bool bPlayerIsCommando) // interface for changing modes in uBullpup
{
    //kyan: modified
    /*
    if (!bPlayerIsCommando && NewMode == 1)
        NewMode++;    
    else if (NewMode > 2) // go from semi auto to auto
        NewMode = 0;
        
    AutoMode = NewMode;
    if (NewMode != 2)
        bWaitForRelease=False;
    else
        bWaitForRelease=True;
    */
   
    //kyan: add
    if (bPlayerIsCommando)
    {
        if (NewMode == 2)
            NewMode = 0;

        bWaitForRelease = False;
    }
    else
    {
        if (NewMode == 1)
        {
            NewMode = 2;
            bWaitForRelease = True;
        }
        else if (NewMode > 2)
        {
            NewMode = 0;
            bWaitForRelease = False;       
        }
    }

    AutoMode = NewMode;
}

function float GetFireSpeed()
{
    if (AutoMode == 0) // regular automatic
    {
        return 1.0; // normal default FireRate
    }
    else if (AutoMode == 1) // super automatic available to commandos
    {
        return 3.0; // Shoot 3x as fast; default FireRate is divided by this number
    }

     //else AutoMode is invalid or 2, so Semi Automatic Mode
    return 1.0; // normal FireRate
}

defaultproperties
{
}
