# Zeus Music Player（Zeus 音乐播放器）

给 Arma 3 Zeus 用的音乐播放器，**客户端模组**：只有 Zeus 自己加载，其他玩家和服务器都不用装。

- 曲库直接来自所有已加载模组的 `CfgMusic`，不新增任何歌曲。
- 全队播放只 `remoteExec` 引擎命令 `playMusic` / `fadeMusic`。因为其他玩家没装本模组，所以绝不 `remoteExec` 本模组的函数。
- 依赖：**CBA_A3**、**ZEN (Zeus Enhanced)**（写在 `requiredAddons` 里）。

## 功能

| 功能 | 说明 |
| --- | --- |
| 曲库 | 遍历 `configFile >> "CfgMusic"`，显示名称（`name`，没有就显示类名）、时长（`duration`）、`musicClass`（显示 `CfgMusicClasses` 里的名字）。支持关键字搜索（名称 / 类名 / musicClass / 来源模组 / 分组 / 备注，空格分隔多个关键字）和按 musicClass 筛选。 |
| 收藏 | 收藏 / 取消收藏，存在 `profileNamespace`，每次改动立刻 `saveProfileNamespace`，跨任务、跨服务器保留。当前服务器没加载的收藏曲目会灰色显示，不会丢。 |
| 收藏分组 | 默认「战斗 / 潜入 / 氛围 / 结尾」，可以新增、删除；收藏页签可以按分组筛选。 |
| 曲目备注 | 每首收藏曲目可写备注名，可被搜索。 |
| 试听 | 只在本机 `playMusic`，其他人听不到（双击列表也可以试听）。 |
| 全队播放 | `[_class] remoteExec ["playMusic", 0]`（可设置起始秒数，此时为 `[[_class, 秒]] remoteExec ["playMusic", 0]`）。 |
| 全队停止 | `[""] remoteExec ["playMusic", 0]` |
| 淡入淡出 | `[时长, 音量] remoteExec ["fadeMusic", 0]`，时长、目标音量可调：淡入播放 / 淡出后停止 / 淡变到目标音量。 |
| 正在播放 | 显示当前曲目、来源（全队 / 仅本机试听 / 其他来源：任务脚本或其他 Zeus）和进度。 |
| 自检 | 打开时检查 `missionConfigFile` / `configFile` 的 `CfgRemoteExec >> Commands`，白名单模式下缺少 `playMusic` / `fadeMusic` 时界面顶部红色警告「全队播放可能被服务器拦截」。 |
| 权限 | 只有当前玩家是 curator（`getAssignedCuratorLogic player` 非空）时才能打开；打开期间被收回 Zeus 会自动关闭。 |

### 三个入口

1. **ZEN 模块**：Zeus 模块列表 → 分类「音乐」→「音乐播放器」（`zen_custom_modules_fnc_register`）。
2. **ZEN 右键菜单**：Zeus 界面里右键 →「音乐播放器」（`zen_context_menu_fnc_addAction`）。
3. **快捷键**：默认 `Ctrl + Shift + M`（`CBA_fnc_addKeybind`），可在 *设置 → 控制 → 插件设置（Configure Addons）→ Zeus Music Player* 里改。

在 Zeus 界面（display 312）中打开时，播放器作为 312 的子 display 弹出，Zeus 界面保持打开，关掉播放器（`X` 或 `Esc`）就回到 Zeus。

### 界面

```
┌ Zeus 音乐播放器 ─────────────────────────────── [状态消息]  X ┐
│ 远程执行自检通过：... / 【警告】全队播放可能被服务器拦截！...     │
│ 正在播放：名称 [类名] · 全队 · 01:23 / 03:45                      │
│ [ 全部 | 收藏 ]   曲库 N 首 · 当前显示 N 首 · 已收藏 N 首         │
│ 搜索 [__________]  musicClass [全部 ▼]   分组 [全部分组 ▼]       │
│ ★ │ 名称                 │ 时长  │ musicClass │ 分组 │ 备注       │
│ ...                                                               │
│ 选中：名称 [类名] 来源：@mod     [新分组名] [添加分组] [删除分组] │
│ [★ 收藏]  分组 [未分组 ▼]  备注 [______________]  [保存备注]      │
│ [试听] [停止试听] [全队播放] [全队停止]   起始(秒) [0]            │
│ 淡变时长(秒) [5]  目标音量(0-1) [1]  [淡入播放] [淡出停止] [淡变] │
│ 提示：playMusic 受每位玩家「音乐」音量影响 ...                   │
└───────────────────────────────────────────────────────────────────┘
```

