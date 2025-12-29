local M = {}

M.GAME_ID = "d954mas_christmas_2025_3d"

M.SYSTEM_INFO = sys.get_sys_info({ignore_secure = true})
M.PLATFORM = M.SYSTEM_INFO.system_name
M.PLATFORM_IS_WEB = M.PLATFORM == "HTML5"
M.PLATFORM_IS_WINDOWS = M.PLATFORM == "Windows"
M.PLATFORM_IS_LINUX = M.PLATFORM == "Linux"
M.PLATFORM_IS_MACOS = M.PLATFORM == "Darwin"
M.PLATFORM_IS_ANDROID = M.PLATFORM == "Android"
M.PLATFORM_IS_IPHONE = M.PLATFORM == "iPhone OS"

M.PLATFORM_IS_PC = M.PLATFORM_IS_WINDOWS or M.PLATFORM_IS_LINUX or M.PLATFORM_IS_MACOS
M.PLATFORM_IS_MOBILE = M.PLATFORM_IS_ANDROID or M.PLATFORM_IS_IPHONE

M.PROJECT_VERSION = sys.get_config_string("project.version")
M.GAME_VERSION = sys.get_config_string("game.version")

M.VERSION_IS_DEV = M.GAME_VERSION == "dev"
M.VERSION_IS_RELEASE = M.GAME_VERSION == "release"

M.GAME_TARGET = sys.get_config_string("game.target")

M.TARGETS = {
	EDITOR = "EDITOR",
	OTHER = "OTHER",
	PLAY_MARKET = "PLAY_MARKET",
	POKI = "POKI",
}

assert(M.TARGETS[M.GAME_TARGET], "unknown target:" .. M.GAME_TARGET)

M.TARGET_IS_EDITOR = M.GAME_TARGET == M.TARGETS.EDITOR
M.TARGET_IS_PLAY_MARKET = M.GAME_TARGET == M.TARGETS.PLAY_MARKET
M.TARGET_IS_POKI = M.GAME_TARGET == M.TARGETS.POKI
M.TARGET_OTHER = M.GAME_TARGET == M.TARGETS.OTHER

M.CRYPTO_KEY = "7soAwsBXY9"

M.GUI_ORDER = {
	GAME = 3,
	MODAL = 4,
	TOP_PANEL = 5,
	SETTINGS = 6,
	DEBUG = 15,
}

M.COLORS = {
	EMPTY = vmath.vector4(1,1,1,0),
	WHITE = vmath.vector4(1,1,1,1),
}

M.EASYMONETIZATION = {
	TEST = {
		banner       = 'demo-banner-yandex',
		interstitial = 'demo-interstitial-yandex',
		rewarded     = 'demo-rewarded-yandex'
	},
	RELEASE = {
		banner       = 'demo-banner-yandex',
		interstitial = 'demo-interstitial-yandex',
		rewarded     = 'demo-rewarded-yandex'
	}
}



M.IS_MOBILE_DEVICE = M.PLATFORM_IS_MOBILE
if html_utils then
	M.IS_MOBILE_DEVICE = html_utils.is_mobile()
end



return M
