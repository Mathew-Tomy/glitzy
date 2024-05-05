

https://github.com/Mathew-Tomy/glitzy/assets/159645212/2f238a22-095d-4ad9-9a94-7ca28ddf8d9e

This is a full-stack e-commerce application built using Flutter for the mobile front-end and Laravel for the server-side backend. The app allows users to browse products, add them to their cart, and securely checkout using Stripe for payments.

Features
User Authentication: Secure user authentication and registration using Laravel Passport.
Product Listings: Browse a wide range of products with detailed descriptions and images.
Shopping Cart: Add products to the cart and manage quantities before checkout.
Stripe Integration: Secure payment processing using Stripe API for credit/debit card payments.
Order Management: Users can view their order history and order details.
Search Functionality: Search for products by name, category, or keyword.
Responsive Design: A mobile-first design approach ensures a seamless shopping experience on both mobile and desktop devices.
Admin Panel: Administrators can manage products, categories, orders, and users through a dedicated admin dashboard.
Technologies Used
Frontend: Flutter, Dart
Backend: Laravel, PHP
Database: MySQL, Eloquent ORM
Payment Gateway: Stripe API
State Management: Provider (Flutter)
API Authentication: Laravel Passport
Responsive Design: Flutter Layout Widgets
Installation
Clone Repository:
bash
Copy code
git clone https://github.com/Mathew-Tomy/glitzy/
Backend Setup:
Navigate to the backend directory and follow the README instructions for setting up Laravel.
Configure your .env file with your database credentials and Stripe API keys.
Frontend Setup:
Open the frontend directory in your Flutter development environment.
Run flutter pub get to install dependencies.
Update the lib/config.dart file with your backend API URL.
Run flutter run to launch the app on your connected device/emulator.
