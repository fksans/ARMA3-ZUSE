#include "..\script_component.hpp"
/*
 * 播放器界面 onLoad：初始化控件、绑定事件、启动"当前播放"刷新。
 *
 * Arguments:
 * 0: Display <DISPLAY>
 */

params ["_display"];

uiNamespace setVariable ["zmp_display", _display];

// ---- 自检：CfgRemoteExec ----
(call zmp_fnc_checkRemoteExec) params ["_reOk", "_reText", "_reDetails"];
private _ctrlCheck = _display displayCtrl IDC_ZMP_RE_CHECK;
_ctrlCheck ctrlSetText _reText;
_ctrlCheck ctrlSetTooltip _reDetails;
if (_reOk) then {
    _ctrlCheck ctrlSetBackgroundColor [0.1, 0.35, 0.1, 0.8];
} else {
    _ctrlCheck ctrlSetBackgroundColor [0.75, 0.1, 0.1, 1];
    _ctrlCheck ctrlSetTextColor [1, 1, 1, 1];
    [localize "STR_ZMP_RECheckWarnShort", [1, 0.4, 0.4, 1]] call zmp_fnc_ui_setStatus;
};

// ---- 列表表头 ----
(_display displayCtrl IDC_ZMP_LIST_HEADER) lnbAddRow [
    "",
    localize "STR_ZMP_ColName",
    localize "STR_ZMP_ColDuration",
    "musicClass",
    localize "STR_ZMP_Group",
    localize "STR_ZMP_Note"
];

// ---- 页签 ----
private _ctrlTabs = _display displayCtrl IDC_ZMP_TABS;
_ctrlTabs lbSetCurSel (uiNamespace getVariable ["zmp_lastTab", 0]);
_ctrlTabs ctrlAddEventHandler ["ToolBoxSelChanged", {
    params ["", "_index"];
    uiNamespace setVariable ["zmp_lastTab", _index];
    [] call zmp_fnc_ui_refreshList;
}];

// ---- musicClass 筛选 ----
private _ctrlFilterClass = _display displayCtrl IDC_ZMP_FILTER_CLASS;
private _index = _ctrlFilterClass lbAdd localize "STR_ZMP_All";
_ctrlFilterClass lbSetData [_index, "*"];
{
    _x params ["_musicClass", "_musicClassName"];
    _index = _ctrlFilterClass lbAdd _musicClassName;
    _ctrlFilterClass lbSetData [_index, _musicClass];
    _ctrlFilterClass lbSetTooltip [_index, _musicClass];
} forEach ((call zmp_fnc_getLibrary) select 2);
_ctrlFilterClass lbSetCurSel 0;
_ctrlFilterClass ctrlAddEventHandler ["LBSelChanged", {[] call zmp_fnc_ui_refreshList}];

// ---- 分组下拉框（筛选 + 收藏分组） ----
[] call zmp_fnc_ui_refreshGroups;
(_display displayCtrl IDC_ZMP_FILTER_GROUP) ctrlAddEventHandler ["LBSelChanged", {[] call zmp_fnc_ui_refreshList}];
(_display displayCtrl IDC_ZMP_GROUP) ctrlAddEventHandler ["LBSelChanged", {
    if (uiNamespace getVariable ["zmp_suppressEvents", false]) exitWith {};
    ["groupChanged"] call zmp_fnc_ui_action;
}];

// ---- 搜索：输入即筛选 ----
(_display displayCtrl IDC_ZMP_SEARCH) ctrlAddEventHandler ["KeyUp", {[] call zmp_fnc_ui_refreshList}];

// ---- 列表 ----
private _ctrlList = _display displayCtrl IDC_ZMP_LIST;
_ctrlList ctrlAddEventHandler ["LBSelChanged", {[] call zmp_fnc_ui_onSelect}];
_ctrlList ctrlAddEventHandler ["LBDblClick", {["preview"] call zmp_fnc_ui_action}];

