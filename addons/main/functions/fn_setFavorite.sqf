#include "..\script_component.hpp"
/*
 * 添加收藏或更新已收藏曲目的分组 / 备注。
 *
 * Arguments:
 * 0: 类名 <STRING>
 * 1: 分组（"" = 未分组） <STRING>
 * 2: 备注 <STRING>
 */

params [["_class", "", [""]], ["_group", "", [""]], ["_note", "", [""]]];

if (_class == "") exitWith {};

private _favorites = call zmp_fnc_getFavorites;
// SQF 的 == 对字符串不区分大小写，和 CfgMusic 类名规则一致
private _index = _favorites findIf {_x select 0 == _class};

if (_index == -1) then {
    _favorites pushBack [_class, _group, _note];
} else {
    _favorites set [_index, [(_favorites select _index) select 0, _group, _note]];
};

[PROFILE_FAVORITES, _favorites] call zmp_fnc_profileSave;
