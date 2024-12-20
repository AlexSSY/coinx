import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="modal"
export default class extends Controller {
  static targets = ["overlay"];

  connect() {
  }

  close() {
    // Hide the modal
    this.overlayTarget.classList.add("hidden");
  }

  closeBg(event) {
    if (event.target === this.overlayTarget) {
      this.close()
    }
  }

  confirm() {
    // Perform the confirm action (e.g., submit form, call API, etc.)
    alert("Action confirmed!");

    // Optionally close the modal
    this.close();
  }
}
