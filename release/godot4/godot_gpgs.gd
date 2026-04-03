extends Node

enum TimeSpan {
	TIME_SPAN_DAILY = 0,
	TIME_SPAN_WEEKLY = 1,
	TIME_SPAN_ALL_TIME = 2
}

enum Collection {
	COLLECTION_PUBLIC = 0,
	COLLECTION_FRIENDS = 3
}

signal achievements_loaded(achievements)
signal achievements_revealed(revealed, achievement_id)
signal achievements_unlocked(is_unlocked, achievement_id)
signal events_loaded(events)
signal events_loaded_by_ids(events)
signal leaderboards_score_submitted(submitted, leaderboard_id)
signal leaderboards_score_loaded(leaderboard_id, score)
signal leaderboards_all_loaded(leaderboards)
signal leaderboards_loaded(leaderboard)
signal leaderboards_player_centered_scores_loaded(leaderboard_id, leaderboard_scores)
signal leaderboards_top_scores_loaded(leaderboard_id, leaderboard_scores)
signal players_current_loaded(player)
signal players_friends_loaded(friends)
signal players_searched(player)
signal sign_in_user_authenticated(is_authenticated)
signal sign_in_requested_server_side_access(token)
signal snapshots_game_saved(saved, file_name, description)
signal snapshots_game_loaded(snapshot)
signal snapshots_conflict_emitted(conflict)
signal image_stored(image)

var _gpgs : JNISingleton

const AUTH_UNKNOWN : int = 0
const AUTH_SIGNED_IN : int = 1
const AUTH_NOT_SIGNED_IN : int = 2
var authStatus : int = AUTH_UNKNOWN

# REGION API

func initialize() -> void:
	if !Engine.has_singleton("GodotGooglePlayGameServices"):
		_output("GPGS JNI singleton not present, doing nothing")
		return
	_gpgs = Engine.get_singleton("GodotGooglePlayGameServices")
	_gpgs.connect("achievementsLoaded", Callable(self, "_onAchievementsloaded"))
	_gpgs.connect("achievementsRevealed", Callable(self, "_onAchievementsRevealed"))
	_gpgs.connect("achievementsUnlocked", Callable(self, "_onAchievementsUnlocked"))
	_gpgs.connect("eventsLoaded", Callable(self, "_onEventsLoaded"))
	_gpgs.connect("eventsLoadedByIds", Callable(self, "_onEventsLoadedByIds"))
	_gpgs.connect("leaderboardsScoreSubmitted", Callable(self, "_onLeaderboardsScoreSubmitted"))
	_gpgs.connect("leaderboardsScoreLoaded", Callable(self, "_onLeaderboardsScoreLoaded"))
	_gpgs.connect("leaderboardsAllLoaded", Callable(self, "_onLeaderboardsAllLoaded"))
	_gpgs.connect("leaderboardsLoaded", Callable(self, "_onLeaderboardsLoaded"))
	_gpgs.connect("leaderboardsPlayerCenteredScoresLoaded", Callable(self, "_onLeaderboardsLoadPlayerCenteredScores"))
	_gpgs.connect("leaderboardsTopScoresLoaded", Callable(self, "_onLeaderboardsLoadTopScores"))
	_gpgs.connect("playersCurrentLoaded", Callable(self, "_onPlayersCurrentLoaded"))
	_gpgs.connect("playersFriendsLoaded", Callable(self, "_onPlayersFriendsLoaded"))
	_gpgs.connect("playersSearched", Callable(self, "_onPlayersSearched"))
	_gpgs.connect("signInUserAuthenticated", Callable(self, "_onSignInUserAuthenticated"))
	_gpgs.connect("signInRequestedServerSideAccess", Callable(self, "_onSignInRequestedServerSideAccess"))
	_gpgs.connect("snapshotsGameSaved", Callable(self, "_onSnapshotsGameSaved"))
	_gpgs.connect("snapshotsGameLoaded", Callable(self, "_onSnapshotsGameLoaded"))
	_gpgs.connect("snapshotsConflictEmitted", Callable(self, "_onSnapshotsConflictEmitted"))
	_gpgs.connect("imageStored", Callable(self, "_onImageStored"))
	_gpgs.initialize()

