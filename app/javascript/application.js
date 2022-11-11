// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

// Handle custom gender registration form input
const genderInput = document.getElementById("user_gender")

genderInput.addEventListener('change', () => {
  if(genderInput.value === "Custom" ) {
    let customInput = '<input type="text" name="user[gender]" id="user_gender">'
    genderInput.insertAdjacentHTML("afterend", customInput)
    genderInput.parentElement.removeChild(genderInput)
  }
})
