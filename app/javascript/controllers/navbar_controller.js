import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "menu", "togglerButton" ]

  togglerClick() {
    this.togglerButtonTarget.classList.toggle("navbar__toggler-opened")
    this.menuTarget.classList.toggle("navbar__menu-opened")
  }

  menuClick() {
    if (this.menuTarget.classList.contains("navbar__menu-opened")) {
      this.closeMenu()
    }
  }

  closeMenu() {
    this.togglerButtonTarget.classList.remove("navbar__toggler-opened")
    this.menuTarget.classList.remove("navbar__menu-opened")
  }
}
