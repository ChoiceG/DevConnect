import { Controller } from "@hotwired/stimulus"

export default class AlertController extends Controller {
  static targets = ["alert"]

  connect() {
    // Set a timeout to fade out the alert after 4 seconds
    setTimeout(() => {
      this.fadeOut()
    }, 4000)
  }

  fadeOut() {
    this.alertTarget.style.transition = "opacity 1s ease-out"
    this.alertTarget.style.opacity = 0

    // Remove the element from the DOM after fade out
    setTimeout(() => {
      this.alertTarget.remove()
    }, 1000) // Wait for the fade out transition to complete
  }
}
