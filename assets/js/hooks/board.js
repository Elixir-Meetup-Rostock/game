"use strict";

// import Projectile from "./board/projectile"
// import Tile from "./board/tile"

export default class Board {
  constructor(node, sprites, layers, player) {
    this.maxFps = 25

    this.zoom = 2

    this.canvas = node
    this.context = this.canvas.getContext("2d")

    this.sprites = sprites

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
    this.context.font = "10pt monospace"
    this.context.fillStyle = "#dddddd"
    this.context.beginPath()
    this.context.rect(10, 70, 140, 30)
    this.context.fill()
    this.context.fillStyle = "black"
    this.context.fillText(`Client FPS: ${Math.round(this.fps)}`, 20, 78)
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

    this.draw()
  }

  clear() {
    this.canvas.width = this.canvas.width // clears the canvas

    // this.context.translate(this.canvas.width / 2, this.canvas.height / 2)
    // this.context.clearRect(0, 0, this.canvas.width, this.canvas.height)
  }

  draw() {
    if (this.animationFrameId) {
      window.cancelAnimationFrame(this.animationFrameId)
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
      const xPos = this.halfWidth - this.player.x + x
      const yPos = this.halfHeight - this.player.y + y

      // TODO: add this.zoom to the drawing
      this.context.drawImage(this.sprites[sprite], 0, 0, size, size, xPos, yPos, size, size)
    })
  }

  drawPlayer({ id, sprite, size, frames }) {
    const xPos = this.halfWidth - (size / 2)
    const yPos = this.halfHeight - (size / 2)


    // TODO: add this.zoom to the drawing
    this.context.drawImage(this.sprites[sprite], 0, 0, size, size, xPos, yPos, size, size)
  }
}
