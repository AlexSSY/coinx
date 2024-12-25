import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="withdraw"
export default class extends Controller {
  static targets = [
    "amount", 
    "select", 
    "icon", 
    "minSend", 
    "currency",
    "received",
    "fee",
  ]
  static values = {
    ton: Number,
    tonix: Number,
    fee: Number,
  }

  connect() {
    this._setMutations()
    this.feeTarget.textContent = this.feeValue
  }

  max() {
    this.amountTarget.value = this.data.get(`${this.selectTarget.value}Value`)
    this.amountTarget.dispatchEvent(new Event("input", { bubbles: true }))
  }

  selectCurrency() {
    this._setMutations()
  }

  amountChanged() {
    var value = this.amountTarget.value
    var fee = this.feeValue
    this.receivedTarget.textContent = Math.max(value - fee, 0)
  }

  _setMutations() {
    switch(this.selectTarget.value) {
      case "ton":
        this.iconTarget.src = "/toncoin-ton-logo.svg"
        this.minSendTarget.textContent = "0,35 TON"
        this.currencyTarget.textContent = "TON"
        break
      case "tonix":
        this.iconTarget.src = "/fan.png"
        this.minSendTarget.textContent = "150 000 TONIX"
        this.currencyTarget.textContent = "TONIX"
        break
    }
  }
}
