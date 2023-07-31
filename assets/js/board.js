"use strict";

import Projectile from "./board/projectile"
import Tile from "./board/tile"

export default class Board {
  constructor(node, sprites, tiles, projectiles, player, players) {
    this.log = false

    this.tileSize = 32
    // this.tileSize = 16

    this.canvas = node
    this.context = this.canvas.getContext("2d")

    this.sprites = sprites

    this.tiles = tiles
    this.projectiles = projectiles
    this.player = player
    this.players = players

    this.animationFrameId = undefined

    this.i = 0
    this.fps = 0
    this.ups = 0

    window.addEventListener("resize", _e => { this.resize() })
    this.resize()
  }

  setProjectiles(projectiles) {
    this.projectiles = projectiles
  }

  setPlayers(player, players) {
    this.player = player
    this.players = players
  }

  resize() {
    this.canvas.height = window.innerHeight
    this.canvas.width = window.innerWidth

    this.halfHeight = this.canvas.height / 2
    this.halfWidth = this.canvas.width / 2

    // this.canvas.width = window.innerWidth * ratio
    // this.canvas.height = window.innerHeight * ratio
    // this.canvas.style.width = `${window.innerWidth}px`
    // this.canvas.style.height = `${window.innerHeight}px`

    this.drawFrame()
  }

  clear() {
    if (this.log) console.log("clear")

    this.canvas.width = this.canvas.width // clears the canvas

    // this.context.translate(this.canvas.width / 2, this.canvas.height / 2)
    // this.context.clearRect(0, 0, this.canvas.width, this.canvas.height)
  }

  drawFrame() {
    if (this.log) console.log("drawFrame")

    if (this.animationFrameId) {
      window.cancelAnimationFrame(this.animationFrameId);
    }

    this.animationFrameId = window.requestAnimationFrame(() => {
      this.draw()
    })
  }

  draw() {
    if (this.log) console.log("draw")

    this.clear()

    this.drawMap()
    this.drawPlayer()
    this.drawPlayers()
    this.drawProjectiles()
    this.drawFps()
  }

  drawMap() {
    if (this.log) console.log("drawMap")

    this.tiles.map(({ x, y, sprite_x, sprite_y }) => {
      const sprite = this.sprites["map"]
      const tile = new Tile(sprite, this.tileSize, sprite_x, sprite_y)

      const xPos = this.halfWidth - this.player.x + (x * this.tileSize)
      const yPos = this.halfHeight - this.player.y + (y * this.tileSize)

      this.context.drawImage(tile, xPos, yPos, this.tileSize, this.tileSize)
    })
  }

  drawPlayer() {
    if (this.log) console.log("drawPlayer")

    const xPos = this.halfWidth - (this.tileSize / 2)
    const yPos = this.halfHeight - (this.tileSize / 2)

    this.context.drawImage(this.sprites["player"], xPos, yPos, this.tileSize, this.tileSize)
  }

  drawPlayers() {
    if (this.log) console.log("drawPlayers")

    this.players.map((player) => { this.drawOtherPlayer(player) })
  }

  drawOtherPlayer({ x, y }) {
    if (this.log) console.log("drawOtherPlayer")

    const p_x = this.halfWidth - this.player.x + x
    const p_y = this.halfHeight - this.player.y + y

    const xPos = p_x - (this.tileSize / 2)
    const yPos = p_y - (this.tileSize / 2)

    this.context.drawImage(this.sprites["player"], xPos, yPos, this.tileSize, this.tileSize)
  }

  drawProjectiles() {
    if (this.log) console.log("drawProjectiles")

    this.projectiles.map(({ x, y }) => {
      const p_x = this.halfWidth - this.player.x + x
      const p_y = this.halfHeight - this.player.y + y

      const projectile = new Projectile(x, y)
      this.context.drawImage(projectile.canvas, p_x, p_y)
    })
  }

  drawFps() {
    this.i++;
    if (this.i % 5 === 0) {
      this.i = 0;
      let now = performance.now();
      this.fps = 1 / ((now - (this.fpsNow || now)) / 5000);
      this.fpsNow = now;
    }

    this.context.textBaseline = "top";
    this.context.font = "20pt monospace";
    this.context.fillStyle = "#dddddd";
    this.context.beginPath();
    this.context.rect(10, 100, 250, 80);
    this.context.fill();
    this.context.fillStyle = "black";
    this.context.fillText(`Client FPS: ${Math.round(this.fps)}`, 20, 110);
    this.context.fillText(`Server FPS: ${Math.round(this.ups)}`, 20, 140);
  }
}
