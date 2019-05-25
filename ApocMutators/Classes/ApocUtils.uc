// http://www.efg2.com/Lab/ScienceAndEngineering/Spectra.htm

Class ApocUtils extends Object;

static function int Adjust(float Color, float Factor)
{
    local float Gamma, IntensityMax;
    local int Result;

    Gamma = 0.80f;
    IntensityMax = 255.f;

    if (Color == 0.f)
        Result = 0; // Don't want 0^x = 1 for x < > 0
    else
        Result = Round(IntensityMax  * (Color * Factor)^Gamma);

    return Result;
}

//kyan: WaveLength[700~380]
static function WavelengthToRGB(int Wavelength, out byte R, out byte G, out byte B)
{
    local float Red, Green, Blue, Factor;

    if (380 <= Wavelength && Wavelength <= 439)
    {
        Red = -float(Wavelength - 440) / float(440 - 380);
        Green = 0.0f;
        Blue = 1.0f;
    }
    else if (440 <= Wavelength && Wavelength <= 489)
    {
        Red = 0.0f;
        Green = float(Wavelength - 440) / float(490 - 440);
        Blue = 1.0f;
    }
    else if (490 <= Wavelength && Wavelength <= 509)
    {
        Red = 0.0f;
        Green = 1.0f;
        Blue = -float(Wavelength - 510) / float(510 - 490);
    }
    else if (510 <= Wavelength && Wavelength <= 579)
    {
        Red = float(Wavelength - 510) / float(580 - 510);
        Green = 1.0;
        Blue = 0.0;
    }
    else if (580 <= Wavelength && Wavelength <= 644)
    {
        Red = 1.0f;
        Green = -float(Wavelength - 645) / float(645 - 580);
        Blue = 0.0f;
    }
    else if (645 <= Wavelength && Wavelength <= 780)
    {
        Red = 1.0f;
        Green = 0.0f;
        Blue = 0.0f;
    }
    else
    {
        Red = 0.0;
        Green = 0.0;
        Blue = 0.0;
    }

    // Let the intensity fall off near the vision limits
    if (380 <= Wavelength && Wavelength <= 419)
    {
        Factor = 0.3f + 0.7f * float(Wavelength - 380) / float(420 - 380);
    }
    else if (420 <= Wavelength && Wavelength <= 700)
    {
        Factor = 1.0f;
    }
    else if (701 <= Wavelength && Wavelength <= 780)
    {
        Factor = 0.3f + 0.7f * float(780 - Wavelength) / float(780 - 700);
    }
    else
    {
        Factor = 0.0f;
    }

    R = Adjust(Red, Factor);
    G = Adjust(Green, Factor);
    B = Adjust(Blue, Factor);
}
