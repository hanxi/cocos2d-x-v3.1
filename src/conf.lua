FONT_PATH = "res/fonts/baidu.ttf"
MUSIC_PATH = "res/music.mp3"
SOUND_JUMP_PATH = "res/jump_effect.wav"
SOUND_PONG_PATH = "res/pong_effect.wav"
SOUND_CLICK_PATH = "res/click_effect.wav"
UPDATE_PACK_PATH = "https://raw.githubusercontent.com/hanxi/runjump/master/package.zip"
UPDATE_VESION_PATH = "https://raw.githubusercontent.com/hanxi/runjump/master/version"

STR_GAME_NAME = "全民顶爆菊花"
STR_MO_SHI = "模式"
STR_BEST = "最佳 "

STR_NO_SHARE = "不分享"
STR_SHARE = "分享"
STR_SHARE_SCORE = "炫耀"
STR_BACK = "返回"
STR_AGAIN = "重来"
STR_CHOOSE_HERO = "选择基友"
STR_START = "开始"
STR_MSG = "消息"
STR_SECOND = "秒"
STR_CONFIRM = "确定"
STR_CANCEL = "取消"
STR_EXIT = "退出游戏"
STR_IS_EXIT = "确认退出游戏？"
STR_UPDATE_NOTICE = "需更新%s,已更新%d%%"
STR_UPDATE_MSG = "正在载入..."
STR_RANK = "爆菊花排行榜"
STR_RANK_T1 = "排名"
STR_RANK_T2 = "玩家名"
STR_RANK_T3 = "分数"

STR_SHARE_IMG = "share.png"
STR_SHARE_TITLE = "全民顶爆菊花"
STR_SHARE_DTITLE = "选择分享方式"
STR_SHARE_TXT = "下载地址： http://git.oschina.net/hanxi/runjumpdata/raw/master/rutodie-release-signed.apk 绝对火爆，绝对具有挑战力的新式小型休闲游戏。"

STR_MENUS = {
    "基童",
    "基士",
    "基佬",
    "基尊",
    "基仙",
}

STR_ADS_NOTICE = "<p><font color='#99FFFF'>如果您喜欢这个应用请点击</font><b><big>安装</big></b><font color='#99FFFF'>，谢谢您的支持。<br>如果不喜欢您可以点击右上角的关闭按钮或者返回键。</font></p>"
STR_BEST_SCORE_NOTICE = "<p><b><big>您已经打破自己的记录，赶紧向朋友们炫耀一下吧。（关闭广告后点击左下角的炫耀按钮即可）</big></b></p>"
STR_TIPS = {
    [1] = "<p><big><b>【Tips】：</b><br><font color='#99FFFF'>想成为基仙吗？挑战自己的极限吧！</font></big></p>",
    [2] = "<p><big><b>【Tips】：</b><br><font color='#99FFFF'>如何选择基友？点击对应的头像即可选中！</font></big></p>",
    [3] = "<p><big><b>【Tips】：</b><br><font color='#99FFFF'>如何控制跳跃速度？越靠近英雄跳跃速度越快，一般人我不告诉他！</font></big></p>",
    [4] = "<p><big><b>【Tips】：</b><br><font color='#99FFFF'>每次都突破了自己的记录，还不如跟好友一起分享，比比谁更厉害！</font></big></p>",
    [5] = "<p><big><b>【Tips】：</b><br><font color='#99FFFF'>如果您对该游戏有什么改进的想法，请用邮件联系hanxi.info@gmail.com</font></big></p>",
    [6] = "<p><big><b>【Tips】：</b><br><font color='#99FFFF'>注意啦！菊花飞过来的速度会越来越快的哦！</font></big></p>",
}

local currentLanguageType = cc.Application:getInstance():getCurrentLanguage()
if currentLanguageType ~= cc.LANGUAGE_CHINESE then
STR_GAME_NAME = "Crack Mum"
STR_MO_SHI = "Level"
STR_BEST = "Best "

STR_NO_SHARE = "Not share"
STR_SHARE = "Share"
STR_SHARE_SCORE = "Show"
STR_BACK = "Back"
STR_AGAIN = "Again"
STR_CHOOSE_HERO = "Select Hero"
STR_START = "Start"
STR_MSG = "MSG"
STR_SECOND = "''"
STR_CONFIRM = "Yes"
STR_CANCEL = "No"
STR_EXIT = "Exit Game"
STR_IS_EXIT = "Are you sure to exit？"
STR_UPDATE_NOTICE = "Need update %s, alreade update %d%%"
STR_UPDATE_MSG = "Loading..."
STR_RANK = "Crack Rank"

STR_SHARE_IMG = "share.png"
STR_SHARE_TITLE = "Crack Chrysanthemum"
STR_SHARE_DTITLE = "Select Share Mode"
STR_SHARE_TXT = "Download address: http://git.oschina.net/hanxi/runjumpdata/raw/master/rutodie-release-signed.apk . Definitely, definitely has the challenge of the new small casual games."

STR_MENUS = {
    "One",
    "Two",
    "Three",
    "Four",
    "Five",
}
end
