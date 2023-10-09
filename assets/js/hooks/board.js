"use strict";

// import Projectile from "./board/projectile"
// import Tile from "./board/tile"

export default class Board {
  constructor(node, sprites, layers, player) {
    this.zoom = 2

    this.canvas = node
    this.context = this.canvas.getContext("2d")

    this.sprites = sprites

    this.layers = layers
    this.player = player

    this.animationFrameId = undefined

    window.addEventListener("resize", _e => { this.resize() })
    this.resize()
  }

  setLayers(layers) {
    this.layers = layers
  }

  setPlayer(player) {
    this.player = player
  }

  resize() {
    this.canvas.height = window.innerHeight
    this.canvas.width = window.innerWidth

    this.halfHeight = this.canvas.height / 2
    this.halfWidth = this.canvas.width / 2

    // this.canvas.width = window.innerWidth * this.zoom
    // this.canvas.height = window.innerHeight * this.zoom
    // this.canvas.style.width = `${window.innerWidth}px`
    // this.canvas.style.height = `${window.innerHeight}px`

    this.drawFrame()
  }

  clear() {
    this.canvas.width = this.canvas.width // clears the canvas

    // this.context.translate(this.canvas.width / 2, this.canvas.height / 2)
    // this.context.clearRect(0, 0, this.canvas.width, this.canvas.height)
  }

  drawFrame() {
    if (this.animationFrameId) {
      window.cancelAnimationFrame(this.animationFrameId)
    }

    this.animationFrameId = window.requestAnimationFrame(() => {
      this.draw()
    })
  }

  draw() {
    this.clear()

    this.layers.forEach(({ level, tiles }) => {
      if (level === 0) {
        this.drawPlayer(this.player)
      } else {
        this.drawLayer(tiles)
      }
    })
  }

  drawLayer(tiles) {
    tiles.map(({ x, y, size, sprite }) => {
      const xPos = this.halfWidth - this.player.x + x
      const yPos = this.halfHeight - this.player.y + y

      // TODO: add this.zoom to the drawing
      this.context.drawImage(this.sprites[sprite], 0, 0, size, size, xPos, yPos, size, size)
    })
  }

  drawPlayer({ size, sprite }) {
    const xPos = this.halfWidth - (size / 2)
    const yPos = this.halfHeight - (size / 2)

    const frame = 0

    // TODO: add this.zoom to the drawing
    this.context.drawImage(this.sprites[sprite], size * frame, 0, size, size, xPos, yPos, size, size)
  }
}
