import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="clipboard"
export default class extends Controller {
  static values = { content: String };

  copy() {
    const value = this.contentValue; // Retrieve the `data-value`
    navigator.clipboard.writeText(value)
      .then(() => {
        console.log(`Copied to clipboard: ${value}`);
        this.showSuccessMessage(); // Optional: Show success feedback
      })
      .catch(err => {
        console.error("Failed to copy:", err);
      });
  }

  showSuccessMessage() {
    // Example: Feedback for successful copy
    const event = new CustomEvent("toast:show", { detail:{ message: "Copied!", icon: "success" } });
    window.dispatchEvent(event);
  }
}
