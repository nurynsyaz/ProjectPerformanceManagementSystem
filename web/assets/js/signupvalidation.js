/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Other/javascript.js to edit this template
 */

document.addEventListener("DOMContentLoaded", function () {
    document.querySelector("form").addEventListener("submit", function (event) {
        if (!validateForm()) {
            event.preventDefault(); // Prevent form submission if validation fails
        }
    });
});

function validateForm() {
    let isValid = true;

    // Get form elements
    let username = document.getElementById("username").value.trim();
    let email = document.getElementById("email").value.trim();
    let phone = document.getElementById("phoneNumber").value.trim();
    let password = document.getElementById("password").value.trim();
    let roleSelected = document.querySelector('input[name="role"]:checked'); // Check if a role is selected

    // Regex patterns
    let emailPattern = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
    let phonePattern = /^\d{10}$/;
    let passwordPattern = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@#$%^&+=!]).{8,}$/;

    // Reset errors
    document.getElementById("usernameError").innerText = "";
    document.getElementById("emailError").innerText = "";
    document.getElementById("phoneError").innerText = "";
    document.getElementById("passwordError").innerText = "";
    document.getElementById("roleError").innerText = "";

    // Validate username
    if (username.length < 3) {
        document.getElementById("usernameError").innerText = "Username must be at least 3 characters.";
        isValid = false;
    }

    // Validate email
    if (!emailPattern.test(email)) {
        document.getElementById("emailError").innerText = "Enter a valid email format (example@gmail.com).";
        isValid = false;
    }

    // Validate phone number
    if (!phonePattern.test(phone)) {
        document.getElementById("phoneError").innerText = "Phone number must be exactly 10 digits.";
        isValid = false;
    }

    // Validate password
    if (!passwordPattern.test(password)) {
        document.getElementById("passwordError").innerText = "Password must be at least 8 characters, include uppercase, lowercase, a digit, and a special character.";
        isValid = false;
    }

    // Validate role selection
    if (!roleSelected) {
        document.getElementById("roleError").innerText = "Please select a role.";
        isValid = false;
    }

    return isValid;
}