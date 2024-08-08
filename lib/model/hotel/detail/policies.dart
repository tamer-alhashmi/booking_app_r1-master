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
      checkIn: json['Check in'] ?? 'N/A',
      checkOut: json['Check out'] ?? 'N/A',
      accommodationType: json['Accommodation Type'] ?? 'N/A',
      petPolicy: json['Pet Policy'] ?? 'N/A',
    );
  }

  Map<String, dynamic> toJson() => {
        "Check in": checkIn,
        "Check out": checkOut,
        "Accommodation Type": accommodationType,
        "Pet Policy": petPolicy,
      };
}
