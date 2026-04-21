require("colorizer").setup({
	css = {
		rgb_fn = true,   -- rgb(255, 0, 0)
		hsl_fn = true,   -- hsl(120, 100%, 50%)
	},
	html = { mode = "foreground" },
	"javascript",
	"typescript",
}, {
	mode = "background", -- color as background
})
