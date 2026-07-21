class SplashModel {
  final bool isInitialized;
  final String? errorMessage;

  SplashModel({
    required this.isInitialized,
    this.errorMessage,
  });

  SplashModel copyWith({
    bool? isInitialized,
    String? errorMessage,
  }) {
    return SplashModel(
      isInitialized: isInitialized ?? this.isInitialized,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  factory SplashModel.initial() {
    return SplashModel(
      isInitialized: false,
      errorMessage: null,
    );
  }

  @override
  String toString() {
    return 'SplashModel(isInitialized: $isInitialized, errorMessage: $errorMessage)';
  }
}