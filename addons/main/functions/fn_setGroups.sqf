#include "..\script_component.hpp"
/*
 * 保存收藏分组列表。被删掉的分组里的收藏会移到「未分组」。
 *
 * Arguments:
 * 0: 分组名列表 <ARRAY of STRING>
 */

params [["_groups", [], [[]]]];

_groups = _groups select {_x isEqualType "" && {_x != ""}};

private _favorites = call zmp_fnc_getFavorites;
private _changed = false;
{
    private _group = _x select 1;
    if (_group != "" && {_groups findIf {_x == _group} == -1}) then {
        _x set [1, ""];
        _changed = true;
    };
} forEach _favorites;

profileNamespace setVariable [PROFILE_GROUPS, _groups];
if (_changed) then {
    profileNamespace setVariable [PROFILE_FAVORITES, _favorites];
};
saveProfileNamespace;