func achievementsIncrement(achievement_id: String, amount: int, immediate := true) -> void:
	_gpgs.achievementsIncrement(achievement_id, amount, immediate)

func achievementsLoad(force_reload := false) -> void:
	_gpgs.achievementsLoad(force_reload)

func achievementsReveal(achievement_id: String, immediate := true) -> void:
	_gpgs.achievementsReveal(achievement_id, immediate)

func achievementsSetSteps(achievement_id: String, amount: int, immediate := true) -> void:
	_gpgs.achievementsSetSteps(achievement_id, amount, immediate)

func achievementsShow() -> void:
	_gpgs.achievementsShow()

func achievementsUnlock(achievement_id: String, immediate := true) -> void:
	_gpgs.achievementsUnlock(achievement_id, immediate)

func eventsIncrement(event_id: String, amount: int) -> void:
	_gpgs.eventsIncrement(event_id, amount)

func eventsLoad(force_reload: bool) -> void:
	_gpgs.eventsLoad(force_reload)

func eventsLoadByIds(force_reload: bool, event_ids: Array) -> void:
	_gpgs.eventsLoadByIds(force_reload, event_ids)

func leaderboardsShowAll() -> void:
	_gpgs.leaderboardsShowAll()

func leaderboardsShow(leaderboard_id: String) -> void:
	_gpgs.leaderboardsShow(leaderboard_id)

func leaderboardsShowForTimeSpan(leaderboard_id: String, time_span: int) -> void:
	_gpgs.leaderboardsShowForTimeSpan(leaderboard_id, time_span)

func leaderboardsShowForTimeSpanAndCollection(leaderboard_id: String, time_span: int, collection: int) -> void:
	_gpgs.leaderboardsShowForTimeSpanAndCollection(leaderboard_id, time_span, collection)

func leaderboardsSubmitScore(leaderboard_id: String, score: float) -> void:
	_gpgs.leaderboardsSubmitScore(leaderboard_id, score)

func leaderboardsLoadPlayerScore(leaderboard_id: String, time_span: int, collection: int) -> void:
	_gpgs.leaderboardsLoadPlayerScore(leaderboard_id, time_span, collection)

func leaderboardsLoadAll(force_reload: bool) -> void:
	_gpgs.leaderboardsLoadAll(force_reload)

func leaderboardsLoad(leaderboard_id: String, force_reload: bool) -> void:
	_gpgs.leaderboardsLoad(leaderboard_id, force_reload)

func leaderboardsLoadPlayerCenteredScores(leaderboard_id: String, time_span: int, collection: int, max_results: int, force_reload: bool) -> void:
	_gpgs.leaderboardsLoadPlayerCenteredScores(leaderboard_id, time_span, collection, max_results, force_reload)

func leaderboardsLoadTopScores(leaderboard_id: String, time_span: int, collection: int, max_results: int, force_reload: bool) -> void:
	_gpgs.leaderboardsLoadTopScores(leaderboard_id, time_span, collection, max_results, force_reload)

# Players
func playersCompareProfile(other_player_id: String) -> void:
	_gpgs.playersCompareProfile(other_player_id)

func playersCompareProfileWithAlternativeNameHints(other_player_id: String, other_player_in_game_name: String, current_player_in_game_name: String) -> void:
	_gpgs.playersCompareProfileWithAlternativeNameHints(
			other_player_id,
			other_player_in_game_name,
			current_player_in_game_name
		)

func playersLoadCurrent(force_reload: bool) -> void:
	_gpgs.playersLoadCurrent(force_reload)

func playersLoadFriends(page_size: int, force_reload: bool, ask_for_permission: bool) -> void:
	_gpgs.playersLoadFriends(page_size, force_reload, ask_for_permission)

func playersSearch() -> void:
	_gpgs.playersSearch()

func signInIsAuthenticated() -> void:
	_gpgs.signInIsAuthenticated()

func signInRequestServerSideAccess(client_id: String, force_refresh_token: bool) -> void:
	_gpgs.signInRequestServerSideAccess(client_id, force_refresh_token)

func signInShowPopup() -> void:
	_gpgs.signInShowPopup()

