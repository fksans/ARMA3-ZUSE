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

// 默认收藏分组（只在玩家第一次使用时写入）
#define DEFAULT_GROUPS [localize "STR_ZMP_GroupCombat", localize "STR_ZMP_GroupStealth", localize "STR_ZMP_GroupAmbient", localize "STR_ZMP_GroupEnding"]

#include "ui_defines.hpp"
