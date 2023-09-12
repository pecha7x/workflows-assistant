import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "text" ]

  copy() {
    this.copyTextToClipboard(this.textTarget.value, this.flashBG(this.textTarget))
  }

  flashBG(el, class_name='flashed') {
    el.classList.add(class_name)
    setTimeout(function() {
      el.classList.remove(class_name)
    }, 1000);
  }

  copyTextToClipboard(text, callback) {
    if (navigator.clipboard) {
      // Modern versions of Chromium browsers, Firefox, etc.
      navigator.clipboard.writeText(text).then(function() {
        callback
      }, function(error) {
        console.error('Failed to copy text to clipboard: ' + error.message)
      });
    }
    else if (window.clipboardData) {
      // Internet Explorer.
      window.clipboardData.setData('Text', text)
      callback
    }
    else {
      // Fallback method using Textarea.
      var textArea            = document.createElement('textarea')
      textArea.value          = text
      textArea.style.position = 'fixed'
      textArea.style.top      = '-999999px'
      textArea.style.left     = '-999999px'
      document.body.appendChild(textArea)
      textArea.focus()
      textArea.select()

      try {
        var successful = document.execCommand('copy');
        if (successful) {
          callback
        }
        else {
          console.error('Could not copy text to clipboard')
        }
      } catch (error) {
        console.error('Failed to copy text to clipboard: ' + error.message)
      }
      document.body.removeChild(textArea)
    }
  }
}