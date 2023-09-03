import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "element", "button", "buttonIcon" ]

  connect () {
    var currentElementHeightRem = 0.0625 * this.elementTarget.clientHeight
    var elementDesireVisibleHeightRem = this.elementTarget.dataset.visibleHeightRem

    if (currentElementHeightRem > elementDesireVisibleHeightRem) {
      this.connect_collapsible()
    }
  }

  toggle_visibility() {
    this.toggle_element_visibility()
    this.toggle_button_icon_rotation()
  }

  toggle_element_visibility() {
    // here we avoid of using one css class name for visible/hidden
    // to keep the things more reusable
    if (this.elementTarget.classList.contains("collapsible-hidden")) {
      this.elementTarget.classList.remove("collapsible-hidden")
      this.elementTarget.classList.add("collapsible-visible")
    } else {
      this.elementTarget.classList.add("collapsible-hidden")
      this.elementTarget.classList.remove("collapsible-visible")
    }
  }

  toggle_button_icon_rotation() {
    this.buttonIconTarget.classList.toggle("fa-rotate-180")
  }

  connect_collapsible() {
    this.buttonTarget.classList.remove("collapsible-button-hidden")
    this.toggle_element_visibility()
  }
}
