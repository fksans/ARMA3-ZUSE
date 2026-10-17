#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = "Zeus Music Player";
        author = "fksans";
        url = "https://github.com/fksans/ARMA3-ZUSE";
        units[] = {};
        weapons[] = {};
        requiredVersion = 2.18;
        requiredAddons[] = {
            "cba_main",
            "zen_main",
            "zen_common",
            "zen_context_menu",
            "zen_custom_modules"
        };
        version = QUOTE(MAJOR.MINOR.PATCH);
        versionStr = QUOTE(MAJOR.MINOR.PATCH);
        versionAr[] = {MAJOR, MINOR, PATCH};
    };
};

#include "CfgEventHandlers.hpp"
#include "CfgFunctions.hpp"
#include "gui.hpp"
#include "gui_env.hpp"
