part of 'invoices_cubit.dart';

enum InvoicesStatus { init, loading, success, failure }

class InvoicesState {
  final InvoicesStatus? status;
  final List<InvoiceModel>? invoices;
  final String? message ;
  const InvoicesState({this.status, this.invoices,this
  .message});
  InvoicesState copyWith({
    InvoicesStatus? status,
     String? message,
    List<InvoiceModel>? invoices,
  }) => InvoicesState(
    message: message??this.message,
    status: status ?? this.status,
    invoices: invoices ?? this.invoices,
  );
}

final class InvoicesInitial extends InvoicesState {
 const InvoicesInitial() : super(status: InvoicesStatus.init);
}
