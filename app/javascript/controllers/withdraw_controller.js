import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="withdraw"
export default class extends Controller {
  static targets = ["amount", "select", "icon"]
  static values = {
    ton: Number,
    tonix: Number
  }

  connect() {
    this._setIcon()
  }

  max() {
    this.amountTarget.value = this.data.get(`${this.selectTarget.value}Value`)
  }

  setIcon() {
    this._setIcon()
  }

  _setIcon() {
    switch(this.selectTarget.value) {
      case "ton":
        this.iconTarget.src = "/toncoin-ton-logo.svg"
        break
      case "tonix":
        this.iconTarget.src = "/fan.png"
        break
    }
  }
}
