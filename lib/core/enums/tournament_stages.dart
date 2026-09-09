enum TournamentStage {
  groupStage(label: 'الدوري', code: 'groups'),
  quarterFinal(label: 'ربع النهائي', code: 'province_league'),
  semiFinal(label: 'نصف النهائي', code: 'inter_province_tournament'),
  finalMatch(label: 'النهائي', code: 'grand_final');

  final String label;
  final String code;

  const TournamentStage({required this.label, required this.code});
}
