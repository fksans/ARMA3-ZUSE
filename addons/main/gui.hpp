// Zeus Music Player - 主界面
// 使用原版 3DEN 风格控件基类（configFile 根下的 ctrl*），不依赖其他模组的 UI。

class ctrlStatic;
class ctrlStaticBackground;
class ctrlStaticTitle;
class ctrlStructuredText;
class ctrlButton;
class ctrlEdit;
class ctrlCombo;
class ctrlToolbox;
class ctrlListNBox;

#define TEXT_SIZE QUOTE(POS_H(0.85))
#define TEXT_SIZE_SMALL QUOTE(POS_H(0.75))

#define LIST_COLUMNS {0, 0.03, 0.42, 0.49, 0.67, 0.79}

// 窗口左上角 (1, 0.5)，宽 38，高 24（40 x 25 网格内居中）
class zmp_RscText: ctrlStatic {
    idc = -1;
    sizeEx = TEXT_SIZE;
    h = QUOTE(POS_H(1));
};
class zmp_RscLabel: zmp_RscText {
    style = 1; // ST_RIGHT
};
class zmp_RscButton: ctrlButton {
    idc = -1;
    sizeEx = TEXT_SIZE;
    h = QUOTE(POS_H(1.1));
};
class zmp_RscEdit: ctrlEdit {
    idc = -1;
    sizeEx = TEXT_SIZE;
    h = QUOTE(POS_H(1));
};
class zmp_RscCombo: ctrlCombo {
    idc = -1;
    sizeEx = TEXT_SIZE;
    h = QUOTE(POS_H(1));
};

class zmp_display {
    idd = IDD_ZMP;
    movingEnable = 1;
    enableSimulation = 1;
    onLoad = "call zmp_fnc_ui_onLoad";
    onUnload = "call zmp_fnc_ui_onUnload";

    class ControlsBackground {
        class Background: ctrlStaticBackground {
            x = QUOTE(POS_X(1));
            y = QUOTE(POS_Y(1.5));
            w = QUOTE(POS_W(38));
            h = QUOTE(POS_H(23));
            colorBackground[] = {0.08, 0.08, 0.08, 0.95};
        };
    };

    class Controls {
        class Title: ctrlStaticTitle {
            idc = IDC_ZMP_TITLE;
            moving = 1;
            text = "$STR_ZMP_Title";
            sizeEx = TEXT_SIZE;
            x = QUOTE(POS_X(1));
            y = QUOTE(POS_Y(0.5));
            w = QUOTE(POS_W(38));
            h = QUOTE(POS_H(1));
        };
        // 标题栏右侧的状态提示（"已向全体玩家播放..." 等）
        class Status: zmp_RscText {
            idc = IDC_ZMP_STATUS;
            style = 1;
            sizeEx = TEXT_SIZE_SMALL;
            colorText[] = {1, 0.85, 0.4, 1};
            x = QUOTE(POS_X(13));
            y = QUOTE(POS_Y(0.5));
            w = QUOTE(POS_W(24.8));
        };
        class Close: zmp_RscButton {
            idc = IDC_ZMP_CLOSE;
            text = "X";
            tooltip = "$STR_ZMP_Close";
            x = QUOTE(POS_X(37.9));
            y = QUOTE(POS_Y(0.5));
            w = QUOTE(POS_W(1.1));
            h = QUOTE(POS_H(1));
            colorBackground[] = {0, 0, 0, 0};
        };

        // ---- 行 1：CfgRemoteExec 自检结果 ----
        class RemoteExecCheck: zmp_RscText {
            idc = IDC_ZMP_RE_CHECK;
            x = QUOTE(POS_X(1.5));
            y = QUOTE(POS_Y(1.8));
            w = QUOTE(POS_W(37));
            colorBackground[] = {0.1, 0.35, 0.1, 0.8};
        };

        // ---- 行 2：当前播放 ----
        class NowPlaying: zmp_RscText {
            idc = IDC_ZMP_NOW_PLAYING;
            x = QUOTE(POS_X(1.5));
            y = QUOTE(POS_Y(3));
            w = QUOTE(POS_W(37));
            colorBackground[] = {0, 0, 0, 0.5};
            colorText[] = {0.55, 0.85, 1, 1};
        };

