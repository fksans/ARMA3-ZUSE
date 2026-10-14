#include "..\script_component.hpp"
/*
 * 刷新"正在播放"一行（播放器打开时每 0.5 秒调用一次）。
 */

private _display = uiNamespace getVariable ["zmp_display", displayNull];
if (isNull _display) exitWith {};

private _ctrl = _display displayCtrl IDC_ZMP_NOW_PLAYING;
private _nowPlaying = missionNamespace getVariable ["zmp_nowPlaying", []];

if (_nowPlaying isEqualTo []) exitWith {
    _ctrl ctrlSetText localize "STR_ZMP_NowPlayingNone";
};

_nowPlaying params ["_class", "_source", ["_startTick", diag_tickTime], ["_targetLabel", ""], ["_local", true], ["_startOffset", 0]];

private _track = ((call zmp_fnc_getLibrary) select 1) getOrDefault [toLower _class, []];
private _name = _class;
private _duration = 0;
if (_track isNotEqualTo []) then {
    _name = _track select 2;
    _duration = _track select 3;
};

// Zeus 自己不在播放对象里时本机没有音乐，只能按开始时间估算进度
private _elapsed = [diag_tickTime - _startTick + _startOffset, getMusicPlayedTime] select _local;

// 没收到 MusicStop 也能识别自然播完
if (_duration > 0 && {_elapsed > _duration + 2}) exitWith {
    zmp_nowPlaying = [];
    _ctrl ctrlSetText localize "STR_ZMP_NowPlayingNone";
};

private _sourceText = switch (_source) do {
    case "global": {format [localize "STR_ZMP_SourceGlobal", _targetLabel]};
    case "preview": {localize "STR_ZMP_SourcePreview"};
    default {localize "STR_ZMP_SourceOther"};
};

_ctrl ctrlSetText format [
    localize "STR_ZMP_NowPlayingFormat",
    _name,
    _class,
    _sourceText,
    [_elapsed, true] call zmp_fnc_formatTime,
    [_duration] call zmp_fnc_formatTime
];
