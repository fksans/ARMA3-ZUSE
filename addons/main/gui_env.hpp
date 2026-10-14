// Zeus Music Player - 时间 / 天气过渡界面
// 控件基类见 gui.hpp

// 配置里不能写 "2060 + 0" 这样的表达式，idc 用拼接得到：
// 勾选框 206x = IDC_ZMP_ENV_WEATHER_CHECK + x，输入框 207x = IDC_ZMP_ENV_WEATHER_EDIT + x
#define ENV_WEATHER_ROW(INDEX,NAME,COL,ROW_Y) \
    class WeatherCheck##INDEX: ctrlCheckbox { \
        idc = 206##INDEX; \
        tooltip = "$STR_ZMP_EnvWeatherCheckTooltip"; \
        x = QUOTE(POS_X(5.5 + COL * 9.8)); \
        y = QUOTE(POS_Y(ROW_Y)); \
        w = QUOTE(POS_W(1)); \
        h = QUOTE(POS_H(1)); \
    }; \
    class WeatherLabel##INDEX: zmp_RscText { \
        text = NAME; \
        x = QUOTE(POS_X(6.6 + COL * 9.8)); \
        y = QUOTE(POS_Y(ROW_Y)); \
        w = QUOTE(POS_W(4.4)); \
    }; \
    class WeatherEdit##INDEX: zmp_RscEdit { \
        idc = 207##INDEX; \
        tooltip = "$STR_ZMP_EnvWeatherValueTooltip"; \
        x = QUOTE(POS_X(11.1 + COL * 9.8)); \
        y = QUOTE(POS_Y(ROW_Y)); \
        w = QUOTE(POS_W(3)); \
    }

// 窗口左上角 (5, 4)，宽 30
class zmp_envDisplay {
    idd = IDD_ZMP_ENV;
    movingEnable = 1;
    enableSimulation = 1;
    onLoad = "call zmp_fnc_env_ui_onLoad";
    onUnload = "call zmp_fnc_env_ui_onUnload";

    class ControlsBackground {
        class Background: ctrlStaticBackground {
            x = QUOTE(POS_X(5));
            y = QUOTE(POS_Y(5));
            w = QUOTE(POS_W(30));
            h = QUOTE(POS_H(13.2));
            colorBackground[] = {0.08, 0.08, 0.08, 0.95};
        };
    };

    class Controls {
        class Title: ctrlStaticTitle {
            moving = 1;
            text = "$STR_ZMP_EnvTitle";
            sizeEx = TEXT_SIZE;
            x = QUOTE(POS_X(5));
            y = QUOTE(POS_Y(4));
            w = QUOTE(POS_W(30));
            h = QUOTE(POS_H(1));
        };
        class Status: zmp_RscText {
            idc = IDC_ZMP_ENV_STATUS;
            style = 1;
            sizeEx = TEXT_SIZE_SMALL;
            colorText[] = {1, 0.85, 0.4, 1};
            x = QUOTE(POS_X(13));
            y = QUOTE(POS_Y(4));
            w = QUOTE(POS_W(20.8));
        };
        class Close: zmp_RscButton {
            idc = IDC_ZMP_ENV_CLOSE;
            text = "X";
            tooltip = "$STR_ZMP_Close";
            x = QUOTE(POS_X(33.9));
            y = QUOTE(POS_Y(4));
            w = QUOTE(POS_W(1.1));
            h = QUOTE(POS_H(1));
            colorBackground[] = {0, 0, 0, 0};
        };

        // ---- 行 1：现在的时间 / 天气 / 过渡进度 ----
        class Current: zmp_RscText {
            idc = IDC_ZMP_ENV_CURRENT;
            sizeEx = TEXT_SIZE_SMALL;
            x = QUOTE(POS_X(5.5));
            y = QUOTE(POS_Y(5.3));
            w = QUOTE(POS_W(29));
            colorBackground[] = {0, 0, 0, 0.5};
            colorText[] = {0.55, 0.85, 1, 1};
        };

