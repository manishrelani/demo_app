enum EmployeeRole {
  productDesigner,
  flutterDeveloper,
  qaTester,
  productOwner;

  String get title {
    return switch (this) {
      productDesigner => "Product Designer",
      flutterDeveloper => "Flutter Developer",
      qaTester => "QA Tester",
      productOwner => "Product Owner",
    };
  }
}
