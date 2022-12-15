A player for short audio asset files, such as beeps.

On Android, this uses the `SoundPool` API, with audio attributes set to
`AudioAttributes.USAGE_ASSISTANCE_SONIFICATION` and
`AudioAttributes.CONTENT_TYPE_SONIFICATION` with max streams of 1.

On iOS, this uses the `AVAudioPlayer` API, with audio category set to
`AVAudioSessionCategoryAmbient`.

## Getting Started

Before any calls to `BeepPlayer.play`, the audio file needs to be loaded first
using `BeepPlayer.load`, otherwise it will silently fail. Don't forget to unload it when no longer needed.

Example:
```dart
static const BeepFile _beepFile = BeepFile(
    'assets/sounds/beep.wav',
    package: 'package1',
);

@override
void initState() {
    super.initState();
    BeepPlayer.load(_beepFile);
}

@override
void dispose() {
    BeepPlayer.unload(_beepFile);
    super.dispose();
}

@override
Widget build(BuildContext context) {
    ...
}

void _onPressed() {
    BeepPlayer.play(_beepFile);
}
```