        // ---- 行 2：方式 + 预览 ----
        class Mode: ctrlToolbox {
            idc = IDC_ZMP_ENV_MODE;
            sizeEx = TEXT_SIZE;
            rows = 1;
            columns = 2;
            strings[] = {"$STR_ZMP_EnvModeTarget", "$STR_ZMP_EnvModeSkip"};
            tooltips[] = {"$STR_ZMP_EnvModeTargetTooltip", "$STR_ZMP_EnvModeSkipTooltip"};
            x = QUOTE(POS_X(5.5));
            y = QUOTE(POS_Y(6.6));
            w = QUOTE(POS_W(12));
            h = QUOTE(POS_H(1.1));
        };
        class Preview: zmp_RscText {
            idc = IDC_ZMP_ENV_PREVIEW;
            colorText[] = {1, 0.85, 0.4, 1};
            x = QUOTE(POS_X(17.8));
            y = QUOTE(POS_Y(6.65));
            w = QUOTE(POS_W(16.7));
        };

        // ---- 行 3：目标时间 / 快捷时间 / 前进小时数 ----
        class TargetTimeLabel: zmp_RscLabel {
            text = "$STR_ZMP_EnvTargetTime";
            x = QUOTE(POS_X(5.5));
            y = QUOTE(POS_Y(7.95));
            w = QUOTE(POS_W(3.6));
        };
        class TargetTime: zmp_RscEdit {
            idc = IDC_ZMP_ENV_TARGET_TIME;
            tooltip = "$STR_ZMP_EnvTargetTimeTooltip";
            x = QUOTE(POS_X(9.1));
            y = QUOTE(POS_Y(7.95));
            w = QUOTE(POS_W(3));
        };
        class Sunrise: zmp_RscButton {
            idc = IDC_ZMP_ENV_SUNRISE;
            text = "$STR_ZMP_EnvSunrise";
            tooltip = "$STR_ZMP_EnvSunriseTooltip";
            x = QUOTE(POS_X(12.4));
            y = QUOTE(POS_Y(7.9));
            w = QUOTE(POS_W(3));
        };
        class Noon: zmp_RscButton {
            idc = IDC_ZMP_ENV_NOON;
            text = "$STR_ZMP_EnvNoon";
            x = QUOTE(POS_X(15.5));
            y = QUOTE(POS_Y(7.9));
            w = QUOTE(POS_W(3));
        };
        class Sunset: zmp_RscButton {
            idc = IDC_ZMP_ENV_SUNSET;
            text = "$STR_ZMP_EnvSunset";
            tooltip = "$STR_ZMP_EnvSunsetTooltip";
            x = QUOTE(POS_X(18.6));
            y = QUOTE(POS_Y(7.9));
            w = QUOTE(POS_W(3));
        };
        class Midnight: zmp_RscButton {
            idc = IDC_ZMP_ENV_MIDNIGHT;
            text = "$STR_ZMP_EnvMidnight";
            x = QUOTE(POS_X(21.7));
            y = QUOTE(POS_Y(7.9));
            w = QUOTE(POS_W(3));
        };
        class SkipHoursLabel: zmp_RscLabel {
            text = "$STR_ZMP_EnvSkipHours";
            x = QUOTE(POS_X(24.8));
            y = QUOTE(POS_Y(7.95));
            w = QUOTE(POS_W(6.4));
        };
        class SkipHours: zmp_RscEdit {
            idc = IDC_ZMP_ENV_SKIP_HOURS;
            tooltip = "$STR_ZMP_EnvSkipHoursTooltip";
            x = QUOTE(POS_X(31.3));
            y = QUOTE(POS_Y(7.95));
            w = QUOTE(POS_W(3.2));
        };

        // ---- 行 4：过渡时长 / 曲线 ----
        class DurationLabel: zmp_RscLabel {
            text = "$STR_ZMP_EnvDuration";
            x = QUOTE(POS_X(5.5));
            y = QUOTE(POS_Y(9.25));
            w = QUOTE(POS_W(6));
        };
        class Duration: zmp_RscEdit {
            idc = IDC_ZMP_ENV_DURATION;
            tooltip = "$STR_ZMP_EnvDurationTooltip";
            x = QUOTE(POS_X(11.5));
            y = QUOTE(POS_Y(9.25));
            w = QUOTE(POS_W(3));
        };
        class EaseLabel: zmp_RscLabel {
            text = "$STR_ZMP_EnvEase";
            x = QUOTE(POS_X(14.8));
            y = QUOTE(POS_Y(9.25));
            w = QUOTE(POS_W(3));
        };
        class Ease: zmp_RscCombo {
            idc = IDC_ZMP_ENV_EASE;
            tooltip = "$STR_ZMP_EnvEaseTooltip";
            x = QUOTE(POS_X(17.8));
            y = QUOTE(POS_Y(9.25));
            w = QUOTE(POS_W(6));
        };

