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

_nowPlaying params ["_class", "_source", ["_startTick", diag_tickTime], ["_targetLabel", ""], ["_local", true], ["_startOffset", 0], ["_loop", []]];

private _track = ((call zmp_fnc_getLibrary) select 1) getOrDefault [toLower _class, []];
private _name = _class;
private _duration = 0;
if (_track isNotEqualTo []) then {
    _name = _track select 2;
    _duration = _track select 3;
};

private _elapsed = (call zmp_fnc_currentPosition) param [1, 0];

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

private _text = format [
    localize "STR_ZMP_NowPlayingFormat",
    _name,
    _class,
    _sourceText,
    [_elapsed, true] call zmp_fnc_formatTime,
    [_duration] call zmp_fnc_formatTime
];
if (_loop isNotEqualTo []) then {
    _text = _text + "  " + format [
        localize "STR_ZMP_NowPlayingLoop",
        [_loop select 0, true] call zmp_fnc_formatTime,
        [_loop select 1, true] call zmp_fnc_formatTime
    ];
};
_ctrl ctrlSetText _text;
