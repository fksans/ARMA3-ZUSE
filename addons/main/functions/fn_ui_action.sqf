#include "..\script_component.hpp"
/*
 * 播放器界面按钮 / 事件的统一处理。
 *
 * Arguments:
 * 0: 动作 <STRING>
 */

params [["_action", "", [""]]];

private _display = uiNamespace getVariable ["zmp_display", displayNull];
if (isNull _display) exitWith {};

private _class = call zmp_fnc_ui_getSelected;
private _library = (call zmp_fnc_getLibrary) select 1;
private _track = _library getOrDefault [toLower _class, []];
private _trackName = _class;
if (_track isNotEqualTo []) then {
    _trackName = _track select 2;
};
(call zmp_fnc_ui_readPlaybackParams) params ["_fadeTime", "_volume", "_start"];

// 需要选中曲目的动作
private _needsSelection = ["toggleFavorite", "saveNote", "groupChanged", "preview", "playAll", "fadeInPlay"];
if (_action in _needsSelection && _class == "") exitWith {
    if (_action != "groupChanged") then {
        [localize "STR_ZMP_SelectFirst", [1, 0.4, 0.4, 1]] call zmp_fnc_ui_setStatus;
    };
};

// 需要曲目在当前服务器已加载的动作
if (_action in ["preview", "playAll", "fadeInPlay"] && {_track isEqualTo []}) exitWith {
    [format [localize "STR_ZMP_InfoNotLoaded", _class], [1, 0.4, 0.4, 1]] call zmp_fnc_ui_setStatus;
};

// 发给其他玩家的动作：读取播放对象（失败时 readTarget 已在状态栏提示）
private _targetInfo = [];
if (_action in ["playAll", "stopAll", "fadeInPlay", "fadeOutStop", "fadeApply"]) then {
    _targetInfo = call zmp_fnc_ui_readTarget;
};
if (_action in ["playAll", "stopAll", "fadeInPlay", "fadeOutStop", "fadeApply"] && {_targetInfo isEqualTo []}) exitWith {};
_targetInfo params [["_target", [["all"], objNull]], ["_targetLabel", ""]];

private _ctrlGroup = _display displayCtrl IDC_ZMP_GROUP;
private _selectedGroup = "";
if (lbCurSel _ctrlGroup >= 0) then {
    _selectedGroup = _ctrlGroup lbData (lbCurSel _ctrlGroup);
};
private _favorite = (call zmp_fnc_getFavorites) select {_x select 0 == _class};

