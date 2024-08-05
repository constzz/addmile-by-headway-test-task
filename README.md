# AddMile by Headway Test Task. Book Listener. Using SwiftUI, MVVM, TDD

### Path (4 hours)
1. **Project setup** Create github repo, add gitignore, ReadMe file. Add colors, AppIcon, make project use SwiftUI. 

2. **Listen screen UI (8 hours)** Create UIComponents, develop screens using them. Snapshot testing each component та screen, in light and dark mode. Now we do not miss any UI change.

_Problems on this step: Disabling animations when making snapshot tests._

3. **Listen feature** (12 hours) Test driving development of AudioViewModel, ListenScreenViewModel. Using AVKit for audio playback, MVVM for UI architecture. Testing ViewModels one by one. Testing ListenScreen (screen playing audio book) in integration: UI + ViewModel.

_Problems on this step: fixing edge cases when swiping forward/backward; saving state while toogle is set to read and backward._

4. **Refactorings (3 hours)**
Make iOS 16 minimum. Most of the users use current (not beta) and previous versions. Formatting code.
Localization to be flexible using new languages in future. Refactoring some code.

### TODO:
- move mocks out of main target code to tests. Use real data and integrate app with data source.
- test viewModel functions that are not tested now
- separate snapshot tests of UIComponenets to separate test and write more test for each with different states

## App screenshots (latest from snapshot tests)
### Listen Screen
<p align="row">
  
<img src= "https://github.com/constzz/addmile-by-headway-test-task/blob/master/BookListener/BookListenerTests/__Snapshots__/ListenScreenSnapshotTests/test_listenMode_empty.iphone13PRO_light.png" height="400">
<img src= "https://github.com/constzz/addmile-by-headway-test-task/blob/master/BookListener/BookListenerTests/__Snapshots__/ListenScreenSnapshotTests/test_listenMode_empty.iphone13PRO_dark.png" height="400">
</p>
