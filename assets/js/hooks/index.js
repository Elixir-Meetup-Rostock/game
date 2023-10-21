"use strict";

import Board from "./board"
import Sprites from "./sprites"

import MapEditor from "./map_editor"

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
      this.board.draw()
    }
  },
  mapEditor: {
    mounted() {
      const node = this.el

      const bottomLayer = JSON.parse(node.dataset.bottom_layer)
      const topLayer = JSON.parse(node.dataset.top_layer)
      const activeLayer = JSON.parse(node.dataset.active_layer)
      const availableTiles = JSON.parse(node.dataset.available_tiles)

      this.mapEditor = new MapEditor(this, node, availableTiles, bottomLayer, topLayer, activeLayer)
    },
    updated() {
      const node = this.el

      const activeLayer = JSON.parse(node.dataset.active_layer)
      const selectedTile = JSON.parse(node.dataset.selected_tile)

      this.mapEditor.setActiveLayer(activeLayer)
      this.mapEditor.setSelectedTile(selectedTile)
      this.mapEditor.drawFrame()
    },
  }
}
