#include "..\script_component.hpp"
/*
 * MusicStart / MusicStop 事件：跟踪本机当前正在播放的曲目。
 * Zeus 自己在播放对象里（或勾选了「我自己也听」）时，本机播放的就是对象正在听的；
 * 不是本模组发起的播放（任务脚本、其他 Zeus）记为 "other"。
 *
 * Arguments:
 * 0: "start" / "stop" <STRING>
 * 1: 事件参数 [类名, EH ID] <ARRAY>
 */

params ["_type", "_args"];
_args params [["_class", "", [""]]];

if (_type == "start") exitWith {
    private _fromUs = (zmp_pendingSource select 0) == toLower _class
        && {zmp_nowPlaying isNotEqualTo []}
        && {(zmp_nowPlaying select 0) == _class};
    zmp_pendingSource = ["", ""];

    if (_fromUs) then {
        // 本模组刚发出的播放：保留播放对象等信息，只校正开始时间
        zmp_nowPlaying set [2, diag_tickTime];
    } else {
        zmp_nowPlaying = [_class, "other", diag_tickTime, "", true, 0];
    };
};

// stop：只有停掉的就是当前曲目时才清空（换歌时旧曲目的 stop 可能晚于新曲目的 start）
if (zmp_nowPlaying isNotEqualTo [] && {(zmp_nowPlaying select 0) == _class} && {diag_tickTime - (zmp_nowPlaying select 2) > 0.5}) then {
    zmp_nowPlaying = [];
};
