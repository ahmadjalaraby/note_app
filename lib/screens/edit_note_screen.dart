import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:lab_project/data/data.dart';
import 'package:lab_project/screens/home_screen.dart';
import 'package:share_plus/share_plus.dart';

import '../db/notes_db.dart';
import '../models/note_model.dart';

class EditNotescreen extends StatefulWidget {
  Note note;
  EditNotescreen({
    Key? key,
    required this.note,
  }) : super(key: key);

  @override
  State<EditNotescreen> createState() => _EditNotescreenState();
}

class _EditNotescreenState extends State<EditNotescreen> {
  Color? noteColor;

  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.note.title;
    _contentController.text = widget.note.content;
    noteColor = widget.note.color;
  }

  updateNote(Note e) async {
    if (_titleController.text.isNotEmpty &&
        _contentController.text.isNotEmpty) {
      await NotesDatabase.instance.update(e);
      // push and remove until
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (_) => false,
      );
    }
  }

  dublicateNote(Note e) async {
    e.id = null;
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
        title: const Text('Edit Note'),
        backgroundColor: widget.note.color,
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
              Note newNote = widget.note.copy(
                title: _titleController.text,
                content: _contentController.text,
                color: noteColor ?? widget.note.color,
              );
              updateNote(newNote);
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
    DateTime dateTime = widget.note.date;
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
              decoration: BoxDecoration(
                color: widget.note.color,
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
                        Share.share(
                            "Hey, check out this note I made on Note App!\n" +
                                widget.note.title +
                                "\n" +
                                widget.note.content);
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
                        // Navigator.pop(buildContext);
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Delete Note"),
                              content: const Text(
                                  "Are you sure you want to delete this note?"),
                              actions: [
                                TextButton(
                                  child: const Text("Cancel"),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                ElevatedButton(
                                  child: const Text("Delete"),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    NotesDatabase.instance
                                        .delete(widget.note.id!);
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => const HomeScreen()),
                                      (_) => false,
                                    );
                                  },
                                ),
                              ],
                            );
                          },
                        );
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
                        Note newNote = widget.note.copy(
                          title: widget.note.title + " (copy)",
                          content: widget.note.content,
                          color: widget.note.color,
                        );
                        dublicateNote(newNote);
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
