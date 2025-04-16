import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="sort-link"
export default class extends Controller {
  static targets = ["sort", "direction"]

  updateForm(event) {
    let searchParams = new URL(event.detail.url).searchParams

    console.log(searchParams.get("sort"))
    console.log(searchParams.get("direction"))

    console.log(new URL(event.detail.url))

    this.sortTarget.value = searchParams.get("sort")
    this.directionTarget.value = searchParams.get("direction")
  }
}
