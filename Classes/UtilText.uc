/**
 * Author:      Shtoyan
 * Home repo:   https://github.com/InsultingPros/KFARGBuchonOPQ
 */
class UtilText extends object
    abstract
    config(KFARGBuchonOPQ);

// tag for logs, messages
const TAG='KFARGBuchonOPQ';

// colors and tags, maybe later I will convert this to a config array
struct ColorRecord {
    var string ColorName;   // color name, for comfort
    var string ColorTag;    // color tag
    var Color Color;        // RGBA values
};
var config array<ColorRecord> ColorList;    // color list
var config bool bPrintToLog;

// caching
var private transient bool bInit;
var private transient array<string> cachedColoredTags;

private final static function CacheStrings() {
    local int i;
    local array<string> cachedColors;

    if (default.ColorList.length == 0) {
        log("WARNING! Your color list is empty, go FIX your config file!", TAG);
    } else {
        for (i = 0; i < default.ColorList.length; i++) {
            cachedColors[cachedColors.length] = MakeColorCode(default.ColorList[i].Color);
        }
    }
    default.cachedColoredTags = cachedColors;
    default.bInit = true;
}

public final static function string ParseTags(string input) {
    local int i;

    if (!default.bInit) {
        CacheStrings();
    }
    for (i = 0; i < default.ColorList.Length; i++) {
        ReplaceText(input, default.ColorList[i].ColorTag, default.cachedColoredTags[i]);
    }
    return input;
}

// Wormbo WUtils (c)
public final static function string MakeColorCode(color Color) {
    return Chr(27) $ Chr(Max(Color.R, 1)) $ Chr(Max(Color.G, 1)) $ Chr(Max(Color.B, 1));
}

public final static function string StripTags(string input) {
    local int i;

    for (i = 0; i < default.ColorList.Length; i++) {
        ReplaceText(input, default.ColorList[i].ColorTag, "");
    }
    return input;
}

public final static function string StripColor(coerce string input) {
    local int i;

    i = InStr(input, chr(27));
    while (i != -1) {
        input = left(input, i) $ mid(input, i + 4);
        i = InStr(input, Chr(27));
    }
    return input;
}

public static function ProcessPickupMessage(
    string pickupName,
    string playerName,
    LevelInfo level
) {
    local string result;

    // replace keys
    result = Repl(class'KFARGBuchonOPQ'.default.StringReplace, "%PICKUP%", pickupName);
    result = Repl(result, "%PLAYER%", playerName);
    // send to everyone
    BroadcastText(result, level);
}

private static function BroadcastText(coerce string message, LevelInfo level) {
    local Controller c;
    local PlayerController pc;
    local string coloredMsg, plainMsg;

    if (message == "")  return;

    coloredMsg = ParseTags(message);
    plainMsg = StripTags(message);
    if (default.bPrintToLog) {
        Log(plainMsg, TAG);
    }
    for (c = level.controllerList; c != none; c = c.nextController) {
        // casting is more expensive than native class check :d
        if (c.IsA('PlayerController')) {
            if (c.IsA('MessagingSpectator')) {
                PlayerController(c).TeamMessage(none, plainMsg, TAG);
                continue;
            }

            pc = PlayerController(c);
            // Broadcast text to the center like admin say.
            pc.TeamMessage(none, coloredMsg, TAG);
        }
    }
}

defaultproperties {
    // defaults in case someone forgets the config
    bPrintToLog=false

    ColorList(0)=(ColorName="Red",ColorTag="^r^",Color=(R=255))
    ColorList(1)=(ColorName="Blue",ColorTag="^b^",Color=(G=100,B=200))
    ColorList(2)=(ColorName="White",ColorTag="^w^",Color=(R=255,G=255,B=255))
}