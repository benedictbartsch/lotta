import Rails from "@rails/ujs";
import { Controller } from "stimulus"
import simpleMDE from "simplemde"

var simpleInstance = null;
var controller = null;

export default class extends Controller {
  static targets = ["input", "select", "iform", "gform", "gselect", "ginput", "bulletbutton", "notebutton", "listbutton", "taskbutton", "submitButton", "dueDateFields", "addDueDateButton"]
  static values = { edit: Boolean }

  connect() {
    controller = this;
    this._restoreDraft();
    if (this.selectTarget.value != "note") {
      this.inputTarget.addEventListener("keypress", this._preventNewline);
    } 
    this._setTextareaHeight();
    if (this.inputTarget.id == "edit_area" && this.selectTarget.value == "note") {
      this._setNote();
    }
  }

  reset() {
    this._removeSimpleMDE();
    this.iformTarget.reset();
    this.submitButtonTarget.classList.remove("is-loading");
    this.dueDateFieldsTarget.classList.add("is-hidden");
    this.addDueDateButtonTarget.classList.remove("is-hidden");
    this._setNoneNote();
    this.inputTarget.style.height = "";
    this._resetDraft();
  }

  change(event) {
    this._handleEnter(event);
    this._setType();
    this._setTextareaHeight();
    this._cacheDraft();
  }

  select() {
    if (this._activeInput().dataset.inputItemsTarget == "input") {
      if (this.selectTarget.value == "note") {
        this._setNote();
      } else if (this.selectTarget.value == "group") {
        this._setInput(true);
      }  else {
        this._setNoneNote();
      }
    } else {
      const target = this.gselectTarget.value;
      if (target != "group") {
        this.selectTarget.value = target;
        this._setInput(false);
        if (target == "note") {
          this._setNote();
        } else {
          this._setNoneNote();
        }
      }
    }
  }

  edit() {
    console.log("edit");
  }

  setBullet() {
    this.selectTarget.value = "bullet";
    this._setInput(false);
    this._setNoneNote();
  }

  setTask() {
    this.selectTarget.value = "task";
    this._setInput(false);
    this._setNoneNote();

  }

  setNote() {
    this.selectTarget.value = "note"
    this._setInput(false);
    this._setNote();
  }

  setList() {
    if (this.hasGformTarget && this._selectContainsGroup) {
      this._setInput(true);
    }
  }

 

  

  _handleEnter(event) {
    if (this._gformAvailable()) {
      if (this.gformTarget.classList.contains("is-hidden") && !this.iformTarget.classList.contains("is-hidden")) {
        this._iFormEnter(event);
      }
    } else {
      this._iFormEnter(event);
    }
  }

  _iFormEnter(event) {
    if (this.selectTarget.value == "note") {
      if (event.which === 13 && event.shiftKey && this.inputTarget.value.length > 1) {
        Rails.fire(this.iformTarget, 'submit');
      } 
    } else {
      if (event.which === 13 && !event.shiftKey) {
        event.preventDefault();

        if (this.inputTarget.value.length > 1) {
          this.submitButtonTarget.classList.add("is-loading");
          // this.submitButtonTarget.disabled = true;
          Rails.fire(this.iformTarget, 'submit');
        }
      }
    }
  }

  _preventNewline(event) {
    if (event.which === 13) {
      event.preventDefault();
    }
  }

