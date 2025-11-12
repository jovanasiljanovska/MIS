import 'package:dom1/models/exam.dart';
import 'package:flutter/material.dart';

class ExamCard extends StatelessWidget{
  final Exam exam;

  const ExamCard({super.key,required this.exam});

  @override
  Widget build(BuildContext context) {
    final bool isPast=exam.isPast;
    Color color= Colors.lightBlue;
    Color accent=Colors.lightBlueAccent;
    if(isPast){
      color=Colors.white12;
      accent=Colors.white24;
    }
    return GestureDetector(
      onTap: (){
        Navigator.pushNamed(context, "/details",arguments: exam);
      },
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.black,width: 3),
          borderRadius: BorderRadius.circular(10),
        ),
        color: color,
        elevation: 2,
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(isPast? Icons.check_circle : Icons.schedule,
              color: accent,
              size: 28,
              ),
              const SizedBox(width: 12),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exam.name,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isPast ? Colors.black26 : Colors.black,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today,size: 16, color: Colors.black,),
                      const SizedBox(width: 4,),
                      Text("${exam.date}")
                    ],
                  ),
                  const SizedBox(height: 6,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.meeting_room,size:18,color:Colors.brown),
                      const SizedBox(width: 6,),
                      Expanded(
                        child: Text(exam.classrooms.join(", ")),
                      )
                    ],
                  )
                ],
              )),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  isPast ? "Finished" : "Upcoming",
                  style: const TextStyle(fontSize: 12),
                ),
              )
            ],
          ),
        ),
      ),


    );

  }

}