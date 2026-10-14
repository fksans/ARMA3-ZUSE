#include "..\script_component.hpp"
/*
 * 取消收藏。
 *
 * Arguments:
 * 0: 类名 <STRING>
 */

params [["_class", "", [""]]];

private _favorites = (call zmp_fnc_getFavorites) select {_x select 0 != _class};
[PROFILE_FAVORITES, _favorites] call zmp_fnc_profileSave;
