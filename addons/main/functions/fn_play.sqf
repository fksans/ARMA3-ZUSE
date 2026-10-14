#include "..\script_component.hpp"
/*
 * 播放曲目。全队播放通过 zmp_fnc_broadcast 让所有机器执行引擎命令
 * playMusic / fadeMusic（其他玩家没有安装本模组）。
 *
 * Arguments:
 * 0: CfgMusic 类名 <STRING>
 * 1: 模式 <STRING>
 *    "preview" - 试听，只在本机 playMusic
 *    "global"  - 全队播放：音量设为目标值 -> playMusic
 *    "fadeIn"  - 全队淡入播放：音量先归零 -> playMusic -> 在淡入时长内 fadeMusic 到目标音量
 * 2: 起始位置（秒） <NUMBER>
 * 3: 音量 0..1 <NUMBER>
 * 4: 淡入时长（秒，仅 fadeIn） <NUMBER>
 */

params [
    ["_class", "", [""]],
    ["_mode", "global", [""]],
    ["_start", 0, [0]],
    ["_volume", 1, [0]],
    ["_fadeTime", 0, [0]]
];

if (_class == "") exitWith {};

private _arg = [_class, [_class, _start]] select (_start > 0);

zmp_actionToken = zmp_actionToken + 1;

if (_mode == "preview") exitWith {
    zmp_pendingSource = [toLower _class, "preview"];
    zmp_nowPlaying = [_class, "preview", diag_tickTime];

    0 fadeMusic _volume;
    playMusic _arg;
};

zmp_pendingSource = [toLower _class, "global"];
zmp_nowPlaying = [_class, "global", diag_tickTime];

if (_mode == "fadeIn") then {
    [[["fade", 0, 0], ["play", _arg], ["fade", _fadeTime, _volume]]] call zmp_fnc_broadcast;
} else {
    // 先把音量恢复到目标值：之前若淡出到 0，不复位的话新曲子会是静音
    [[["fade", 0, _volume], ["play", _arg]]] call zmp_fnc_broadcast;
};
