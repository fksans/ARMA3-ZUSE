#include "..\script_component.hpp"
/*
 * 时间 / 天气过渡界面 onUnload：记住过渡时长、曲线（profileNamespace）和本次输入（uiNamespace）。
 *
 * Arguments:
 * 0: Display <DISPLAY>
 */

params ["_display"];

uiNamespace setVariable ["zmp_envLastTarget", ctrlText (_display displayCtrl IDC_ZMP_ENV_TARGET_TIME)];
uiNamespace setVariable ["zmp_envLastSkip", ctrlText (_display displayCtrl IDC_ZMP_ENV_SKIP_HOURS)];

private _duration = parseNumber ctrlText (_display displayCtrl IDC_ZMP_ENV_DURATION);
profileNamespace setVariable [PROFILE_ENV_DURATION, 1 max _duration min 600];
profileNamespace setVariable [PROFILE_ENV_EASE, lbCurSel (_display displayCtrl IDC_ZMP_ENV_EASE) != 0];
saveProfileNamespace;

uiNamespace setVariable ["zmp_envDisplay", displayNull];
