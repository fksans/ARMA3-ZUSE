#include "..\script_component.hpp"
/*
 * 本机玩家是不是播放对象（用来判断 Zeus 自己能不能听到）。
 * 和 zmp_fnc_broadcast 里发给其他机器的判断逻辑相同。
 *
 * Arguments:
 * 0: 播放对象 [筛选, 额外单位] <ARRAY>
 *
 * Return Value:
 * 本机会播放 <BOOL>
 */

params [["_target", [["all"], objNull], [[]]]];
_target params [["_filter", ["all"], [[]]], ["_extraUnit", objNull, [objNull]]];
_filter params [["_type", "all", [""]], ["_list", [], [[]]]];

if (!isNull _extraUnit && {player == _extraUnit}) exitWith {true};

switch (_type) do {
    case "sides": {side group player in _list};
    case "groups": {group player in _list};
    case "units": {player in _list};
    default {true};
}
