require('catppuccin').setup({
		transparent_background = false,
		term_colors = false,
		styles = {
			comments = "italic",
			functions = "italic",
			keywords = "italic",
			strings = "NONE",
			variables = "NONE",
		},
		integrations = {
			treesitter = true, native_lsp = {
				enabled = true,
				virtual_text = {
					errors = "italic",
					hints = "italic",
					warnings = "italic",
					information = "italic",
				},
				underlines = { errors = "underline", hints = "underline", warnings = "underline",
					information = "underline",
				},
			},
			lsp_trouble = false,
			lsp_saga = false,
			gitgutter = false,
			gitsigns = true,
			telescope = false,
			nvimtree = {
				enabled = false,
				show_root = false,
			},
			which_key = true,
			indent_blankline = {
				enabled = true,
				colored_indent_levels = false,
			},
			dashboard = true,
			neogit = false,
			vim_sneak = false,
			fern = false,
			barbar = false,
			bufferline = true,
			markdown = false,
			lightspeed = true,
			ts_rainbow = true,
			hop = false,
		},
	}
)


