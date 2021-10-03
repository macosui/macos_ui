class MockOnPressedFunction {
  int called = 0;

  void handler() {
    called = 2;
  }
}

class MockOnTapCancelFunction {
  int called = 0;

  void handler() {
    called = 1;
  }
}
