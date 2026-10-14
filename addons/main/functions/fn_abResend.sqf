#include "..\script_component.hpp"
/*
 * remoteExec 方式下的 AB 循环：每隔 (B - A) 秒重新向播放对象发送 playMusic [类名, A]。
 * 期间有任何新的播放 / 停止操作（zmp_actionToken 变了）就停止。
 * Zeus 掉线或关闭任务后循环也会停止（ZEN 事件方式没有这个限制）。
 *
 * Arguments:
 * 0: 发起循环时的 zmp_actionToken <NUMBER>
 * 1: 类名 <STRING>
 * 2: A 点（秒） <NUMBER>
 * 3: B 点（秒） <NUMBER>
 * 4: 播放对象 <ARRAY>
 */

params ["_token", "_class", "_a", "_b", "_target"];

[{
    params ["_token", "_class", "_a", "_b", "_target"];
    if (_token != zmp_actionToken) exitWith {};

    [[["play", [_class, _a]]], _target] call zmp_fnc_broadcast;
    _this call zmp_fnc_abResend;
}, _this, _b - _a] call CBA_fnc_waitAndExecute;
