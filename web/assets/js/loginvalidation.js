/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Other/javascript.js to edit this template
 */
document.addEventListener("DOMContentLoaded", function () {
    const loginForm = document.querySelector("form");
    
    loginForm.addEventListener("submit", function (event) {
        const username = document.getElementById("username").value.trim();
        const password = document.getElementById("password").value.trim();
        const role = document.querySelector('input[name="role"]:checked');

        if (username === "") {
            alert("Username is required.");
            event.preventDefault();
            return;
        }

        if (password === "") {
            alert("Password is required.");
            event.preventDefault();
            return;
        }

        if (password.length < 8) {
            alert("Password must be at least 8 characters long.");
            event.preventDefault();
            return;
        }

        if (!role) {
            alert("Please select a role.");
            event.preventDefault();
            return;
        }
    });
});


