import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["content", "toast"] 
    connect() {
        this.handleNotification = this.handleNotification.bind(this)
        document.addEventListener("notificationReceived", this.handleNotification)
    }
    
    disconnect() {
        document.removeEventListener("notificationReceived", this.handleNotification)
    }

    handleNotification(event) {
        this.contentTarget.textContent = event.detail.value
        const toast = new bootstrap.Toast(this.toastTarget)
        toast.show()
    }
    
}