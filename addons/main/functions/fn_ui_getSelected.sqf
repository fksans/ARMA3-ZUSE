#include "..\script_component.hpp"
/*
 * 当前列表选中的曲目类名，没有选中返回 ""。
 *
 * Return Value:
 * 类名 <STRING>
 */

private _display = uiNamespace getVariable ["zmp_display", displayNull];
if (isNull _display) exitWith {""};

private _ctrlList = _display displayCtrl IDC_ZMP_LIST;
private _row = lnbCurSelRow _ctrlList;
if (_row < 0) exitWith {""};

_ctrlList lnbData [_row, 0]
