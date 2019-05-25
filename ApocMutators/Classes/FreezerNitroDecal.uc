class FreezerNitroDecal extends ProjectedDecal;

#exec OBJ LOAD File=KFX.utx

simulated function BeginPlay()
{
    if ( !Level.bDropDetail && FRand() < 0.4 )
        ProjTexture = texture'NitroSplat';
    Super.BeginPlay();
}

defaultproperties
{
     bClipStaticMesh=True
     CullDistance=7000.000000
     LifeSpan=5.000000
     DrawScale=0.500000
}
