#include "..\script_component.hpp"
/*
 * 让「播放对象」所在的机器依次执行一组音乐命令。
 *
 * 其他玩家没有安装本模组，所以只能借用他们已经有的东西：
 * - 方式 0（默认）：ZEN 的 "zen_common_execute" 事件。ZEN 在每台机器上都注册了这个事件，
 *   它会执行收到的代码（ZEN 自己的「执行代码」等模块就用它）。事件通过 CBA 的
 *   publicVariable 通道发给所有机器，每台机器自己判断是不是播放对象，不是就跳过。
 *   不受 CfgRemoteExec 白名单影响。所有步骤放在一条事件里，保证执行顺序。
 * - 方式 1：直接 remoteExec 引擎命令 playMusic / fadeMusic，目标为阵营 / 小队 / 单位
 *   （受 CfgRemoteExec 限制）。
 * 方式由 CBA 设置 zmp_transport 决定。
 *
 * Arguments:
 * 0: 步骤列表 <ARRAY>，每一步是以下之一：
 *    ["play", 曲目]           曲目为类名、[类名, 起始秒] 或 ""（停止）
 *    ["fade", 时长, 音量]
 * 1: 播放对象 <ARRAY> (default: 全体玩家)，见 zmp_fnc_ui_readTarget
 *    0: 筛选 ["all"] / ["sides", [阵营...]] / ["groups", [小队...]] / ["units", [单位...]]
 *    1: 额外一定要收到的单位（Zeus 自己，勾选「我自己也听」时），不需要时为 objNull
 *
 * Example:
 * [[["fade", 0, 1], ["play", "LeadTrack01_F"]], [["sides", [west]], player]] call zmp_fnc_broadcast
 */

params [["_steps", [], [[]]], ["_target", [["all"], objNull], [[]]]];
_target params [["_filter", ["all"], [[]]], ["_extraUnit", objNull, [objNull]]];
_filter params [["_type", "all", [""]], ["_list", [], [[]]]];

if (missionNamespace getVariable ["zmp_transport", 0] == 1) exitWith {
    // 复制一份再加 Zeus：_list 来自界面缓存，不能原地修改
    private _targets = [0, +_list] select (_type != "all");
    if (_type != "all" && !isNull _extraUnit) then {
        _targets pushBack _extraUnit;
    };
    {
        _x params ["_command", "_arg1", "_arg2"];
        if (_command == "play") then {
            [_arg1] remoteExec ["playMusic", _targets];
        } else {
            [_arg1, _arg2] remoteExec ["fadeMusic", _targets];
        };
    } forEach _steps;
};

// 这段代码会在其他玩家的机器上执行，只能用引擎命令，不能调用本模组的函数。
// 判断逻辑和 zmp_fnc_targetMatches 相同，改的时候两边一起改。
["zen_common_execute", [{
    params ["_filter", "_extraUnit", "_steps"];
    if (!hasInterface) exitWith {};

    _filter params ["_type", ["_list", []]];
    private _match = switch (_type) do {
        case "sides": {side group player in _list};
        case "groups": {group player in _list};
        case "units": {player in _list};
        default {true};
    };
    if (!_match && {isNull _extraUnit || {player != _extraUnit}}) exitWith {};

    {
        _x params ["_command", "_arg1", "_arg2"];
        if (_command == "play") then {
            playMusic _arg1;
        } else {
            _arg1 fadeMusic _arg2;
        };
    } forEach _steps;
}, [_filter, _extraUnit, _steps]]] call CBA_fnc_globalEvent;
