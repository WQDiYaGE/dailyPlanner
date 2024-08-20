import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/board.dart';
import '../services/theme_services.dart';

class BoardTile extends StatelessWidget {
  final Board? board;
  final int? taskCount;

  const BoardTile(this.board, this.taskCount, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      width: MediaQuery.of(context).size.width,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: ThemeService.getBGClr(board?.color ?? 0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
              child: Text(
                overflow: TextOverflow.ellipsis,
                board?.boardName ?? "",
                style: GoogleFonts.lato(
                  textStyle: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF454545)),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5.0),
              alignment: Alignment.center,
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ThemeService.getBoardIcon(board!.boardName!)),
            ),
            const Spacer(),
            Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16)),
                  color: Colors.white.withOpacity(0.3),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 12.0, left: 16.0, bottom: 12.0),
                  child: Text(
                    taskCount == 0
                        ? "No tasks"
                        : taskCount == 1
                            ? "$taskCount task"
                            : "$taskCount tasks",
                    textAlign: TextAlign.left,
                    style: GoogleFonts.lato(
                      textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF454545)),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
