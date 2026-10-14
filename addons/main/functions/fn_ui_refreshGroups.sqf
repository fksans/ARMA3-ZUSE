#include "..\script_component.hpp"
/*
 * 重新填充两个分组下拉框，尽量保留当前选择：
 * - 筛选用（IDC_ZMP_FILTER_GROUP）：全部分组(*) / 未分组("") / 各分组
 * - 收藏分组（IDC_ZMP_GROUP）：未分组("") / 各分组
 */

private _display = uiNamespace getVariable ["zmp_display", displayNull];
if (isNull _display) exitWith {};

private _groups = call zmp_fnc_getGroups;

private _fnc_fill = {
    params ["_ctrl", "_entries"];

    private _current = "<none>";
    if (lbCurSel _ctrl >= 0) then {
        _current = _ctrl lbData (lbCurSel _ctrl);
    };
    lbClear _ctrl;

    private _select = 0;
    {
        _x params ["_text", "_data"];
        private _index = _ctrl lbAdd _text;
        _ctrl lbSetData [_index, _data];
        if (_data == _current) then {_select = _index};
    } forEach _entries;

    _ctrl lbSetCurSel _select;
};

private _groupEntries = _groups apply {[_x, _x]};

uiNamespace setVariable ["zmp_suppressEvents", true];

[
    _display displayCtrl IDC_ZMP_FILTER_GROUP,
    [[localize "STR_ZMP_AllGroups", "*"], [localize "STR_ZMP_Ungrouped", ""]] + _groupEntries
] call _fnc_fill;

[
    _display displayCtrl IDC_ZMP_GROUP,
    [[localize "STR_ZMP_Ungrouped", ""]] + _groupEntries
] call _fnc_fill;

uiNamespace setVariable ["zmp_suppressEvents", false];
