# 🍽️ Food Ordering App

## 📌 Project Title
**Food Ordering App** – A food ordering experience with Firebase authentication, Firestore database, and Core Data session management.

---

## 📖 Project Description
The **Food Ordering App** is an iOS application built using **Swift, Firebase, and Core Data**. It allows users to browse restaurant menus, and manage authentication securely. 

### 🔥 Key Features:
✅ User authentication (Sign Up, Login, Logout) using **Firebase Authentication**  
✅ Stores user sessions securely using **Core Data (60-minute session expiration)**  
✅ **Firestore Database** for storing users, restaurants, and orders  
✅ Follows **SOLID principles** for better testability and maintainability (implemented according to the time frame available)

## 🛠️ How to Install and Run the Project
1️⃣ **Clone the Repository**  
2️⃣ Install Dependencies (install cocoapods): sudo gem install cocoapods
Navigate to the project folder and install dependencies: pod install
3️⃣ Open Project in Xcode
Open FoodOrdering.xcworkspace in Xcode.
4️⃣ Run the App on a simulator or a real device! 🚀


🚀 How to Use the Project
Sign Up / Log In

Enter an email and password to create an account or log in.
Session Management (Core Data)

The app maintains a 60-minute session after login.
After session expiry, the user is automatically logged out.

Users can browse available restaurants.
Logout & Session Expiration

Users can manually log out.
After 60 minutes of inactivity, the session expires, requiring re-login.
