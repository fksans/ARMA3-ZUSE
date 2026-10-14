#include "..\script_component.hpp"
/*
 * 全队音乐音量渐变（所有机器执行 fadeMusic）。
 *
 * Arguments:
 * 0: 时长（秒） <NUMBER>
 * 1: 目标音量 0..1 <NUMBER>
 */

params [["_time", 0, [0]], ["_volume", 1, [0]]];

[[["fade", _time, _volume]]] call zmp_fnc_broadcast;
