import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:daily_planner/ui/button.dart';
import 'package:daily_planner/ui/theme.dart';

import '../controllers/task_controller.dart';
import '../models/board.dart';
import '../services/theme_services.dart';
import 'input_feild.dart';

class AddBoardPage extends StatefulWidget {
  final Board? editBoard;

  const AddBoardPage({super.key, this.editBoard});

  @override
  // ignore: no_logic_in_create_state
  State<AddBoardPage> createState() => _AddBoardPageState(editBoard);
}

class _AddBoardPageState extends State<AddBoardPage> {
  Board? myEditBoard;

  final TaskController _taskController = Get.put(TaskController());
  final TextEditingController _titleController = TextEditingController();
  int _selectedColorIndex = 0;

  _AddBoardPageState(Board? editBoard) {
    myEditBoard = editBoard;
  }

  @override
  void initState() {
    super.initState();
    _titleController.text =
        myEditBoard?.boardName == null ? "" : myEditBoard!.boardName!;
  }

  @override
  Widget build(BuildContext context) {
    if (myEditBoard != null) _selectedColorIndex = myEditBoard!.color!;
    return Scaffold(
        appBar: _appBar(context),
        body: Container(
            margin: const EdgeInsets.all(8),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              TextInputFeild(
                  maxLength: 15,
                  hint: _getHint(),
                  label: _getLabel(),
                  widget: null,
                  controller: _titleController,
                  isDisabled: myEditBoard?.isPredefined == 1 ? 1 : 0),
              _showNote(),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(
                  "Choose Color",
                  textAlign: TextAlign.left,
                  style: inputLabelTextStyle,
                ),
              ),
              const SizedBox(height: 5),
              _chooseColorNew(),
              const SizedBox(height: 20),
              Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(right: 14),
                  child: MyButton(
                      label: myEditBoard != null ? "Update" : "Create",
                      onTap: () => {_validateInputData()})),
            ])));
  }

  _showNote() {
    if (myEditBoard != null && myEditBoard?.isPredefined == 1) {
      return Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Text(
          "Note: Default Board names can't be updated",
          style: TextStyle(
              fontSize: 12,
              color: Get.isDarkMode ? Colors.white38 : Colors.black54),
        ),
      );
    } else {
      return Container();
    }
  }

  _getLabel() {
    if (myEditBoard == null) {
      return "Add Board Name";
    } else {
      return "Board Name";
    }
  }

  _getHint() {
    if (myEditBoard == null) {
      return "Name";
    } else {
      return myEditBoard?.boardName;
    }
  }

  _chooseColorNew() {
    return GridView.count(
        shrinkWrap: true,
        crossAxisCount: 5,
        children: List.generate(10, (index) {
          return GestureDetector(
              onTap: () => {
                    setState(() {
                      myEditBoard?.setColor(index);
                      _selectedColorIndex = index;
                    })
                  },
              // ignore: avoid_unnecessary_containers
              child: Container(
                  child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: CircleAvatar(
                    radius: 5,
                    backgroundColor: ThemeService.getBGClr(index),
                    child: index == _selectedColorIndex
                        ? const Icon(Icons.done, color: Colors.white)
                        : Container()),
              )));
        }));
  }

  _appBar(BuildContext context) {
    return AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: ColorConstants.iconColor),
          onPressed: () => Get.back(),
        ),
        title: Text(
          myEditBoard == null ? "Create Board" : "Update Board",
          style: toolbarTitleStyle,
        ),
        centerTitle: true);
  }

  _validateInputData() {
    if (myEditBoard != null) {
      _updateBoard();
      _taskController.getTaskBoard();
      Get.back();
    } else if (boardNameExist()) {
      Get.snackbar("Error", "Board already exists",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: ColorConstants.iconColor,
          colorText: Colors.white,
          icon: const Icon(Icons.warning, color: Colors.white));
    } else if (_titleController.text.isNotEmpty) {
      _addBoardToDB();
      Get.back();
    } else if (_titleController.text.isEmpty) {
      Get.snackbar("Required", "Board name can't be empty",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: ColorConstants.iconColor,
          colorText: Colors.white,
          icon: const Icon(Icons.warning, color: Colors.white));
    }
  }

  bool boardNameExist() {
    var boardList = _taskController.boardList;
    return boardList.any((element) =>
        element.boardName?.toLowerCase() ==
        _titleController.text.trim().toLowerCase());
  }

  _addBoardToDB() async {
    // ignore: unused_local_variable
    int? value = await _taskController.addBoard(
        board: Board(
            boardName: _titleController.text,
            color: _selectedColorIndex,
            isPredefined: 0));
  }

  _updateBoard() async {
    _taskController.updateTBoard(Board(
        id: myEditBoard?.id,
        boardName: _titleController.text.isEmpty
            ? myEditBoard?.boardName
            : _titleController.text,
        color: _selectedColorIndex,
        isPredefined: myEditBoard?.isPredefined));
  }
}
