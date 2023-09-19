export default class Tile {
  constructor(sprite, size) {
    this.sprite = sprite

    this.canvas = document.createElement("canvas")
    this.canvas.width = size
    this.canvas.height = size

    this.context = this.canvas.getContext("2d")

    // this.context.save()
    // this.context.restore()
    // this.context.translate(this.canvas.width / 2, this.canvas.height / 2)

    this.context.drawImage(sprite, 0, 0, size, size, 0, 0, size, size)

    return this.canvas
  }
}
