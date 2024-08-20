import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:daily_planner/ui/theme.dart';

import '../controllers/task_controller.dart';
import '../models/task.dart';
import '../services/theme_services.dart';
import 'add_task.dart';

class TaskDetailPage extends StatefulWidget {
  final Task? taskDetail;
  final bool? shouldShowEdit;

  const TaskDetailPage({super.key, this.taskDetail, this.shouldShowEdit});

  @override
  State<TaskDetailPage> createState() =>
      // ignore: no_logic_in_create_state
      TaskDetailPageState(taskDetail, shouldShowEdit);
}

class TaskDetailPageState extends State<TaskDetailPage> {
  Task? taskDetail;
  bool? shouldShowEdit;
  final _taskController = Get.put(TaskController());

  TaskDetailPageState(this.taskDetail, this.shouldShowEdit);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var setDate = DateFormat.yMMMd().format(DateTime.parse(taskDetail!.date!));
    var selectedBoard = Get.put(TaskController())
        .boardList
        .firstWhere((element) => element.id == taskDetail!.boardId!);

    return Scaffold(
        appBar: _appBar(context),
        body: Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
            child: Column(children: [
              const SizedBox(height: 15),
              Text(taskDetail?.title ?? "",
                  style: taskTitleStyle, textAlign: TextAlign.center),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                  Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: ColorConstants.buttonColor.withOpacity(0.2)
                          //color: Get.isDarkMode ? Colors.greenAccent: Color.amberAccent)),
                          ),
                      child: Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Text(taskDetail?.note ?? "",
                            style: normalTextStyle18),
                      )),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Icon(
                        Icons.notifications,
                        color: ColorConstants.iconColor,
                      ),
                      const SizedBox(width: 10),
                      Text("Remind before ${taskDetail?.remind} mins",
                          style: headingStyle),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Icon(Icons.repeat, color: ColorConstants.iconColor),
                      const SizedBox(width: 10),
                      Text("Repeat ${taskDetail?.repeat}", style: headingStyle),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Divider(
                    thickness: 1,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.calendar_month,
                          color: ColorConstants.iconColor),
                      const SizedBox(width: 10),
                      Text(setDate, style: headingStyle),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Start Time', style: normalTextStyle16),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(Icons.timelapse,
                                  color: ColorConstants.iconColor),
                              const SizedBox(width: 10),
                              Text(taskDetail?.startTime ?? "",
                                  style: headingStyle),
                            ],
                          )
                        ],
                      ),
                      const Spacer(),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('End Time', style: normalTextStyle16),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(Icons.timelapse,
                                  color: ColorConstants.iconColor),
                              const SizedBox(width: 10),
                              Text(taskDetail?.endTime ?? "",
                                  style: headingStyle),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Divider(
                    thickness: 1,
                  ),
                  const SizedBox(height: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Task Board', style: normalTextStyle16),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          ThemeService.getBoardIconForDetail(
                            selectedBoard.boardName ?? "",
                          ),
                          const SizedBox(width: 10),
                          Text(selectedBoard.boardName ?? "",
                              style: headingStyle),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 50),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: GestureDetector(
                        onTap: () {
                          _taskController.delete(taskDetail!);
                          _taskController.getTasks();
                          Get.back();
                        },
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.red.shade400
                              //color: Get.isDarkMode ? Colors.greenAccent: Color.amberAccent)),
                              ),
                          child: const Center(
                              child: Text(
                            "Delete Task",
                            style: TextStyle(color: Colors.white),
                          )),
                        )),
                  ),
                  shouldShowEdit == true ? const SizedBox(width: 30) : Container(),
                  shouldShowEdit == true
                      ? Expanded(
                          child: GestureDetector(
                              onTap: () async {
                                //Get.back();
                                await Get.to(AddTaskPage(editTask: taskDetail));
                                _taskController.getTasks();
                                Get.back();
                              },
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: ColorConstants.buttonColor),
                                child: const Center(
                                    child: Text(
                                  "Edit Task",
                                  style: TextStyle(color: Colors.white),
                                )),
                              )),
                        )
                      : Container(),
                ],
              )
            ])));
  }

  _appBar(BuildContext context) {
    return AppBar(
        iconTheme: IconThemeData(color: ColorConstants.iconColor),
        //backgroundColor: context.theme.backgroundColor,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: ColorConstants.iconColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("Task Detail", style: toolbarTitleStyle),
        centerTitle: true);
  }
}
