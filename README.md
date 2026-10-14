# Zeus Music Player（Zeus 音乐播放器）

给 Arma 3 Zeus 用的音乐播放器，附带一个**平滑的时间 / 天气过渡**工具（见下面的「时间 / 天气过渡」）。**客户端模组**：只有 Zeus 自己加载，其他玩家和服务器都不用装。

- 曲库直接来自所有已加载模组的 `CfgMusic`，不新增任何歌曲。
- 全队播放只让其他玩家执行引擎命令 `playMusic` / `fadeMusic`，不调用本模组的函数（其他玩家没装本模组）。默认通过 ZEN 的事件通道发送，不受服务器 `CfgRemoteExec` 白名单影响，详见下面的「全队播放是怎么发出去的」。
- 依赖：**CBA_A3**、**ZEN (Zeus Enhanced)**（写在 `requiredAddons` 里）。

## 功能

| 功能 | 说明 |
| --- | --- |
| 曲库 | 遍历 `configFile >> "CfgMusic"`，显示名称（`name`，没有就显示类名）、时长（`duration`）、`musicClass`（显示 `CfgMusicClasses` 里的名字）。支持关键字搜索（名称 / 类名 / musicClass / 来源模组 / 分组 / 备注，空格分隔多个关键字）和按 musicClass 筛选。 |
| 收藏 | 收藏 / 取消收藏，存在 `profileNamespace`，每次改动立刻 `saveProfileNamespace`，跨任务、跨服务器保留。当前服务器没加载的收藏曲目会灰色显示，不会丢。 |
| 收藏分组 | 默认「战斗 / 潜入 / 氛围 / 结尾」，可以新增、删除；收藏页签可以按分组筛选。 |
| 曲目备注 | 每首收藏曲目可写备注名，可被搜索。 |
| 试听 | 只在本机 `playMusic`，其他人听不到（双击列表也可以试听）。 |
| 播放对象 | 播放 / 停止 / 淡入淡出可以只发给：全体玩家、某个阵营、某个小队、某个玩家，或者 Zeus 界面里当前选中的单位（及其所在小队）。可勾选「我自己也听」，不在对象里也能监听。 |
| 播放 | 播放对象执行 `playMusic _class`（可设置起始秒数，此时为 `playMusic [_class, 秒]`）。 |
| 停止 | 播放对象执行 `playMusic ""` |
| AB 循环 | 填 A 点、B 点（可以在试听时点「A」「B」按钮记录当前进度），播放对象在 A～B 之间无限循环，接缝处有很短的淡出淡入。点「播放」「停止」或「淡出停止」结束循环。 |
| 淡入淡出 | 播放对象执行 `时长 fadeMusic 音量`，时长、目标音量可调：淡入播放 / 淡出后停止 / 淡变到目标音量。 |
| 正在播放 | 显示当前曲目、来源（发给了谁 / 仅本机试听 / 其他来源：任务脚本或其他 Zeus）和进度。 |
| 自检 | 界面顶部显示全队播放走的是哪条通道。如果在设置里改成 remoteExec 方式，会检查 `missionConfigFile` / `configFile` 的 `CfgRemoteExec >> Commands`，白名单里缺少 `playMusic` / `fadeMusic` 时显示红色警告「全队播放可能被服务器拦截」。 |
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
│ 正在播放：名称 [类名] · 发给：OPFOR · 01:23 / 03:45               │
│ [ 全部 | 收藏 ]   曲库 N 首 · 当前显示 N 首 · 已收藏 N 首         │
│ 搜索 [__________]  musicClass [全部 ▼]   分组 [全部分组 ▼]       │
│ ★ │ 名称                 │ 时长  │ musicClass │ 分组 │ 备注       │
│ ...                                                               │
│ 选中：名称 [类名] 来源：@mod     [新分组名] [添加分组] [删除分组] │
│ [★ 收藏]  分组 [未分组 ▼]  备注 [______________]  [保存备注]      │
│ 播放对象 [全体玩家 / 阵营 / 小队 / 玩家 ▼] [刷新] ☑我自己也听   │
│ [试听] [停止试听] [播放] [停止]  [A][0  ] [B][   ] [AB 循环]      │
│ 淡变时长(秒) [5]  目标音量(0-1) [1]  [淡入播放] [淡出停止] [淡变] │
│ 提示：playMusic 受每位玩家「音乐」音量影响 ...                   │
└───────────────────────────────────────────────────────────────────┘
```

界面文字跟随游戏语言：简体中文显示中文，其他语言都显示英文。

### 存储（profileNamespace）

| 变量 | 内容 |
| --- | --- |
| `zmp_favorites` | `[[类名, 分组, 备注], ...]` |
| `zmp_favoriteGroups` | `["战斗", "潜入", ...]` |
| `zmp_fadeTime` | 上次使用的淡变时长 |
| `zmp_volume` | 上次使用的目标音量 |
| `zmp_envDuration` | 上次使用的时间 / 天气过渡时长 |
| `zmp_envEase` | 上次是否使用缓入缓出 |

### 注意事项

- **音乐音量**：`playMusic` 受每位玩家自己的「设置 → 音频 → 音乐」音量影响，调成 0 的玩家听不到，Zeus 无法强制。界面底部有提示。
- **你自己听不听**：播放对象是全体玩家时包括你自己。选了阵营 / 小队 / 玩家而你不在其中时，默认勾选的「我自己也听」会让你也听到，「正在播放」就是对方正在听的；取消勾选后你听不到，进度按时间估算。
- **试听会替换你本机的音乐**：音乐通道只有一个，试听时你自己会暂时听不到发给别人的曲子（其他玩家不受影响）。
- **淡出后的音量**：`fadeMusic` 改的音量会一直保持。「淡出停止」结束后会自动把音量复位；「播放」前也会先把音量设为「目标音量」，不会出现淡出到 0 之后新歌没声音的情况。
- **自检的局限**（只在 remoteExec 方式下有意义）：客户端只能看到任务 `description.ext` 和本机加载的模组。服务器专用模组（`-serverMod`）里的 `CfgRemoteExec`、BattlEye `remoteexec.txt` 过滤都检测不到。
- **不会污染任务**：本模组不添加任何可放置对象（模块通过 ZEN 的自定义模块注册），用它的 Zeus 保存的任务不会依赖本模组。

## 时间 / 天气过渡

原版 / ZEN 改时间是一下子 `setDate` 过去，画面直接跳变；改天气要等很久才看得出来，体积云又不能立刻改变。这个工具把它们换成一段「延时摄影」式的过渡：

- **时间**：「到指定时间」（例如 18:30，只往后走）或「前进 N 小时」（可以超过 24 小时）。快捷按钮：日出 / 正午 / 日落 / 午夜，日出日落按当前地图纬度和日期计算。
- **过渡时长**：现实中用几秒走完（1–600 秒）。比如跳 12 小时、用 20 秒，太阳会在 20 秒内平滑地划过天空。曲线可选「匀速」或「缓入缓出」。
- **天气跟着时间轴走**：勾选云量 / 雾 / 雨 / 风力 / 闪电 / 海浪并填目标值（0–1），它们会和时间一起渐变，**过渡结束时正好到达目标**。有「晴朗 / 多云 / 阴天 / 下雨 / 暴风雨 / 晨雾」预设，「读取当前」把现在的天气填进去。
- **只改天气**：时间填成现在（或前进 0 小时），天气在设定的秒数内渐变。云量在这种情况下变得比较慢，想要明显的云层变化最好配合跳过几个小时。
- **停止过渡**：时间和天气停在当时的样子。新的过渡会直接取代正在进行的过渡。

入口：ZEN 模块分类「时间天气」→「时间 / 天气过渡」；Zeus 右键菜单「时间 / 天气过渡」；快捷键默认 `Ctrl + Shift + T`。

```
┌ 时间 / 天气过渡 ─────────────────────── [状态消息]  X ┐
│ 现在 05:32 · 云 0.30 · 雾 0.00 · 雨 0.00 · ... · 过渡中 45% │
│ [ 到指定时间 | 前进时长 ]     05:32 → 18:30（+12:58，20 秒） │
│ 目标时间 [18:30] [日出][正午][日落][午夜]  前进(小时) [1]   │
│ 过渡时长(秒) [20]  曲线 [缓入缓出 ▼]                         │
│ 天气（跟着时间轴一起渐变）   预设 [选择预设… ▼] [读取当前]  │
│ ☑ 云量 [0.80]   ☐ 雾 [0.00]     ☑ 雨 [0.60]                  │
│ ☐ 风力 [0.20]   ☐ 闪电 [0.00]   ☐ 海浪 [0.20]                │
│ 提示 ...                                                     │
│ [        开始过渡        ] [        停止过渡        ]        │
└──────────────────────────────────────────────────────────────┘
```

### 原理

- **时间**：过渡代码通过 ZEN 事件发给**所有机器（服务器 + 每位玩家）**，每台机器每帧用 `skipTime` 推进一小段，按「进度 × 总时长 − 已经跳过的」计算，最后一帧正好补齐，误差不累积。所有机器步调一致，服务器的时间同步不会把客户端拉回去，所以看到的是太阳平滑移动，而不是隔几秒跳一下。
- **天气**：天气命令（`setOvercast` / `setFog` / `setRain` / `setWindStr` / `setLightnings` / `setWaves`）的过渡时间按**游戏时间**计算，`skipTime` 跳过的时间同样会推进天气（官方 wiki 的 `skipTime -24; 86400 setOvercast 1; skipTime 24` 就是这个原理）。所以把天气的过渡时间设成「跳过的时间 + 过渡期间正常流逝的时间」，天气就和太阳一起渐变，过渡结束时正好到达目标。天气命令的效果只在本机，所以同样在每台机器上执行。雾只改浓度，保留任务设置的雾衰减和高度。
- **注意**：
  - **服务器也要加载 ZEN**（一般都会）。服务器上没有 ZEN 时服务器时间不变，客户端过几秒就会被同步回去。
  - 这个功能总是走 ZEN 事件，不受「全队播放方式」设置影响（remoteExec 没办法在对方机器上运行每帧的代码）。
  - 过渡进行中才进服的玩家只会收到服务器的时间同步，会看到几次跳变。
  - 云量较低时引擎可能不下雨。

### 全队播放是怎么发出去的

其他玩家没有安装本模组，所以只能借用他们已经有的东西。在 ESC → 选项 → 插件设置 → Zeus Music Player →「全队播放方式」里可以选：

| 方式 | 原理 | 会不会被服务器拦截 |
| --- | --- | --- |
| **ZEN 事件**（默认，推荐） | 用 `CBA_fnc_globalEvent` 触发 ZEN 在每台机器上都注册了的 `zen_common_execute` 事件，让它执行 `playMusic` / `fadeMusic`。ZEN 自己的「执行代码」等模块用的就是这条通道。CBA 事件通过 `publicVariable` 传输。 | 不经过 `remoteExec`，不受 `CfgRemoteExec` 白名单影响。只要 ZEN 在这台服务器上能用，它就能用。 |
| **remoteExec** | `[_class] remoteExec ["playMusic", 0]`、`[时长, 音量] remoteExec ["fadeMusic", 0]` | 服务器的 `CfgRemoteExec` 白名单或 BattlEye `remoteexec.txt` 没放行这两个命令时会被拦截，结果只有 Zeus 自己听得到。 |

一次操作的所有步骤（比如淡入播放的「音量归零 → 播放 → 淡入」）放在同一条事件里发送，保证在每台机器上按顺序执行。

**AB 循环**：ZEN 事件方式下，循环代码和播放命令一起发给播放对象，在他们各自的机器上用 `playMusic [类名, A]` 循环（到 B 点前约 0.3 秒淡出，跳回 A 点再淡入），不依赖网络往返，Zeus 掉线也会继续，直到收到新的播放 / 停止。remoteExec 方式下只能由 Zeus 每隔 (B − A) 秒重新发送一次 `playMusic [类名, A]`，Zeus 掉线循环就停了。

**只发给部分人（阵营 / 小队 / 玩家）**：ZEN 事件方式下，事件仍然发给所有机器，每台机器执行前自己检查 `side group player` / `group player` / `player` 是否在播放对象里，不在就跳过。remoteExec 方式下直接把阵营 / 小队 / 单位作为 `remoteExec` 的目标。

如果你选择 remoteExec 方式，而任务或服务器使用 `CfgRemoteExec` 白名单，白名单里需要包含：

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
│       ├── gui_env.hpp         # 时间 / 天气过渡界面 zmp_envDisplay
│       ├── script_component.hpp
│       ├── script_version.hpp  # 版本号（HEMTT 读取）
│       ├── ui_defines.hpp      # IDD / IDC / 网格宏
│       ├── stringtable.xml     # 英文（默认）+ 简体中文
│       ├── XEH_preInit.sqf          # CBA 设置：全队播放方式
│       ├── XEH_postInitClient.sqf   # 注册 ZEN 模块、右键菜单、CBA 快捷键（播放器 + 时间天气）、音乐事件
│       └── functions/
│           ├── fn_canOpen.sqf           # 是否为 curator
│           ├── fn_open.sqf              # 打开（312 子 display / dialog）
│           ├── fn_getLibrary.sqf        # 遍历 CfgMusic（缓存在 uiNamespace）
│           ├── fn_getFavorites.sqf / fn_setFavorite.sqf / fn_removeFavorite.sqf
│           ├── fn_getGroups.sqf / fn_setGroups.sqf / fn_profileSave.sqf
│           ├── fn_play.sqf / fn_stop.sqf / fn_fade.sqf   # 播放控制
│           ├── fn_broadcast.sqf         # 把 playMusic / fadeMusic 发给所有机器（ZEN 事件 / remoteExec）
│           ├── fn_onMusicEvent.sqf      # MusicStart / MusicStop 跟踪当前曲目
│           ├── fn_checkRemoteExec.sqf   # CfgRemoteExec 自检
│           ├── fn_env_transition.sqf    # 时间 / 天气过渡（所有机器每帧 skipTime，天气跟着时间轴）
│           ├── fn_env_open.sqf / fn_env_ui_*.sqf   # 时间 / 天气过渡界面
│           ├── fn_formatTime.sqf / fn_formatClock.sqf / fn_parseClock.sqf
│           └── fn_ui_*.sqf              # 界面逻辑
├── .github/workflows/
│   └── build.yml               # CI：PR 检查 + 打标签自动发布到 GitHub Releases
├── docs/
│   ├── SERVER_KEY_INSTALL.md   # 给服务器腐竹的 key 安装说明
│   └── WORKSHOP.md             # 创意工坊介绍页（英文 + 中文）
├── CHANGELOG.md                # 更新日志（hemtt publish 用它写创意工坊的更新说明）
├── LICENSE.md                  # APL-SA
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
├── CHANGELOG.md                # 更新日志（hemtt publish 用它写创意工坊的更新说明）
├── LICENSE.md                  # APL-SA
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

`hemtt release` 每次随机生成私钥签名后就丢弃，authority 为 `zmp_<版本号>`，例如 `zmp_1.2.1.bikey`。
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
> 所以选了 B 之后，下面的「自动打包发布」会在 `hemtt release` 这一步失败，需要改成本地 `hemtt release`，再把 zip 和 `.bikey` 手动传到 GitHub Releases。

### 5. 改版本号

修改 `addons/main/script_version.hpp` 里的 `MAJOR / MINOR / PATCH`，并在 `CHANGELOG.md` 里加上这个版本的条目。

### 6. 自动打包发布（GitHub Actions）

`.github/workflows/build.yml` 做两件事：

- **推到 main / 提 PR**：运行 `hemtt check`，有错误会在 PR 上标红。
- **推 `v*` 标签，或在 Actions 页面手动运行**：运行 `hemtt release` 构建并签名，然后在 GitHub **Releases** 页面创建一个版本，附上两个文件：
  - `zmp-<版本>.zip`：给 Zeus 玩家下载，解压就是 `@zeus_music_player`
  - `zmp_<版本>.bikey`：给服务器腐竹

发新版本有两种方式。

**方式一：网页上点按钮（最简单）**

1. 改 `addons/main/script_version.hpp` 里的版本号，比如改成 `1.0.1`，提交并推到 main。
2. 打开仓库的 **Actions** 页签 → 左侧选 **Build** → 右侧点 **Run workflow** → 分支选 `main` → 点绿色的 **Run workflow**。
3. 等几分钟，工作流会自动创建 `v1.0.1` 标签和 Release。如果这个版本号已经发布过，会直接报错，提醒你先改版本号。

**方式二：自己打标签**

1. 改 `addons/main/script_version.hpp` 里的版本号，比如改成 `1.0.1`，提交并推到 main。
2. 打一个**和版本号一致**的标签并推上去：

   ```sh
   git tag v1.0.1
   git push origin v1.0.1
   ```

   也可以在 GitHub 网页上操作：Releases → Draft a new release → 标签填 `v1.0.1`（选 main）→ Publish release。标签推上去后 Actions 会自动把 zip 和 `.bikey` 加到这个 Release 里。
3. 等 Actions 跑完（仓库的 Actions 页面能看到进度），Releases 页面就会出现新版本。

- 标签必须和 `script_version.hpp` 的 `MAJOR.MINOR.PATCH` 一致（`v1.0.1` 对应 `1.0.1`），不一致时工作流会直接报错，不会发出版本号对不上的包。
- CI 里用的是默认签名方式 A：**每个版本的 `.bikey` 都不同**，更新版本后要把新的 `.bikey` 发给腐竹。

### 7. 发布到 Steam 创意工坊

HEMTT 自带 `hemtt publish`：先做一次 `hemtt release`，再把结果上传到创意工坊。介绍页会用 `docs/WORKSHOP.md` 生成，更新说明取 `CHANGELOG.md` 里对应版本的条目（在 `.hemtt/project.toml` 的 `[hemtt.publish]` 里配置）。

**需要在你自己的 Windows 电脑上操作，Steam 必须开着并已登录**（上传走的是 Steam 客户端，CI 里做不了）。

1. 改好版本号（`addons/main/script_version.hpp`），并在 `CHANGELOG.md` 最上面加上这个版本的条目，比如 `## [1.3.0]`。**没有对应版本的条目，`hemtt publish` 会直接报错。**
2. 在仓库根目录运行：

   ```sh
   hemtt publish
   ```

   - **第一次**会问你是否新建创意工坊物品。确认后 HEMTT 会在仓库根目录生成 `meta.cpp`，里面记录了物品 ID。**把 `meta.cpp` 提交到仓库**，以后再运行就是更新同一个物品，不会重复新建。
   - 第一次上传后，到 Steam 上同意创意工坊条款（如果提示需要的话）。

3. 第一次上传后，在创意工坊页面上手动补几样东西（HEMTT 不会自动设置）：
   - **必需物品**：添加 CBA_A3 和 Zeus Enhanced，订阅的人会自动装上依赖。
   - **可见性**：默认可能是隐藏或仅好友可见，确认没问题后改成公开。
   - **预览图**：可选。不设置的话，Steam 会显示默认的灰色占位图。

**签名 key**：`hemtt publish` 打包时也会签名。现在没配固定 key，每个版本的 `.bikey` 都不一样，用这个模组的服务器每次更新都要换 key。正式上架前，建议按上面「签名与 key」的 B 方式换成固定 key。

## 许可证

[Arma Public License Share Alike (APL-SA)](https://www.bohemia.net/community/licenses/arma-public-license-share-alike)，见 [LICENSE.md](LICENSE.md)。

## 给服务器腐竹

见 [docs/SERVER_KEY_INSTALL.md](docs/SERVER_KEY_INSTALL.md)。简要：把 `.bikey` 放进服务器的 `keys` 文件夹并重启，服务器**不需要**加载本模组。
