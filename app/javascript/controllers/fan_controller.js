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
    this.speed = 1

    if (this.miningStartedValue) {
      fetch("/mining/get")
        .then(response => response.json())
        .then(jsonResponse => {
          this.mining = parseFloat(jsonResponse.amount)
        })

      setInterval(() => {
        this.mining = this.mining + 0.0000000001 * this.speed
        this.averageTarget.textContent = this.mining.toFixed(10)
      }, 1)

      let rotation = 0

      setInterval(() => {
        rotation += this.speed
        // element.style.backgroundImage = `url('your-image-url.jpg')`;
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
    fetch("/mining/push", {
      method: "POST",
      headers: {
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
        "Content-Type": "application/json"
      },
      body: JSON.stringify({ amount: this.mining })
    })
  }

  fanClicked() {
    // this.fanTarget.classList.add("!animate-zoom-rotate")
    // this.fanTarget.classList.add("!animate-zoom-out-in")
    clearTimeout(this.speedHandler)
    this.speed = 5
    this.speedHandler = setTimeout(() => {
      this.speed = 1
      // this.fanTarget.classList.remove("!animate-zoom-rotate")
      // this.fanTarget.classList.remove("!animate-zoom-out-in")
    }, 1000)
  }
}
