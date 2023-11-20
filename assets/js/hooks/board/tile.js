"use strict";

export default class Tile {
  constructor(sprite, width, height, frames = 1) {
    this.sprite = sprite
    this.width = width
    this.height = height
    this.frames = frames
    this.frame = 0

    this.canvas = document.createElement("canvas")
    this.canvas.width = width
    this.canvas.height = height

    this.context = this.canvas.getContext("2d")

    // this.context.save()
    // this.context.restore()
    // this.context.translate(this.canvas.width / 2, this.canvas.height / 2)

    this.drawFrame()
  }

  tick() {
    if (this.frames > 1) {
      this.frame = (this.frame + 1) % this.frames
      this.drawFrame()
    }
  }

  drawFrame() {
    this.context.drawImage(this.sprite, this.width * this.frame, 0, this.width, this.height, 0, 0, this.width, this.height)
  }
}