// ---- 备注：回车保存 ----
(_display displayCtrl IDC_ZMP_NOTE) ctrlAddEventHandler ["KeyDown", {
    params ["", "_key"];
    if (_key in [0x1C, 0x9C]) then { // DIK_RETURN, DIK_NUMPADENTER
        ["saveNote"] call zmp_fnc_ui_action;
        true
    } else {
        false
    };
}];

// ---- 播放对象 ----
[] call zmp_fnc_ui_refreshTargets;
(_display displayCtrl IDC_ZMP_TARGET) ctrlAddEventHandler ["LBSelChanged", {
    params ["_ctrl", "_index"];
    if (uiNamespace getVariable ["zmp_suppressEvents", false]) exitWith {};
    uiNamespace setVariable ["zmp_lastTarget", _ctrl lbData _index];
}];
private _ctrlIncludeSelf = _display displayCtrl IDC_ZMP_INCLUDE_SELF;
_ctrlIncludeSelf cbSetChecked (uiNamespace getVariable ["zmp_includeSelf", true]);
_ctrlIncludeSelf ctrlAddEventHandler ["CheckedChanged", {
    params ["", "_checked"];
    uiNamespace setVariable ["zmp_includeSelf", _checked == 1];
}];

// ---- 播放参数（上次的设置保存在 profileNamespace） ----
(_display displayCtrl IDC_ZMP_FADE_TIME) ctrlSetText str (profileNamespace getVariable [PROFILE_FADE_TIME, 5]);
(_display displayCtrl IDC_ZMP_VOLUME) ctrlSetText str (profileNamespace getVariable [PROFILE_VOLUME, 1]);

// ---- 按钮 ----
{
    _x params ["_idc", "_action"];
    private _ctrl = _display displayCtrl _idc;
    _ctrl setVariable ["zmp_action", _action];
    _ctrl ctrlAddEventHandler ["ButtonClick", {
        params ["_ctrl"];
        [_ctrl getVariable "zmp_action"] call zmp_fnc_ui_action;
    }];
} forEach [
    [IDC_ZMP_CLOSE, "close"],
    [IDC_ZMP_TARGET_REFRESH, "refreshTargets"],
    [IDC_ZMP_FAVORITE, "toggleFavorite"],
    [IDC_ZMP_SAVE_NOTE, "saveNote"],
    [IDC_ZMP_ADD_GROUP, "addGroup"],
    [IDC_ZMP_DELETE_GROUP, "deleteGroup"],
    [IDC_ZMP_PREVIEW, "preview"],
    [IDC_ZMP_PREVIEW_STOP, "previewStop"],
    [IDC_ZMP_PLAY_ALL, "playAll"],
    [IDC_ZMP_STOP_ALL, "stopAll"],
    [IDC_ZMP_FADE_IN_PLAY, "fadeInPlay"],
    [IDC_ZMP_FADE_OUT_STOP, "fadeOutStop"],
    [IDC_ZMP_FADE_APPLY, "fadeApply"]
];

// ---- 提示：音乐音量 ----
(_display displayCtrl IDC_ZMP_HINT) ctrlSetStructuredText parseText localize "STR_ZMP_HintMusicVolume";

// ---- 列表内容 + 当前播放 ----
[] call zmp_fnc_ui_refreshList;
[] call zmp_fnc_ui_updateNowPlaying;

[{
    params ["", "_handle"];
    private _display = uiNamespace getVariable ["zmp_display", displayNull];
    if (isNull _display) exitWith {
        [_handle] call CBA_fnc_removePerFrameHandler;
    };
    // 播放器打开期间失去 curator 身份（被收回 Zeus）则直接关闭
    if !(call zmp_fnc_canOpen) exitWith {
        _display closeDisplay 2;
        [_handle] call CBA_fnc_removePerFrameHandler;
    };
    [] call zmp_fnc_ui_updateNowPlaying;
}, 0.5] call CBA_fnc_addPerFrameHandler;

ctrlSetFocus (_display displayCtrl IDC_ZMP_SEARCH);
