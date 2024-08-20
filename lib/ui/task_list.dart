import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:daily_planner/ui/home.dart';
import 'package:daily_planner/ui/task_detail.dart';
import 'package:daily_planner/ui/task_tile_new.dart';
import 'package:daily_planner/ui/theme.dart';

import '../controllers/task_controller.dart';
import '../models/board.dart';
import '../models/task.dart';
import '../services/theme_services.dart';
import 'add_task.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});

  @override
  State<TaskListPage> createState() => TaskListPageState();
}

class TaskListPageState extends State<TaskListPage> {
  DateTime selectedDate = DateTime.now();
  final TaskController _taskController = Get.put(TaskController());
  var shouldShowActualCompleteStatus = false;

  @override
  void initState() {
    super.initState();
    _taskController.getTaskBoard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _appBar(context),
        body: Column(children: [
          const SizedBox(height: 15),
          Text("You can create a Task here and view all the tasks",
              style: subHeadingNormalStyle),
          const SizedBox(height: 15),
          _addDatePicker(),
          const SizedBox(height: 20),
          _showTasks()
        ]));
  }

  _appBar(BuildContext context) {
    _taskController.getTasks();
    return AppBar(
      iconTheme: IconThemeData(color: ColorConstants.iconColor),
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: ColorConstants.iconColor),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text("Task Board", style: toolbarTitleStyle),
      centerTitle: true,
      actions: [
        GestureDetector(
          onTap: () async {
            await Get.to(const AddTaskPage());
            //Wait & fetch list again to refresh the list on home page.
            _taskController.getTasks();
          },
          child: Icon(Icons.add, color: ColorConstants.iconColor),
        ),
        const SizedBox(width: 20),
      ],
    );
  }

  _addDatePicker() {
    // ignore: avoid_unnecessary_containers
    return Container(
      child: DatePicker(
        DateTime.now(),
        height: 80,
        width: 60,
        initialSelectedDate: selectedDate,
        onDateChange: (date) {
          setState(() {
            selectedDate = date;
          });
          if (kDebugMode) {
            print("date selected $selectedDate  ${selectedDate.weekday}");
          }
        },
        selectionColor: Get.isDarkMode
            ? ColorConstants.buttonColor
            : ColorConstants.buttonColor,
        selectedTextColor: Colors.white,
        deactivatedColor: Colors.white,
        monthTextStyle: GoogleFonts.lato(
            textStyle: const TextStyle(
                fontSize: 11, fontWeight: FontWeight.w400, color: Colors.grey)),
        dateTextStyle: GoogleFonts.lato(
            textStyle: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.w800, color: Colors.grey)),
        dayTextStyle: GoogleFonts.lato(
            textStyle: const TextStyle(
                fontSize: 12, fontWeight: FontWeight.w400, color: Colors.grey)),
      ),
    );
  }

  _showTasks() {
    return Expanded(child: Obx(() {
      if (_taskController.taskList.isEmpty) {
        // ignore: avoid_unnecessary_containers
        return Container(
          child: Center(
              child: Text("No tasks",
                  style: headingStyle, textAlign: TextAlign.center)),
        );
      }
      return ListView.builder(
          itemCount: _taskController.taskList.length,
          itemBuilder: (context, index) {
            Task currentTask = _taskController.taskList[index];
            if (kDebugMode) {
              print(currentTask.toJson());
            }
            String selectedDay = DateFormat('EEEE').format(selectedDate);

            var shouldShow = false;
            if (currentTask.repeat == "Everyday") {
              shouldShow = true;
            } else if (currentTask.repeat == "Weekend" &&
                (selectedDay == "Saturday" || selectedDay == "Sunday")) {
              shouldShow = true;
            } else if (currentTask.repeat == "Weekdays" &&
                (selectedDay != "Saturday" && selectedDay != "Sunday")) {
              shouldShow = true;
            } else if (currentTask.repeat == "None" &&
                selectedDate.isSameDate(DateTime.parse(currentTask.date!))) {
              shouldShow = true;
            }

            if (shouldShow == true && selectedDate.isSameDate(DateTime.now())) {
              //Only show actual status for today

              shouldShowActualCompleteStatus = true;
            } else {
              //For future day show only as todo
              shouldShowActualCompleteStatus = false;
            }

            if (shouldShow == true) {
              return AnimationConfiguration.staggeredList(
                  position: index,
                  child: GestureDetector(
                      onTap: () async {
                        //_showBottomSheet(context, currentTask);
                        await Get.to(TaskDetailPage(
                            taskDetail: currentTask,
                            shouldShowEdit: _showEditOption(currentTask)));
                        _taskController.getTasks();
                      },
                      child: TaskTileNew(
                          currentTask,
                          getColorIndex(currentTask.boardId!),
                          shouldShowActualCompleteStatus)));
            } else {
              return Container();
            }
          });
    }));
  }

  getColorIndex(int boardId) {
    //var r = _taskController.boardList.firstWhereOrNull((e) => e.id == boardId);
    Board? b = _taskController.boardList
        .firstWhereOrNull((element) => element.id == boardId);
    if (b != null) {
      return b.color;
    } else {
      return 0;
    }
  }

  // ignore: unused_element
  _showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(Container(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            color: Get.isDarkMode ? Colors.grey.shade800 : Colors.white),
        padding: const EdgeInsets.all(10),
        height: task.isCompleted == 1
            ? MediaQuery.of(context).size.height * 0.32
            : MediaQuery.of(context).size.height * 0.32,
        child: Column(
          children: [
            Container(
              height: 6,
              width: 120,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50), color: Colors.grey),
            ),
            const SizedBox(height: 20),
            _bottomSheetButton(
                context: context,
                label: "View Task",
                color: ColorConstants.iconColor,
                onTap: () async {
                  Get.back();
                  await Get.to(TaskDetailPage(
                      taskDetail: task, shouldShowEdit: _showEditOption(task)));
                  _taskController.getTasks();
                }),
            _bottomSheetButton(
                context: context,
                label: "Delete Task",
                color: ColorConstants.iconColor,
                onTap: () {
                  _taskController.delete(task);
                  _taskController.getTasks();
                  Get.back();
                }),
            const SizedBox(height: 5),
            _bottomSheetButton(
                context: context,
                label: "Close",
                color: Colors.white,
                onTap: () {
                  Get.back();
                },
                isClose: true),
          ],
        )));
  }

  _showEditOption(Task task) {
    // ignore: prefer_typing_uninitialized_variables
    var showMarkAsCompleteOption;

    if (!selectedDate.isSameDate(DateTime.now())) {
      showMarkAsCompleteOption = true;
    } else {
      if (task.isCompleted == 1) {
        //check when was the status last updated; if not updated today then display the option
        var lastUpdatedDate = DateTime.parse(task.taskStatusUpdatedOn!);
        var islastUpdatedIsToday = lastUpdatedDate.isSameDate(selectedDate);
        if (task.taskStatusUpdatedOn != null && islastUpdatedIsToday) {
          showMarkAsCompleteOption = false;
        } else {
          showMarkAsCompleteOption = true;
        }
      } else {
        showMarkAsCompleteOption = true;
      }
    }
    return showMarkAsCompleteOption;
  }

  _bottomSheetButton(
      {required BuildContext context,
      required String label,
      required Function() onTap,
      required Color color,
      bool isClose = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(5),
        height: 50,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
            border: Border.all(
                width: 2, color: isClose == true ? Colors.red : color),
            borderRadius: BorderRadius.circular(10),
            color: isClose ? Colors.transparent : color),
        child: Center(
            child: Text(
          label,
          style: TextStyle(
              color: isClose
                  ? Get.isDarkMode
                      ? Colors.white
                      : Colors.black
                  : Colors.white),
        )),
      ),
    );
  }
}
