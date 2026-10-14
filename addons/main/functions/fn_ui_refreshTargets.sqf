#include "..\script_component.hpp"
/*
 * 重新填充「播放对象」下拉框：全体玩家 / Zeus 选中的单位 / 选中单位所在小队 /
 * 各阵营 / 有玩家的小队 / 每个玩家。尽量保留当前选择。
 * 每一项的筛选条件存在 uiNamespace 的 zmp_targets 里（键 = lbData）。
 */

private _display = uiNamespace getVariable ["zmp_display", displayNull];
if (isNull _display) exitWith {};

private _ctrl = _display displayCtrl IDC_ZMP_TARGET;
private _current = uiNamespace getVariable ["zmp_lastTarget", "all"];

private _fnc_sideName = {
    params ["_side"];
    switch (_side) do {
        case west: {localize "STR_ZMP_SideWest"};
        case east: {localize "STR_ZMP_SideEast"};
        case independent: {localize "STR_ZMP_SideGuer"};
        case civilian: {localize "STR_ZMP_SideCiv"};
        default {str _side};
    }
};

private _players = allPlayers select {!(_x isKindOf "HeadlessClient_F")};

// [显示文字, 键, 筛选]；Zeus 选中的那两项在点按钮时才读取 curatorSelected，这里筛选留空
private _entries = [
    [localize "STR_ZMP_TargetAll", "all", ["all"]],
    [localize "STR_ZMP_TargetSelectedUnits", "selUnits", []],
    [localize "STR_ZMP_TargetSelectedGroups", "selGroups", []]
];

{
    private _side = _x;
    private _count = {side group _x == _side} count _players;
    _entries pushBack [
        format [localize "STR_ZMP_TargetSide", [_side] call _fnc_sideName, _count],
        "side:" + str _side,
        ["sides", [_side]]
    ];
} forEach [west, east, independent, civilian];

// 有玩家的小队，按阵营、名称排序
private _groups = [];
{
    _groups pushBackUnique group _x;
} forEach _players;
_groups = _groups select {!isNull _x};
private _sortedGroups = _groups apply {[[west, east, independent, civilian, sideLogic] find side _x, groupId _x, _x]};
_sortedGroups sort true;
{
    private _group = _x select 2;
    private _count = {group _x == _group} count _players;
    _entries pushBack [
        format [localize "STR_ZMP_TargetGroup", groupId _group, [side _group] call _fnc_sideName, _count],
        format ["group:%1:%2", side _group, groupId _group],
        ["groups", [_group]]
    ];
} forEach _sortedGroups;

// 每个玩家，按名字排序
private _sortedPlayers = _players apply {[toLower name _x, _x]};
_sortedPlayers sort true;
{
    private _unit = _x select 1;
    private _uid = getPlayerUID _unit;
    if (_uid == "") then {_uid = name _unit};
    _entries pushBack [
        format [localize "STR_ZMP_TargetUnit", name _unit, groupId group _unit],
        "unit:" + _uid,
        ["units", [_unit]]
    ];
} forEach _sortedPlayers;

private _targets = createHashMap;
lbClear _ctrl;
private _select = 0;
{
    _x params ["_text", "_key", "_filter"];
    private _index = _ctrl lbAdd _text;
    _ctrl lbSetData [_index, _key];
    _targets set [_key, [_text, _filter]];
    if (_key == _current) then {_select = _index};
} forEach _entries;

uiNamespace setVariable ["zmp_targets", _targets];

uiNamespace setVariable ["zmp_suppressEvents", true];
_ctrl lbSetCurSel _select;
uiNamespace setVariable ["zmp_suppressEvents", false];
