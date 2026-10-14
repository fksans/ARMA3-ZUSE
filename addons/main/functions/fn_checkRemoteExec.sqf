#include "..\script_component.hpp"
/*
 * 自检：全队播放会不会被服务器拦截。
 *
 * 默认通过 ZEN 事件广播（见 fn_broadcast），不经过 remoteExec，不受 CfgRemoteExec 影响。
 * 只有在设置里改成 remoteExec 方式时，才检查 CfgRemoteExec >> Commands 是否允许 playMusic / fadeMusic。
 * 任务 description.ext（missionConfigFile）中定义了 CfgRemoteExec 时优先，否则看 configFile。
 *
 * mode: 0 = 全部禁止, 1 = 白名单, 2 = 全部允许（默认）
 * 白名单模式下，命令类不存在或 allowedTargets = 2（只允许发给服务器）都会导致全队播放被拦截。
 *
 * 注意：客户端只能看到本机加载的配置。服务器专用模组里的 CfgRemoteExec、
 * BattlEye 的 remoteexec.txt 过滤都检测不到。
 *
 * Return Value:
 * [是否正常 <BOOL>, 显示文本 <STRING>, 详细说明（tooltip） <STRING>]
 */

if (missionNamespace getVariable ["zmp_transport", 0] != 1) exitWith {
    [true, localize "STR_ZMP_RECheckZenEvent", localize "STR_ZMP_RECheckZenEventTooltip"]
};

private _commands = ["playMusic", "fadeMusic"];

private _root = missionConfigFile >> "CfgRemoteExec" >> "Commands";
private _source = "description.ext (missionConfigFile)";
if (!isClass _root) then {
    _root = configFile >> "CfgRemoteExec" >> "Commands";
    _source = "configFile";
};

private _details = localize "STR_ZMP_RECheckLimits";

if (!isClass _root) exitWith {
    [true, localize "STR_ZMP_RECheckNotDefined", _details]
};

private _mode = 2;
if (isNumber (_root >> "mode")) then {
    _mode = getNumber (_root >> "mode");
};

if (_mode == 0) exitWith {
    [false, format [localize "STR_ZMP_RECheckBlocked", _source], _details]
};

if (_mode == 1) exitWith {
    private _missing = _commands select {
        private _entry = _root >> _x;
        !isClass _entry || {getNumber (_entry >> "allowedTargets") == 2}
    };

    if (_missing isEqualTo []) then {
        [true, format [localize "STR_ZMP_RECheckWhitelistOk", _source], _details]
    } else {
        [false, format [localize "STR_ZMP_RECheckWhitelistMissing", _source, _missing joinString " / "], _details]
    };
};

[true, format [localize "STR_ZMP_RECheckAllowed", _source, _mode], _details]
