"use strict";

import Board from "./board"
import Sprites from "./sprites"
import Tile from "./board/tile"

export const Hooks = {
  cursorMove: {
    mounted() {
      document.addEventListener("mousemove", (e) => {
        const x = (e.pageX / window.innerWidth) * 100 // in %
        const y = (e.pageY / window.innerHeight) * 100 // in %
        this.pushEvent("cursor-move", { x, y })
      })
    }
  },
  gameAssets: {
    mounted() {
      const onSpritesLoaded = (sprites) => {
        // sprites are loaded. now create tiles (and use the sprites).
        window.tiles = tiles.reduce((acc, { id, size, sprite }) => {
          return { ...acc, [id]: new Tile(sprites[sprite], size) }
        }, {})

        this.pushEvent("assets_loaded")
      }

      const node = this.el
      const sprites = JSON.parse(node.dataset.sprites)
      const tiles = JSON.parse(node.dataset.tiles)

      new Sprites(sprites, onSpritesLoaded)
    }
  },
  gameDraw: {
    mounted() {
      this.j = 0

      const node = this.el
      const board = JSON.parse(node.dataset.board)
      const projectiles = JSON.parse(node.dataset.projectiles)
      const player = JSON.parse(node.dataset.player)
      const players = JSON.parse(node.dataset.players)

      this.board = new Board(node, window.tiles, board, projectiles, player, players)
    },
    updated() {
      this.j++
      if (this.j % 5 === 0) {
        this.j = 0
        let now = performance.now()
        this.board.ups = 1 / ((now - (this.upsNow || now)) / 5000)
        this.upsNow = now
      }

      const node = this.el
      // const board = JSON.parse(node.dataset.board)
      const projectiles = JSON.parse(node.dataset.projectiles)
      const player = JSON.parse(node.dataset.player)
      const players = JSON.parse(node.dataset.players)

      this.board.setProjectiles(projectiles)
      this.board.setPlayers(player, players)
      this.board.drawFrame()
    }
  }
};
