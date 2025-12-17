return {
	STATES = {
		UNLOADED = "UNLOADED",
		LOADING = "LOADING",
		HIDE = "HIDE", --scene is loaded.But not showing on screen
		PAUSED = "PAUSED", --scene is showing.But update not called.
		RUNNING = "RUNNING", --scene is running
	},
	TRANSITIONS = {
		ON_HIDE = "ON_HIDE",
		ON_SHOW = "ON_SHOW",
	}
}
