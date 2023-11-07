"use strict";

// import Projectile from "./board/projectile"
import Tile from "./board/tile"

export default class Board {
  constructor(node, sprites, layers, player) {
    this.maxFps = 25

    this.zoom = 3

    this.canvas = node
    this.context = this.canvas.getContext("2d")

    this.sprites = sprites

    this.tiles = {}

    this.layers = layers
    this.player = player

    this.animationFrameId = undefined

    window.addEventListener("resize", _e => { this.resize() })
    this.resize()

    setInterval(this.draw.bind(this), 1000 / this.maxFps)

    this.i = 0
    this.fps = 0
  }

  drawFps() {
    this.i++;
    if (this.i % 5 === 0) {
      this.i = 0
      let now = performance.now()
      this.fps = 1 / ((now - (this.fpsNow || now)) / 5000)
      this.fpsNow = now
    }

    this.context.textBaseline = "top"
    this.context.font = "5pt monospace"
    this.context.fillStyle = "#dddddd"
    this.context.beginPath()
    this.context.rect(-50, -50, 60, 12)
    this.context.fill()
    this.context.fillStyle = "black"
    this.context.fillText(`Client FPS: ${Math.round(this.fps)}`, -48, -48)
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

    this.draw()
  }

  clear() {
    this.canvas.width = this.canvas.width // clears the canvas

    this.context.imageSmoothingEnabled = false
    this.context.scale(this.zoom, this.zoom)
    this.context.translate(this.canvas.width / (2 * this.zoom), this.canvas.height / (2 * this.zoom))

    // this.context.clearRect(0, 0, this.canvas.width, this.canvas.height)
  }

  draw() {
    if (this.animationFrameId) {
      window.cancelAnimationFrame(this.animationFrameId)
    }

    for (let id in this.tiles) {
      this.tiles[id].tick()
    }

    this.animationFrameId = window.requestAnimationFrame(() => {
      this.drawFrame()
      this.drawFps()
    })
  }

  drawFrame() {
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
    tiles.map(({ id, x, y, sprite, size }) => {
      const xPos = -this.player.x + x - (size / 2)
      const yPos = -this.player.y + y - (size / 2)

      if (!this.tiles[id]) {
        this.tiles[id] = new Tile(this.sprites[sprite], size, frames)
      }

      this.context.drawImage(this.tiles[id].canvas, 0, 0, size, size, xPos, yPos, size, size)
    })
  }

  drawPlayer({ id, name, sprite, size, frames }) {
    const xPos = -(size / 2)
    const yPos = -(size / 2)

    if (!this.tiles[id]) {
      this.tiles[id] = new Tile(this.sprites[sprite], size, frames)
    }

    this.context.drawImage(this.tiles[id].canvas, 0, 0, size, size, xPos, yPos, size, size)

    this.drawLabel(0, (size / 2) + 1, name)
  }

  drawLabel(x, y, text) {
    this.context.font = "4px monospace"

    const padding = 4
    const boxWidth = this.context.measureText(text).width + padding

    this.context.fillStyle = "rgba(255,255,255,0.5)"
    this.context.beginPath()
    this.context.roundRect(x - (boxWidth / 2), y, boxWidth, 6, [8])
    this.context.fill()

    this.context.fillStyle = "rgba(0,0,0)"
    this.context.textAlign = "center"
    this.context.textBaseline = "top"
    this.context.fillText(text, x, y)
  }
}
