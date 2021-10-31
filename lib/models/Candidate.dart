class Candidate{
  final int candidateNumber;
  final String candidateTitle;
  final String candidateName;

  Candidate({
    required this.candidateNumber,
    required this.candidateTitle,
    required this.candidateName,
  });

  factory Candidate.fromJson(Map<String, dynamic> json) {
    return Candidate(
      candidateNumber: json['candidateNumber'],
      candidateTitle: json['candidateTitle'],
      candidateName: json['candidateName'],
    );
  }

 Candidate.fromJson2(Map<String, dynamic> json)
      : candidateNumber = json['candidateNumber'],
       candidateTitle = json['candidateTitle'],
       candidateName = json['candidateName'];

  @override
  String toString() {
    return "";
  }
}