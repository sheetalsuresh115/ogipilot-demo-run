// // Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "bootstrap"
import "popper"
import "jquery-slim-min"
import "controllers"
import "channels"

document.addEventListener('DOMContentLoaded', () => {
  document.querySelectorAll('.nav-link').forEach(navLink => {
    navLink.addEventListener('click', function(event) {
      event.preventDefault();
      loadComponent(this.getAttribute('data-url'));
      // Update the active tab class
      document.querySelectorAll('.nav-link').forEach(link => link.classList.remove('active'));
      this.classList.add('active');
    });
  });

  function loadComponent(url) {
    fetch(url)
      .then(response => response.text())
      .then(html => {
        document.getElementById('tab-content').innerHTML = html;
      }) 
      .catch(error => console.error('Error loading component:', error));
  }
});
