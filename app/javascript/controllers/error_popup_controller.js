import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="error-popup"
export default class extends Controller {
  static targets = [ "title", "body" ]

  show({detail: { message }}) {
    const title = "Sorry, something went wrong"
    let finalMessage = "Please reload the page"

    if (message) {
      finalMessage = message
    }

    if (finalMessage.length > 512) {
      finalMessage = finalMessage.substring(0, 512) + "..."
    }

    this.titleTarget.innerHTML = title
    this.bodyTarget.innerHTML = finalMessage

    const toast = bootstrap.Toast.getOrCreateInstance(this.element)
    toast.show()
  }
}
