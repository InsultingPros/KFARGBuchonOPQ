/**
 * Author:      NANOMO (killingfloorarg.com / kf-argentina@hotmail.com)
 * Modified by:	Shtoyan
 * Home repo:   https://github.com/InsultingPros/KFARGBuchonOPQ
 */
class KFARGBuchonOPQGR extends GameRules;

function PostBeginPlay() {
    if (Level.Game.GameRulesModifiers == none) {
        Level.Game.GameRulesModifiers = self;
    } else {
        Level.Game.GameRulesModifiers.AddGameRules(self);
    }
}

function AddGameRules(GameRules GR) {
    if (GR != self) {
        super.AddGameRules(GR);
    }
}

function bool OverridePickupQuery(Pawn other, Pickup item, out byte bAllowPickup) {
    // IFDEBUG! Uncomment if you wan't to measure execution time
    // local float f;
    // Clock(f);

    if (
        other != none &&
        item.IsA('KFWeaponPickup') &&
        !item.IsA('SyringePickup') &&
        !item.IsA('KnifePickup') &&
        !item.IsA('WelderPickup')
    ) {
        if (!class'UtilInventory'.static.bHasInventory(other, item.InventoryType)) {
            class'UtilText'.static.ProcessPickupMessage(
                KFWeaponPickup(item).ItemName,
                other.GetHumanReadableName(),
                level
            );
        }
    }

    // UnClock(f);
    // warn("Execution time: " $ f);

    if (NextGameRules != none) {
        return NextGameRules.OverridePickupQuery(other, Item, bAllowPickup);
    }

    return false;
}