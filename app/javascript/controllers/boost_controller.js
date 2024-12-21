import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="boost"
export default class extends Controller {
  static targets = ["link", "totalProfit", "dailyProfit", "ghAmount"]

  connect() {
  }

  onInput(event) {
    var value = event.currentTarget.value

    if (value < 1) {
      value = 1
      event.currentTarget.value = value
    } else if (value > 1000000) {
      value = 1000000
      event.currentTarget.value = value
    }

    this.ghAmountTarget.textContent = 10 * value
    this.totalProfitTarget.textContent = (2.5378 * value).toFixed(3)
    this.dailyProfitTarget.textContent = (0.0849 * value).toFixed(3)

    this.linkTarget.href=`/payment/${value}`
  }
}
