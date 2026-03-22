# FocusFlow ⏳
> A cross-platform student productivity hub built with Flutter and Dart.

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web-lightgrey?style=for-the-badge)

## 📖 Overview
Students are constantly juggling lectures, assignments, and personal events, but the tools they use are fragmented. Managing a scattered system leads to missed deadlines, double-booking, and academic burnout.

**FocusFlow** unifies task management and scheduling into one seamless, centralized experience. The platform is currently engineered for an initial launch on Web and Android, utilizing a scalable architecture that allows for a seamless future deployment to iOS.

## ✨ Core Features
* **Smart Task Management:** A dynamic To-Do list featuring interactive checkboxes and swipe-to-delete functionality.
* **Focus Mode (Pomodoro):** A built-in, course-specific timer to track study sessions and prevent burnout.
* **Class Scheduling:** A visual weekly timetable for tracking lectures and lab periods.
* **User Gamification:** Profile tracking for study streaks, tasks completed, and hours studied.
* **[IN DEVELOPMENT] AI-Powered Timetables:** Users will be able to upload a PDF syllabus, utilizing AI parsing to automatically extract and populate their weekly timetable.
* **[IN DEVELOPMENT] Universal Calendar Sync:** Native API integration to establish a two-way sync with Google Calendar and Apple Calendar.

## 📱 Screen Previews
*(Note: Replace these placeholder links with actual screenshot URLs once uploaded to your repository!)*
| Home / Tasks | Focus Timer | Class Schedule | Profile & Stats |
| :---: | :---: | :---: | :---: |
| <img src="placeholder_link_1.png" width="200"> | <img src="placeholder_link_2.png" width="200"> | <img src="placeholder_link_3.png" width="200"> | <img src="placeholder_link_4.png" width="200"> |

## 🛠️ Tech Stack
* **Frontend:** Flutter, Dart
* **Architecture:** Stateful Widget Management, Custom Navigation Shell
* **Packages used:** `table_calendar`, `lottie` (for animations)
* **Planned Backend:** SQLite, Python (Flask), OpenAI GPT-4o-mini (for syllabus parsing)

## 🚀 Getting Started

### Prerequisites
Make sure you have [Flutter](https://docs.flutter.dev/get-started/install) installed on your machine.

### Installation
1. Clone the repository:
   ```bash
   git clone [https://github.com/YourUsername/FocusFlow.git](https://github.com/YourUsername/FocusFlow.git)
2. Navigate to the project directory:
    ```bash
    cd FocusFlow
3. Install the dependencies:
    ```bash
    flutter pub get
4. Run the app:
    ```bash
    flutter run
   
## Project Structure
lib/

┣ main.dart # App entry point & theme setup

┣ login_screen.dart # User authentication UI

┣ signup_screen.dart # New user registration UI

┣ home_screen.dart # Main navigation & to-do list

┣ calendar_screen.dart # Calendar (table_calendar integration)

┣ schedule_screen.dart # Weekly timetable UI

┣ timer_screen.dart # Pomodoro focus mode logic

┗ profile_screen.dart # User stats, rewards & settings