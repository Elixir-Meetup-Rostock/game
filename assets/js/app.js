// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html";
// Establish Phoenix Socket and LiveView configuration.
import { Socket } from "phoenix";
import { LiveSocket } from "phoenix_live_view";
import topbar from "../vendor/topbar";

import Board from "./board";
import Sprites from "./sprites";

import MapEditor from "./map_editor/editor";

let hooks = {};

hooks.cursorMove = {
	mounted() {
		document.addEventListener("mousemove", (e) => {
			const x = (e.pageX / window.innerWidth) * 100; // in %
			const y = (e.pageY / window.innerHeight) * 100; // in %
			this.pushEvent("cursor-move", { x, y });
		});
	},
};

hooks.gameAssets = {
	mounted() {
		const onSpritesLoaded = (sprites) => {
			window.sprites = sprites;

			this.pushEvent("assets_loaded");
		};

		const node = this.el;
		const sprites = JSON.parse(node.dataset.sprites);
		const tiles = JSON.parse(node.dataset.tiles);

		new Sprites(sprites, onSpritesLoaded);

		// tiles.map(({ tile }) => {
		// console.log(tile)
		// const tile = new Tile(sprite, this.tileSize, sprite_x, sprite_y)
		// })
	},
};

hooks.gameDraw = {
	mounted() {
		this.j = 0;

		const node = this.el;
		const board = JSON.parse(node.dataset.board);
		const projectiles = JSON.parse(node.dataset.projectiles);
		const player = JSON.parse(node.dataset.player);
		const players = JSON.parse(node.dataset.players);

		this.board = new Board(
			node,
			window.sprites,
			board,
			projectiles,
			player,
			players
		);
	},
	updated() {
		this.j++;
		if (this.j % 5 === 0) {
			this.j = 0;
			let now = performance.now();
			this.board.ups = 1 / ((now - (this.upsNow || now)) / 5000);
			this.upsNow = now;
		}

		const node = this.el;
		// const board = JSON.parse(node.dataset.board)
		const projectiles = JSON.parse(node.dataset.projectiles);
		const player = JSON.parse(node.dataset.player);
		const players = JSON.parse(node.dataset.players);

		this.board.setProjectiles(projectiles);
		this.board.setPlayers(player, players);
		this.board.drawFrame();
	},
};

hooks.mapEditor = {
	mounted() {
		const node = this.el;

		const bottomLayer = JSON.parse(node.dataset.bottom_layer);
		const topLayer = JSON.parse(node.dataset.top_layer);
		const activeLayer = JSON.parse(node.dataset.active_layer);

		const availableTiles = JSON.parse(node.dataset.available_tiles);

		this.mapEditor = new MapEditor(
			this,
			node,
			availableTiles,
			bottomLayer,
			topLayer,
			activeLayer
		);
	},
	updated() {
		const node = this.el;

		// const bottomLayer = JSON.parse(node.dataset.bottom_layer);
		// const topLayer = JSON.parse(node.dataset.top_layer);
		const activeLayer = JSON.parse(node.dataset.active_layer);

		const selectedTile = JSON.parse(node.dataset.selected_tile);

		// const availableTiles = JSON.parse(node.dataset.availableTiles);

		// this.mapEditor.setBottomLayer(bottomLayer);
		// this.mapEditor.setTopLayer(topLayer);
		this.mapEditor.setActiveLayer(activeLayer);
		this.mapEditor.setSelectedTile(selectedTile);

		this.mapEditor.drawFrame();
	},
};

let csrfToken = document
	.querySelector("meta[name='csrf-token']")
	.getAttribute("content");
let liveSocket = new LiveSocket("/live", Socket, {
	hooks: hooks,
	params: { _csrf_token: csrfToken },
	metadata: {
		click: (e, el) => {
			const centerX = Math.round(e.target.width / 2);
			const centerY = Math.round(e.target.height / 2);

			return {
				altKey: e.altKey,
				xPos: e.offsetX - centerX,
				yPos: e.offsetY - centerY,
			};
		},
		keydown: (e, el) => {
			return {
				key: e.key,
				metaKey: e.metaKey,
				repeat: e.repeat,
			};
		},
	},
});

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" });
window.addEventListener("phx:page-loading-start", (_info) => topbar.show(300));
window.addEventListener("phx:page-loading-stop", (_info) => topbar.hide());

// connect if there are any LiveViews on the page
liveSocket.connect();

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket;
