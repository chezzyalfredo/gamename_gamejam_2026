class_name Audio_Player extends Control

var music_tracks := [
	preload("res://Audio/1 - Phat Phrog Studios - Beat Em Up.wav"), 
	preload("res://Audio/2 - Phat Phrog Studios - Beat Em Up.wav"), 
	preload("res://Audio/3 - Phat Phrog Studios - Beat Em Up.wav"), 
	preload("res://Audio/7 - Phat Phrog Studios - Beat Em Up.wav"), 
	preload("res://Audio/8 - Phat Phrog Studios - Beat Em Up.wav")]
@onready var music : AudioStreamPlayer = $Music
@onready var sound : AudioStreamPlayer = $Sound_Effect
var rng : RandomNumberGenerator = RandomNumberGenerator.new()
var last_played := -1

func _process(_delta: float) -> void:
	if music.playing:
		return
	var next_track := rng.randi_range(0, music_tracks.size()-1)
	while next_track == last_played:
		next_track = rng.randi_range(0, music_tracks.size()-1)
	music.stream = music_tracks.get(next_track)
	music.play()
	last_played = next_track

func play_growl() -> void:
	sound.play()
