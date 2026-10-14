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

    private _sameTrack = zmp_nowPlaying isNotEqualTo [] && {(zmp_nowPlaying select 0) == _class};
    private _looping = _sameTrack && {(zmp_nowPlaying param [6, []]) isNotEqualTo []};

    switch (true) do {
        // AB 循环每一圈都会重新 playMusic，保留原来的信息（进度按第一次开始时间换算）
        case (_looping): {};
        // 本模组刚发出的播放：保留播放对象等信息，只校正开始时间
        case (_fromUs): {
            zmp_nowPlaying set [2, diag_tickTime];
        };
        default {
            zmp_nowPlaying = [_class, "other", diag_tickTime, "", true, 0, []];
        };
    };
};

// stop：只有停掉的就是当前曲目时才清空（换歌时旧曲目的 stop 可能晚于新曲目的 start）
// AB 循环的每一圈也会触发 stop，循环由「停止」按钮结束，这里不清空
if (
    zmp_nowPlaying isNotEqualTo []
    && {(zmp_nowPlaying select 0) == _class}
    && {(zmp_nowPlaying param [6, []]) isEqualTo []}
    && {diag_tickTime - (zmp_nowPlaying select 2) > 0.5}
) then {
    zmp_nowPlaying = [];
};
