class Notebook {
  String name;
  List<Note> notes;
  
  Notebook({required this.name, required this.notes});
}

//TODO: Add Image, Inking, and other metadata
// store relative location on page
class Note {
  String title;
  List<String> content;
  
  Note({required this.title, required this.content});
}
