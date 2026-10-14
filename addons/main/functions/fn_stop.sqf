#include "..\script_component.hpp"
/*
 * 停止播放。
 *
 * Arguments:
 * 0: 模式 <STRING>
 *    "preview" - 只停止本机音乐
 *    "global"  - 全队 playMusic ""
 *    "fadeOut" - 全队淡出到 0，结束后停止并把音量复位
 * 1: 淡出时长（秒，仅 fadeOut） <NUMBER>
 * 2: 停止后复位的音量（仅 fadeOut） <NUMBER>
 * 3: 播放对象 <ARRAY>（见 zmp_fnc_broadcast，default: 全体玩家）
 */

params [
    ["_mode", "global", [""]],
    ["_fadeTime", 0, [0]],
    ["_restoreVolume", 1, [0]],
    ["_target", [["all"], objNull], [[]]]
];

zmp_actionToken = zmp_actionToken + 1;

if (_mode == "preview") exitWith {
    playMusic "";
    zmp_nowPlaying = [];
};

if (_mode == "fadeOut" && _fadeTime > 0) exitWith {
    [[["fade", _fadeTime, 0]], _target] call zmp_fnc_broadcast;

    // 淡出完成后再停止；如果期间又有新的播放/停止操作，这次延时操作作废
    [{
        params ["_token", "_restoreVolume", "_target"];
        if (_token != zmp_actionToken) exitWith {};

        [[["play", ""], ["fade", 0, _restoreVolume]], _target] call zmp_fnc_broadcast;
        zmp_nowPlaying = [];
    }, [zmp_actionToken, _restoreVolume, _target], _fadeTime + 0.2] call CBA_fnc_waitAndExecute;
};

[[["play", ""]], _target] call zmp_fnc_broadcast;
zmp_nowPlaying = [];
