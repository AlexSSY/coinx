import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="client-toast"
export default class extends Controller {
  static targets = ["message", "icon"];

  connect() {
    this.timeout = null;
    window.addEventListener("toast:show", this.show.bind(this));
  }

  disconnect() {
    window.removeEventListener("toast:show", this.show.bind(this));
  }

  show(event) {
    const message = event.detail.message || "Action completed!";
    const icon = event.detail.icon || "success"

    switch (icon) {
      case "success":
        this.iconTarget.className = "fa-solid block fa-circle-check text-green-500"
        break
      case "fail":
        this.iconTarget.className = "fa-solid block fa-circle-exclamation text-red-500"
        break
    }

    this.messageTarget.textContent = message;
    this.element.classList.add("!flex", "opacity-0");
    this.element.classList.add("opacity-100");

    clearTimeout(this.timeout);
    this.timeout = setTimeout(() => this.hide(), 2000);
  }

  hide() {
    this.element.classList.remove("opacity-100");
    this.element.classList.add("opacity-0");
    this.element.addEventListener(
      "transitionend",
      () => this.element.classList.remove("!flex"),
      { once: true }
    );
  }
}
