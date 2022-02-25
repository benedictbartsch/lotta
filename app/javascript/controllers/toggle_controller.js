// https://github.com/damonbauer/stimulus-toggle-util

import { Controller } from "stimulus";

export default class extends Controller {
  hidden(event) {
    this._toggle_class("is-hidden", event.currentTarget);
  }

  active(event) {
    this._toggle_class("is-active", event.currentTarget)
  }

  loading(event) {
    this._toggle_class("is-loading", event.currentTarget)
  }

  _toggle_class(css_class, currentTarget) {
    if (!currentTarget.dataset.toggleTarget) {
      currentTarget.classList.toggle(css_class)
    } else {
      const TARGETS = currentTarget.dataset.toggleTarget.split(",");
      TARGETS.forEach((target) =>
        document
          .querySelectorAll(`[data-toggle-name="${target}"]`)
          .forEach((target) => target.classList.toggle(css_class))
      );
    }
  }


}