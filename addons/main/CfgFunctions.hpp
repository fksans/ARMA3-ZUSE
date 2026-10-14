class CfgFunctions {
    class PREFIX {
        tag = QUOTE(PREFIX);
        class main {
            file = "\z\zmp\addons\main\functions";
            // 入口 / 权限
            class canOpen {};
            class open {};
            // 曲库与收藏
            class getLibrary {};
            class getFavorites {};
            class setFavorite {};
            class removeFavorite {};
            class getGroups {};
            class setGroups {};
            class profileSave {};
            // 播放控制（全队只执行引擎命令，见 fn_broadcast）
            class broadcast {};
            class targetMatches {};
            class play {};
            class stop {};
            class fade {};
            class onMusicEvent {};
            // 自检
            class checkRemoteExec {};
            // 工具
            class formatTime {};
            // 界面
            class ui_action {};
            class ui_onLoad {};
            class ui_onUnload {};
            class ui_refreshList {};
            class ui_refreshGroups {};
            class ui_onSelect {};
            class ui_updateNowPlaying {};
            class ui_setStatus {};
            class ui_getSelected {};
            class ui_readPlaybackParams {};
            class ui_readTarget {};
            class ui_refreshTargets {};
        };
    };
};
