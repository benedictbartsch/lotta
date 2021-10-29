import Rails from "@rails/ujs";
import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["input", "select"]

  connect() {
    if (this.selectTarget.value != "note") {
      this.inputTarget.addEventListener("keypress", this._preventNewline);
    }
    this._setTextareaHeight();
  }

  reset() {
    this.element.reset();
    this._setNoneNote();
    this.inputTarget.style.height = "";
  }

  change(event) {
    this._handleEnter(event);
    this._setType();
    this._setTextareaHeight();
  }

  select() {
    if (this.selectTarget.value == "note") {
      this._setNote();
    } else {
      this._setNoneNote();
    }
  }

  _handleEnter(event) {
    if (this.selectTarget.value == "note") {
      if(event.which === 13 && event.shiftKey && this.inputTarget.value.length > 1) {
        Rails.fire(this.element, 'submit');
      }
    } else {
      if(event.which === 13 && !event.shiftKey) {
        event.preventDefault();
        
        if (this.inputTarget.value.length > 1) {
  
          Rails.fire(this.element, 'submit');
        }
      }
    }
  }

  _preventNewline(event) {
    if(event.which === 13 ) {
      event.preventDefault();
    }
  }


  _setType() {
    let isNote = this.selectTarget.value == "note";
    let text = this.inputTarget.value;

    if (text.length >= 2) {
      let typeChar = text[0];
      if (text[1] == " ") {
        switch (typeChar) {
          case "i":
            this.selectTarget.value = "info";
            this._removeFirstTwo(isNote);

            break;
          case "t":
            this.selectTarget.value = "task";
            this._removeFirstTwo(isNote);

            break;
          case "n":
            this.selectTarget.value = "note";
            this._removeFirstTwo(isNote);

            break;
          default:
            break;
        }
      }

      if (!isNote && this.selectTarget.value == "note") {
        this._setNote();
      } else if (isNote && this.selectTarget.value != "note") {
        this._setNoneNote();
      }
    }
  }

  _removeFirstTwo() {
    this.inputTarget.value = this.inputTarget.value.substring(2);
  }

  _setNote() {
    this.inputTarget.classList.remove("input");
    this.inputTarget.classList.add("textarea");
    this.inputTarget.removeEventListener("keypress", this._preventNewline);
  }

  _setNoneNote() {
    this.inputTarget.classList.add("input");
    this.inputTarget.classList.remove("textarea");
    this.inputTarget.addEventListener("keypress", this._preventNewline);
  }

  // https://stackoverflow.com/a/48460773
  _setTextareaHeight() {
    this.inputTarget.style.height = "";
    this.inputTarget.style.height = this.inputTarget.scrollHeight + 3 + "px";
  }


}