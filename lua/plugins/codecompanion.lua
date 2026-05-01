return {
	"olimorris/codecompanion.nvim",
	version = "v17.33.0",
	dependencies = {
		"sameert89/dotenv.nvim",
	},
	config = function()
		local dotenv = require("dotenv")
		local adapters = require("codecompanion.adapters")

		require("codecompanion").setup({
			adapters = {
				http = {
					tavily = function()
						return adapters.extend("tavily", {
							env = {
								api_key = dotenv.get("TAVILY_API_KEY"),
							},
						})
					end,
					openai_gpt54mini = function()
						return adapters.extend("openai", {
							env = {
								api_key = dotenv.get("OPENAI_API_KEY"),
							},
							schema = {
								model = {
									default = "gpt-5.4mini",
								},
							},
						})
					end,
					openrouter_grok = function()
						return adapters.extend("openai_compatible", {
							env = {
								url = "https://openrouter.ai/api",
								api_key = dotenv.get("OPENROUTER_API_KEY"),
								chat_url = "/v1/chat/completions",
							},
							schema = {
								model = {
									default = "x-ai/grok-code-fast-1",
								},
							},
						})
					end,
				},
			},
			strategies = {
				chat = {
					adapter = "openai_gpt54mini",
				},
				inline = {
					adapter = "openai_gpt54mini",
				},
				cmd = {
					adapter = "openai_gpt54mini",
				},
			},
			display = {
				chat = {
					intro_message = "Hey! how can I help?",
					window = {
						layout = "vertical",
						height = 0.8,
						width = 0.25,
						position = "right",
					},
				},
			},
		})
	end,
}