界面文字跟随游戏语言：中文显示中文，英文游戏显示英文，其他语言默认中文。

### 存储（profileNamespace）

| 变量 | 内容 |
| --- | --- |
| `zmp_favorites` | `[[类名, 分组, 备注], ...]` |
| `zmp_favoriteGroups` | `["战斗", "潜入", ...]` |
| `zmp_fadeTime` | 上次使用的淡变时长 |
| `zmp_volume` | 上次使用的目标音量 |

### 注意事项

- **音乐音量**：`playMusic` 受每位玩家自己的「设置 → 音频 → 音乐」音量影响，调成 0 的玩家听不到，Zeus 无法强制。界面底部有提示。
- **全队包括你自己**：`remoteExec` 目标 `0` 包括 Zeus 本人（以及服务器），所以「正在播放」显示的就是全队正在听的。
- **试听会替换你本机的音乐**：音乐通道只有一个，试听时你自己会暂时听不到全队的曲子（其他玩家不受影响）。
- **淡出后的音量**：`fadeMusic` 改的音量会一直保持。「淡出停止」结束后会自动把音量复位；「全队播放」前也会先把音量设为「目标音量」，不会出现淡出到 0 之后新歌没声音的情况。
- **自检的局限**：客户端只能看到任务 `description.ext` 和本机加载的模组。服务器专用模组（`-serverMod`）里的 `CfgRemoteExec`、BattlEye `remoteexec.txt` 过滤都检测不到。如果全队听不到，请让服务器管理员检查这些配置。
- **不会污染任务**：本模组不添加任何可放置对象（模块通过 ZEN 的自定义模块注册），用它的 Zeus 保存的任务不会依赖本模组。

如果任务或服务器使用 `CfgRemoteExec` 白名单，需要包含：

```cpp
class CfgRemoteExec {
    class Commands {
        mode = 1;
        class playMusic { allowedTargets = 0; };
        class fadeMusic { allowedTargets = 0; };
    };
};
```

## 项目结构（HEMTT）

```
.
├── .hemtt/
│   ├── project.toml            # HEMTT 项目配置（name / prefix / 版本 / release 目录 / 签名）
│   └── launch.toml             # hemtt launch 用的 CBA / ZEN / ACE 创意工坊 ID
├── addons/
│   └── main/                   # → zmp_main.pbo
│       ├── $PBOPREFIX$         # z\zmp\addons\main
│       ├── config.cpp          # CfgPatches（requiredAddons: cba_main, zen_*）
│       ├── CfgEventHandlers.hpp# CBA XEH：clientInit
│       ├── CfgFunctions.hpp    # zmp_fnc_*
│       ├── gui.hpp             # 播放器界面 zmp_display
│       ├── script_component.hpp
│       ├── script_version.hpp  # 版本号（HEMTT 读取）
│       ├── ui_defines.hpp      # IDD / IDC / 网格宏
│       ├── stringtable.xml     # 中文（默认）+ 英文
│       ├── XEH_postInitClient.sqf   # 注册 ZEN 模块、右键菜单、CBA 快捷键、音乐事件
│       └── functions/
│           ├── fn_canOpen.sqf           # 是否为 curator
│           ├── fn_open.sqf              # 打开（312 子 display / dialog）
│           ├── fn_getLibrary.sqf        # 遍历 CfgMusic（缓存在 uiNamespace）
│           ├── fn_getFavorites.sqf / fn_setFavorite.sqf / fn_removeFavorite.sqf
│           ├── fn_getGroups.sqf / fn_setGroups.sqf / fn_profileSave.sqf
│           ├── fn_play.sqf / fn_stop.sqf / fn_fade.sqf   # remoteExec 引擎命令
│           ├── fn_onMusicEvent.sqf      # MusicStart / MusicStop 跟踪当前曲目
│           ├── fn_checkRemoteExec.sqf   # CfgRemoteExec 自检
│           ├── fn_formatTime.sqf
│           └── fn_ui_*.sqf              # 界面逻辑
├── docs/
│   └── SERVER_KEY_INSTALL.md   # 给服务器腐竹的 key 安装说明
├── mod.cpp
└── README.md
```

