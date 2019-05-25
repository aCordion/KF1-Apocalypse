/**
 * Laser beam effect for a third person laser site
 * Implemented another color mode: Green laser
 * @author PooSH, 2012
 */

class Weapon_LaserBeamEffect extends LaserBeamEffect
    Config(ApocMutators);

#exec OBJ LOAD FILE=ScrnTex.utx

var     class<LaserDot>                 LaserDotClass;

var byte LaserColor;
var byte CurrentLaserColor;

replication
{
    // from server to client
    reliable if ( !bNetOwner && Role == ROLE_Authority )
        LaserColor;
}

simulated function PostNetReceive()
{
    if (LaserColor != CurrentLaserColor) {
        //kyan: modified
        SetLaserColor(class'ApocMutators.Weapon_M14EBRBattleRifle'.default.LASER_Blue);
        //SetLaserColor(LaserColor);
    }
    super.PostNetReceive();
}


simulated function SpawnDot()
{
    //spawn this dot only for 3-rd person actor
    if (!Instigator.IsLocallyControlled()) {
        if (Spot == None)
            Spot = Spawn(LaserDotClass, self);
        Weapon_LaserDot(Spot).SetLaserColor(LaserColor);
    }
}

//no need to simulate, because beam is seen only for others
simulated function SetLaserColor(byte NewLaserColor)
{
    LaserColor = NewLaserColor;
    CurrentLaserColor = NewLaserColor;

    switch (NewLaserColor) {
        case class'ApocMutators.Weapon_M14EBRBattleRifle'.default.LASER_None:
            SetActive(false);
            break;
        case class'ApocMutators.Weapon_M14EBRBattleRifle'.default.LASER_Red:
            Skins[0]=Texture'ScrnTex.Laser.Laser_Red';
            break;
        case class'ApocMutators.Weapon_M14EBRBattleRifle'.default.LASER_Green:
            Skins[0]=Texture'ScrnTex.Laser.Laser_Green';
            break;
        case class'ApocMutators.Weapon_M14EBRBattleRifle'.default.LASER_Blue:
            Skins[0]=Texture'ScrnTex.Laser.Laser_Blue';
            break;
        case class'ApocMutators.Weapon_M14EBRBattleRifle'.default.LASER_Orange:
            Skins[0]=Texture'ScrnTex.Laser.Laser_Orange';
            break;
    }
    if (Spot != None) Weapon_LaserDot(Spot).SetLaserColor(NewLaserColor);
}

// copy-pasted with add off SpawnDot()
simulated function Tick(float dt)
{
    local Vector BeamDir;
    local BaseKFWeaponAttachment Attachment;
    local rotator NewRotation;
    local float LaserDist;

    if (Role == ROLE_Authority && (Instigator == None || Instigator.Controller == None))
    {
        Destroy();
        return;
    }

    // set beam start location
    if ( Instigator == None )
    {
        // do nothing
    }
    else
    {
        if ( Instigator.IsFirstPerson() && Instigator.Weapon != None )
        {
            bHidden=True;
            if (Spot != None)
            {
                Spot.Destroy();
            }
        }
        else
        {
            bHidden=!bLaserActive;
            if( Level.NetMode != NM_DedicatedServer && Spot == none && bLaserActive)
            {
                //spawn dot of LaserDotClass
                SpawnDot();
            }

            LaserDist = VSize(EndBeamEffect - StartEffect);
            if( LaserDist > 100 )
            {
                LaserDist = 100;
            }
            else
            {
                LaserDist *= 0.5;
            }

            Attachment = BaseKFWeaponAttachment(xPawn(Instigator).WeaponAttachment);
            if (Attachment != None && (Level.TimeSeconds - Attachment.LastRenderTime) < 1)
            {
                StartEffect= Attachment.GetTipLocation();
                NewRotation = Rotator(-Attachment.GetBoneCoords('tip').XAxis);
                SetLocation( StartEffect + Attachment.GetBoneCoords('tip').XAxis * LaserDist );
            }
            else
            {
                StartEffect = Instigator.Location + Instigator.EyeHeight*Vect(0,0,1) + Normal(EndBeamEffect - Instigator.Location) * 25.0;
                SetLocation( StartEffect + Normal(EndBeamEffect - StartEffect) * LaserDist );
                NewRotation = Rotator(Normal(StartEffect - Location));
            }
        }
    }

    BeamDir = Normal(StartEffect - Location);
    SetRotation(NewRotation);

    mSpawnVecA = StartEffect;


    if (Spot != None)
    {
        Spot.SetLocation(EndBeamEffect + BeamDir * SpotProjectorPullback);

        if( EffectHitNormal == vect(0,0,0) )
        {
            Spot.SetRotation(Rotator(-BeamDir));
        }
        else
        {
            Spot.SetRotation(Rotator(-EffectHitNormal));
        }
    }
}

defaultproperties
{
     LaserDotClass=Class'ApocMutators.Weapon_LaserDot'
     Skins(0)=Texture'ScrnTex.Laser.Laser_Blue'
}