        // ---- 行 5：天气标题 / 预设 / 读取当前 ----
        class WeatherTitle: zmp_RscText {
            text = "$STR_ZMP_EnvWeatherTitle";
            tooltip = "$STR_ZMP_EnvWeatherTitleTooltip";
            colorText[] = {0.8, 0.8, 0.8, 1};
            x = QUOTE(POS_X(5.5));
            y = QUOTE(POS_Y(10.6));
            w = QUOTE(POS_W(13.5));
        };
        class WeatherPresetLabel: zmp_RscLabel {
            text = "$STR_ZMP_EnvWeatherPreset";
            x = QUOTE(POS_X(19));
            y = QUOTE(POS_Y(10.6));
            w = QUOTE(POS_W(2.6));
        };
        class WeatherPreset: zmp_RscCombo {
            idc = IDC_ZMP_ENV_WEATHER_PRESET;
            tooltip = "$STR_ZMP_EnvWeatherPresetTooltip";
            x = QUOTE(POS_X(21.6));
            y = QUOTE(POS_Y(10.6));
            w = QUOTE(POS_W(7));
        };
        class ReadWeather: zmp_RscButton {
            idc = IDC_ZMP_ENV_READ_WEATHER;
            text = "$STR_ZMP_EnvReadWeather";
            tooltip = "$STR_ZMP_EnvReadWeatherTooltip";
            x = QUOTE(POS_X(28.8));
            y = QUOTE(POS_Y(10.55));
            w = QUOTE(POS_W(5.7));
        };

        // ---- 行 6、7：天气项（勾选 = 这一项参与过渡） ----
        ENV_WEATHER_ROW(0,"$STR_ZMP_EnvOvercast",0,11.9);
        ENV_WEATHER_ROW(1,"$STR_ZMP_EnvFog",1,11.9);
        ENV_WEATHER_ROW(2,"$STR_ZMP_EnvRain",2,11.9);
        ENV_WEATHER_ROW(3,"$STR_ZMP_EnvWind",0,13.2);
        ENV_WEATHER_ROW(4,"$STR_ZMP_EnvLightnings",1,13.2);
        ENV_WEATHER_ROW(5,"$STR_ZMP_EnvWaves",2,13.2);

        // ---- 行 8：提示 ----
        class Hint: ctrlStructuredText {
            idc = IDC_ZMP_ENV_HINT;
            size = TEXT_SIZE_SMALL;
            x = QUOTE(POS_X(5.5));
            y = QUOTE(POS_Y(14.5));
            w = QUOTE(POS_W(29));
            h = QUOTE(POS_H(2.1));
            colorBackground[] = {0, 0, 0, 0};
        };

        // ---- 行 9：开始 / 停止 ----
        class Start: zmp_RscButton {
            idc = IDC_ZMP_ENV_START;
            text = "$STR_ZMP_EnvStart";
            tooltip = "$STR_ZMP_EnvStartTooltip";
            x = QUOTE(POS_X(5.5));
            y = QUOTE(POS_Y(16.8));
            w = QUOTE(POS_W(14.3));
            colorBackground[] = {0.75, 0.45, 0.05, 1};
        };
        class Stop: zmp_RscButton {
            idc = IDC_ZMP_ENV_STOP;
            text = "$STR_ZMP_EnvStop";
            tooltip = "$STR_ZMP_EnvStopTooltip";
            x = QUOTE(POS_X(20.2));
            y = QUOTE(POS_Y(16.8));
            w = QUOTE(POS_W(14.3));
            colorBackground[] = {0.6, 0.12, 0.12, 1};
        };
    };
};
