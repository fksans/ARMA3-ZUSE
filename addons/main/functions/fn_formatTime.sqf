#include "..\script_component.hpp"
/*
 * 秒数 -> "mm:ss"，未知时长返回 "--:--"。
 *
 * Arguments:
 * 0: 秒 <NUMBER>
 * 1: 0 秒显示为 "00:00" 而不是 "--:--" <BOOL> (default: false)
 *
 * Return Value:
 * 文本 <STRING>
 */

params [["_seconds", 0, [0]], ["_showZero", false, [false]]];

if (_seconds <= 0 && !_showZero) exitWith {"--:--"};

_seconds = floor (0 max _seconds);
private _minutes = floor (_seconds / 60);
private _rest = _seconds % 60;

format ["%1%2:%3%4", ["", "0"] select (_minutes < 10), _minutes, ["", "0"] select (_rest < 10), _rest]
