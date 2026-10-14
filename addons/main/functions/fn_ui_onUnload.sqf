#include "..\script_component.hpp"
/*
 * 播放器界面 onUnload：保存淡变时长 / 音量设置。
 *
 * Arguments:
 * 0: Display <DISPLAY>
 */

params ["_display"];

(call zmp_fnc_ui_readPlaybackParams) params ["_fadeTime", "_volume"];

profileNamespace setVariable [PROFILE_FADE_TIME, _fadeTime];
profileNamespace setVariable [PROFILE_VOLUME, _volume];
saveProfileNamespace;

uiNamespace setVariable ["zmp_display", displayNull];
