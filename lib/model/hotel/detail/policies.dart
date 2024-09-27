class HotelPolicies {
  final String checkIn;
  final String checkOut;
  final String accommodationType;
  final String petPolicy;

  HotelPolicies({
    required this.checkIn,
    required this.checkOut,
    required this.accommodationType,
    required this.petPolicy,
  });

  factory HotelPolicies.fromJson(Map<String, dynamic> json) {
    return HotelPolicies(
      checkIn: json['check-In'] ?? 'N/A',
      checkOut: json['check-Out'] ?? 'N/A',
      accommodationType: json['accommodation-Type'] ?? 'N/A',
      petPolicy: json['pet-Policy'] ?? 'Not Allowed',
    );
  }

  Map<String, dynamic> toJson() => {
        "Check-In": checkIn,
        "Check-Out": checkOut,
        "accommodation-Type": accommodationType,
        "Pet-Policy": petPolicy,
      };
}
