import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="error-popup"
export default class extends Controller {
  static targets = [ "title", "body" ]

  show({detail: { message }}) {
    const title = "Sorry, something went wrong"
    let defaultMessage = "Please reload the page"

    this.titleTarget.innerHTML = title
    this.bodyTarget.innerHTML = message || defaultMessage

    const toast = bootstrap.Toast.getOrCreateInstance(this.element)
    toast.show()
  }
}
