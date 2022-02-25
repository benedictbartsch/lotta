import { Controller } from "stimulus"
import Rails from "@rails/ujs"

export default class extends Controller {
  edit(event) {
    const target = event.target;
    const parentItem = target.closest("div.box");
    const editButton = parentItem.querySelector('.edit-button');
    const menuToggle = parentItem.querySelector('.item-menu-toggle');
    const menuToggleIcon = parentItem.querySelector('.item-menu-icon');
    if (editButton && !target.classList.contains('icon') && !target.classList.contains('fas')) {
      editButton.click();
      menuToggle.classList.add('is-loading');
      menuToggleIcon.classList.add('is-hidden');
    }
  }

  menu(event) {
    if (event.target.classList.contains("edit-button")) {
      return
    }
    const parentItem = event.target.closest("div.box");
    const itemMenu = parentItem.querySelector('.item-menu');
    const itemMenuToggle = parentItem.querySelector('.item-menu-toggle');
    itemMenu.classList.toggle('is-hidden');
  }
  submit() {
    Rails.fire(this.element, 'submit');
  }
}