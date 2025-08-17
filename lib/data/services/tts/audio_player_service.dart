import 'dart:typed_data';
import 'package:audioplayers/audioplayers.dart';
import '../../../core/utils/logger.dart';

class AudioPlayerService {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;

  AudioPlayerService() {
    _setupListeners();
  }

  void _setupListeners() {
    _audioPlayer.onPlayerComplete.listen((_) {
      _isPlaying = false;
      Logger.info('Audio playback completed');
    });

    _audioPlayer.onPlayerStateChanged.listen((state) {
      _isPlaying = state == PlayerState.playing;
      Logger.debug('Audio player state: $state');
    });
  }

  Future<void> playAudio(Uint8List audioData) async {
    try {
      await stop();
      
      final source = BytesSource(audioData);
      await _audioPlayer.play(source);
      _isPlaying = true;
      
      Logger.success('Started audio playback');
    } catch (e) {
      Logger.error('Failed to play audio', e);
      rethrow;
    }
  }

  Future<void> playFromUrl(String url) async {
    try {
      await stop();
      
      final source = UrlSource(url);
      await _audioPlayer.play(source);
      _isPlaying = true;
      
      Logger.success('Started audio playback from URL');
    } catch (e) {
      Logger.error('Failed to play audio from URL', e);
      rethrow;
    }
  }

  Future<void> pause() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
      Logger.info('Audio playback paused');
    }
  }

  Future<void> resume() async {
    if (!_isPlaying) {
      await _audioPlayer.resume();
      Logger.info('Audio playback resumed');
    }
  }

  Future<void> stop() async {
    if (_isPlaying) {
      await _audioPlayer.stop();
      _isPlaying = false;
      Logger.info('Audio playback stopped');
    }
  }

  Future<void> setVolume(double volume) async {
    await _audioPlayer.setVolume(volume.clamp(0.0, 1.0));
  }

  Future<void> setPlaybackRate(double rate) async {
    await _audioPlayer.setPlaybackRate(rate.clamp(0.5, 2.0));
  }

  bool get isPlaying => _isPlaying;

  Stream<PlayerState> get onPlayerStateChanged => 
      _audioPlayer.onPlayerStateChanged;

  Stream<Duration> get onPositionChanged => 
      _audioPlayer.onPositionChanged;

  Stream<Duration> get onDurationChanged => 
      _audioPlayer.onDurationChanged;

  void dispose() {
    _audioPlayer.dispose();
    Logger.info('AudioPlayerService disposed');
  }
}