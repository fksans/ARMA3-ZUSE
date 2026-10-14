#include "..\script_component.hpp"
/*
 * 读取收藏列表（profileNamespace 里的 zmp_favorites），过滤掉格式不对的条目。
 *
 * Return Value:
 * [[类名, 分组, 备注], ...] <ARRAY>（副本，可随意修改）
 */

private _favorites = profileNamespace getVariable [PROFILE_FAVORITES, []];
if !(_favorites isEqualType []) exitWith {[]};

(_favorites select {_x isEqualTypeArray ["", "", ""]}) apply {+_x}