  _setType() {
    let isNote = this.selectTarget.value == "note";
    let text = this._activeInput().value;

    if (text.length >= 2) {
      let typeChar = text[0];
      if (text[1] == " ") {
        switch (typeChar) {
          case "b":
            this.selectTarget.value = "bullet";
            this._setInput(false);
            this.bulletbuttonTarget.classList.remove("has-background-white-ter");
            this.taskbuttonTarget.classList.add("has-background-white-ter");
            this.notebuttonTarget.classList.add("has-background-white-ter");
            
            if (this.hasListbuttonTarget) {
              this.listbuttonTarget.classList.add("has-background-white-ter");
            }

            break;
          case "t":
            this.selectTarget.value = "task";
            this._setInput(false);
            this.bulletbuttonTarget.classList.add("has-background-white-ter");
            this.taskbuttonTarget.classList.remove("has-background-white-ter");
            this.notebuttonTarget.classList.add("has-background-white-ter");
            
            if (this.hasListbuttonTarget) {
              this.listbuttonTarget.classList.add("has-background-white-ter");
            }

            break;
          case "n":
            this.selectTarget.value = "note";
            this._setInput(false);

            break;
          case "g":
            if (this.hasGformTarget && this._selectContainsGroup) {
              this._setInput(true);
            }

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

  _removeFirstTwo(target) {
    target = target || this._activeInput();
    target.value = target.value.substring(2);
    this._resetDraft();
  }

  _setNote() {
    this.inputTarget.classList.remove("input");
    this.inputTarget.classList.add("textarea");

    this.bulletbuttonTarget.classList.add("has-background-white-ter");
    this.taskbuttonTarget.classList.add("has-background-white-ter");
    this.notebuttonTarget.classList.remove("has-background-white-ter");
    
    if (this.hasListbuttonTarget) {
      this.listbuttonTarget.classList.add("has-background-white-ter");
    }

    this.inputTarget.removeEventListener("keypress", this._preventNewline);
    simpleInstance = new simpleMDE({element: this.inputTarget, spellChecker: false, autocorrect: true, status: false, autofocus: true, toolbar: false, autosave: false, forceSync: true, autoDownloadFontAwesome: false });
    simpleInstance.codemirror.on("change", function(self){
      controller._setType();
      controller._cacheDraft();
    });
    simpleInstance.codemirror.on("keydown", function(cm, event){
      if (event.which === 13 && event.shiftKey && cm.getValue().length > 1) {
        Rails.fire(controller.iformTarget, 'submit');
      }
    });
    simpleInstance.codemirror.focus();
  }

  _setNoneNote() {
    this.inputTarget.classList.add("input");
    this.inputTarget.classList.remove("textarea");
    this.inputTarget.addEventListener("keypress", this._preventNewline);
    this._removeSimpleMDE();
    this.inputTarget.focus();
    if (this.selectTarget.value == "bullet") {
      this.bulletbuttonTarget.classList.remove("has-background-white-ter");
      this.taskbuttonTarget.classList.add("has-background-white-ter");
      this.notebuttonTarget.classList.add("has-background-white-ter");

      if (this.hasListbuttonTarget) {
        this.listbuttonTarget.classList.add("has-background-white-ter");
      }
    } else if (this.selectTarget.value == "task") {
      this.bulletbuttonTarget.classList.add("has-background-white-ter");
      this.taskbuttonTarget.classList.remove("has-background-white-ter");
      this.notebuttonTarget.classList.add("has-background-white-ter");

      if (this.hasListbuttonTarget) {
        this.listbuttonTarget.classList.add("has-background-white-ter");
      }
    }
  }

  // https://stackoverflow.com/a/48460773
  _setTextareaHeight() {
    this.inputTarget.style.height = "";
    this.inputTarget.style.height = this.inputTarget.scrollHeight + 3 + "px";
  }

  _cacheDraft() {
    if (this.inputTarget.value.length > 2 && !this.editValue) {
      localStorage.setItem('itemDraftContent', this.inputTarget.value);
      localStorage.setItem('itemDraftType', this.selectTarget.value);
    }
  }

  _restoreDraft() {
    let itemDraftContent = localStorage.getItem('itemDraftContent');
    let itemDraftType = localStorage.getItem('itemDraftType');

    if (itemDraftContent == null || itemDraftType == null || this.editValue) {
      return
    }

    if (itemDraftContent.length > 0) {
      this.inputTarget.value = itemDraftContent;
    }

    const itemTypes = ["note", "bullet", "task"];
    if (itemTypes.includes(itemDraftType)) {
      this.selectTarget.value = itemDraftType;
      this._setTextareaHeight();

      if (itemDraftType == "note") {
        this._setNote();
      } 
    }
  }

  _resetDraft() {
    localStorage.removeItem('itemDraftContent');
    localStorage.removeItem('itemDraftType');
  }

  _gformAvailable() {
    return this.hasGformTarget;
  }

  _selectContainsGroup() {
    return [...this.selectTarget.options].map(o => o.value).includes("group");
  }

  _activeInput() {
    if (this._gformAvailable()) {
      if (this.gformTarget.classList.contains("is-hidden") && !this.iformTarget.classList.contains("is-hidden")) {
        return this.inputTarget;
      } else {
        return this.ginputTarget;
      }
    } else {
      return this.inputTarget;
    }
  }

  _removeSimpleMDE() {
    if (simpleInstance) {
      simpleInstance.toTextArea();
      this.inputTarget.style.removeProperty('height');
    }
  }

  _setInput(group) {
    if (group) {
      this.iformTarget.classList.add("is-hidden");
      this.gformTarget.classList.remove("is-hidden");
      this._removeSimpleMDE();
      this._removeFirstTwo(this.inputTarget);
      this.ginputTarget.focus();

    } else {
      this._removeFirstTwo(this._activeInput());
      if (this._gformAvailable()) {
        this.iformTarget.classList.remove("is-hidden");
        this.gformTarget.classList.add("is-hidden");
      }
      this.inputTarget.focus();
    }
  }

}