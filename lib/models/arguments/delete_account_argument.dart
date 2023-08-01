class DeleteCustomerAccountArguments {
  final String reason;
  final String email;

  String? additionalComments;

  DeleteCustomerAccountArguments({
    required this.email,
    required this.reason,
    this.additionalComments,
  });
}
