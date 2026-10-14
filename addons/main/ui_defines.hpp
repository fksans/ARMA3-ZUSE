// Zeus Music Player - UI IDs & layout helpers

#define IDD_ZMP 191370

#define IDC_ZMP_TITLE 1000
#define IDC_ZMP_STATUS 1001
#define IDC_ZMP_CLOSE 1002
#define IDC_ZMP_RE_CHECK 1010
#define IDC_ZMP_NOW_PLAYING 1020
#define IDC_ZMP_TABS 1030
#define IDC_ZMP_COUNT 1031
#define IDC_ZMP_SEARCH 1040
#define IDC_ZMP_FILTER_CLASS 1041
#define IDC_ZMP_FILTER_GROUP 1042
#define IDC_ZMP_LIST_HEADER 1050
#define IDC_ZMP_LIST 1051
#define IDC_ZMP_INFO 1060
#define IDC_ZMP_NEW_GROUP 1061
#define IDC_ZMP_ADD_GROUP 1062
#define IDC_ZMP_DELETE_GROUP 1063
#define IDC_ZMP_FAVORITE 1070
#define IDC_ZMP_GROUP 1071
#define IDC_ZMP_NOTE 1072
#define IDC_ZMP_SAVE_NOTE 1073
#define IDC_ZMP_PREVIEW 1080
#define IDC_ZMP_PREVIEW_STOP 1081
#define IDC_ZMP_PLAY_ALL 1082
#define IDC_ZMP_STOP_ALL 1083
#define IDC_ZMP_START 1084
#define IDC_ZMP_FADE_TIME 1090
#define IDC_ZMP_VOLUME 1091
#define IDC_ZMP_FADE_IN_PLAY 1092
#define IDC_ZMP_FADE_OUT_STOP 1093
#define IDC_ZMP_FADE_APPLY 1094
#define IDC_ZMP_HINT 1100

// 40 x 25 居中网格（与原版 GUI_GRID_CENTER 相同）
#define GRID_AREA_W ((safezoneW / safezoneH) min 1.2)
#define GRID_AREA_H (((safezoneW / safezoneH) min 1.2) / 1.2)
#define GRID_W (GRID_AREA_W / 40)
#define GRID_H (GRID_AREA_H / 25)
#define GRID_X (safezoneX + (safezoneW - GRID_AREA_W) / 2)
#define GRID_Y (safezoneY + (safezoneH - GRID_AREA_H) / 2)

#define POS_X(N) ((N) * GRID_W + GRID_X)
#define POS_Y(N) ((N) * GRID_H + GRID_Y)
#define POS_W(N) ((N) * GRID_W)
#define POS_H(N) ((N) * GRID_H)
