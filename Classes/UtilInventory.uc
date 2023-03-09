/**
 * Author:      Shtoyan
 * Home repo:   https://github.com/InsultingPros/KFARGBuchonOPQ
 */
class UtilInventory extends Object
    abstract;

// @Marco Server Perks `DualWeaponsManager`
struct FDualList {
    var class<KFWeapon> Single, Dual;
};
var private array<FDualList> DualMap;

public final static function bool bHasInventory(Pawn other, class<Inventory> pickupInventoryType) {
    local Inventory Inv;

    for (Inv = other.Inventory; Inv != None; Inv = Inv.Inventory) {
        // you have a 9mm and you pick up a 9mm... check these cases
        if (Inv.class == pickupInventoryType) {
            if (bHasDualVariant(pickupInventoryType)) {
                return false;
            }
        } else {
            if (bAlreadyHasDualInventory(Inv.class, pickupInventoryType)) {
                return true;
            }
        }
    }
    return false;
}

private final static function bool bHasDualVariant(class<Inventory> pickupInventoryType) {
    local int i;

    for (i = 0; i < default.DualMap.length; i += 1) {
        if (pickupInventoryType == default.DualMap[i].Single) {
            return true;
        }
    }
    return false;
}

private final static function bool bAlreadyHasDualInventory(
    class<Inventory> compareClass,
    class<Inventory> pickupInventoryType
) {
    local int i;

    for (i = 0; i < default.DualMap.length; i += 1) {
        if (
            pickupInventoryType == default.DualMap[i].Single &&
            compareClass == default.DualMap[i].Dual
        ) {
            return true;
        }
    }
    return false;
}

defaultproperties {
    DualMap(0)=(Single=class'Single',Dual=class'Dualies')
    DualMap(1)=(Single=class'Magnum44Pistol',Dual=class'Dual44Magnum')
    DualMap(2)=(Single=class'Deagle',Dual=class'DualDeagle')
    DualMap(3)=(Single=class'FlareRevolver',Dual=class'DualFlareRevolver')
    DualMap(4)=(Single=class'MK23Pistol',Dual=class'DualMK23Pistol')
}