import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="tabs"
export default class extends Controller {
  static targets = ["tab", "body"]

  connect() {
    this._select(this.tabTargets[0])
  }

  select(event) {
    this._select(event.currentTarget)
  }

  _select(tabTarget) {
    var tabIndex = this.tabTargets.indexOf(tabTarget)

    this.tabTargets.forEach(tab => {
      tab.classList.remove("bg-slate-800")
    })

    tabTarget.classList.add("bg-slate-800")

    this.bodyTargets.forEach((body, bodyIndex) => {
      if (tabIndex !== bodyIndex) {
        body.classList.add("hidden")
      } else {
        body.classList.remove("hidden")
      }
    })
  }
}
