// lib/services/web_payment_service.dart

@JS('snap')
library snap;

import 'dart:js_interop';

@JS('pay')
external void pay(String token, JSAny? options);

extension type PayOptions._(JSObject _) implements JSObject {
  external factory PayOptions({
    JSFunction onSuccess,
    JSFunction onPending,
    JSFunction onError,
    JSFunction onClose,
  });
}

// PERBAIKAN: Menambahkan anotasi @JS() dan @anonymous
@JS()
@anonymous
extension type TransactionResult._(JSObject _) implements JSObject {
  // PERBAIKAN: Menambahkan anotasi @JS() untuk properti dengan nama non-standar
  @JS('transaction_id')
  external JSString get transactionId;
  @JS('payment_type')
  external JSString get paymentType;
  @JS('status_message')
  external JSString get statusMessage;
}
