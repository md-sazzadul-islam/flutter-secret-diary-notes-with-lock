import 'package:secret_diary/model/Note.dart';
import 'package:secret_diary/repositories/NoteRepository.dart';
import 'package:get/get.dart';

class NoteController extends GetxController {
  var allNote = <Note>[].obs;
  NoteRepository noteRepository = NoteRepository();

  @override
  void onInit() {
    super.onInit();
    fetchAllNote();
  }

  fetchAllNote() async {
    var note = await noteRepository.getNote();
    allNote.value = note;
  }

  fetchWhereNote(String date) async {
    var note = await noteRepository.whereNote(date);
    allNote.value = note;
  }

  addNote(Note note) {
    noteRepository.add(note);
    fetchAllNote();
  }

  updateNote(Note note) {
    noteRepository.update(note);
    fetchAllNote();
  }

  deleteNote(int id) {
    noteRepository.delete(id);
    fetchAllNote();
  }
}
