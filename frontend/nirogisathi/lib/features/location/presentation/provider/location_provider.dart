import 'package:flutter/foundation.dart';
import '../../domain/entities/location_entity.dart';
import '../../domain/usecases/get_location_usecase.dart';

class LocationProvider extends ChangeNotifier {
  final GetLocationUseCase getLocationUseCase;

  LocationProvider(this.getLocationUseCase);

  LocationEntity? _location;
  LocationEntity? get location => _location;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> fetchCurrentLocation() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await getLocationUseCase();

    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _isLoading = false;
        notifyListeners();
      },
      (locationEntity) {
        _location = locationEntity;
        _isLoading = false;
        notifyListeners();
      },
    );
  }
}
