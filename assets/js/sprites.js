export default class Sprites {
  constructor(sprites, callback) {
    let loadedImages = 0
    const totalImages = sprites.length

    this.images = {}

    sprites.map(({ key, file }) => {
      const img = new Image()
      img.onload = () => {
        if (++loadedImages >= totalImages) { callback(this.images) }
      }
      img.src = file
      // img.complete

      this.images[key] = img
    })
  }
}
