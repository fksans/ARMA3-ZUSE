#include "..\script_component.hpp"
/*
 * 全队音乐音量渐变：[时长, 音量] remoteExec ["fadeMusic", 0]
 *
 * Arguments:
 * 0: 时长（秒） <NUMBER>
 * 1: 目标音量 0..1 <NUMBER>
 */

params [["_time", 0, [0]], ["_volume", 1, [0]]];

[_time, _volume] remoteExec ["fadeMusic", 0];