## 构建

### 1. 安装 HEMTT

需要 HEMTT **1.22.0 或更新**（固定签名 key 的 `hemtt keys` 命令需要较新版本）。

- Windows：`winget install hemtt`（更新：`winget upgrade hemtt`），或从 <https://github.com/BrettMayson/HEMTT/releases> 下载 `hemtt.exe` 放到仓库根目录 / PATH 中。
- Linux：`curl -sSf https://hemtt.dev/install.sh | sh`

```sh
hemtt --version
```

### 2. 常用命令（在仓库根目录执行）

| 命令 | 作用 |
| --- | --- |
| `hemtt check` | 只做检查（配置、SQF、stringtable lint），不输出文件。加 `-p` 运行全部严格检查。 |
| `hemtt dev` | 快速开发构建到 `.hemttout/dev`（不签名），配合 `-filePatching` 调试。 |
| `hemtt launch` | 开发构建并直接启动游戏，自动加载 `.hemtt/launch.toml` 里配置的 CBA + ZEN（`hemtt launch ace` 再加 ACE3）。 |
| `hemtt build` | 正式构建到 `.hemttout/build`，不签名。 |
| `hemtt release` | 正式构建 + **签名** + 打包 zip。 |

### 3. 发布（签名）

```sh
hemtt release
```

输出：

```
.hemttout/release/                     # 即 @zeus_music_player 的内容
├── addons/
│   ├── zmp_main.pbo
│   └── zmp_main.pbo.<authority>.bisign
├── keys/
│   └── <authority>.bikey              # 交给服务器
├── mod.cpp
└── README.md
releases/
├── zmp-<版本>.zip                     # 解压后为 @zeus_music_player/
└── zmp-latest.zip
```

Zeus 玩家把 `@zeus_music_player` 放进游戏目录（或做成创意工坊物品），在启动器里和 CBA、ZEN 一起作为本地模组加载即可。

### 4. 签名与 key

HEMTT 有两种签名方式，二选一：

**A. 默认：每个版本一把新 key（零配置）**

`hemtt release` 每次随机生成私钥签名后就丢弃，authority 为 `zmp_<版本号>`，例如 `zmp_1.0.0.0.bikey`。
私钥从不落盘，最安全；但**每发一个新版本，服务器都要换一次 `.bikey`**（旧 key 可以删掉）。

**B. 推荐：固定 key（服务器只装一次）**

1. 在仓库根目录执行（只做一次）：

   ```sh
   hemtt keys generate
   ```

   - 按提示确认，HEMTT 会生成 `zmp.hemttprivatekey`（已加密）并显示一串**密码，只显示一次**，请存进密码管理器。
   - `*.hemttprivatekey` 已经在 `.gitignore` 里，**绝对不要提交、不要发给任何人**。请另外备份这个文件和密码，丢了只能换新 key。
   - 这把 key 绑定本项目（name / prefix / 仓库第一个提交）。

2. 把命令最后输出的那一行填进 `.hemtt/project.toml`（文件末尾已留好注释模板）：

   ```toml
   [signing]
   private_key_hash = "……"
   ```

3. 之后每次 `hemtt release` 都会提示输入密码，用同一把 key 签名，生成的 key 固定为 `keys/zmp.bikey`。
   发新版本时服务器不需要做任何改动。

> 固定私钥只能在本地使用：HEMTT 检测到 CI 环境时会拒绝使用私钥文件。

### 5. 改版本号

修改 `addons/main/script_version.hpp` 里的 `MAJOR / MINOR / PATCH / BUILD`。

## 给服务器腐竹

见 [docs/SERVER_KEY_INSTALL.md](docs/SERVER_KEY_INSTALL.md)。简要：把 `.bikey` 放进服务器的 `keys` 文件夹并重启，服务器**不需要**加载本模组。
