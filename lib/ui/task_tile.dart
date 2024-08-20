import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/task.dart';

class TaskTile extends StatelessWidget {
  final Task? task;
  final int? colorId;

  const TaskTile(this.task, this.colorId, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        //  width: SizeConfig.screenWidth * 0.78,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: _getBGClr(colorId!),
        ),
        child: Row(children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task?.title ?? "",
                  style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.access_time_rounded,
                      color: Colors.black87,
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "${task!.startTime} - ${task!.endTime}",
                      style: GoogleFonts.lato(
                        textStyle:
                            const TextStyle(fontSize: 13, color: Colors.black87),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  task?.note ?? "",
                  style: GoogleFonts.lato(
                    textStyle: const TextStyle(fontSize: 15, color: Colors.black87),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            height: 60,
            width: 0.5,
            color: Colors.black12.withOpacity(0.3),
          ),
          RotatedBox(
            quarterTurns: 3,
            child: Text(
              task!.isCompleted == 1 ? "COMPLETED" : "TODO",
              style: GoogleFonts.lato(
                textStyle: const TextStyle(
                    backgroundColor: Colors.black,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  _getBGClr(int no) {
    switch (no) {
      case 0:
        return const Color(0xFFfd7f6f);
      case 1:
        return const Color(0xFF7eb0d5);
      case 2:
        return const Color(0xFFb2e061);
      case 3:
        return const Color(0xFFbd7ebe);
      case 4:
        return const Color(0xFFffb55a);
      case 5:
        return const Color(0xFFffee65);
      case 6:
        return const Color(0xFFbeb9db);
      case 7:
        return const Color(0xFFfdcce5);
      case 8:
        return const Color(0xFF8bd3c7);
      default:
        return const Color(0xFF6cd4c5);
    }
  }
}
