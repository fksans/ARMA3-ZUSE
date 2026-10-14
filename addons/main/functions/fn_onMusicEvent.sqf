#include "..\script_component.hpp"
/*
 * MusicStart / MusicStop 事件：跟踪本机当前正在播放的曲目。
 * 因为全队播放的目标 0 也包括 Zeus 自己，所以本机播放的就是全队正在听的；
 * 不是本模组发起的播放（任务脚本、其他 Zeus）记为 "other"。
 *
 * Arguments:
 * 0: "start" / "stop" <STRING>
 * 1: 事件参数 [类名, EH ID] <ARRAY>
 */

params ["_type", "_args"];
_args params [["_class", "", [""]]];

if (_type == "start") exitWith {
    private _source = "other";
    if ((zmp_pendingSource select 0) == toLower _class) then {
        _source = zmp_pendingSource select 1;
    };
    zmp_pendingSource = ["", ""];
    zmp_nowPlaying = [_class, _source, diag_tickTime];
};

// stop：只有停掉的就是当前曲目时才清空（换歌时旧曲目的 stop 可能晚于新曲目的 start）
if (zmp_nowPlaying isNotEqualTo [] && {(zmp_nowPlaying select 0) == _class} && {diag_tickTime - (zmp_nowPlaying select 2) > 0.5}) then {
    zmp_nowPlaying = [];
};
