/// Types de subdivision pour un bloc de tempo.
enum SubdivisionType {
  none('None', 1),
  eighth('Croches', 2),
  triplet('Triolets', 3),
  sixteenth('Doubles-croches', 4);

  const SubdivisionType(this.label, this.divisor);
  final String label;
  final int divisor;
}

/// Dénominateurs autorisés pour la signature rythmique.
enum Denominator {
  whole(1, '1'),
  half(2, '2'),
  quarter(4, '4'),
  eighth(8, '8'),
  sixteenth(16, '16');

  const Denominator(this.value, this.label);
  final int value;
  final String label;
}

/// Noms de tempo par plage de BPM.
class TempoName {
  TempoName._();

  static String fromBpm(int bpm) {
    if (bpm < 60) return 'Largo';
    if (bpm < 66) return 'Larghetto';
    if (bpm < 76) return 'Adagio';
    if (bpm < 108) return 'Andante';
    if (bpm < 120) return 'Moderato';
    if (bpm < 156) return 'Allegro';
    if (bpm < 176) return 'Vivace';
    if (bpm < 200) return 'Presto';
    return 'Prestissimo';
  }
}
