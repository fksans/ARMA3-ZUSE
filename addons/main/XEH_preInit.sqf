#include "script_component.hpp"
/*
 * CBA 设置（ESC → 选项 → 插件设置 → Zeus Music Player）。只影响本机。
 */

[
    "zmp_transport",
    "LIST",
    [localize "STR_ZMP_SettingTransport", localize "STR_ZMP_SettingTransportTooltip"],
    "Zeus Music Player",
    [[0, 1], [localize "STR_ZMP_TransportZen", localize "STR_ZMP_TransportRemoteExec"], 0],
    0
] call CBA_fnc_addSetting;