        // ---- 行 3：页签 ----
        class Tabs: ctrlToolbox {
            idc = IDC_ZMP_TABS;
            sizeEx = TEXT_SIZE;
            rows = 1;
            columns = 2;
            strings[] = {"$STR_ZMP_TabAll", "$STR_ZMP_TabFavorites"};
            x = QUOTE(POS_X(1.5));
            y = QUOTE(POS_Y(4.3));
            w = QUOTE(POS_W(12));
            h = QUOTE(POS_H(1.1));
        };
        class Count: zmp_RscText {
            idc = IDC_ZMP_COUNT;
            sizeEx = TEXT_SIZE_SMALL;
            colorText[] = {0.7, 0.7, 0.7, 1};
            x = QUOTE(POS_X(13.8));
            y = QUOTE(POS_Y(4.35));
            w = QUOTE(POS_W(24.7));
        };

        // ---- 行 4：搜索 / 筛选 ----
        class SearchLabel: zmp_RscLabel {
            text = "$STR_ZMP_Search";
            x = QUOTE(POS_X(1.5));
            y = QUOTE(POS_Y(5.6));
            w = QUOTE(POS_W(2.5));
        };
        class Search: zmp_RscEdit {
            idc = IDC_ZMP_SEARCH;
            tooltip = "$STR_ZMP_SearchTooltip";
            x = QUOTE(POS_X(4));
            y = QUOTE(POS_Y(5.6));
            w = QUOTE(POS_W(13));
        };
        class FilterClassLabel: zmp_RscLabel {
            text = "musicClass";
            x = QUOTE(POS_X(17.2));
            y = QUOTE(POS_Y(5.6));
            w = QUOTE(POS_W(4));
        };
        class FilterClass: zmp_RscCombo {
            idc = IDC_ZMP_FILTER_CLASS;
            x = QUOTE(POS_X(21.2));
            y = QUOTE(POS_Y(5.6));
            w = QUOTE(POS_W(8));
        };
        class FilterGroupLabel: zmp_RscLabel {
            text = "$STR_ZMP_Group";
            x = QUOTE(POS_X(29.3));
            y = QUOTE(POS_Y(5.6));
            w = QUOTE(POS_W(2.4));
        };
        class FilterGroup: zmp_RscCombo {
            idc = IDC_ZMP_FILTER_GROUP;
            tooltip = "$STR_ZMP_FilterGroupTooltip";
            x = QUOTE(POS_X(31.7));
            y = QUOTE(POS_Y(5.6));
            w = QUOTE(POS_W(6.8));
        };

        // ---- 列表 ----
        class ListHeader: ctrlListNBox {
            idc = IDC_ZMP_LIST_HEADER;
            sizeEx = TEXT_SIZE_SMALL;
            columns[] = LIST_COLUMNS;
            x = QUOTE(POS_X(1.5));
            y = QUOTE(POS_Y(6.8));
            w = QUOTE(POS_W(37));
            h = QUOTE(POS_H(0.9));
            colorBackground[] = {0.2, 0.2, 0.2, 1};
            colorSelectBackground[] = {0.2, 0.2, 0.2, 1};
            colorSelectBackground2[] = {0.2, 0.2, 0.2, 1};
            colorText[] = {0.8, 0.8, 0.8, 1};
        };
        class List: ctrlListNBox {
            idc = IDC_ZMP_LIST;
            sizeEx = TEXT_SIZE;
            columns[] = LIST_COLUMNS;
            x = QUOTE(POS_X(1.5));
            y = QUOTE(POS_Y(7.7));
            w = QUOTE(POS_W(37));
            h = QUOTE(POS_H(10.3));
            colorBackground[] = {0, 0, 0, 0.6};
        };

