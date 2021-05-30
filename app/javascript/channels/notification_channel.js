import consumer from "./consumer"

consumer.subscriptions.create("NotificationChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
    var toast_container = document.getElementById("toast-container");
    toast_container.innerHTML += data

    // Re-initiate toasts
    var toastElList = [].slice.call(document.querySelectorAll('.toast'))
      var toastList = toastElList.map(function (toastEl) {
        return new bootstrap.Toast(toastEl)
      })
      toastList.forEach(toast => toast.show());
  },

  complete: function() {
    return this.perform('complete');
  }
});
