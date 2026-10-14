#include "..\script_component.hpp"
/*
 * 读取界面上选的播放对象。选了「Zeus 选中的单位 / 小队」时，在这里读取 curatorSelected。
 * 出错时（没选中单位、选中的单位里没有玩家）在状态栏提示并返回 []。
 *
 * Return Value:
 * [播放对象 [筛选, 额外单位], 显示名] <ARRAY>，失败为 []
 */

private _display = uiNamespace getVariable ["zmp_display", displayNull];
if (isNull _display) exitWith {[]};

private _ctrl = _display displayCtrl IDC_ZMP_TARGET;
private _key = "all";
if (lbCurSel _ctrl >= 0) then {
    _key = _ctrl lbData (lbCurSel _ctrl);
};

private _entry = (uiNamespace getVariable ["zmp_targets", createHashMap]) getOrDefault [_key, []];
if (_entry isEqualTo []) exitWith {
    [localize "STR_ZMP_StatusTargetInvalid", [1, 0.4, 0.4, 1]] call zmp_fnc_ui_setStatus;
    []
};
_entry params ["_label", "_filter"];

if (_key in ["selUnits", "selGroups"]) then {
    // curatorSelected: [物体, 小队, 航点, 标记]
    curatorSelected params [["_objects", []], ["_selectedGroups", []]];
    private _units = [];
    {
        if (_x isKindOf "CAManBase") then {
            _units pushBackUnique _x;
        } else {
            {_units pushBackUnique _x} forEach crew _x;
        };
    } forEach _objects;
    {
        {_units pushBackUnique _x} forEach units _x;
    } forEach _selectedGroups;

    if (_key == "selUnits") then {
        private _playerCount = {isPlayer _x} count _units;
        _filter = ["units", _units];
        _label = format [localize "STR_ZMP_TargetSelectedUnitsLabel", count _units, _playerCount];
    } else {
        private _groups = [];
        {_groups pushBackUnique group _x} forEach _units;
        private _playerCount = {group _x in _groups} count allPlayers;
        _filter = ["groups", _groups];
        _label = format [localize "STR_ZMP_TargetSelectedGroupsLabel", count _groups, _playerCount];
    };
};

if (_filter isEqualTo []) exitWith {[]};
_filter params ["_type", ["_list", []]];

if (_type in ["units", "groups"] && {_list isEqualTo []}) exitWith {
    [localize "STR_ZMP_StatusNoCuratorSelection", [1, 0.4, 0.4, 1]] call zmp_fnc_ui_setStatus;
    []
};
if (_type == "units" && {_list findIf {isPlayer _x} == -1}) exitWith {
    [localize "STR_ZMP_StatusNoPlayersSelected", [1, 0.4, 0.4, 1]] call zmp_fnc_ui_setStatus;
    []
};

private _includeSelf = cbChecked (_display displayCtrl IDC_ZMP_INCLUDE_SELF);

[[_filter, [objNull, player] select _includeSelf], _label]
