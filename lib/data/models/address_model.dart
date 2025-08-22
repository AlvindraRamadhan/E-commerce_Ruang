class Address {
  final String? id;
  final String fullName;
  final String phoneNumber;
  final String address;
  final String city;
  final String province;
  final String postalCode;
  final bool isDefault;

  Address({
    this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.address,
    required this.city,
    required this.province,
    required this.postalCode,
    this.isDefault = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'address': address,
      'city': city,
      'province': province,
      'postalCode': postalCode,
      'isDefault': isDefault,
    };
  }

  factory Address.fromFirestore(Map<String, dynamic> data, String documentId) {
    return Address(
      id: documentId,
      fullName: data['fullName'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      address: data['address'] ?? '',
      city: data['city'] ?? '',
      province: data['province'] ?? '',
      postalCode: data['postalCode'] ?? '',
      isDefault: data['isDefault'] ?? false,
    );
  }
}
