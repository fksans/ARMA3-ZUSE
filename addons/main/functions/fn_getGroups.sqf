#include "..\script_component.hpp"
/*
 * 读取收藏分组列表。第一次使用时写入默认分组（战斗 / 潜入 / 氛围 / 结尾）。
 *
 * Return Value:
 * 分组名列表 <ARRAY of STRING>
 */

private _groups = profileNamespace getVariable PROFILE_GROUPS;

if (isNil "_groups" || {!(_groups isEqualType [])}) then {
    _groups = DEFAULT_GROUPS;
    [PROFILE_GROUPS, _groups] call zmp_fnc_profileSave;
};

_groups select {_x isEqualType "" && {_x != ""}}
