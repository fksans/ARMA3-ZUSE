#include "script_component.hpp"
/*
 * 客户端初始化：入口（ZEN 模块 / ZEN 右键菜单 / CBA 快捷键）+ 音乐事件跟踪。
 * 音乐播放器和时间 / 天气过渡各有一套入口。
 * 本模组只在 Zeus 自己的客户端加载，其他玩家不需要安装。
 */

if (!hasInterface) exitWith {};

// ---- 当前播放跟踪 ----
// zmp_nowPlaying: [类名, 来源("global"/"preview"/"other"), 开始时间(diag_tickTime)]，没有播放时为 []
zmp_nowPlaying = [];
// 我们刚刚发出的播放请求，用来在 MusicStart 事件里区分来源：[类名小写, 来源]
zmp_pendingSource = ["", ""];
// 每次播放/停止操作自增，用于让"淡出后停止"的延时操作在期间有新操作时自动作废
zmp_actionToken = 0;

addMusicEventHandler ["MusicStart", {["start", _this] call zmp_fnc_onMusicEvent}];
addMusicEventHandler ["MusicStop", {["stop", _this] call zmp_fnc_onMusicEvent}];

// ---- 入口 1：ZEN 自定义模块 ----
[
    localize "STR_ZMP_ModuleCategory",
    localize "STR_ZMP_ModuleName",
    {[] call zmp_fnc_open},
    "\a3\ui_f\data\igui\cfg\simpleTasks\types\listen_ca.paa"
] call zen_custom_modules_fnc_register;
[
    localize "STR_ZMP_EnvModuleCategory",
    localize "STR_ZMP_EnvModuleName",
    {[] call zmp_fnc_env_open},
    "\a3\ui_f\data\igui\cfg\simpleTasks\types\wait_ca.paa"
] call zen_custom_modules_fnc_register;

// ---- 入口 2：ZEN 右键菜单 ----
private _action = [
    "zmp_openPlayer",
    localize "STR_ZMP_ContextMenu",
    "\a3\ui_f\data\igui\cfg\simpleTasks\types\listen_ca.paa",
    {[] call zmp_fnc_open},
    {call zmp_fnc_canOpen}
] call zen_context_menu_fnc_createAction;
[_action, [], 0] call zen_context_menu_fnc_addAction;
_action = [
    "zmp_openEnv",
    localize "STR_ZMP_EnvContextMenu",
    "\a3\ui_f\data\igui\cfg\simpleTasks\types\wait_ca.paa",
    {[] call zmp_fnc_env_open},
    {call zmp_fnc_canOpen}
] call zen_context_menu_fnc_createAction;
[_action, [], 0] call zen_context_menu_fnc_addAction;

// ---- 入口 3：CBA 快捷键（默认 Ctrl+Shift+M，可在 设置→控制→插件设置 中修改） ----
[
    "Zeus Music Player",
    "zmp_openPlayer",
    [localize "STR_ZMP_KeybindOpen", localize "STR_ZMP_KeybindOpenTooltip"],
    {
        if (call zmp_fnc_canOpen) then {
            [] call zmp_fnc_open;
            true
        } else {
            false
        };
    },
    "",
    [0x32, [true, true, false]] // DIK_M, [Shift, Ctrl, Alt]
] call CBA_fnc_addKeybind;

// 时间 / 天气过渡：默认 Ctrl+Shift+T
[
    "Zeus Music Player",
    "zmp_openEnv",
    [localize "STR_ZMP_KeybindOpenEnv", localize "STR_ZMP_KeybindOpenEnvTooltip"],
    {
        if (call zmp_fnc_canOpen) then {
            [] call zmp_fnc_env_open;
            true
        } else {
            false
        };
    },
    "",
    [0x14, [true, true, false]] // DIK_T, [Shift, Ctrl, Alt]
] call CBA_fnc_addKeybind;
