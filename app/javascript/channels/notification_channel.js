import consumer from "channels/consumer"

const NotificationChannel = consumer.subscriptions.create("NotificationChannel", {
  received(data) {
    const notificationMenu = document.querySelector(".notifications-start")
    notificationMenu.insertAdjacentHTML("afterend", this.template(data))
  },

  template(data) {
    return `<a href="/notifications/${data.id}">
              <li class="dropdown-item">
                <p class="has-text-link">${data.body}</p>
              </li>
            </a>
            <hr class="dropdown-divider">`
  }
});
