# Zeus Music Player

A music player for Zeus. **Only the Zeus needs this mod** – players and the server do not.

Browse every track from the `CfgMusic` of your loaded mods, keep favorites, preview locally, and play music for everyone, one side, one squad or a single player.

## Features

- **Library**: every `CfgMusic` track of every loaded mod, with name, length and music class. Search and filter by music class.
- **Favorites**: saved in your profile, so they carry over between missions and servers. Groups (Combat / Stealth / Ambient / Ending, or your own) and notes.
- **Preview**: listen on your own machine only.
- **Play to**: all players, a side, a squad, a single player, or the units you have selected in Zeus.
- **Fade in / fade out / volume fades** with adjustable time and volume.
- **A-B loop**: loop any part of a track. Click A and B while previewing to mark the points.
- **Now playing**: track, who it was sent to, and progress.
- Opens from a **ZEN module**, the **ZEN right-click menu**, or a **CBA keybind** (default Ctrl+Shift+M). Only works while you are a Zeus.

### Bonus: time / weather transitions

- Skip to a time of day (with sunrise / noon / sunset / midnight shortcuts) or forward N hours as a **smooth time-lapse** over the number of seconds you choose, instead of an instant jump.
- Overcast, fog, rain, wind, lightning and waves **change along the same timeline** and reach their targets exactly when the transition ends. Presets included.
- Opens from a ZEN module, the ZEN right-click menu or a CBA keybind (default Ctrl+Shift+T).
- English and Simplified Chinese.

## Requirements

- CBA_A3
- Zeus Enhanced (ZEN)

Every player must have CBA_A3 and ZEN loaded (true on almost every Zeus server). Music is sent through ZEN's event channel, so it is not blocked by the server's `CfgRemoteExec` whitelist. Time / weather transitions also need ZEN on the server.

## Notes

- Players with their in-game **music volume** set to 0 will not hear anything.
- Server admins: add the mod's `.bikey` to the server `keys` folder. The server does not need to load the mod.

## License

Arma Public License Share Alike (APL-SA).

---

# Zeus 音乐播放器

给 Zeus 用的音乐播放器，**只有 Zeus 需要安装**，其他玩家和服务器都不用装。

曲库来自已加载模组的全部 `CfgMusic`。支持收藏、分组、备注、本机试听，可以发给全体玩家、某个阵营、某个小队或单个玩家，支持淡入淡出和 AB 循环。附带「时间 / 天气过渡」工具：跳时间时像延时摄影一样平滑过渡，天气跟着时间一起渐变。依赖 CBA_A3 和 ZEN。
