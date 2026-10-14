#include "..\script_component.hpp"
/*
 * 列表选中项变化：刷新选中信息、收藏按钮文字、分组下拉框、备注输入框。
 */

private _display = uiNamespace getVariable ["zmp_display", displayNull];
if (isNull _display) exitWith {};

private _class = call zmp_fnc_ui_getSelected;
private _ctrlInfo = _display displayCtrl IDC_ZMP_INFO;
private _ctrlFavorite = _display displayCtrl IDC_ZMP_FAVORITE;
private _ctrlGroup = _display displayCtrl IDC_ZMP_GROUP;
private _ctrlNote = _display displayCtrl IDC_ZMP_NOTE;

if (_class == "") exitWith {
    _ctrlInfo ctrlSetText localize "STR_ZMP_NoSelection";
    _ctrlFavorite ctrlSetText localize "STR_ZMP_AddFavorite";
    _ctrlNote ctrlSetText "";
};

private _track = ((call zmp_fnc_getLibrary) select 1) getOrDefault [toLower _class, []];
if (_track isEqualTo []) then {
    _ctrlInfo ctrlSetText format [localize "STR_ZMP_InfoNotLoaded", _class];
} else {
    _track params ["", "", "_name", "_duration", "_musicClass", "", "_source"];
    _ctrlInfo ctrlSetText format [localize "STR_ZMP_InfoFormat", _name, _class, _source];
    _ctrlInfo ctrlSetTooltip format ["%1\n%2\nmusicClass: %3\n%4", _name, _class, _musicClass, _source];
};

private _favorite = (call zmp_fnc_getFavorites) select {_x select 0 == _class};
private _isFavorite = _favorite isNotEqualTo [];

_ctrlFavorite ctrlSetText localize (["STR_ZMP_AddFavorite", "STR_ZMP_RemoveFavorite"] select _isFavorite);

if (_isFavorite) then {
    (_favorite select 0) params ["", "_group", "_note"];
    _ctrlNote ctrlSetText _note;

    uiNamespace setVariable ["zmp_suppressEvents", true];
    for "_i" from 0 to (lbSize _ctrlGroup - 1) do {
        if (_ctrlGroup lbData _i == _group) exitWith {
            _ctrlGroup lbSetCurSel _i;
        };
    };
    uiNamespace setVariable ["zmp_suppressEvents", false];
} else {
    _ctrlNote ctrlSetText "";
};
