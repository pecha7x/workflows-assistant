import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "anchor" ]

  encode({ target }) {
    for (const anchor of this.anchorTargets) {
      const currentSearchParams = anchor.search
      const targetAttrValue =  new URLSearchParams({ [target.name]: target.value })

      let searchString;
      if (currentSearchParams) {
        searchString = currentSearchParams + '&' + targetAttrValue
      } else {
        searchString = targetAttrValue
      }

      anchor.search = searchString
    }
  }
}
