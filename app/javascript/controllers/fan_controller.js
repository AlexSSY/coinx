import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="fan"
export default class extends Controller {
  static targets = ["average", "fan", "center"]
  static values = {
    "miningStarted": Boolean,
    "ghAmount": Number
  }

  connect() {
    this.mining = 0
    this.tapSpeed = 0
    this.speed = 1 * this.ghAmountValue
    this.ignorePush = false

    if (this.miningStartedValue) {
      fetch("/mining/get")
        .then(response => response.json())
        .then(jsonResponse => {
          this.mining = parseFloat(jsonResponse.amount)
        })

      setInterval(() => {
        this.mining = this.mining + 0.0000000001 * (this.speed + this.tapSpeed)
        if (this.averageTarget !== null)
          this.averageTarget.textContent = this.mining.toFixed(10)
      }, 1)

      let rotation = 0

      setInterval(() => {
        rotation += (this.speed + this.tapSpeed)
        // element.style.backgroundImage = `url('your-image-url.jpg')`;
        if (this.fanTarget)
          this.fanTarget.style.transform = `rotate(${rotation}deg)`
      }, 16) // Roughly 60 FPS
      // update server side mining amount
      this.pushIntervalHandler = setInterval(() => {
        this._pushMining()
      }, 3000)
    }
  }

  disconnect() {
    clearInterval(this.pushIntervalHandler)
    this._pushMining()
  }

  _pushMining() {
    if (!this.ignorePush) {
      fetch("/mining/push", {
        method: "POST",
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
          "Content-Type": "application/json"
        },
        body: JSON.stringify({ amount: this.mining })
      })
    }
  }

  claim() {
    this.ignorePush = true

    fetch("/claim/create", {
      method: "POST",
      headers: {
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
        "Content-Type": "application/json"
      },
      body: JSON.stringify({ amount: this.mining })
    })
      .then(async (response) => {
        var jsonResponse = await response.json()

        if (!response.ok) {
          throw new Error(jsonResponse.msg || "Unknown error")
        }

        return jsonResponse
      })
      .then((jsonResponse) => {
        this.mining = 0
        const event = new CustomEvent("toast:show", { detail: { message: jsonResponse.msg, icon: "success" } })
        window.dispatchEvent(event)
      })
      .catch((error) => {
        const event = new CustomEvent("toast:show", { detail: { message: error.message, icon: "fail" } })
        window.dispatchEvent(event)
      })
      .finally(() => {
        this.ignorePush = false
      });
  }

  fanClicked() {
    clearTimeout(this.speedHandler)
    this.tapSpeed = 5
    this.speedHandler = setTimeout(() => {
      this.tapSpeed = 0
    }, 1000)
  }
}
