class Notebook {
  String name;
  List<Note> notes;
  
  Notebook({required this.name, required this.notes});
}

class Note {
  String title;
  List<String> content;
  
  Note({required this.title, required this.content});
}
