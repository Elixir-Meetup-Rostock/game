"use strict";

export default class Sprites {
  constructor(sprites, callback) {
    let loadedImages = 0
    const totalImages = sprites.length

    this.images = {}

    sprites.forEach(({ id, src, width, height, frames }) => {
      const img = new Image()
      img.onload = () => {
        if (++loadedImages >= totalImages) { callback(this.images) }
      }
      img.src = src
      // img.complete

      this.images[id] = { img, width, height, frames }
    })
  }
}
