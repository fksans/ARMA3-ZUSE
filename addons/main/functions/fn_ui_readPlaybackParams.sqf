#include "..\script_component.hpp"
/*
 * 读取界面上的淡变时长 / 音量 / 起始秒，并限制在合理范围内。
 *
 * Return Value:
 * [淡变时长 0..600, 音量 0..1, 起始秒（A 点） >= 0, B 点（没填为 -1）] <ARRAY>
 */

private _display = uiNamespace getVariable ["zmp_display", displayNull];
if (isNull _display) exitWith {[5, 1, 0, -1]};

private _fadeTime = parseNumber ctrlText (_display displayCtrl IDC_ZMP_FADE_TIME);
private _volume = parseNumber ctrlText (_display displayCtrl IDC_ZMP_VOLUME);
private _start = parseNumber ctrlText (_display displayCtrl IDC_ZMP_START);
private _loopEndText = trim ctrlText (_display displayCtrl IDC_ZMP_LOOP_END);
private _loopEnd = [parseNumber _loopEndText, -1] select (_loopEndText == "");

// parseNumber 遇到非数字返回 0；音量栏留空时按 1 处理
if (trim ctrlText (_display displayCtrl IDC_ZMP_VOLUME) == "") then {_volume = 1};

[0 max _fadeTime min 600, 0 max _volume min 1, 0 max _start, _loopEnd]
