import { Controller } from "stimulus"

export default class extends Controller {
    static targets = ["dueDateFields", "addDueDateButton", "dueDateInput", "deleteDueDateButton"]
    
    addDueDate() {
        this.addDueDateButtonTarget.classList.add("is-hidden");
        this.dueDateFieldsTarget.classList.remove("is-hidden");
        this.dueDateInputTarget.focus();
    }

    delete() {
        this.dueDateInputTarget.value = "";
        this.addDueDateButtonTarget.classList.remove("is-hidden");
        this.dueDateFieldsTarget.classList.add("is-hidden");
    }
}
