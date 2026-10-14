#include "..\script_component.hpp"
/*
 * 遍历 configFile >> "CfgMusic"，生成曲库。结果缓存在 uiNamespace（整个游戏会话内配置不会变）。
 *
 * Return Value:
 * [曲目列表, 类名(小写)->曲目 HashMap, musicClass 列表 [[类, 显示名], ...]] <ARRAY>
 *
 * 曲目格式:
 * 0: 排序键（名称小写） <STRING>
 * 1: 类名 <STRING>
 * 2: 显示名（name，没有则为类名） <STRING>
 * 3: 时长 duration（秒，未知为 0） <NUMBER>
 * 4: musicClass <STRING>
 * 5: musicClass 显示名 <STRING>
 * 6: 来源模组 <STRING>
 * 7: 搜索用小写文本 <STRING>
 */

private _cached = uiNamespace getVariable "zmp_library";
if (!isNil "_cached") exitWith {_cached};

private _cfgClasses = configFile >> "CfgMusicClasses";
private _classNames = createHashMap;
private _list = [];

{
    private _class = configName _x;
    private _sound = getArray (_x >> "sound");

    // 没有音频文件的条目（基类等）跳过
    if (_sound isEqualTo [] || {!((_sound select 0) isEqualType "")} || {(_sound select 0) isEqualTo ""}) then {
        continue;
    };

    private _name = getText (_x >> "name");
    if (_name select [0, 1] == "$") then {
        _name = localize (_name select [1]);
    };
    if (_name == "") then {
        _name = _class;
    };

    private _musicClass = getText (_x >> "musicClass");
    private _musicClassName = _classNames getOrDefault [toLower _musicClass, ""];
    if (_musicClassName == "") then {
        _musicClassName = getText (_cfgClasses >> _musicClass >> "displayName");
        if (_musicClassName select [0, 1] == "$") then {
            _musicClassName = localize (_musicClassName select [1]);
        };
        if (_musicClassName == "") then {
            _musicClassName = [_musicClass, "-"] select (_musicClass == "");
        };
        _classNames set [toLower _musicClass, _musicClassName];
    };

    private _source = configSourceMod _x;
    if (_source == "") then {_source = "A3"};

    private _haystack = toLower format ["%1 %2 %3 %4 %5", _name, _class, _musicClass, _musicClassName, _source];

    _list pushBack [toLower _name, _class, _name, getNumber (_x >> "duration"), _musicClass, _musicClassName, _source, _haystack];
} forEach ("true" configClasses (configFile >> "CfgMusic"));

_list sort true;

private _map = createHashMap;
{
    _map set [toLower (_x select 1), _x];
} forEach _list;

// musicClass 筛选项：按显示名排序
private _musicClasses = [];
{
    _x params ["", "", "", "", "_musicClass", "_musicClassName"];
    if (_musicClasses findIf {_x select 1 == _musicClass} == -1) then {
        _musicClasses pushBack [toLower _musicClassName, _musicClass, _musicClassName];
    };
} forEach _list;
_musicClasses sort true;
_musicClasses = _musicClasses apply {[_x select 1, _x select 2]};

private _result = [_list, _map, _musicClasses];
uiNamespace setVariable ["zmp_library", _result];

_result
