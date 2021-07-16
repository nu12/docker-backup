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
    var icon_td = document.getElementsByClassName("icon-" + data.id)[0];
    icon_td.innerHTML = data.icon
  },

  complete: function() {
    return this.perform('complete');
  }
});
