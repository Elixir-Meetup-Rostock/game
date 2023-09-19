"use strict";

export default class Projectile {
  constructor(x, y) {
    this.x = x
    this.y = y

    this.canvas = document.createElement("canvas")
    this.canvas.width = 16
    this.canvas.height = 16

    this.context = this.canvas.getContext("2d")

    this.draw()
  }

  // setPosition(x, y) {
  //   this.x = x
  //   this.y = y
  // }

  draw() {
    // this.context.save()
    // this.context.restore()

    this.context.translate(this.canvas.width / 2, this.canvas.height / 2)

    this.context.beginPath()
    this.context.arc(0, 0, 8, 0, 2 * Math.PI, false)
    this.context.fillStyle = '#c42'
    this.context.fill()
  }
}
