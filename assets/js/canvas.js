"use strict";

export default class Canvas {
  constructor(node, player, players) {
    this.canvas = node
    this.context = this.canvas.getContext("2d")

    this.player = player
    this.players = players

    this.animationFrameId = undefined

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

    this.draw()
  }

  clear() {
    console.log("clear")

    this.canvas.width = this.canvas.width // clears the canvas
    // this.context.translate(this.canvas.width / 2, this.canvas.height / 2)
  }

  draw() {
    console.log("draw")

    this.clear()

    this.drawPlayer()
    this.drawPlayers()
  }

  drawPlayer() {
    console.log("drawPlayer")

    const playerImg = new Image();
    playerImg.src = "./images/player.png"
    playerImg.onload = () => {
      this.context.drawImage(playerImg, 100, 100, 100, 100);
    }

    let halfHeight = this.canvas.height / 2
    let halfWidth = this.canvas.width / 2
    let smallerHalf = Math.min(halfHeight, halfWidth)

    // this.context.clearRect(0, 0, this.canvas.width, this.canvas.height)
    this.context.fillStyle = "rgba(128, 0, 255, 0.5)"
    this.context.beginPath()
    this.context.arc(
      halfWidth,
      halfHeight,
      smallerHalf / 16,
      0,
      2 * Math.PI
    )
    this.context.fill()
  }

  drawPlayers() {
    console.log("drawPlayers")

    // this.players.map()
  }
}
