"use strict";

export default class Canvas {
  constructor(node, player, players) {
    this.log = false

    this.canvas = node
    this.context = this.canvas.getContext("2d")

    this.player = player
    this.players = players

    this.animationFrameId = undefined

    this.i = 0
    this.fps = 0
    this.ups = 0

    this.mapImg = new Image();
    this.mapImg.src = "./images/game_background.jpeg"
    this.mapImg.onload = () => {
      // loaded = true
    }

    this.playerImg = new Image();
    this.playerImg.src = "./images/player.png"
    this.playerImg.onload = () => {
      // loaded = true
    }

    window.addEventListener("resize", _e => { this.resize() })
    this.resize()
  }

  setPlayers(player, players) {
    this.player = player
    this.players = players
  }

  resize() {
    this.canvas.height = window.innerHeight
    this.canvas.width = window.innerWidth

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

    this.i++;
    if (this.i % 5 === 0) {
      this.i = 0;
      let now = performance.now();
      this.fps = 1 / ((now - (this.fpsNow || now)) / 5000);
      this.fpsNow = now;
    }

    this.clear()

    this.drawMap()
    this.drawPlayer()
    // this.drawPlayers()
  }

  drawMap() {
    this.context.drawImage(this.mapImg, 0, 0, this.canvas.width, this.canvas.height);
  }

  drawPlayer() {
    if (this.log) console.log("drawPlayer")

    const x = this.player.x + 100
    const y = this.player.y + 100

    this.context.drawImage(this.playerImg, x - 25, y - 25, 50, 50);

    // this.context.clearRect(0, 0, this.canvas.width, this.canvas.height)
    this.context.strokeStyle = "rgba(128, 0, 255, 0.5)"
    this.context.beginPath()
    this.context.arc(
      x,
      y,
      32,
      0,
      2 * Math.PI
    )
    this.context.stroke()

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

  drawPlayers() {
    if (this.log) console.log("drawPlayers")
  }
}
