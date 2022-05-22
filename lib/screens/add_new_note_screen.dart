import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lab_project/data/data.dart';
import 'package:lab_project/screens/home_screen.dart';
import 'package:share_plus/share_plus.dart';

import '../db/notes_db.dart';
import '../models/note_model.dart';

class AddNewNoteScreen extends StatefulWidget {
  const AddNewNoteScreen({Key? key}) : super(key: key);

  @override
  State<AddNewNoteScreen> createState() => _AddNewNoteScreenState();
}

class _AddNewNoteScreenState extends State<AddNewNoteScreen> {
  Color? noteColor;

  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  addNewNote(Note e) async {
    if (_titleController.text.isNotEmpty &&
        _contentController.text.isNotEmpty &&
        noteColor != null) {
      await NotesDatabase.instance.create(e);
      // push and remove until
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (_) => false,
      );
    }
  }

  addDuplicateNotes(Note e) async {
    await NotesDatabase.instance.create(e);
    e.title = '${e.title} (copy)';
    await NotesDatabase.instance.create(e);
    // push and remove until
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    noteColor ??= noteColors.first;
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Note'),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert_rounded),
            onPressed: () {
              FocusScope.of(context).unfocus();
              _showBottomSheet(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.check_rounded),
            onPressed: () {
              FocusScope.of(context).unfocus();
              Note note = Note(
                title: _titleController.text,
                content: _contentController.text,
                color: noteColor ?? noteColors.first,
                date: DateTime.now(),
              );
              addNewNote(note);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(generateTime()),
              const SizedBox(height: 10),
              // make a text field for title with bottom border
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  focusColor: defaultColor,
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.shade200,
                      width: 10,
                    ),
                  ),
                  hintText: 'Type something...',
                  hintStyle: GoogleFonts.openSans(
                    fontWeight: FontWeight.w600,
                    color: defaultColor.withOpacity(0.7),
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _contentController,
                minLines: 1,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  alignLabelWithHint: true,
                  focusColor: defaultColor,
                  border: InputBorder.none,
                  hintText: 'Type something...',
                  hintStyle: GoogleFonts.openSans(
                    fontWeight: FontWeight.w600,
                    color: defaultColor.withOpacity(0.7),
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String generateTime() {
    DateTime dateTime = DateTime.now();
    String dateFormatMonth = DateFormat('d MMM').format(dateTime);
    String dateFormatHour = DateFormat('kk:mm a').format(dateTime);

    return dateFormatHour + ", " + dateFormatMonth;
  }

  void _showBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        enableDrag: false,
        elevation: 0,
        builder: (BuildContext buildContext) {
          return Container(
            color: Colors.transparent,
            child: Container(
              decoration: const BoxDecoration(
                color: defaultColor,
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      dense: true,
                      leading: CircleAvatar(
                          backgroundColor: Colors.grey.shade200,
                          child: const Icon(Icons.share, color: Colors.black)),
                      title: Text("Share with your friends",
                          style: GoogleFonts.openSans(
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade100,
                            fontSize: 17,
                          )),
                      onTap: () {
                        if (_titleController.text.isNotEmpty &&
                            _contentController.text.isNotEmpty) {
                          Share.share(
                              "Hey, check out this note I made on Note App!\n" +
                                  _titleController.text +
                                  "\n" +
                                  _contentController.text);
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    ListTile(
                      dense: true,
                      leading: CircleAvatar(
                          backgroundColor: Colors.grey.shade200,
                          child: const Icon(Icons.delete_outline_rounded,
                              color: Colors.black)),
                      title: Text("Delete",
                          style: GoogleFonts.openSans(
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade100,
                            fontSize: 17,
                          )),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    const SizedBox(height: 10),
                    ListTile(
                      dense: true,
                      leading: CircleAvatar(
                          backgroundColor: Colors.grey.shade200,
                          child: const Icon(Icons.copy_rounded,
                              color: Colors.black)),
                      title: Text("Duplicate",
                          style: GoogleFonts.openSans(
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade100,
                            fontSize: 17,
                          )),
                      onTap: () {
                        if (_titleController.text.isNotEmpty &&
                            _contentController.text.isNotEmpty) {
                          Note note = Note(
                            title: _titleController.text,
                            content: _contentController.text,
                            color: noteColor ?? noteColors.first,
                            date: DateTime.now(),
                          );
                          addDuplicateNotes(note);
                        }
                      },
                    ),
                    // const SizedBox(height: 10),
                    Container(
                      height: 80,
                      padding: const EdgeInsets.only(left: 15),
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          ...noteColors.map(
                            ((e) => Container(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          noteColor = e;
                                        });
                                        Navigator.of(context).pop();
                                        _showBottomSheet(context);
                                      },
                                      child: CircleAvatar(
                                        backgroundColor: e,
                                        child: noteColor == e
                                            ? const Icon(
                                                Icons.check,
                                                color: Colors.black,
                                                size: 27,
                                              )
                                            : null,
                                      )),
                                )),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
