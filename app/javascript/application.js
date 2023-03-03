// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

document.addEventListener("turbo:load", () => {
  // Handle custom gender registration form input
  const genderInput = document.getElementById("user_gender")

  if (genderInput) {
    genderInput.addEventListener("change", () => {
      if(genderInput.value === "Custom" ) {
        let customInput = '<input type="text" name="user[gender]" id="user_gender" class="input">'
        genderInput.parentElement.classList.remove("select")
        genderInput.outerHTML = customInput
      }
    })
  }

  // Hide timeline pagination
  const paginationLoadButtons = document.getElementsByClassName("pagination-load")
  const paginationControls    = document.querySelector(".pagination-controls")

  if(paginationLoadButtons[0]) {
    paginationLoadButtons[0].hidden = false
  }

  if(paginationControls) {
    paginationControls.hidden = true
  }

  document.addEventListener("turbo:frame-load", () => {
    paginationLoadButtons[paginationLoadButtons.length - 1].hidden = false
  });
});
