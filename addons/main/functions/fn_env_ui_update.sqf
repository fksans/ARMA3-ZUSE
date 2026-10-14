#include "..\script_component.hpp"
/*
 * 刷新时间 / 天气过渡界面的「现在」一行和预览（界面打开时每 0.25 秒调用一次，输入变化时也会调用）。
 */

private _display = uiNamespace getVariable ["zmp_envDisplay", displayNull];
if (isNull _display) exitWith {};

// ---- 现在的时间 / 天气 / 过渡进度 ----
private _current = format [
    localize "STR_ZMP_EnvCurrent",
    [dayTime] call zmp_fnc_formatClock,
    overcast toFixed 2,
    fog toFixed 2,
    rain toFixed 2,
    windStr toFixed 2,
    lightnings toFixed 2,
    waves toFixed 2
];
private _active = missionNamespace getVariable ["zmp_envToken", ""] != "";
if (_active) then {
    _current = _current + " · " + format [localize "STR_ZMP_EnvProgress", round (100 * (missionNamespace getVariable ["zmp_envProgress", 0]))];
};
(_display displayCtrl IDC_ZMP_ENV_CURRENT) ctrlSetText _current;
(_display displayCtrl IDC_ZMP_ENV_STOP) ctrlEnable _active;

// ---- 预览：会跳到几点 ----
private _ctrlPreview = _display displayCtrl IDC_ZMP_ENV_PREVIEW;
private _params = call zmp_fnc_env_ui_readParams;
if (_params isEqualType "") exitWith {
    _ctrlPreview ctrlSetText _params;
    _ctrlPreview ctrlSetTextColor [1, 0.4, 0.4, 1];
};

_params params ["_hours", "_duration"];
_ctrlPreview ctrlSetTextColor [1, 0.85, 0.4, 1];
if (_hours == 0) then {
    _ctrlPreview ctrlSetText format [localize "STR_ZMP_EnvPreviewWeatherOnly", _duration];
} else {
    _ctrlPreview ctrlSetText format [
        localize "STR_ZMP_EnvPreview",
        [dayTime] call zmp_fnc_formatClock,
        [dayTime + _hours] call zmp_fnc_formatClock,
        [_hours, false] call zmp_fnc_formatClock,
        _duration
    ];
};
