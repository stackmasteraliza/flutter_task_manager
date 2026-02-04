class Validators {
  static String? validateUsername(String value) {
    if (value.trim().isEmpty) {
      return 'Username is required';
    }
    if (value.trim().length < 3) {
      return 'Username must be at least 3 characters';
    }
    return null;
  }

  static String? validatePassword(String value) {
    if (value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 4) {
      return 'Password must be at least 4 characters';
    }
    return null;
  }

  static String? validateTaskTitle(String value) {
    if (value.trim().isEmpty) {
      return 'Task title cannot be empty';
    }
    if (value.trim().length < 3) {
      return 'Task title must be at least 3 characters';
    }
    return null;
  }
}
