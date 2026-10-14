#include "..\script_component.hpp"
/*
 * 播放曲目。其他玩家没有安装本模组，所以全队播放只 remoteExec 引擎命令
 * playMusic / fadeMusic，绝不 remoteExec 本模组的函数。
 *
 * Arguments:
 * 0: CfgMusic 类名 <STRING>
 * 1: 模式 <STRING>
 *    "preview" - 试听，只在本机 playMusic
 *    "global"  - 全队播放：[_class] remoteExec ["playMusic", 0]
 *    "fadeIn"  - 全队淡入播放：音量先归零 -> 播放 -> [时长, 音量] remoteExec ["fadeMusic", 0]
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
    [0, 0] remoteExec ["fadeMusic", 0];
    [_arg] remoteExec ["playMusic", 0];
    [_fadeTime, _volume] remoteExec ["fadeMusic", 0];
} else {
    // 先把音量恢复到目标值：之前若淡出到 0，不复位的话新曲子会是静音
    [0, _volume] remoteExec ["fadeMusic", 0];
    [_arg] remoteExec ["playMusic", 0];
};
