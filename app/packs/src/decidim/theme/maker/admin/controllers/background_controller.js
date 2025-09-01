import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["box"]
  static values = { colors: Array, index: Number }

  connect() {
    // defaults
    if (!this.hasColorsValue) this.colorsValue = ["#fef9c3", "#bfdbfe", "#bbf7d0", "#fecaca"]
    if (!this.hasIndexValue) this.indexValue = 0
    this.applyColor()
  }

  next() {
    this.indexValue = (this.indexValue + 1) % this.colorsValue.length
    this.applyColor()
  }

  applyColor() {
    const el = this.hasBoxTarget ? this.boxTarget : this.element
    el.style.backgroundColor = this.colorsValue[this.indexValue]
  }
}