        // ---- 行 5：选中曲目信息 + 分组管理 ----
        class Info: zmp_RscText {
            idc = IDC_ZMP_INFO;
            sizeEx = TEXT_SIZE_SMALL;
            colorText[] = {0.8, 0.8, 0.8, 1};
            x = QUOTE(POS_X(1.5));
            y = QUOTE(POS_Y(18.2));
            w = QUOTE(POS_W(22));
        };
        class NewGroup: zmp_RscEdit {
            idc = IDC_ZMP_NEW_GROUP;
            tooltip = "$STR_ZMP_NewGroupTooltip";
            x = QUOTE(POS_X(23.7));
            y = QUOTE(POS_Y(18.2));
            w = QUOTE(POS_W(6));
        };
        class AddGroup: zmp_RscButton {
            idc = IDC_ZMP_ADD_GROUP;
            text = "$STR_ZMP_AddGroup";
            x = QUOTE(POS_X(29.9));
            y = QUOTE(POS_Y(18.2));
            w = QUOTE(POS_W(4.2));
            h = QUOTE(POS_H(1));
        };
        class DeleteGroup: zmp_RscButton {
            idc = IDC_ZMP_DELETE_GROUP;
            text = "$STR_ZMP_DeleteGroup";
            tooltip = "$STR_ZMP_DeleteGroupTooltip";
            x = QUOTE(POS_X(34.3));
            y = QUOTE(POS_Y(18.2));
            w = QUOTE(POS_W(4.2));
            h = QUOTE(POS_H(1));
        };

        // ---- 行 6：收藏 / 分组 / 备注 ----
        class Favorite: zmp_RscButton {
            idc = IDC_ZMP_FAVORITE;
            text = "$STR_ZMP_AddFavorite";
            x = QUOTE(POS_X(1.5));
            y = QUOTE(POS_Y(19.4));
            w = QUOTE(POS_W(6));
        };
        class GroupLabel: zmp_RscLabel {
            text = "$STR_ZMP_Group";
            x = QUOTE(POS_X(7.7));
            y = QUOTE(POS_Y(19.45));
            w = QUOTE(POS_W(2));
        };
        class Group: zmp_RscCombo {
            idc = IDC_ZMP_GROUP;
            tooltip = "$STR_ZMP_GroupTooltip";
            x = QUOTE(POS_X(9.7));
            y = QUOTE(POS_Y(19.45));
            w = QUOTE(POS_W(8));
        };
        class NoteLabel: zmp_RscLabel {
            text = "$STR_ZMP_Note";
            x = QUOTE(POS_X(17.9));
            y = QUOTE(POS_Y(19.45));
            w = QUOTE(POS_W(2));
        };
        class Note: zmp_RscEdit {
            idc = IDC_ZMP_NOTE;
            tooltip = "$STR_ZMP_NoteTooltip";
            x = QUOTE(POS_X(19.9));
            y = QUOTE(POS_Y(19.45));
            w = QUOTE(POS_W(14.3));
        };
        class SaveNote: zmp_RscButton {
            idc = IDC_ZMP_SAVE_NOTE;
            text = "$STR_ZMP_SaveNote";
            x = QUOTE(POS_X(34.4));
            y = QUOTE(POS_Y(19.4));
            w = QUOTE(POS_W(4.1));
        };

