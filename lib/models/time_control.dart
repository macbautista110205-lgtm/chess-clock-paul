/// One saved time setting, like "Blitz, 3 min + 2s".
class TimeControl {
  const TimeControl({
    required this.id,
    required this.name,
    required this.base,
    this.increment = Duration.zero,
  });

  final String id;
  final String name;
  final Duration base;
  final Duration increment;

  String get summary {
    final m = base.inMinutes;
    final s = base.inSeconds % 60;
    final b = s == 0 ? '$m min' : '$m:${s.toString().padLeft(2, '0')}';
    return '$b + ${increment.inSeconds}s';
  }

  TimeControl copyWith({String? name, Duration? base, Duration? increment}) =>
      TimeControl(
        id: id,
        name: name ?? this.name,
        base: base ?? this.base,
        increment: increment ?? this.increment,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'base': base.inSeconds,
        'inc': increment.inSeconds,
      };

  factory TimeControl.fromJson(Map<String, dynamic> j) => TimeControl(
        id: j['id'] as String,
        name: j['name'] as String,
        base: Duration(seconds: j['base'] as int),
        increment: Duration(seconds: j['inc'] as int),
      );

  static String newId() => DateTime.now().microsecondsSinceEpoch.toString();
}

const defaultControls = [
  TimeControl(id: 'bullet1', name: 'Bullet', base: Duration(minutes: 1)),
  TimeControl(
      id: 'blitz3', name: 'Blitz', base: Duration(minutes: 3), increment: Duration(seconds: 2)),
  TimeControl(id: 'blitz5', name: 'Blitz', base: Duration(minutes: 5)),
  TimeControl(id: 'rapid10', name: 'Rapid', base: Duration(minutes: 10)),
  TimeControl(
      id: 'rapid15', name: 'Rapid', base: Duration(minutes: 15), increment: Duration(seconds: 10)),
];
