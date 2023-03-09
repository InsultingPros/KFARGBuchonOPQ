/**
 * Author:      NANOMO (killingfloorarg.com / kf-argentina@hotmail.com)
 * Modified by:	Shtoyan
 * Home repo:   https://github.com/InsultingPros/KFARGBuchonOPQ
 */
class KFARGBuchonOPQ extends Mutator
    config(KFARGBuchonOPQ);

var private KFARGBuchonOPQGR Rules;
var config string StringReplace;

function PostBeginPlay() {
    if (Rules == none) {
        Rules = Spawn(class'KFARGBuchonOPQGR');
    }
}

static function FillPlayInfo(PlayInfo PlayInfo) {
    super.FillPlayInfo(PlayInfo);
    PlayInfo.AddSetting("Weapon Pickup Messages", "StringReplace", "Weapon Pickup text", 0, 0, "Text", "100:200");
}

static event string GetDescriptionText(string PropName) {
    switch (PropName) {
        case "StringReplace":
            return "A String to replace in every weapon pickup, see the description for further details.";
    }
    return super.GetDescriptionText(PropName);
}

defaultproperties {
    GroupName="KF-ARGBuchonOPQ"
    FriendlyName="KFARGBuchonOPQ Weapon pickup message!"
    Description="Show a message when player picks up a weapon"

    // defaults in case someone forgets the config
    StringReplace="^b^%PLAYER% ^w^picked up ^r^%PICKUP%"
}