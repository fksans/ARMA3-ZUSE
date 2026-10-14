#include "..\script_component.hpp"
/*
 * 让所有机器（包括自己）依次执行一组音乐命令。
 *
 * 其他玩家没有安装本模组，所以只能借用他们已经有的东西：
 * - 方式 0（默认）：ZEN 的 "zen_common_execute" 事件。ZEN 在每台机器上都注册了这个事件，
 *   它会执行收到的代码（ZEN 自己的「执行代码」等模块就用它）。事件通过 CBA 的
 *   publicVariable 通道发送，不受 CfgRemoteExec 白名单影响。所有步骤放在一条事件里，
 *   保证执行顺序。
 * - 方式 1：直接 remoteExec 引擎命令 playMusic / fadeMusic（受 CfgRemoteExec 限制）。
 * 方式由 CBA 设置 zmp_transport 决定。
 *
 * Arguments:
 * 0: 步骤列表 <ARRAY>，每一步是以下之一：
 *    ["play", 曲目]           曲目为类名、[类名, 起始秒] 或 ""（停止）
 *    ["fade", 时长, 音量]
 *
 * Example:
 * [[["fade", 0, 1], ["play", "LeadTrack01_F"]]] call zmp_fnc_broadcast
 */

params [["_steps", [], [[]]]];

if (missionNamespace getVariable ["zmp_transport", 0] == 1) exitWith {
    {
        _x params ["_command", "_arg1", "_arg2"];
        if (_command == "play") then {
            [_arg1] remoteExec ["playMusic", 0];
        } else {
            [_arg1, _arg2] remoteExec ["fadeMusic", 0];
        };
    } forEach _steps;
};

// 这段代码会在其他玩家的机器上执行，只能用引擎命令，不能调用本模组的函数
["zen_common_execute", [{
    {
        _x params ["_command", "_arg1", "_arg2"];
        if (_command == "play") then {
            playMusic _arg1;
        } else {
            _arg1 fadeMusic _arg2;
        };
    } forEach _this;
}, _steps]] call CBA_fnc_globalEvent;