func snapshotsLoadGame(file_name: String) -> void:
	_gpgs.snapshotsLoadGame(file_name)

func snapshotsSaveGame(file_name: String, description: String, save_data: PackedByteArray, played_time_millis: int,	progress_value: int) -> void:
	_gpgs.snapshotsSaveGame(file_name, description, save_data, played_time_millis, progress_value)

func snapshotsShowSavedGames(title: String, allow_add_button: bool, allow_delete: bool, max_snapshots: int) -> void:
	_gpgs.snapshotsShowSavedGames(title, allow_add_button, allow_delete, max_snapshots)

# REGION Internal

func _output(message) -> void:
	print("%s: %s" % [name, message])

# REGION Callbacks

func _onAchievementsloaded(achievements: String) -> void:
	emit_signal("achievements_loaded", JSON.parse_string(achievements))

func _onAchievementsRevealed(revealed: bool, achievement_id: String) -> void:
	emit_signal("achievements_revealed", revealed, achievement_id)

func _onAchievementsUnlocked(is_unlocked: bool, achievement_id: String) -> void:
	emit_signal("achievements_unlocked", is_unlocked, achievement_id)

func _onEventsLoaded(events: String) -> void:
	emit_signal("events_loaded", JSON.parse_string(events))

func _onEventsLoadedByIds(events: String) -> void:
	emit_signal("events_loaded_by_ids", JSON.parse_string(events))

func _onLeaderboardsScoreSubmitted(submitted: bool, leaderboard_id: String) -> void:
	emit_signal("leaderboards_score_submitted", submitted, leaderboard_id)

func _onLeaderboardsScoreLoaded(leaderboard_id: String, score: String) -> void:
	emit_signal("leaderboards_score_loaded", leaderboard_id, JSON.parse_string(score))

func _onLeaderboardsAllLoaded(leaderboards: String) -> void:
	emit_signal("leaderboards_all_loaded", JSON.parse_string(leaderboards))

func _onLeaderboardsLoaded(leaderboard: String) -> void:
	emit_signal("leaderboards_loaded", JSON.parse_string(leaderboard))

func _onLeaderboardsLoadPlayerCenteredScores(leaderboard_id: String, scores: String) -> void:
	emit_signal("leaderboards_player_centered_scores_loaded", leaderboard_id, JSON.parse_string(scores))

func _onLeaderboardsLoadTopScores(leaderboard_id: String, scores: String) -> void:
	emit_signal("leaderboards_top_scores_loaded", leaderboard_id, JSON.parse_string(scores))

func _onPlayersCurrentLoaded(player: String) -> void:
	emit_signal("players_current_loaded", JSON.parse_string(player))

func _onPlayersFriendsLoaded(friends: String) -> void:
	emit_signal("players_friends_loaded", JSON.parse_string(friends))

func _onPlayersSearched(player: String) -> void:
	emit_signal("players_searched", JSON.parse_string(player))

func _onSignInUserAuthenticated(_is_authenticated: bool) -> void:
	if _is_authenticated:
		authStatus = AUTH_SIGNED_IN
	else:
		authStatus = AUTH_NOT_SIGNED_IN
	emit_signal("sign_in_user_authenticated", _is_authenticated)

func _onSignInRequestedServerSideAccess(token: String) -> void:
	emit_signal("sign_in_requested_server_side_access", token)

func _onSnapshotsGameSaved(saved: bool, file_name: String, description: String) -> void:
	emit_signal("snapshots_game_saved", saved, file_name, description)

func _onSnapshotsGameLoaded(snapshot: String) -> void:
	var parsed_snapshot: Dictionary = JSON.parse_string(snapshot)
	var content: Array = parsed_snapshot.get("content", [])
	if typeof(content) == TYPE_ARRAY:
		parsed_snapshot["content"] = PackedByteArray(content)
	emit_signal("snapshots_game_loaded", parsed_snapshot)

func _onSnapshotsConflictEmitted(conflict: String) -> void:
	emit_signal("snapshots_conflict_emitted", JSON.parse_string(conflict))

func _onImageStored(image: String) -> void:
	emit_signal("image_stored", image)
