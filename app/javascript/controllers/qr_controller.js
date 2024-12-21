import { Controller } from "@hotwired/stimulus"
import qrcode from "qrcode"

// Connects to data-controller="qr"
export default class extends Controller {
  static values = {
    data: String
  }

  connect() {
    qrcode.toCanvas(this.element, this.dataValue, { width: 200 }, function (error) {
      if (error) console.error(error)
      console.log("Success! QR Code generated.")
    })
  }
}
