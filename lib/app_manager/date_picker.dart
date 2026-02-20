

import 'package:flutter/Material.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

 Future<String> datePicker(context) async{
   DateTime? dateTime = await showOmniDateTimePicker(
     context: context,
     initialDate: DateTime.now(),
     firstDate:
     DateTime(1600).subtract(const Duration(days: 3652)),
     lastDate: DateTime.now().add(
       const Duration(days: 3652),
     ),
     type: OmniDateTimePickerType.date,
     borderRadius: const BorderRadius.all(Radius.circular(16)),
     constraints: const BoxConstraints(
       maxWidth: 350,
       maxHeight: 650,
     ),
     transitionBuilder: (context, anim1, anim2, child) {
       return FadeTransition(
         opacity: anim1.drive(
           Tween(
             begin: 0,
             end: 1,
           ),
         ),
         child: child,
       );
     },
     transitionDuration: const Duration(milliseconds: 200),
     barrierDismissible: true,

   );


   return formatDateToYMD(dateTime  );

 }


String formatDateToYMD(DateTime ?date) {
  if(date!=null){
    final String year = date.year.toString() ;
    final String month = date.month < 10 ? '0${date.month}' : '${date.month}';
    final String day = date.day < 10 ? '0${date.day}' : '${date.day}';
    return '$year-$month-$day';
  }
  return '';

}


String formatDatePlusOneMonth(String inputDate) {
  // Parse the input date string (e.g., "2025-05-01")
  DateTime date = DateTime.parse(inputDate);

  // Add one month and reset day to 1
  DateTime newDate = DateTime(date.year, date.month + 1, 1);

  // Month names list
  const monthNames = [
    '', // Placeholder for index 0
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  // Format: "Month day, year"
  return '${monthNames[newDate.month]} ${newDate.day}, ${newDate.year}';
}
