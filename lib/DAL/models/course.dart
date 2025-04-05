class Course {
  final int _id;
  final String _language;
  final List<Map<String, String>> _grammer_tasks;
  final List<Map<String, Map<String, String>>> _reading_tasks;
  final List<Map<String, Map<String, String>>> _audition_tasks;
  Course(this._id, this._language, this._grammer_tasks, this._reading_tasks, this._audition_tasks);
}

