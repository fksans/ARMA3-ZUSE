// Zeus Music Player - shared macros (config + SQF)
// 不依赖 CBA 的宏头文件，保持构建时无需额外 include。

#include "script_version.hpp"

#define PREFIX zmp
#define COMPONENT main
#define ADDON zmp_main
#define ADDON_PATH \z\zmp\addons\main

#define QUOTE(var) #var
#define DOUBLES(var1,var2) var1##_##var2

// profileNamespace 变量名（统一前缀，避免和其他模组冲突）
#define PROFILE_FAVORITES "zmp_favorites"
#define PROFILE_GROUPS "zmp_favoriteGroups"
#define PROFILE_FADE_TIME "zmp_fadeTime"
#define PROFILE_VOLUME "zmp_volume"
#define PROFILE_ENV_DURATION "zmp_envDuration"
#define PROFILE_ENV_EASE "zmp_envEase"

// 默认收藏分组（只在玩家第一次使用时写入）
#define DEFAULT_GROUPS [localize "STR_ZMP_GroupCombat", localize "STR_ZMP_GroupStealth", localize "STR_ZMP_GroupAmbient", localize "STR_ZMP_GroupEnding"]

// 时间 / 天气过渡：界面上的天气项，顺序和 IDC_ZMP_ENV_WEATHER_CHECK / _EDIT 的序号一致
#define ENV_WEATHER_KEYS ["overcast", "fog", "rain", "windStr", "lightnings", "waves"]

// 天气预设：[名称, [云量, 雾, 雨, 风力, 闪电, 海浪]]
#define ENV_WEATHER_PRESETS [ \
    [localize "STR_ZMP_EnvPresetClear", [0.05, 0, 0, 0.1, 0, 0.1]], \
    [localize "STR_ZMP_EnvPresetCloudy", [0.5, 0, 0, 0.3, 0, 0.3]], \
    [localize "STR_ZMP_EnvPresetOvercast", [0.75, 0.05, 0, 0.4, 0.1, 0.4]], \
    [localize "STR_ZMP_EnvPresetRain", [0.85, 0.08, 0.6, 0.5, 0.2, 0.5]], \
    [localize "STR_ZMP_EnvPresetStorm", [1, 0.1, 1, 0.9, 0.9, 0.9]], \
    [localize "STR_ZMP_EnvPresetFog", [0.4, 0.4, 0, 0.05, 0, 0.1]] \
]

#include "ui_defines.hpp"
