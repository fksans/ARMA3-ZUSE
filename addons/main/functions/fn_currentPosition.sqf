#include "..\script_component.hpp"
/*
 * 当前曲目（zmp_nowPlaying）播放到第几秒。
 * AB 循环时换算成 A～B 之间的位置；Zeus 本机没有在播放时按开始时间估算。
 *
 * Return Value:
 * [类名, 秒, 本机是否在播放] <ARRAY>，没有播放时为 []
 */

private _nowPlaying = missionNamespace getVariable ["zmp_nowPlaying", []];
if (_nowPlaying isEqualTo []) exitWith {[]};

_nowPlaying params [
    "_class",
    "_source",
    ["_startTick", diag_tickTime],
    ["_targetLabel", ""],
    ["_local", true],
    ["_startOffset", 0],
    ["_loop", []]
];

private _position = diag_tickTime - _startTick + _startOffset;
if (_loop isNotEqualTo []) then {
    _loop params ["_a", "_b"];
    _position = _a + ((diag_tickTime - _startTick) mod (_b - _a));
} else {
    // 从头播放且本机在播放时，以引擎记录的播放时间为准
    if (_local && _startOffset == 0) then {
        _position = getMusicPlayedTime;
    };
};

[_class, _position, _local]
