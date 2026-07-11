extends Node

const MIX_RATE := 44100.0
const VOICE_COUNT := 4

class Voice:
	var player: AudioStreamPlayer
	var playback: AudioStreamGeneratorPlayback
	var freq: float = 0.0
	var duration: float = 0.0
	var elapsed: float = 0.0
	var active: bool = false
	var wave: String = "sine"

var voices: Array = []

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	for i in range(VOICE_COUNT):
		var v := Voice.new()
		var p := AudioStreamPlayer.new()
		var gen := AudioStreamGenerator.new()
		gen.mix_rate = MIX_RATE
		gen.buffer_length = 0.15
		p.stream = gen
		p.process_mode = Node.PROCESS_MODE_ALWAYS
		add_child(p)
		v.player = p
		voices.append(v)

func _volume_scale() -> float:
	var settings: Dictionary = SaveManager.data.settings
	if settings.get("muted", false):
		return 0.0
	return clamp(float(settings.get("sfx_volume", 1.0)), 0.0, 1.0)

func _find_free_voice() -> Voice:
	for v: Voice in voices:
		if not v.active:
			return v
	return voices[0]

func play_tone(freq: float, duration: float, wave: String = "sine") -> void:
	if _volume_scale() <= 0.0:
		return
	var v: Voice = _find_free_voice()
	v.freq = freq
	v.duration = duration
	v.elapsed = 0.0
	v.wave = wave
	v.active = true
	v.player.play()
	v.playback = v.player.get_stream_playback()

func play_jump() -> void:
	play_tone(520.0, 0.12, "sine")

func play_collect() -> void:
	play_tone(880.0, 0.10, "sine")

func play_button() -> void:
	play_tone(440.0, 0.05, "square")

func play_death() -> void:
	play_tone(140.0, 0.3, "square")

func play_shield_break() -> void:
	play_tone(950.0, 0.22, "sine")

func play_powerup() -> void:
	play_tone(1200.0, 0.18, "sine")

func _process(delta: float) -> void:
	var volume: float = _volume_scale()
	for v: Voice in voices:
		if not v.active or v.playback == null:
			continue
		v.elapsed += delta
		var frames_available: int = v.playback.get_frames_available()
		if frames_available > 0:
			var fade := 0.02
			var env := 1.0
			if v.elapsed < fade:
				env = v.elapsed / fade
			elif v.elapsed > v.duration - fade:
				env = max(0.0, (v.duration - v.elapsed) / fade)
			for i in range(frames_available):
				var sample_time: float = v.elapsed + float(i) / MIX_RATE
				var value: float = 0.0
				if v.wave == "sine":
					value = sin(TAU * v.freq * sample_time)
				else:
					value = sign(sin(TAU * v.freq * sample_time))
				value *= 0.4 * env * volume
				v.playback.push_frame(Vector2(value, value))
		if v.elapsed >= v.duration:
			v.active = false
			v.player.stop()
