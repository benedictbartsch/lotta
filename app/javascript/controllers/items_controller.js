import Rails from "@rails/ujs";
import { Controller } from "stimulus"

export default class extends Controller {
  submit() {
    Rails.fire(this.element, 'submit');
  }
}