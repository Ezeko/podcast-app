# Jolly Podcast App

[Download Android APK](android/apk/app-release.apk)

## 🚀 Steps to Run the Project

1. **Prerequisites**
   - Install Flutter (>= 3.19) and ensure `flutter doctor` passes.
   - Ensure you have a device/emulator set up (Android, iOS, or web).

2. **Clone the repository** (if you haven't already)
   ```bash
   git clone <repo-url>
   cd jolly_podcast
   ```

3. **Install dependencies**
   ```bash
   flutter pub get
   ```

4. **Run the app**
   ```bash
   flutter run
   ```
   - The app will start on the connected device/emulator.

5. **Optional – Build for release**
   ```bash
   flutter build apk   # Android
   flutter build ios   # iOS (requires macOS)
   flutter build web   # Web
   ```

## 🛠️ Chosen State Management Approach

The project uses **GetX** for:
- **State management** (`Rx` variables, `Obx` widgets)
- **Routing** (`Get.toNamed`, `Get.offAllNamed`)
- **Dependency injection** (`Get.put`, `Get.lazyPut`)

GetX provides a lightweight, reactive solution without boilerplate, which aligns well with the app’s modular architecture.

## 🤔 Assumptions Made

- The backend returns user data with keys `first_name`, `last_name`, and `email`. The `ProfileController` now builds the full name from these keys.
- The `shimmer` package is used for loading placeholders on the Home screen.
- Mini‑player visibility is controlled by `PlayerController.currentEpisode` and `isPlaying`. The controller now reloads the player when `currentEpisode` is `null`.
- The app’s logo image exists at `assets/images/jolly_logo.png`.

## 📈 What Could Be Improved with More Time

| Area | Potential Improvements |
|------|------------------------|
| **UI/UX** | Add real skeleton screens for each section, implement dark‑mode theming, and refine animations for the mini‑player. |
| **Testing** | Write unit and widget tests for controllers, especially the player flow and profile loading. |
| **Error Handling** | Centralise API error handling, show user‑friendly dialogs, and implement retry logic. |
| **Architecture** | Split large files into smaller widgets, adopt a clean‑architecture folder layout (domain, data, presentation). |
| **Performance** | Optimize image caching, lazy‑load list items, and profile avatar loading from network. |

---

*Happy coding! 🎧*
