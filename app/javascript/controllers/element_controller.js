import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "click", "hide" ]

  click() {
    this.clickTargets.forEach(target => target.click())
  }

  remove() {
    this.element.remove()
  }

  hide() {
    this.hideTargets.forEach(target => target.classList.addClass("hidden"))
  }
}
