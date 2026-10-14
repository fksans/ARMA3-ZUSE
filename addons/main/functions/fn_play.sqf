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
 *    "abLoop"  - AB 循环：从 A 点（起始位置）播放到 B 点，然后跳回 A 点，直到下一次播放 / 停止
 * 2: 起始位置 / A 点（秒） <NUMBER>
 * 3: 音量 0..1 <NUMBER>
 * 4: 淡入时长（秒，仅 fadeIn） <NUMBER>
 * 5: 播放对象 <ARRAY>（见 zmp_fnc_broadcast，default: 全体玩家）
 * 6: 播放对象的显示名（用于「正在播放」） <STRING>
 * 7: B 点（秒，仅 abLoop） <NUMBER>
 */

params [
    ["_class", "", [""]],
    ["_mode", "global", [""]],
    ["_start", 0, [0]],
    ["_volume", 1, [0]],
    ["_fadeTime", 0, [0]],
    ["_target", [["all"], objNull], [[]]],
    ["_targetLabel", "", [""]],
    ["_loopEnd", -1, [0]]
];

if (_class == "") exitWith {};

private _arg = [_class, [_class, _start]] select (_start > 0);

zmp_actionToken = zmp_actionToken + 1;

if (_mode == "preview") exitWith {
    // 试听会替换本机的音乐，本机正在跑的 AB 循环也一起结束
    missionNamespace setVariable ["zmp_abToken", ""];
    zmp_pendingSource = [toLower _class, "preview"];
    zmp_nowPlaying = [_class, "preview", diag_tickTime, "", true, _start, []];

    0 fadeMusic _volume;
    playMusic _arg;
};

// Zeus 自己不在播放对象里时，本机不会播放，进度只能按时间估算
private _local = [_target] call zmp_fnc_targetMatches;
zmp_pendingSource = [["", toLower _class] select _local, "global"];
private _loop = [[], [_start, _loopEnd]] select (_mode == "abLoop");
zmp_nowPlaying = [_class, "global", diag_tickTime, _targetLabel, _local, _start, _loop];

if (_mode == "abLoop") exitWith {
    if (missionNamespace getVariable ["zmp_transport", 0] == 1) then {
        // remoteExec 方式不能在对方机器上跑循环代码，只能由 Zeus 每隔 (B - A) 秒重新发一次
        [[["fade", 0, _volume], ["play", [_class, _start]]], _target] call zmp_fnc_broadcast;
        [zmp_actionToken, _class, _start, _loopEnd, _target] call zmp_fnc_abResend;
    } else {
        [[["fade", 0, _volume], ["loop", [_class, _start, _loopEnd]]], _target] call zmp_fnc_broadcast;
    };
};

if (_mode == "fadeIn") then {
    [[["fade", 0, 0], ["play", _arg], ["fade", _fadeTime, _volume]], _target] call zmp_fnc_broadcast;
} else {
    // 先把音量恢复到目标值：之前若淡出到 0，不复位的话新曲子会是静音
    [[["fade", 0, _volume], ["play", _arg]], _target] call zmp_fnc_broadcast;
};
