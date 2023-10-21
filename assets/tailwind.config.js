// See the Tailwind configuration guide for advanced usage
// https://tailwindcss.com/docs/configuration

const plugin = require("tailwindcss/plugin");
const fs = require("fs");
const path = require("path");

module.exports = {
	content: ["./js/**/*.js", "../lib/*_web.ex", "../lib/*_web/**/*.*ex"],
	theme: {
		extend: {
			colors: {
				brand: "#FD4F00",

				gray: "#242932",
				"gray-light": "#3A404B",
				blue: "#2F3B8B",
				"blue-light": "#747FC9",
				"green-vibrant": "#5FBA42",
			},
			boxShadow: {
				hard: "8px 8px 0px 0px",
			},
			fontFamily: {
				PressStart2P: ["PressStart2P", "sans-serif"],
			},
		},
	},
	plugins: [
		require("@tailwindcss/forms"),
		// Allows prefixing tailwind classes with LiveView classes to add rules
		// only when LiveView classes are applied, for example:
		//
		//     <div class="phx-click-loading:animate-ping">
		//
		plugin(({ addVariant }) =>
			addVariant("phx-no-feedback", [".phx-no-feedback&", ".phx-no-feedback &"])
		),
		plugin(({ addVariant }) =>
			addVariant("phx-click-loading", [
				".phx-click-loading&",
				".phx-click-loading &",
			])
		),
		plugin(({ addVariant }) =>
			addVariant("phx-submit-loading", [
				".phx-submit-loading&",
				".phx-submit-loading &",
			])
		),
		plugin(({ addVariant }) =>
			addVariant("phx-change-loading", [
				".phx-change-loading&",
				".phx-change-loading &",
			])
		),

		// Embeds Hero Icons (https://heroicons.com) into your app.css bundle
		// See your `CoreComponents.icon/1` for more information.
		//
		plugin(function ({ matchComponents, theme }) {
			let iconsDir = path.join(__dirname, "./vendor/heroicons/optimized");
			let values = {};
			let icons = [
				["", "/24/outline"],
				["-solid", "/24/solid"],
				["-mini", "/20/solid"],
			];
			icons.forEach(([suffix, dir]) => {
				fs.readdirSync(path.join(iconsDir, dir)).map((file) => {
					let name = path.basename(file, ".svg") + suffix;
					values[name] = { name, fullPath: path.join(iconsDir, dir, file) };
				});
			});
			matchComponents(
				{
					hero: ({ name, fullPath }) => {
						let content = fs
							.readFileSync(fullPath)
							.toString()
							.replace(/\r?\n|\r/g, "");
						return {
							[`--hero-${name}`]: `url('data:image/svg+xml;utf8,${content}')`,
							"-webkit-mask": `var(--hero-${name})`,
							mask: `var(--hero-${name})`,
							"background-color": "currentColor",
							"vertical-align": "middle",
							display: "inline-block",
							width: theme("spacing.5"),
							height: theme("spacing.5"),
						};
					},
				},
				{ values }
			);
		}),
	],
};
