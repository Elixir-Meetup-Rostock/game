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
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import { Socket } from "phoenix"
import { LiveSocket } from "phoenix_live_view"
import topbar from "../vendor/topbar"

import Canvas from "./canvas"

let hooks = {}

hooks.cursorMove = {
  mounted() {
    document.addEventListener("mousemove", (e) => {
      const x = (e.pageX / window.innerWidth) * 100; // in %
      const y = (e.pageY / window.innerHeight) * 100; // in %
      this.pushEvent("cursor-move", { x, y });
    })
  }
}

hooks.gameCanvas = {
  mounted() {
    this.j = 0

    const node = this.el
    const projectiles = JSON.parse(node.dataset.projectiles);
    const player = JSON.parse(node.dataset.player);
    const players = JSON.parse(node.dataset.players);

    this.canvas = new Canvas(node, projectiles, player, players)
  },
  updated() {
    this.j++;
    if (this.j % 5 === 0) {
      this.j = 0;
      let now = performance.now();
      this.canvas.ups = 1 / ((now - (this.upsNow || now)) / 5000);
      this.upsNow = now;
    }

    const node = this.el
    const projectiles = JSON.parse(node.dataset.projectiles);
    const player = JSON.parse(node.dataset.player);
    const players = JSON.parse(node.dataset.players);

    this.canvas.setProjectiles(projectiles)
    this.canvas.setPlayers(player, players)
    this.canvas.drawFrame()
  }
}

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {
  hooks: hooks,
  params: { _csrf_token: csrfToken },
  metadata: {
    click: (e, el) => {
      return {
        altKey: e.altKey,
        clientX: e.clientX,
        clientY: e.clientY
      }
    },
    keydown: (e, el) => {
      return {
        key: e.key,
        metaKey: e.metaKey,
        repeat: e.repeat
      }
    }
  }
})

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" })
window.addEventListener("phx:page-loading-start", _info => topbar.show(300))
window.addEventListener("phx:page-loading-stop", _info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

