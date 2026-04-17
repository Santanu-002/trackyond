class WorkerProfile {
  final String uid;
  final String name;
  final String phone;
  final String designation;
  final String? gender;
  final String? image;

  const WorkerProfile({
    required this.uid,
    required this.name,
    required this.phone,
    required this.designation,
    this.gender,
    this.image,
  });
}
