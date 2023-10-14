"use strict";

export default class Tile {
  constructor(sprite, size, frames = 0, frame = 0) {
    this.sprite = sprite
    this.size = size
    this.frames = frames
    this.frame = frame

    this.canvas = document.createElement("canvas")
    this.canvas.width = size
    this.canvas.height = size

    this.context = this.canvas.getContext("2d")

    // this.context.save()
    // this.context.restore()
    // this.context.translate(this.canvas.width / 2, this.canvas.height / 2)

    this.drawFrame()
  }

  tick() {
    if (this.frames > 0) {
      this.frame = (this.frame + 1) % this.frames
      this.drawFrame()
    }
  }

  drawFrame() {
    this.context.drawImage(this.sprite, this.size * this.frame, 0, this.size, this.size, 0, 0, this.size, this.size)
  }
}
