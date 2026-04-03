# Godot Google Play Games Services 20.1.2
[![GPGS](https://img.shields.io/badge/gpgs-20.1.2-gray?style=for-the-badge&logo=google%20play&logoColor=green&logoSize=auto&labelColor=gray&color=green)](https://developer.android.com/games/pgs/overview)
[![Godot](https://img.shields.io/badge/Godot%20Engine-3.6.2-blue?style=for-the-badge&logo=godotengine&logoSize=auto)](https://godotengine.org/)
[![Godot](https://img.shields.io/badge/Godot%20Engine-4.6.1-blue?style=for-the-badge&logo=godotengine&logoSize=auto)](https://godotengine.org/)
[![GitHub License](https://img.shields.io/github/license/damnedpie/godot-gpgs?style=for-the-badge)](https://github.com/damnedpie/godot-gpgs/blob/main/LICENSE)
[![GitHub Repo stars](https://img.shields.io/github/stars/damnedpie/godot-gpgs?style=for-the-badge&logo=github&logoSize=auto&color=%23FFD700)](https://github.com/damnedpie/godot-gpgs/stargazers)

Godot Google Play Games Services 20.1.2 Android plugin for Godot. Built on Godot 3.6.2 / Godot 4.6.1 dependency.

## Why the heck have I forked this

I've been making Android Games ever since Godot 3.1.x and I currently maintain both Godot 3 and Godot 4 mobile games. Over time it got pretty annoying to babysit a whole zoo of different plugins with different APIs and different integrations methods (e.g. just having stuff in `android/plugins` vs. having stuff in `addons/`). I found API of @lakobs GD3 plugin quite straightworward (huge shout out to him) so I just decided to fork his work and split the repo into GD3 and GD4 version of the plugin (so that the AARs are built on according Godot dependencies) and keep API for both plugins identical.

# How to use

- Create and setup your Google Play Console account and app
- Create a new Godot project
- Configure your editor Android settings
- Install and edit the Android build template for custom builds
- Paste the plugin `.aar` and `.gdap` files in the proper folder (`android/plugins`), available in the releases page of this repository
- Create the Android export configuration

Below there is an extensive guide on the steps shown above. Please, **read carefully** and review that you didn't miss any steps if you find any problems down the line.

## Setup Google Play Console account and app

- Create a Google Play Console dev account (this step involves a payment)
- Create a new app of type game
- Configure your achievements, leaderboards, etc.

Add to `AndroidManifest.xml` inside the `<application/>` tag:

```xml
<application ...>

  <!-- Google Play Game Services -->
  <meta-data android:name="com.google.android.gms.games.APP_ID"
      android:value="@string/game_services_project_id"/>

  ...

</application>
```

Then, create a file named `strings.xml` in the following path of your Godot project: `android/build/res/values` and copy this to the file. If the file already exists, you only need to copy the `<string... />` tag:

```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string translatable="false" name="game_services_project_id">146910152586</string>
</resources>
```

You have to replace the project id with the id of your app in Google Play Console.

There's a shit ton of other stuff you have to do in order to make your GPGS project work. Follow the steps Google Play Console suggests.


# GDScript Reference

In this document is listed the plugin signals and methods available for use inside Godot with GDScript.
The source code is available [here](app/src/main/java/com/jacobibanez/godot/gpgs/GodotGooglePlayGameServices.kt).

After you install the plugin in `android/plugins` and enable it on your Export preset, you should be able to access its functionalities through:

```gdscript
Engine.get_singleton("GodotGooglePlayGameServices")
```

> ⚠️ Keep in mind that a wrapper with **full autocompletion** is already available at [this repository](https://github.com/Iakobs/godot-google-play-game-services-plugin), so prefer using it instead of interfacing with the native plugin singleton directly.

## Signals

These signals belong to the native plugin singleton and can be used by connecting them to a method.

```gdscript
func _ready() -> void:
    var plugin: JNISingleton = Engine.get_singleton("GodotGooglePlayGameServices")
    plugin.connect("leaderboardsAllLoaded", self, "_on_allLeaderboardsLoaded")
    plugin.loadAllLeaderboards(true)


func _on_allLeaderboardsLoaded(leaderboards: String) -> void:
    var parsed_leaderboards: Dictionary = JSON.parse(leaderboards).result
    prints(parsed_leaderboards)
```

### Achievements

#### achievementsLoaded(achievements: String)

This signal is emitted when calling the `achievementsLoad` method.
Returns A JSON string with a list of [Achievement](https://developers.google.com/android/reference/com/google/android/gms/games/achievement/Achievement).

#### achievementsRevealed(revealed: bool, achievementId: String)

This signal is emitted when calling the `achievementsReveal` method.
Returns `true` if the achievement is revealed and `false` otherwise.
Also returns the id of the achievement.

#### achievementsUnlocked(isUnlocked: bool, achievementId: String)

This signal is emitted when calling the `achievementsIncrement`, `achievementsSetSteps` or `achievementsUnlock` methods.
Returns `true` if the achievement is unlocked or `false` otherwise.
Also returns the id of the achievement.

### Events

#### eventsLoaded(events: String)

This signal is emitted when calling the `eventsLoad` method.
Returns A JSON string with the list of [Event](https://developers.google.com/android/reference/com/google/android/gms/games/event/Event).

#### eventsLoadedByIds(events: String)

This signal is emitted when calling the `eventsLoadByIds` method.
Returns A JSON string with the list of [Event](https://developers.google.com/android/reference/com/google/android/gms/games/event/Event).

### Leaderboards

#### leaderboardsScoreSubmitted(submitted: bool, leaderboardId: String)

This signal is emitted when calling the `leaderboardsSubmitScore` method.
Returns `true` if the score is submitted. `false` otherwise. Also returns the id of the leaderboard.

#### leaderboardsScoreLoaded(leaderboardId: String, score: String)

This signal is emitted when calling the `leaderboardsLoadPlayerScore` method.
Return The leaderboard id and a JSON string with a [LeaderboardScore](https://developers.google.com/android/reference/com/google/android/gms/games/leaderboard/LeaderboardScore).

#### leaderboardsAllLoaded(leaderboards: String)

This signal is emitted when calling the `leaderboardsLoadAll` method.
Returns A JSON string with a list of [Leaderboard](https://developers.google.com/android/reference/com/google/android/gms/games/leaderboard/Leaderboard).

#### leaderboardsLoaded(leaderboard: String)

This signal is emitted when calling the `leaderboardsLoad` method.
Returns A JSON string with a [Leaderboard](https://developers.google.com/android/reference/com/google/android/gms/games/leaderboard/Leaderboard).

### Players

#### playersCurrentLoaded(player: String)

This signal is emitted when calling the `playersLoadCurrent` method.
Returns A JSON string with a [Player](https://developers.google.com/android/reference/com/google/android/gms/games/Player).

#### playersFriendsLoaded(friends: String)

This signal is emitted when calling the `playersLoadFriends` method.
Returns A JSON with a list of [Player](https://developers.google.com/android/reference/com/google/android/gms/games/Player).

#### playersSearched(player: String)

This signal is emitted when selecting a player in the search window that is being displayed after calling the [playersSearch] method. Returns A JSON string with a [Player](https://developers.google.com/android/reference/com/google/android/gms/games/Player).

### Sign In

#### signInUserAuthenticated(isAuthenticated: bool)

This signal is emitted when calling the `signInIsAuthenticated` and `signInShowPopup` methods.
Returns `true` if the user is authenticated or `false` otherwise.

#### signInRequestedServerSideAccess(token: String)

This signal is emitted when calling the `signInRequestServerSideAccess` method.
Returns an OAuth 2.0 authorization token as a string.

### Snapshots

#### snapshotsGameSaved(saved: bool, fileName: String, description: String)

This signal is emitted when calling the `snapshotsSaveGame` method.
Returns a boolean indicating if the game was saved or not, and the name and description of the save file.

#### snapshotsGameLoaded(snapshot: String)

This signal is emitted when calling the `snapshotsLoadGame` method or after selecting a saved game in the window opened by the `snapshotsShowSavedGames` method.
Returns A JSON string representing a [Snapshot](https://developers.google.com/android/reference/com/google/android/gms/games/snapshot/Snapshot).

#### snapshotsConflictEmitted(conflict: String)

This signal is emitted when saving or loading a game, whenever a conflict occurs.
Returns A JSON string representing a [SnapshotConflict](https://developers.google.com/android/reference/com/google/android/gms/games/SnapshotsClient.SnapshotConflict).

## Methods

### Achievements

#### achievementsIncrement(achievementId: String, amount: int, immediate: bool)

Increments an achievement by the given number of steps.
The achievement must be an incremental achievement.
Once an achievement reaches at least the maximum number of steps, it will be unlocked automatically.
Any further increments will be ignored.
Emits `achievementsUnlocked`.

#### achievementsLoad(forceReload: bool)

Loads the achievement data for the currently signed-in player.
Emits `achievementsLoaded`.

#### achievementsReveal(achievementId: String, immediate: bool)

Reveals a hidden achievement to the currently signed-in player.
If the achievement has already been unlocked, this will have no effect.
Emits `achievementRevealed` if `immediate` is `true`.

#### achievementsSetSteps(achievementId: String, amount: int, immediate: bool)

Sets an achievement to have at least the given number of steps completed.
The achievement must be an incremental achievement.
Once an achievement reaches at least the maximum number of steps, it will be unlocked automatically.
Emits `achievementsUnlocked` if `immediate` is `true`.

#### achievementsShow()

Shows a native popup to browse game achievements of the currently signed-in player.

#### achievementsUnlock(achievementId: String, immediate: bool)

Unlocks an achievement for the currently signed in player.
If the achievement is hidden this will reveal it to the player.
Emits `achievementsUnlocked` if `immediate` is `true`.

### Events

#### eventsIncrement(eventId: String, amount: int)

Increments an event specified by eventId by the given number of steps.
This is the fire-and-forget form of the API (no signals are emitted).

#### eventsLoad(forceReload: bool)

Loads the event data for the currently signed-in player. Emits `eventsLoaded`.

#### eventsLoadByIds(forceReload: bool, eventIds: Array[String])

Loads the event data for the currently signed-in player for the specified ids. Emits `eventsLoadedByIds`.

### Leaderboards

#### leaderboardsShowAll()

Shows a native popup to browse all leaderboards.

#### leaderboardsShow(leaderboardId: String)

Shows a native popup to browse the specified leaderboard.

#### leaderboardsShowForTimeSpan(leaderboardId: String, timeSpan: Int)

Shows a native popup to browse the specified leaderboard for the specified time span.

#### leaderboardsShowForTimeSpanAndCollection(leaderboardId: String, timeSpan: int, collection: int)

Shows a native popup to browse the specified leaderboard for the specified time span and collection.

#### leaderboardsSubmitScore(leaderboardId: String, score: float)

Submits a score to the specified leaderboard. Emits `leaderboardsScoreSubmitted`.

#### leaderboardsLoadPlayerScore(leaderboardId: String, timeSpan: int, collection: int)

Loads the player's score for the specified leaderboard. Emits `leaderboardsScoreLoaded`.

#### leaderboardsLoadAll(forceReload: bool)

Loads the leaderboard data for the currently signed-in player. Emits `leaderboardsAllLoaded`.

#### leaderboardsLoad(leaderboardId: String, forceReload: bool)

Loads the leaderboard data for the currently signed-in player. Emits `leaderboardsLoaded`

### Players

#### playersCompareProfile(otherPlayerId: String)

Shows a native popup to compare two players.

#### playersCompareProfileWithAlternativeNameHints(otherPlayerId: String, otherPlayerInGameName: String, currentPlayerInGameName: String)

Shows a native popup to compare two players with alternative name hints.

#### playersLoadCurrent(forceReload: bool)

Loads the player data for the currently signed-in player. Emits `playersCurrentLoaded`.

#### playersLoadFriends(pageSize: int, forceReload: bool, askForPermission: bool)

Loads the friends data for the currently signed-in player. Emits `playersFriendsLoaded`.

#### playersSearch()

Shows a native popup to search for players. Emits `playersSearched`.

### Sign in

#### signInIsAuthenticated()

Checks if the user is signed in. Emits `signInUserAuthenticated`.

#### signInShowPopup()

Show a native popup to sign in the user. Emits `signInUserAuthenticated`.

#### signInRequestServerSideAccess(serverClientId: String, forceRefreshToken: bool)

Requests server-side access for the specified server client ID. Emits `signInRequestedServerSideAccess`.

### Snapshots

#### snapshotsLoadGame(fileName: String)

Loads a game from the specified file. Emits `snapshotsGameLoaded` or `snapshotsConflictEmitted`.

#### snapshotsSaveGame(fileName: String, description: String, saveData: PoolByteArray, playedTimeMillis: int, progressValue: int)

Saves a game to the specified file. Emits `snapshotsGameSaved` or `snapshotsConflictEmitted`.

#### snapshotsShowSavedGames(title: String, allowAddButton: bool, allowDelete: bool, maxSnapshots: int)

Shows a native popup to browse saved games. Emits `snapshotsGameLoaded`.
