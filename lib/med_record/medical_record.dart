import 'dart:convert';

import 'package:elder_link/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'medical_record_database.dart';

class AddMedicalRecordPage extends StatefulWidget {
  const AddMedicalRecordPage({Key? key}) : super(key: key);

  @override
  _AddMedicalRecordPageState createState() => _AddMedicalRecordPageState();

}

class _AddMedicalRecordPageState extends State<AddMedicalRecordPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController genderController = TextEditingController();

  TextEditingController allergiesController = TextEditingController();
  TextEditingController chronicConditionsController = TextEditingController();
  TextEditingController surgeriesController = TextEditingController();
  TextEditingController hospitalizationsController = TextEditingController();

  TextEditingController vaccinesReceivedController = TextEditingController();
  TextEditingController immunizationDatesController = TextEditingController();

  TextEditingController insuranceProviderController = TextEditingController();
  TextEditingController policyNumberController = TextEditingController();
  TextEditingController insuranceContactController = TextEditingController();

  TextEditingController primaryCarePhysicianController = TextEditingController();
  TextEditingController specialistsController = TextEditingController();
  TextEditingController doctorContactController = TextEditingController();

  TextEditingController testDetailsController = TextEditingController();
  TextEditingController testResultsController = TextEditingController();

  TextEditingController appointmentDatesController = TextEditingController();
  TextEditingController visitReasonsController = TextEditingController();
  TextEditingController appointmentNotesController = TextEditingController();

  TextEditingController generalNotesController = TextEditingController();
  TextEditingController symptomsController = TextEditingController();

  TextEditingController emergencyInstructionsController = TextEditingController();
  TextEditingController emergencyAllergiesController = TextEditingController();

  TextEditingController dietaryRestrictionsController = TextEditingController();
  TextEditingController exerciseRoutineController = TextEditingController();

  TextEditingController sleepDetailsController = TextEditingController();

  TextEditingController mentalHealthConditionsController = TextEditingController();
  TextEditingController therapistContactController = TextEditingController();
  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();
  String nameControllerValue = '';
  String dobControllerValue = '';
  String genderControllerValue = '';
  String allergiesControllerValue = '';
  String chronicConditionsControllerValue = '';
  String surgeriesControllerValue = '';
  String hospitalizationsControllerValue = '';
  String vaccinesReceivedControllerValue = '';
  String immunizationDatesControllerValue = '';
  String insuranceProviderControllerValue = '';
  String policyNumberControllerValue = '';
  String insuranceContactControllerValue = '';
  String primaryCarePhysicianControllerValue = '';
  String specialistsControllerValue = '';
  String doctorContactControllerValue = '';
  String testDetailsControllerValue = '';
  String testResultsControllerValue = '';
  String appointmentDatesControllerValue = '';
  String visitReasonsControllerValue = '';
  String appointmentNotesControllerValue = '';
  String generalNotesControllerValue = '';
  String symptomsControllerValue = '';
  String emergencyInstructionsControllerValue = '';
  String emergencyAllergiesControllerValue = '';
  String dietaryRestrictionsControllerValue = '';
  String exerciseRoutineControllerValue = '';
  String sleepDetailsControllerValue = '';
  String mentalHealthConditionsControllerValue = '';
  String therapistContactControllerValue = '';
  bool areMedicalRecordsSaved = false;

  MedicalRecord latestMedicalRecord = MedicalRecord(
      name: '',
      dateOfBirth: '',
      gender: '',
      allergies: '',
      chronicConditions: '',
      previousSurgeries: '',
      hospitalizations: '',
      vaccinesReceived: '',
      immunizationDates: '',
      insuranceProvider: '',
      policyNumber: '',
      insuranceContact: '',
      primaryCarePhysician: '',
      specialists: '',
      doctorContact: '',
      testDetails: '',
      testResults: '',
      appointmentDates: '',
      visitReasons: '',
      appointmentNotes: '',
      generalNotes: '',
      symptoms: '',
      emergencyInstructions: '',
      emergencyAllergies: '',
      dietaryRestrictions: '',
      exerciseRoutine: '',
      sleepDetails: '',
      mentalHealthConditions: '',
      therapistContact: ''
  );

  @override
  void initState() {
    super.initState();
    loadLatestMedicalRecord();
  }

  void loadLatestMedicalRecord() async {

    final prefs = await SharedPreferences.getInstance();
    String? latestMedicalRecordJson = prefs.getString('latestMedicalRecord');
    if (latestMedicalRecordJson != null) {
      Map<String, dynamic> latestMedicalRecordMap = jsonDecode(latestMedicalRecordJson);

      setState(() {
        latestMedicalRecord = MedicalRecord(
          name: latestMedicalRecordMap['name'],
          dateOfBirth: latestMedicalRecordMap['dateOfBirth'],
          gender: latestMedicalRecordMap['gender'],
          allergies: latestMedicalRecordMap['allergies'],
          chronicConditions: latestMedicalRecordMap['chronicConditions'],
          previousSurgeries: latestMedicalRecordMap['previousSurgeries'],
          hospitalizations: latestMedicalRecordMap['hospitalizations'],
          vaccinesReceived: latestMedicalRecordMap['vaccinesReceived'],
          immunizationDates: latestMedicalRecordMap['immunizationDates'],
          insuranceProvider: latestMedicalRecordMap['insuranceProvider'],
          policyNumber: latestMedicalRecordMap['policyNumber'],
          insuranceContact: latestMedicalRecordMap['insuranceContact'],
          primaryCarePhysician: latestMedicalRecordMap['primaryCarePhysician'],
          specialists: latestMedicalRecordMap['specialists'],
          doctorContact: latestMedicalRecordMap['doctorContact'],
          testDetails: latestMedicalRecordMap['testDetails'],
          testResults: latestMedicalRecordMap['testResults'],
          appointmentDates: latestMedicalRecordMap['appointmentDates'],
          visitReasons: latestMedicalRecordMap['visitReasons'],
          appointmentNotes: latestMedicalRecordMap['appointmentNotes'],
          generalNotes: latestMedicalRecordMap['generalNotes'],
          symptoms: latestMedicalRecordMap['symptoms'],
          emergencyInstructions: latestMedicalRecordMap['emergencyInstructions'],
          emergencyAllergies: latestMedicalRecordMap['emergencyAllergies'],
          dietaryRestrictions: latestMedicalRecordMap['dietaryRestrictions'],
          exerciseRoutine: latestMedicalRecordMap['exerciseRoutine'],
          sleepDetails: latestMedicalRecordMap['sleepDetails'],
          mentalHealthConditions: latestMedicalRecordMap['mentalHealthConditions'],
          therapistContact: latestMedicalRecordMap['therapistContact'],
        );
        nameController.text = latestMedicalRecord.name;
        dobController.text = latestMedicalRecord.dateOfBirth;
        genderController.text = latestMedicalRecord.gender;
        allergiesController.text = latestMedicalRecord.allergies;
        chronicConditionsController.text = latestMedicalRecord.chronicConditions;
        surgeriesController.text = latestMedicalRecord.previousSurgeries;
        hospitalizationsController.text = latestMedicalRecord.hospitalizations;
        vaccinesReceivedController.text = latestMedicalRecord.vaccinesReceived;
        immunizationDatesController.text = latestMedicalRecord.immunizationDates;
        insuranceProviderController.text = latestMedicalRecord.insuranceProvider;
        policyNumberController.text = latestMedicalRecord.policyNumber;
        insuranceContactController.text = latestMedicalRecord.insuranceContact;
        primaryCarePhysicianController.text = latestMedicalRecord.primaryCarePhysician;
        specialistsController.text = latestMedicalRecord.specialists;
        doctorContactController.text = latestMedicalRecord.doctorContact;
        testDetailsController.text = latestMedicalRecord.testDetails;
        testResultsController.text = latestMedicalRecord.testResults;
        appointmentDatesController.text = latestMedicalRecord.appointmentDates;
        visitReasonsController.text = latestMedicalRecord.visitReasons;
        appointmentNotesController.text = latestMedicalRecord.appointmentNotes;
        generalNotesController.text = latestMedicalRecord.generalNotes;
        symptomsController.text = latestMedicalRecord.symptoms;
        emergencyInstructionsController.text = latestMedicalRecord.emergencyInstructions;
        emergencyAllergiesController.text = latestMedicalRecord.emergencyAllergies;
        dietaryRestrictionsController.text = latestMedicalRecord.dietaryRestrictions;
        exerciseRoutineController.text = latestMedicalRecord.exerciseRoutine;
        sleepDetailsController.text = latestMedicalRecord.sleepDetails;
        mentalHealthConditionsController.text = latestMedicalRecord.mentalHealthConditions;
        therapistContactController.text = latestMedicalRecord.therapistContact;

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Medical Record'),
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
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffdbecf5), Color(0xfff9ebf0)],
            stops: [0.25, 0.75],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Patient Information
              _buildSectionHeader('Patient Information'),
              _buildTextField('Name', nameController, Icons.person),
              _buildTextField('Date of Birth', dobController, Icons.calendar_today),
              _buildTextField('Gender', genderController, Icons.wc),

              // Medical History
              _buildSectionHeader('Medical History'),
              _buildTextField('Allergies', allergiesController, Icons.health_and_safety),
              _buildTextField('Chronic Conditions', chronicConditionsController, Icons.local_hospital),
              _buildTextField('Previous Surgeries', surgeriesController, Icons.local_hospital_outlined),
              _buildTextField('Hospitalizations', hospitalizationsController, Icons.local_hospital_sharp),

              // Immunization History
              _buildSectionHeader('Immunization History'),
              _buildTextField('Vaccines Received', vaccinesReceivedController, Icons.health_and_safety_sharp),
              _buildTextField('Dates of Immunization', immunizationDatesController, Icons.calendar_today),

              // Insurance Information
              _buildSectionHeader('Insurance Information'),
              _buildTextField('Insurance Provider', insuranceProviderController, Icons.local_hospital),
              _buildTextField('Policy Number', policyNumberController, Icons.confirmation_number),
              _buildTextField('Contact Information', insuranceContactController, Icons.phone),

              // Doctor Information
              _buildSectionHeader('Doctor Information'),
              _buildTextField('Primary Care Physician', primaryCarePhysicianController, Icons.local_hospital),
              _buildTextField('Specialists', specialistsController, Icons.local_hospital),
              _buildTextField('Contact Information', doctorContactController, Icons.phone),

              // Diagnostic Tests and Results
              _buildSectionHeader('Diagnostic Tests and Results'),
              _buildTextField('Dates and Details of Tests', testDetailsController, Icons.event),
              _buildTextField('Results and Interpretations', testResultsController, Icons.fact_check),

              // Appointments and Visits
              _buildSectionHeader('Appointments and Visits'),
              _buildTextField('Dates of Appointments', appointmentDatesController, Icons.event),
              _buildTextField('Reasons for Visits', visitReasonsController, Icons.article),
              _buildTextField('Notes from Appointments', appointmentNotesController, Icons.notes),

              // Notes Section
              _buildSectionHeader('Notes Section'),
              _buildTextField('General Notes', generalNotesController, Icons.notes),
              _buildTextField('Symptoms Experienced', symptomsController, Icons.healing),

              // Emergency Medical Plan
              _buildSectionHeader('Emergency Medical Plan'),
              _buildTextField('Emergency Instructions', emergencyInstructionsController, Icons.dangerous),
              _buildTextField('Allergies or Conditions', emergencyAllergiesController, Icons.health_and_safety),

              // Diet and Exercise
              _buildSectionHeader('Diet and Exercise'),
              _buildTextField('Dietary Restrictions', dietaryRestrictionsController, Icons.food_bank),
              _buildTextField('Exercise Routine', exerciseRoutineController, Icons.directions_run),

              // Sleep Patterns
              _buildSectionHeader('Sleep Patterns'),
              _buildTextField('Sleep Duration and Quality', sleepDetailsController, Icons.access_time),

              // Mental Health
              _buildSectionHeader('Mental Health'),
              _buildTextField('Mental Health Conditions', mentalHealthConditionsController, Icons.psychology),
              _buildTextField('Therapist or Counselor Contact', therapistContactController, Icons.phone),

              ElevatedButton(
                onPressed: () async {
                  MedicalRecord medicalRecord = MedicalRecord(
                    name: nameController.text,
                    dateOfBirth: dobController.text,
                    gender: genderController.text,
                    allergies: allergiesController.text,
                    chronicConditions: chronicConditionsController.text,
                    previousSurgeries: surgeriesController.text,
                    hospitalizations: hospitalizationsController.text,
                    vaccinesReceived: vaccinesReceivedController.text,
                    immunizationDates: immunizationDatesController.text,
                    insuranceProvider: insuranceProviderController.text,
                    policyNumber: policyNumberController.text,
                    insuranceContact: insuranceContactController.text,
                    primaryCarePhysician: primaryCarePhysicianController.text,
                    specialists: specialistsController.text,
                    doctorContact: doctorContactController.text,
                    testDetails: testDetailsController.text,
                    testResults: testResultsController.text,
                    appointmentDates: appointmentDatesController.text,
                    visitReasons: visitReasonsController.text,
                    appointmentNotes: appointmentNotesController.text,
                    generalNotes: generalNotesController.text,
                    symptoms: symptomsController.text,
                    emergencyInstructions: emergencyInstructionsController.text,
                    emergencyAllergies: emergencyAllergiesController.text,
                    dietaryRestrictions: dietaryRestrictionsController.text,
                    exerciseRoutine: exerciseRoutineController.text,
                    sleepDetails: sleepDetailsController.text,
                    mentalHealthConditions: mentalHealthConditionsController.text,
                    therapistContact: therapistContactController.text,
                  );

                  // Save the medical record
                  MedicalRecordDatabase().saveMedicalRecord(medicalRecord);

                  setState(() {
                    areMedicalRecordsSaved = true;
                  });
                  showDialog(
                      context: context,
                      builder: (BuildContext context){
                        return _buildMedicalRecordCard(medicalRecord);
                      }
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(100.0, 36.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
                child: const Text('Save Medical Record'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMedicalRecordCard(MedicalRecord medicalRecord) {
    bool isEditing = true;

    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      contentPadding: EdgeInsets.zero,
      content: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          width: MediaQuery.of(context).size.width * 0.8,
          child: SingleChildScrollView(
            child: FlipCard(
              key: cardKey,
              direction: FlipDirection.HORIZONTAL,
              front: _buildFrontCard(medicalRecord),
              back: _buildBackCard(medicalRecord),
            ),
          ),
        ),
      ),
      actions: [
        if (isEditing)
          ElevatedButton(
            onPressed: () {
              setState(() {
                isEditing = false;
              });
              showDialog(
                context: context,
                builder: (BuildContext context)
                {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    title: const Text('Medical Records Saved'),
                    content: const Text(
                        'Your medical records have been successfully saved.'),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          // Close the dialog
                          Navigator.pop(context);
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
                        },
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                        ),
                        child: const Text('OK'),
                      ),
                    ],
                  );
                },
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
            ),
            child: const Text(
              'Save',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ElevatedButton(
          onPressed: () {
            if (isEditing) {
              // Save the changes to shared state
              nameControllerValue = nameController.text;
              dobControllerValue = dobController.text;
              genderControllerValue = genderController.text;
              allergiesControllerValue = allergiesController.text;
              chronicConditionsControllerValue = chronicConditionsController.text;
              surgeriesControllerValue = surgeriesController.text;
              hospitalizationsControllerValue = hospitalizationsController.text;
              vaccinesReceivedControllerValue = vaccinesReceivedController.text;
              immunizationDatesControllerValue = immunizationDatesController.text;
              insuranceProviderControllerValue = insuranceProviderController.text;
              policyNumberControllerValue = policyNumberController.text;
              insuranceContactControllerValue = insuranceContactController.text;
              primaryCarePhysicianControllerValue = primaryCarePhysicianController.text;
              specialistsControllerValue = specialistsController.text;
              doctorContactControllerValue = doctorContactController.text;
              testDetailsControllerValue = testDetailsController.text;
              testResultsControllerValue = testResultsController.text;
              appointmentDatesControllerValue = appointmentDatesController.text;
              visitReasonsControllerValue = visitReasonsController.text;
              appointmentNotesControllerValue = appointmentNotesController.text;
              generalNotesControllerValue = generalNotesController.text;
              symptomsControllerValue = symptomsController.text;
              emergencyInstructionsControllerValue = emergencyInstructionsController.text;
              emergencyAllergiesControllerValue = emergencyAllergiesController.text;
              dietaryRestrictionsControllerValue = dietaryRestrictionsController.text;
              exerciseRoutineControllerValue = exerciseRoutineController.text;
              sleepDetailsControllerValue = sleepDetailsController.text;
              mentalHealthConditionsControllerValue = mentalHealthConditionsController.text;
              therapistContactControllerValue = therapistContactController.text;
              Navigator.pop(context);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
          ),
          child: Text(
            isEditing ? 'Edit' : 'View',
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),


        if (!isEditing)
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: const Text(
              'Close',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
      ],
    );

  }

  Widget _buildFrontCard(MedicalRecord medicalRecord) {
    return Card(
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: BorderSide(color: Colors.grey[300]!),
      ),
      child: InkWell(
        onTap: () {
          cardKey.currentState?.toggleCard();
        },
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
              const Divider(color: Colors.grey),
              _buildInfoRow('Allergies', medicalRecord.allergies, Icons.health_and_safety),
              _buildInfoRow('Chronic Conditions', medicalRecord.chronicConditions, Icons.local_hospital),
              _buildInfoRow('Previous Surgeries', medicalRecord.previousSurgeries, Icons.local_hospital_outlined),
              _buildInfoRow('Hospitalizations', medicalRecord.hospitalizations, Icons.local_hospital_sharp),
              const Divider(color: Colors.grey),
              _buildInfoRow('Vaccines Received', medicalRecord.vaccinesReceived, Icons.health_and_safety_sharp),
              _buildInfoRow('Immunization Dates', medicalRecord.immunizationDates, Icons.calendar_today),
              const Divider(color: Colors.grey),
              _buildInfoRow('Insurance Provider', medicalRecord.insuranceProvider, Icons.local_hospital),
              _buildInfoRow('Policy Number', medicalRecord.policyNumber, Icons.confirmation_number),
              _buildInfoRow('Insurance Contact', medicalRecord.insuranceContact, Icons.phone),
              const Divider(color: Colors.grey),
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
      child: InkWell(
        onTap: () {
          // Flip the card back
          cardKey.currentState?.toggleCard();
        },
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
              const Divider(color: Colors.grey),
              _buildInfoRow('Appointment Dates', medicalRecord.appointmentDates, Icons.event),
              _buildInfoRow('Visit Reasons', medicalRecord.visitReasons, Icons.article),
              _buildInfoRow('Appointment Notes', medicalRecord.appointmentNotes, Icons.notes),
              const Divider(color: Colors.grey),
              _buildInfoRow('General Notes', medicalRecord.generalNotes, Icons.notes),
              _buildInfoRow('Symptoms', medicalRecord.symptoms, Icons.healing),
              const Divider(color: Colors.grey),
              _buildInfoRow('Emergency Instructions', medicalRecord.emergencyInstructions, Icons.warning),
              _buildInfoRow('Emergency Allergies', medicalRecord.emergencyAllergies, Icons.health_and_safety),
              const Divider(color: Colors.grey),
              _buildInfoRow('Dietary Restrictions', medicalRecord.dietaryRestrictions, Icons.food_bank),
              _buildInfoRow('Exercise Routine', medicalRecord.exerciseRoutine, Icons.directions_run),
              const Divider(color: Colors.grey),
              _buildInfoRow('Sleep Details', medicalRecord.sleepDetails, Icons.access_time),
              const Divider(color: Colors.grey),
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

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTextField(String labelText, TextEditingController controller, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $labelText';
          }
          return null;
        },
      ),
    );
  }

}
