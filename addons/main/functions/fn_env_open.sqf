#include "..\script_component.hpp"
/*
 * 打开时间 / 天气过渡界面（和 zmp_fnc_open 一样：在 Zeus 界面中作为 312 的子 display 弹出）。
 *
 * Return Value:
 * 是否允许打开 <BOOL>
 */

if !(call zmp_fnc_canOpen) exitWith {
    systemChat localize "STR_ZMP_NotCurator";
    false
};

[{
    if (!isNull (uiNamespace getVariable ["zmp_envDisplay", displayNull])) exitWith {};
    if !(call zmp_fnc_canOpen) exitWith {};

    private _curatorDisplay = findDisplay 312;
    if (isNull _curatorDisplay) then {
        createDialog "zmp_envDisplay";
    } else {
        _curatorDisplay createDisplay "zmp_envDisplay";
    };
}] call CBA_fnc_execNextFrame;

true
