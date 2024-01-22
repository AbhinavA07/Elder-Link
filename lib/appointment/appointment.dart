import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'appointment_database.dart';

String _formatShortDate(DateTime date) {
  return '${date.day}/${date.month}/${date.year}';
}

class AppointmentCard extends StatelessWidget {
  const AppointmentCard({
    Key? key,
    required this.appointment,
    required this.onDelete,
  }) : super(key: key);

  final Appointment appointment;
  final VoidCallback onDelete;

  Future<void> _showDeleteConfirmationDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: const Text('Delete Appointment'),
          content: Text(
              'Are you sure you want to delete "${appointment.title}"?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await AppointmentDatabase.instance.deleteAppointment(appointment.id);
                await AwesomeNotifications().cancel(appointment.id);
                onDelete();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Appointment deleted successfully'),
                    backgroundColor: Colors.green,
                    elevation: 10.0,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                );
              },
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Material(
        type: MaterialType.transparency,
        borderRadius: BorderRadius.circular(20.0),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          borderRadius: BorderRadius.circular(20.0), // Adjust the border radius as needed
          onTap: () {
            // Handle onTap
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment.title,
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Location: ${appointment.location}',
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Date: ${_formatShortDate(appointment.date.toLocal())}',
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Time: ${appointment.time.format(context)}',
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 50.0),
                ElevatedButton(
                  onPressed: () => _showDeleteConfirmationDialog(context),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(100.0, 36.0),
                    backgroundColor: Colors.red, // Adjust width as needed
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                  child: const Text('Delete'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}