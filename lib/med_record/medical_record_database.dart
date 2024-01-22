import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class MedicalRecordDatabase {
  static final MedicalRecordDatabase _instance = MedicalRecordDatabase._internal();
  factory MedicalRecordDatabase() {
    return _instance;
  }

  MedicalRecordDatabase._internal(){
    _loadMedicalRecords();
  }

  final List<MedicalRecord> _medicalRecords = [];

  Future<void> _loadMedicalRecords() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedRecords = prefs.getString('medicalRecords');
    if (savedRecords != null) {
      final List<Map<String, dynamic>> recordList = jsonDecode(savedRecords);
      _medicalRecords.clear();
      _medicalRecords.addAll(recordList.map((record) => MedicalRecord.fromJson(record)));
    }
  }

  Future<void> saveMedicalRecord(MedicalRecord medicalRecord) async {
    _medicalRecords.add(medicalRecord);
    final prefs = await SharedPreferences.getInstance();
    final latestMedicalRecordJson = medicalRecord.toJson();
    await prefs.setString('latestMedicalRecord', jsonEncode(latestMedicalRecordJson));
  }

  List<MedicalRecord> getMedicalRecords() {
    return List.from(_medicalRecords);
  }
}

class MedicalRecord {
  final String name;
  final String dateOfBirth;
  final String gender;
  final String allergies;
  final String chronicConditions;
  final String previousSurgeries;
  final String hospitalizations;
  final String vaccinesReceived;
  final String immunizationDates;
  final String insuranceProvider;
  final String policyNumber;
  final String insuranceContact;
  final String primaryCarePhysician;
  final String specialists;
  final String doctorContact;
  final String testDetails;
  final String testResults;
  final String appointmentDates;
  final String visitReasons;
  final String appointmentNotes;
  final String generalNotes;
  final String symptoms;
  final String emergencyInstructions;
  final String emergencyAllergies;
  final String dietaryRestrictions;
  final String exerciseRoutine;
  final String sleepDetails;
  final String mentalHealthConditions;
  final String therapistContact;

  MedicalRecord({
    required this.name,
    required this.dateOfBirth,
    required this.gender,
    required this.allergies,
    required this.chronicConditions,
    required this.previousSurgeries,
    required this.hospitalizations,
    required this.vaccinesReceived,
    required this.immunizationDates,
    required this.insuranceProvider,
    required this.policyNumber,
    required this.insuranceContact,
    required this.primaryCarePhysician,
    required this.specialists,
    required this.doctorContact,
    required this.testDetails,
    required this.testResults,
    required this.appointmentDates,
    required this.visitReasons,
    required this.appointmentNotes,
    required this.generalNotes,
    required this.symptoms,
    required this.emergencyInstructions,
    required this.emergencyAllergies,
    required this.dietaryRestrictions,
    required this.exerciseRoutine,
    required this.sleepDetails,
    required this.mentalHealthConditions,
    required this.therapistContact,
  });

  factory MedicalRecord.fromJson(Map<String, dynamic> json) {
    return MedicalRecord(
      name: json['name'],
      dateOfBirth: json['dateOfBirth'],
      gender: json['gender'],
      allergies: json['allergies'],
      chronicConditions: json['chronicConditions'],
      previousSurgeries: json['previousSurgeries'],
      hospitalizations: json['hospitalizations'],
      vaccinesReceived: json['vaccinesReceived'],
      immunizationDates: json['immunizationDates'],
      insuranceProvider: json['insuranceProvider'],
      policyNumber: json['policyNumber'],
      insuranceContact: json['insuranceContact'],
      primaryCarePhysician: json['primaryCarePhysician'],
      specialists: json['specialists'],
      doctorContact: json['doctorContact'],
      testDetails: json['testDetails'],
      testResults: json['testResults'],
      appointmentDates: json['appointmentDates'],
      visitReasons: json['visitReasons'],
      appointmentNotes: json['appointmentNotes'],
      generalNotes: json['generalNotes'],
      symptoms: json['symptoms'],
      emergencyInstructions: json['emergencyInstructions'],
      emergencyAllergies: json['emergencyAllergies'],
      dietaryRestrictions: json['dietaryRestrictions'],
      exerciseRoutine: json['exerciseRoutine'],
      sleepDetails: json['sleepDetails'],
      mentalHealthConditions: json['mentalHealthConditions'],
      therapistContact: json['therapistContact'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
      'allergies': allergies,
      'chronicConditions': chronicConditions,
      'previousSurgeries': previousSurgeries,
      'hospitalizations': hospitalizations,
      'vaccinesReceived': vaccinesReceived,
      'immunizationDates': immunizationDates,
      'insuranceProvider': insuranceProvider,
      'policyNumber': policyNumber,
      'insuranceContact': insuranceContact,
      'primaryCarePhysician': primaryCarePhysician,
      'specialists': specialists,
      'doctorContact': doctorContact,
      'testDetails': testDetails,
      'testResults': testResults,
      'appointmentDates': appointmentDates,
      'visitReasons': visitReasons,
      'appointmentNotes': appointmentNotes,
      'generalNotes': generalNotes,
      'symptoms': symptoms,
      'emergencyInstructions': emergencyInstructions,
      'emergencyAllergies': emergencyAllergies,
      'dietaryRestrictions': dietaryRestrictions,
      'exerciseRoutine': exerciseRoutine,
      'sleepDetails': sleepDetails,
      'mentalHealthConditions': mentalHealthConditions,
      'therapistContact': therapistContact,
    };
}
}
