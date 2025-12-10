/// Either type للتعامل مع النتائج (نجاح أو فشل)
/// مستوحى من dartz package
abstract class Either<L, R> {
  const Either();

  /// تنفيذ دالة بناءً على النتيجة
  T fold<T>(T Function(L l) ifLeft, T Function(R r) ifRight);

  /// هل النتيجة يسار (فشل)؟
  bool get isLeft;

  /// هل النتيجة يمين (نجاح)؟
  bool get isRight;

  /// الحصول على القيمة اليمنى أو null
  R? get rightOrNull;

  /// الحصول على القيمة اليسرى أو null
  L? get leftOrNull;
}

/// النتيجة اليسرى (عادة الفشل)
class Left<L, R> extends Either<L, R> {
  final L value;

  const Left(this.value);

  @override
  T fold<T>(T Function(L l) ifLeft, T Function(R r) ifRight) => ifLeft(value);

  @override
  bool get isLeft => true;

  @override
  bool get isRight => false;

  @override
  R? get rightOrNull => null;

  @override
  L? get leftOrNull => value;
}

/// النتيجة اليمنى (عادة النجاح)
class Right<L, R> extends Either<L, R> {
  final R value;

  const Right(this.value);

  @override
  T fold<T>(T Function(L l) ifLeft, T Function(R r) ifRight) => ifRight(value);

  @override
  bool get isLeft => false;

  @override
  bool get isRight => true;

  @override
  R? get rightOrNull => value;

  @override
  L? get leftOrNull => null;
}
