import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:lab_project/data/data.dart';
import 'package:lab_project/db/notes_db.dart';
import 'package:lab_project/screens/add_new_note_screen.dart';
import 'package:lab_project/screens/edit_note_screen.dart';

import '../models/note_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Note>? notes;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getNotes();
  }

  void getNotes() async {
    setState(() {
      isLoading = true;
    });
    notes = await NotesDatabase.instance.readAllNotes();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    NotesDatabase.instance.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: const Center(child: Text('My Notes')),
      ),
      body: isLoading || notes == null
          ? const Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(defaultColor)),
            )
          : notes!.isEmpty
              ? const EmptyNotes()
              : buildNotes(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => const AddNewNoteScreen())),
        child: Container(
          width: 60,
          height: 60,
          child: const Icon(Icons.add, size: 40),
          decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [defaultColor, Colors.purple],
              )),
        ),
      ),
    );
  }

  buildNotes() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          for (final note in notes!)
            NoteWidget(
              note: note,
              // onDelete: () => deleteNote(note),
            ),
        ],
      ),
    );
  }
}

class NoteWidget extends StatelessWidget {
  Note note;
  NoteWidget({
    Key? key,
    required this.note,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      height: MediaQuery.of(context).size.height / 7,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            spreadRadius: 5,
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          print(note.id);
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => EditNotescreen(note: note)));
        },
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 5,
                height: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: note.color,
                ),
              ),
              const SizedBox(width: 10),
              Container(
                margin: const EdgeInsets.only(top: 15),
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      note.title,
                      style: GoogleFonts.openSans(
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                        color: defaultColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 20),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 1.2,
                          child: Text(
                            note.content,
                            style: GoogleFonts.openSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Colors.grey.shade400,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EmptyNotes extends StatelessWidget {
  const EmptyNotes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              const Icon(Icons.note, size: 100, color: defaultColor),
              const SizedBox(height: 40),
              Text(
                'No Notes :(',
                style: GoogleFonts.openSans(
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                  color: defaultColor.withOpacity(0.3),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10),
              Text(
                'You have no task to do',
                style: GoogleFonts.openSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Colors.grey.shade400,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
