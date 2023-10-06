"use strict";

import Board from "./board"
import Sprites from "./sprites"
// import Tile from "./board/tile"

export const Hooks = {
  gameSprites: {
    mounted() {
      const node = this.el
      const sprites = JSON.parse(node.dataset.sprites)

      new Sprites(sprites, (loaded_sprites) => {
        window.sprites = loaded_sprites
        this.pushEvent("sprites_loaded")
      })
    }
  },
  gameDraw: {
    mounted() {
      const node = this.el
      const layers = JSON.parse(node.dataset.layers)
      const player = JSON.parse(node.dataset.player)

      this.board = new Board(node, window.sprites, layers, player)
    },
    updated() {
      const node = this.el
      const layers = JSON.parse(node.dataset.layers)
      const player = JSON.parse(node.dataset.player)

      this.board.setLayers(layers)
      this.board.setPlayer(player)
      this.board.drawFrame()
    }
  }
};
