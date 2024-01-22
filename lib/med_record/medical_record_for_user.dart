import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'medical_record_database.dart';
import 'package:share/share.dart';
// import 'package:pdf/pdf.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class MedicalRecordUser extends StatefulWidget {
  const MedicalRecordUser({Key? key}) : super(key: key);

  @override
  State<MedicalRecordUser> createState() => _MedicalRecordUserState();
}

class _MedicalRecordUserState extends State<MedicalRecordUser> {
  late Future<List<MedicalRecord>> _medicalRecords;

  @override
  void initState() {
    super.initState();
    _medicalRecords = _fetchMedicalRecords();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medical Records'),
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blue.shade500,
                Colors.blue.shade800,
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () async {
              // Fetch medical records
              List<MedicalRecord> medicalRecords = await _medicalRecords;

              // Create a PDF document
              final pdf = pw.Document();
              for (var medicalRecord in medicalRecords) {
                pdf.addPage(
                  pw.Page(
                    build: (pw.Context context) => _buildPdfContent(medicalRecord),
                  ),
                );
              }

              // Save the PDF to a temporary file
              final tempDir = await getTemporaryDirectory();
              final tempPath = tempDir.path;
              final pdfPath = '$tempPath/medical_records.pdf';
              final File file = File(pdfPath);
              final Uint8List bytes = await pdf.save();
              await file.writeAsBytes(bytes);
              // Share the PDF using the share package
              Share.shareFiles([pdfPath], text: 'Medical Records PDF');
            },
          ),
        ],
      ),
      body: FutureBuilder<List<MedicalRecord>>(
        future: _medicalRecords,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No medical records available.'));
          } else {
            final medicalRecord = snapshot.data![0];
            return _buildMedicalRecordCard(medicalRecord);
          }
        },
      ),
    );
  }

  pw.Widget _buildPdfContent(MedicalRecord medicalRecord) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Name: ${medicalRecord.name}'),
        pw.Text('Date of Birth: ${medicalRecord.dateOfBirth}'),
        pw.Text('Gender: ${medicalRecord.gender}'),
        pw.Text('Allergies: ${medicalRecord.allergies}'),
        pw.Text('Chronic Conditions: ${medicalRecord.chronicConditions}'),
        pw.Text('Previous Surgeries: ${medicalRecord.previousSurgeries}'),
        pw.Text('Hospitalizations: ${medicalRecord.hospitalizations}'),
        pw.Text('Vaccines Received: ${medicalRecord.vaccinesReceived}'),
        pw.Text('Immunization Dates: ${medicalRecord.immunizationDates}'),
        pw.Text('Insurance Provider: ${medicalRecord.insuranceProvider}'),
        pw.Text('Policy Number: ${medicalRecord.policyNumber}'),
        pw.Text('Insurance Contact: ${medicalRecord.insuranceContact}'),
        pw.Text('Primary Care Physician: ${medicalRecord.primaryCarePhysician}'),
        pw.Text('Specialists: ${medicalRecord.specialists}'),
        pw.Text('Doctor Contact: ${medicalRecord.doctorContact}'),
        pw.Text('Test Details: ${medicalRecord.testDetails}'),
        pw.Text('Test Results: ${medicalRecord.testResults}'),
        pw.Text('Appointment Dates: ${medicalRecord.appointmentDates}'),
        pw.Text('Visit Reasons: ${medicalRecord.visitReasons}'),
        pw.Text('Appointment Notes: ${medicalRecord.appointmentNotes}'),
        pw.Text('General Notes: ${medicalRecord.generalNotes}'),
        pw.Text('Symptoms: ${medicalRecord.symptoms}'),
        pw.Text('Emergency Instructions: ${medicalRecord.emergencyInstructions}'),
        pw.Text('Emergency Allergies: ${medicalRecord.emergencyAllergies}'),
        pw.Text('Dietary Restrictions: ${medicalRecord.dietaryRestrictions}'),
        pw.Text('Exercise Routine: ${medicalRecord.exerciseRoutine}'),
        pw.Text('Sleep Details: ${medicalRecord.sleepDetails}'),
        pw.Text('Mental Health Conditions: ${medicalRecord.mentalHealthConditions}'),
        pw.Text('Therapist Contact: ${medicalRecord.therapistContact}'),
      ],
    );
  }

  Widget _buildMedicalRecordCard(MedicalRecord medicalRecord) {
    return FlipCard(
      direction: FlipDirection.HORIZONTAL,
      front: _buildFrontCard(medicalRecord),
      back: _buildBackCard(medicalRecord),
    );
  }

  Widget _buildFrontCard(MedicalRecord medicalRecord) {
    return Card(
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: BorderSide(color: Colors.grey[300]!),
      ),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffdbecf5), Color(0xfff9ebf0)],
            stops: [0.25, 0.75],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Personal Information',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  Icon(
                    Icons.info,
                    color: Colors.blue,
                  ),
                ],
              ),
              const SizedBox(height: 12.0),
              _buildInfoRow('Name', medicalRecord.name, Icons.person),
              _buildInfoRow('Date of Birth', medicalRecord.dateOfBirth, Icons.calendar_today),
              _buildInfoRow('Gender', medicalRecord.gender, Icons.wc),
              _buildInfoRow('Allergies', medicalRecord.allergies, Icons.health_and_safety),
              _buildInfoRow('Chronic Conditions', medicalRecord.chronicConditions, Icons.local_hospital),
              _buildInfoRow('Previous Surgeries', medicalRecord.previousSurgeries, Icons.local_hospital_outlined),
              _buildInfoRow('Hospitalizations', medicalRecord.hospitalizations, Icons.local_hospital_sharp),
              _buildInfoRow('Vaccines Received', medicalRecord.vaccinesReceived, Icons.health_and_safety_sharp),
              _buildInfoRow('Immunization Dates', medicalRecord.immunizationDates, Icons.calendar_today),
              _buildInfoRow('Insurance Provider', medicalRecord.insuranceProvider, Icons.local_hospital),
              _buildInfoRow('Policy Number', medicalRecord.policyNumber, Icons.confirmation_number),
              _buildInfoRow('Insurance Contact', medicalRecord.insuranceContact, Icons.phone),
              _buildInfoRow('Primary Care Physician', medicalRecord.primaryCarePhysician, Icons.local_hospital),
              _buildInfoRow('Specialists', medicalRecord.specialists, Icons.local_hospital),
              _buildInfoRow('Doctor Contact', medicalRecord.doctorContact, Icons.phone),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackCard(MedicalRecord medicalRecord) {
    return Card(
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: BorderSide(color: Colors.grey[300]!),
      ),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffdbecf5), Color(0xfff9ebf0)],
            stops: [0.25, 0.75],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Additional Information',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  Icon(
                    Icons.info,
                    color: Colors.blue,
                  ),
                ],
              ),
              const SizedBox(height: 12.0),
              _buildInfoRow('Test Details', medicalRecord.testDetails, Icons.event),
              _buildInfoRow('Test Results', medicalRecord.testResults, Icons.fact_check),
              _buildInfoRow('Appointment Dates', medicalRecord.appointmentDates, Icons.event),
              _buildInfoRow('Visit Reasons', medicalRecord.visitReasons, Icons.article),
              _buildInfoRow('Appointment Notes', medicalRecord.appointmentNotes, Icons.notes),
              _buildInfoRow('General Notes', medicalRecord.generalNotes, Icons.notes),
              _buildInfoRow('Symptoms', medicalRecord.symptoms, Icons.healing),
              _buildInfoRow('Emergency Instructions', medicalRecord.emergencyInstructions, Icons.warning),
              _buildInfoRow('Emergency Allergies', medicalRecord.emergencyAllergies, Icons.health_and_safety),
              _buildInfoRow('Dietary Restrictions', medicalRecord.dietaryRestrictions, Icons.food_bank),
              _buildInfoRow('Exercise Routine', medicalRecord.exerciseRoutine, Icons.directions_run),
              _buildInfoRow('Sleep Details', medicalRecord.sleepDetails, Icons.access_time),
              _buildInfoRow('Mental Health Conditions', medicalRecord.mentalHealthConditions, Icons.psychology),
              _buildInfoRow('Therapist Contact', medicalRecord.therapistContact, Icons.phone),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          const SizedBox(width: 8.0),
          Text(
            '$label:',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Future<List<MedicalRecord>> _fetchMedicalRecords() async {
    // Try to fetch from shared preferences
    final prefs = await SharedPreferences.getInstance();
    final savedRecords = prefs.getString('latestMedicalRecord');

    if (savedRecords != null) {
      final Map<String, dynamic> savedRecord = jsonDecode(savedRecords);
      final List<Map<String, dynamic>> recordList = [savedRecord];
      return recordList.map((record) => MedicalRecord.fromJson(record)).toList();
    }

    // If not found, fetch from the database
    final records = MedicalRecordDatabase().getMedicalRecords();

    // Save to shared preferences for future use
    prefs.setString('medical_records', jsonEncode(records));

    return records;
  }

}