switch (_action) do {
    case "close": {
        _display closeDisplay 2;
    };
    case "refreshTargets": {
        [] call zmp_fnc_ui_refreshTargets;
        [localize "STR_ZMP_StatusTargetsRefreshed"] call zmp_fnc_ui_setStatus;
    };

    // ---- 收藏 ----
    case "toggleFavorite": {
        if (_favorite isEqualTo []) then {
            [_class, _selectedGroup, trim ctrlText (_display displayCtrl IDC_ZMP_NOTE)] call zmp_fnc_setFavorite;
            [format [localize "STR_ZMP_StatusFavorited", _trackName]] call zmp_fnc_ui_setStatus;
        } else {
            [_class] call zmp_fnc_removeFavorite;
            [format [localize "STR_ZMP_StatusUnfavorited", _trackName]] call zmp_fnc_ui_setStatus;
        };
        [] call zmp_fnc_ui_refreshList;
    };
    case "groupChanged": {
        // 只有已收藏的曲目才会立即改分组；未收藏时，选好的分组会在点「收藏」时使用
        if (_favorite isNotEqualTo []) then {
            [_class, _selectedGroup, (_favorite select 0) select 2] call zmp_fnc_setFavorite;
            [] call zmp_fnc_ui_refreshList;
        };
    };
    case "saveNote": {
        private _note = trim ctrlText (_display displayCtrl IDC_ZMP_NOTE);
        private _group = _selectedGroup;
        if (_favorite isNotEqualTo []) then {
            _group = (_favorite select 0) select 1;
        };
        [_class, _group, _note] call zmp_fnc_setFavorite;
        [localize (["STR_ZMP_StatusNoteSavedAdded", "STR_ZMP_StatusNoteSaved"] select (_favorite isNotEqualTo []))] call zmp_fnc_ui_setStatus;
        [] call zmp_fnc_ui_refreshList;
    };
    case "addGroup": {
        private _ctrlNewGroup = _display displayCtrl IDC_ZMP_NEW_GROUP;
        private _name = trim ctrlText _ctrlNewGroup;
        private _groups = call zmp_fnc_getGroups;
        if (_name == "") exitWith {
            [localize "STR_ZMP_StatusGroupEmpty", [1, 0.4, 0.4, 1]] call zmp_fnc_ui_setStatus;
        };
        if (_groups findIf {_x == _name} != -1) exitWith {
            [localize "STR_ZMP_StatusGroupExists", [1, 0.4, 0.4, 1]] call zmp_fnc_ui_setStatus;
        };
        _groups pushBack _name;
        [_groups] call zmp_fnc_setGroups;
        _ctrlNewGroup ctrlSetText "";
        [] call zmp_fnc_ui_refreshGroups;
        [] call zmp_fnc_ui_refreshList;
        [format [localize "STR_ZMP_StatusGroupAdded", _name]] call zmp_fnc_ui_setStatus;
    };
    case "deleteGroup": {
        private _ctrlFilterGroup = _display displayCtrl IDC_ZMP_FILTER_GROUP;
        private _name = "*";
        if (lbCurSel _ctrlFilterGroup >= 0) then {
            _name = _ctrlFilterGroup lbData (lbCurSel _ctrlFilterGroup);
        };
        if (_name in ["*", ""]) exitWith {
            [localize "STR_ZMP_StatusGroupPick", [1, 0.4, 0.4, 1]] call zmp_fnc_ui_setStatus;
        };
        [(call zmp_fnc_getGroups) select {_x != _name}] call zmp_fnc_setGroups;
        [] call zmp_fnc_ui_refreshGroups;
        [] call zmp_fnc_ui_refreshList;
        [format [localize "STR_ZMP_StatusGroupDeleted", _name]] call zmp_fnc_ui_setStatus;
    };

    // ---- 播放 ----
    case "preview": {
        [_class, "preview", _start, _volume] call zmp_fnc_play;
        [format [localize "STR_ZMP_StatusPreview", _trackName]] call zmp_fnc_ui_setStatus;
    };
    case "previewStop": {
        ["preview"] call zmp_fnc_stop;
        [localize "STR_ZMP_StatusPreviewStopped"] call zmp_fnc_ui_setStatus;
    };
    case "playAll": {
        [_class, "global", _start, _volume, 0, _target, _targetLabel] call zmp_fnc_play;
        [format [localize "STR_ZMP_StatusPlayAll", _trackName, _targetLabel]] call zmp_fnc_ui_setStatus;
    };
    case "stopAll": {
        ["global", 0, 1, _target] call zmp_fnc_stop;
        [format [localize "STR_ZMP_StatusStopAll", _targetLabel]] call zmp_fnc_ui_setStatus;
    };
    case "fadeInPlay": {
        [_class, "fadeIn", _start, _volume, _fadeTime, _target, _targetLabel] call zmp_fnc_play;
        [format [localize "STR_ZMP_StatusFadeIn", _trackName, _fadeTime, _targetLabel]] call zmp_fnc_ui_setStatus;
    };
    case "fadeOutStop": {
        ["fadeOut", _fadeTime, _volume, _target] call zmp_fnc_stop;
        [format [localize "STR_ZMP_StatusFadeOut", _fadeTime, _targetLabel]] call zmp_fnc_ui_setStatus;
    };
    case "fadeApply": {
        [_fadeTime, _volume, _target] call zmp_fnc_fade;
        [format [localize "STR_ZMP_StatusFade", _volume, _fadeTime, _targetLabel]] call zmp_fnc_ui_setStatus;
    };
};

[] call zmp_fnc_ui_updateNowPlaying;
