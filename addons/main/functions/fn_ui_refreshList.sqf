#include "..\script_component.hpp"
/*
 * 按当前页签 / 搜索关键字 / musicClass / 分组筛选，重建曲目列表。
 * 「收藏」页签里，当前服务器没加载的收藏曲目也会显示（灰色、不可播放），收藏不会丢。
 */

private _display = uiNamespace getVariable ["zmp_display", displayNull];
if (isNull _display) exitWith {};

(call zmp_fnc_getLibrary) params ["_library", "_libraryMap"];

private _ctrlList = _display displayCtrl IDC_ZMP_LIST;
private _ctrlFilterClass = _display displayCtrl IDC_ZMP_FILTER_CLASS;
private _ctrlFilterGroup = _display displayCtrl IDC_ZMP_FILTER_GROUP;

private _favoritesTab = lbCurSel (_display displayCtrl IDC_ZMP_TABS) == 1;

// 分组筛选只在「收藏」页签有意义
_ctrlFilterGroup ctrlEnable _favoritesTab;
(_display displayCtrl IDC_ZMP_DELETE_GROUP) ctrlEnable _favoritesTab;

private _keywords = (toLower ctrlText (_display displayCtrl IDC_ZMP_SEARCH)) splitString " ";
private _filterClass = "*";
if (lbCurSel _ctrlFilterClass >= 0) then {
    _filterClass = _ctrlFilterClass lbData (lbCurSel _ctrlFilterClass);
};
private _filterGroup = "*";
if (_favoritesTab && {lbCurSel _ctrlFilterGroup >= 0}) then {
    _filterGroup = _ctrlFilterGroup lbData (lbCurSel _ctrlFilterGroup);
};

// 收藏：类名小写 -> [分组, 备注]
private _favorites = call zmp_fnc_getFavorites;
private _favoriteMap = createHashMap;
{
    _x params ["_class", "_group", "_note"];
    _favoriteMap set [toLower _class, [_group, _note]];
} forEach _favorites;

// 要显示的条目：[曲目数据, 是否已加载]
private _entries = [];
if (_favoritesTab) then {
    private _groups = call zmp_fnc_getGroups;
    private _sortable = [];
    {
        _x params ["_class", "_group"];
        private _track = _libraryMap getOrDefault [toLower _class, []];
        private _loaded = _track isNotEqualTo [];
        if (!_loaded) then {
            // 当前服务器没有加载该曲目所在模组
            _track = [toLower _class, _class, _class, 0, "", "-", "", toLower _class];
        };
        // 排序：按分组顺序，未分组放最后，组内按名称（类名兜底，保证不会比较到数组元素）
        private _groupIndex = _groups findIf {_x == _group};
        if (_groupIndex == -1) then {_groupIndex = 1e6};
        _sortable pushBack [_groupIndex, _track select 0, toLower _class, _track, _loaded];
    } forEach _favorites;
    _sortable sort true;
    _entries = _sortable apply {[_x select 3, _x select 4]};
} else {
    _entries = _library apply {[_x, true]};
};

private _selectedClass = call zmp_fnc_ui_getSelected;

lnbClear _ctrlList;

private _shown = 0;
private _selectRow = -1;
{
    _x params ["_track", "_loaded"];
    _track params ["", "_class", "_name", "_duration", "_musicClass", "_musicClassName", "", "_haystack"];

    private _favorite = _favoriteMap getOrDefault [toLower _class, []];
    private _isFavorite = _favorite isNotEqualTo [];
    _favorite params [["_group", ""], ["_note", ""]];

    if (_filterClass != "*" && _musicClass != _filterClass) then {continue};
    if (_filterGroup != "*" && _group != _filterGroup) then {continue};

    if (_keywords isNotEqualTo []) then {
        private _text = _haystack;
        if (_isFavorite) then {
            _text = _text + " " + toLower _group + " " + toLower _note;
        };
        if (_keywords findIf {_text find _x == -1} != -1) then {continue};
    };

    private _displayName = _name;
    if (!_loaded) then {
        _displayName = format ["%1 %2", _class, localize "STR_ZMP_NotLoaded"];
    };

    private _row = _ctrlList lnbAddRow [
        ["", "★"] select _isFavorite,
        _displayName,
        [_duration] call zmp_fnc_formatTime,
        _musicClassName,
        [_group, localize "STR_ZMP_Ungrouped"] select (_isFavorite && _group == ""),
        _note
    ];
    _ctrlList lnbSetData [[_row, 0], _class];

    if (_isFavorite) then {
        _ctrlList lnbSetColor [[_row, 0], [1, 0.8, 0.2, 1]];
    };
    if (!_loaded) then {
        for "_column" from 1 to 5 do {
            _ctrlList lnbSetColor [[_row, _column], [0.55, 0.55, 0.55, 1]];
        };
    };

    if (_class == _selectedClass) then {_selectRow = _row};
    _shown = _shown + 1;
} forEach _entries;

if (_selectRow == -1 && _shown > 0) then {_selectRow = 0};
_ctrlList lnbSetCurSelRow _selectRow;

(_display displayCtrl IDC_ZMP_COUNT) ctrlSetText format [
    localize "STR_ZMP_CountFormat",
    count _library,
    _shown,
    count _favorites
];

[] call zmp_fnc_ui_onSelect;
