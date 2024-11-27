import consumer from "./consumer"

consumer.subscriptions.create({ channel: "MeasurementChannel" }, {
  initialized() {
    // Called once when the subscription is created.
  },
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
    const event = new CustomEvent("measurementReceived", {
      detail: data,
    });
    document.dispatchEvent(event);
  }
})