        // ---- 行 7：播放 ----
        class Preview: zmp_RscButton {
            idc = IDC_ZMP_PREVIEW;
            text = "$STR_ZMP_Preview";
            tooltip = "$STR_ZMP_PreviewTooltip";
            x = QUOTE(POS_X(1.5));
            y = QUOTE(POS_Y(20.8));
            w = QUOTE(POS_W(5));
        };
        class PreviewStop: zmp_RscButton {
            idc = IDC_ZMP_PREVIEW_STOP;
            text = "$STR_ZMP_PreviewStop";
            x = QUOTE(POS_X(6.7));
            y = QUOTE(POS_Y(20.8));
            w = QUOTE(POS_W(5.5));
        };
        class PlayAll: zmp_RscButton {
            idc = IDC_ZMP_PLAY_ALL;
            text = "$STR_ZMP_PlayAll";
            tooltip = "$STR_ZMP_PlayAllTooltip";
            x = QUOTE(POS_X(12.6));
            y = QUOTE(POS_Y(20.8));
            w = QUOTE(POS_W(6.5));
            colorBackground[] = {0.75, 0.45, 0.05, 1};
        };
        class StopAll: zmp_RscButton {
            idc = IDC_ZMP_STOP_ALL;
            text = "$STR_ZMP_StopAll";
            tooltip = "$STR_ZMP_StopAllTooltip";
            x = QUOTE(POS_X(19.3));
            y = QUOTE(POS_Y(20.8));
            w = QUOTE(POS_W(5.5));
            colorBackground[] = {0.6, 0.12, 0.12, 1};
        };
        class StartLabel: zmp_RscLabel {
            text = "$STR_ZMP_StartAt";
            x = QUOTE(POS_X(25));
            y = QUOTE(POS_Y(20.85));
            w = QUOTE(POS_W(4.5));
        };
        class Start: zmp_RscEdit {
            idc = IDC_ZMP_START;
            text = "0";
            tooltip = "$STR_ZMP_StartAtTooltip";
            x = QUOTE(POS_X(29.6));
            y = QUOTE(POS_Y(20.85));
            w = QUOTE(POS_W(2.4));
        };

        // ---- 行 8：淡入淡出 ----
        class FadeTimeLabel: zmp_RscLabel {
            text = "$STR_ZMP_FadeTime";
            x = QUOTE(POS_X(1.5));
            y = QUOTE(POS_Y(22.15));
            w = QUOTE(POS_W(5));
        };
        class FadeTime: zmp_RscEdit {
            idc = IDC_ZMP_FADE_TIME;
            tooltip = "$STR_ZMP_FadeTimeTooltip";
            x = QUOTE(POS_X(6.5));
            y = QUOTE(POS_Y(22.15));
            w = QUOTE(POS_W(2.5));
        };
        class VolumeLabel: zmp_RscLabel {
            text = "$STR_ZMP_Volume";
            x = QUOTE(POS_X(9.1));
            y = QUOTE(POS_Y(22.15));
            w = QUOTE(POS_W(5.5));
        };
        class Volume: zmp_RscEdit {
            idc = IDC_ZMP_VOLUME;
            tooltip = "$STR_ZMP_VolumeTooltip";
            x = QUOTE(POS_X(14.6));
            y = QUOTE(POS_Y(22.15));
            w = QUOTE(POS_W(2.5));
        };
        class FadeInPlay: zmp_RscButton {
            idc = IDC_ZMP_FADE_IN_PLAY;
            text = "$STR_ZMP_FadeInPlay";
            tooltip = "$STR_ZMP_FadeInPlayTooltip";
            x = QUOTE(POS_X(17.4));
            y = QUOTE(POS_Y(22.1));
            w = QUOTE(POS_W(6.8));
        };
        class FadeOutStop: zmp_RscButton {
            idc = IDC_ZMP_FADE_OUT_STOP;
            text = "$STR_ZMP_FadeOutStop";
            tooltip = "$STR_ZMP_FadeOutStopTooltip";
            x = QUOTE(POS_X(24.4));
            y = QUOTE(POS_Y(22.1));
            w = QUOTE(POS_W(6.8));
        };
        class FadeApply: zmp_RscButton {
            idc = IDC_ZMP_FADE_APPLY;
            text = "$STR_ZMP_FadeApply";
            tooltip = "$STR_ZMP_FadeApplyTooltip";
            x = QUOTE(POS_X(31.4));
            y = QUOTE(POS_Y(22.1));
            w = QUOTE(POS_W(7.1));
        };

        // ---- 行 9：提示 ----
        class Hint: ctrlStructuredText {
            idc = IDC_ZMP_HINT;
            size = TEXT_SIZE_SMALL;
            x = QUOTE(POS_X(1.5));
            y = QUOTE(POS_Y(23.3));
            w = QUOTE(POS_W(37));
            h = QUOTE(POS_H(1.15));
            colorBackground[] = {0, 0, 0, 0};
        };
    };
};
