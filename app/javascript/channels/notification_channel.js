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

    if(icon_td){
      // Change icon
      icon_td.innerHTML = data.icon
  
      // Decrease counter
      var counter = document.getElementById("running-counter");
      var count = Number(counter.innerHTML) - 1;
      counter.innerHTML = Math.max(0, count); 
    }
  },

  complete: function() {
    return this.perform('complete');
  }
});
