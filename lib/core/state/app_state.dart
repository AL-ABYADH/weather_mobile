import '../error/error_model.dart';

class AppState {
  final bool isInitial;
  final bool isLoading;
  final bool isLoadingMore;
  final bool isLoaded;
  final bool isLoadedMore;
  final bool isSuccess;
  final bool isSuccessMore;
  final bool isError;
  ErrorModel? errorData;

  AppState._({
    this.isInitial = false,
    this.isLoading = false,
    this.isLoaded = false,
    this.isError = false,
    this.isSuccess = false,
    this.errorData,
    this.isLoadingMore = false,
    this.isLoadedMore = false,
    this.isSuccessMore = false,
  });

  factory AppState.loading() {
    return AppState._(isLoading: true);
  }

  factory AppState.loadingMore() {
    return AppState._(isSuccess: true, isLoadingMore: true);
  }

  factory AppState.success() {
    return AppState._(isSuccess: true);
  }

  factory AppState.successMore() {
    return AppState._(isSuccessMore: true);
  }

  factory AppState.error({ErrorModel? error}) {
    return AppState._(isError: true, errorData: error);
  }

  factory AppState.initial() {
    return AppState._(isInitial: true);
  }

  factory AppState.loaded() {
    return AppState._(isLoaded: true);
  }

  factory AppState.loadedMore() {
    return AppState._(isLoadedMore: true);
  }

  @override
  String toString() {
    if (isError) return 'Error';
    if (isLoading) return 'Loading';
    if (isLoaded) return 'Loaded';
    if (isLoadingMore) return 'LoadingMore';
    if (isLoadedMore) return 'LoadedMore';

    return 'Initial';
  }
}
