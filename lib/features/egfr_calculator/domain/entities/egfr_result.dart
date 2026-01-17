/// Entity representing eGFR calculation result
class EgfrResult {
  final double serumCreatinine; // in μmol/L
  final double? cystatinC; // in mg/L, optional
  final int age;
  final bool isMale;
  final double serumCreatinineMgPerDl; // converted to mg/dL
  final EgfrFormulaType formulaUsed;
  final double egfr; // in mL/min/1.73 m²
  final CkdStage ckdStage;

  const EgfrResult({
    required this.serumCreatinine,
    this.cystatinC,
    required this.age,
    required this.isMale,
    required this.serumCreatinineMgPerDl,
    required this.formulaUsed,
    required this.egfr,
    required this.ckdStage,
  });
}

/// Type of eGFR formula used
enum EgfrFormulaType {
  creatinineOnly, // CKD-EPI 2021
  cystatinCOnly, // CKD-EPI 2012 cystatin C
  combined, // CKD-EPI 2012 combined (most accurate)
}

/// CKD Stage classification (KDIGO 2023)
enum CkdStage {
  g1, // ≥ 90
  g2, // 60–89
  g3a, // 45–59
  g3b, // 30–44
  g4, // 15–29
  g5, // < 15
}
