# CivikDesk - Complaint Management System

<div align="center">

![CivikDesk Logo](asets/images/complaint-round-svgrepo-com.svg)

A modern complaint management system built with Flutter and Firebase

</div>

## 🌟 Features

### For Users
- 📝 Easy complaint submission with image attachments
- 🔍 Real-time tracking of complaint status
- 👤 User profile management
- 💬 AI-powered chat assistance
- 🔐 Secure authentication with email and Google Sign-in

### For Administrators
- 📊 Comprehensive dashboard for complaint management
- ✅ Review and process complaints efficiently
- 🔑 Secure admin authentication with special access key
- 👥 Department-wise complaint handling
- 📈 Status updates and complaint resolution

## 🛠️ Tech Stack

- **Frontend:** Flutter
- **Backend:** Firebase
  - Authentication
  - Cloud Firestore
  - Cloud Storage
- **State Management:** Riverpod
- **Navigation:** Go Router
- **AI Services:** Custom AI integration for chat support
- **Image Processing:** Cloudinary

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (latest version)
- Firebase project setup
- Android Studio/VS Code with Flutter plugins

### Installation

1. Clone the repository
```bash
git clone https://github.com/yourusername/CivikDesk.git
```

2. Install dependencies
```bash
flutter pub get
```

3. Configure Firebase
   - Add your `google-services.json` for Android
   - Add your `GoogleService-Info.plist` for iOS

4. Run the app
```bash
flutter run
```

## 📱 App Structure

```
lib/
├── core/           # App constants and theme
├── models/         # Data models
├── presentation/   # UI screens and widgets
├── providers/      # State management
├── routes/         # Navigation
├── services/       # Firebase and other services
└── widgets/        # Reusable widgets
```

## 🔐 Security Features

- Secure admin authentication with special access key
- Email verification
- Google Sign-in integration
- Protected admin routes
- Secure file storage

## 🎯 Key Workflows

### User Workflow
1. Sign up/Login
2. Create/Update profile
3. Submit complaint with details and images
4. Track complaint status
5. Interact with AI chat assistant

### Admin Workflow
1. Secure admin login with special key
2. Review incoming complaints
3. Process and update complaint status
4. Manage department-specific complaints
5. Update resolution status

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

---

<div align="center">
Made with ❤️ using Flutter and Firebase
</div>
