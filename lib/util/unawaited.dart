/// Explicitely indicate to the `unawaited_futures` lint
/// that the future is not awaited for on purpose
void unawaited<T>(Future<T> future) {}
