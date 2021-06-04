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
    toast_container.innerHTML += data.html

    // Re-initiate toasts
    var newToast = new bootstrap.Toast(document.getElementById(data.id));
    newToast.show();
    window.setTimeout(function(){
      newToast.hide();
    }, 2000);
  },

  complete: function() {
    return this.perform('complete');
  }
});
