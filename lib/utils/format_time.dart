/// Shows mm:ss normally, and tenths of a second when under 10 seconds.
String formatTime(Duration d) {
  if (d < const Duration(seconds: 10)) {
    return (d.inMilliseconds ~/ 100 / 10).toStringAsFixed(1);
  }
  final h = d.inHours;
  final m = (d.inMinutes % 60).toString().padLeft(2, '0');
  final s = (d.inSeconds % 60).toString().padLeft(2, '0');
  return h > 0 ? '$h:$m:$s' : '$m:$s';
}
