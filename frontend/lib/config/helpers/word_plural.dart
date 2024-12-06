String getChaptersLabel(int cantidad) {
  if (cantidad < 0) {
    return "";
  } else if (cantidad == 1) {
    return "capítulo";
  } else {
    return "capítulos";
  }
}
