#include "..\script_component.hpp"
/*
 * 写入 profileNamespace 并立刻 saveProfileNamespace（跨任务、跨服务器保留）。
 *
 * Arguments:
 * 0: 变量名 <STRING>
 * 1: 值 <ANY>
 */

params [["_name", "", [""]], "_value"];

if (_name == "") exitWith {};

profileNamespace setVariable [_name, _value];
saveProfileNamespace;
