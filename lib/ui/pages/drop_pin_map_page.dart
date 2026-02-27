import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';

import '../../application/providers/location_providers.dart';
import '../../application/providers/submit_place_providers.dart';
import '../../env.dart';
import '../../theme.dart';

/// Providers for drop pin map state
final _selectedPositionProvider = StateProvider.autoDispose<LatLng>(
  (ref) => const LatLng(33.5651, 73.0169), // Default: Rawalpindi
);

final _addressTextProvider = StateProvider.autoDispose<String?>(
  (ref) => null,
);

final _hasInitializedProvider = StateProvider.autoDispose<bool>(
  (ref) => false,
);

final _isInitializingProvider = StateProvider.autoDispose<bool>(
  (ref) => true, // Start as loading — prevents any flash on first build
);

/// Drop Pin Map Page
/// Full-screen map for selecting a location by dropping a pin
class DropPinMapPage extends ConsumerStatefulWidget {
  final SelectedLocation? initialLocation;

  const DropPinMapPage({
    super.key,
    this.initialLocation,
  });

  @override
  ConsumerState<DropPinMapPage> createState() => _DropPinMapPageState();
}

class _DropPinMapPageState extends ConsumerState<DropPinMapPage> {
  GoogleMapController? _mapController;
  Timer? _debounceTimer;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _isProgrammaticMove = false;
  bool _isAddressLocked = false;

  // Rawalpindi default coordinates
  static const LatLng _defaultLocation = LatLng(33.5651, 73.0169);
  static final String _googleApiKey = Env.googleApiKey;

  @override
  void initState() {
    super.initState();

    if (widget.initialLocation != null) {
      // Already have a location — clear loading state after first frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(_selectedPositionProvider.notifier).state = LatLng(
          widget.initialLocation!.latitude,
          widget.initialLocation!.longitude,
        );
        ref.read(_addressTextProvider.notifier).state =
            widget.initialLocation!.address;
        ref.read(_hasInitializedProvider.notifier).state = true;
        ref.read(_isInitializingProvider.notifier).state = false;
      });
    } else {
      // Will fetch current location — provider already starts as true (loading)
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _initializeLocation();
      });
    }
  }

  Future<void> _initializeLocation() async {
    final hasPermission = await ref.read(locationPermissionProvider.future);

    if (hasPermission && !ref.read(_hasInitializedProvider)) {
      try {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        if (mounted) {
          final currentLocation = LatLng(position.latitude, position.longitude);

          ref.read(_selectedPositionProvider.notifier).state = currentLocation;
          ref.read(_hasInitializedProvider.notifier).state = true;

          // Fetch address for current location
          await _fetchAddressFromCoordinates(currentLocation);

          // Animate camera to current location when map is ready
          _isProgrammaticMove = true;
          _mapController?.animateCamera(
            CameraUpdate.newLatLngZoom(
                ref.read(_selectedPositionProvider), 15),
          );

          ref.read(_isInitializingProvider.notifier).state = false;
        }
      } catch (e) {
        // If error getting location, keep default Rawalpindi location
        if (mounted) {
          ref.read(_hasInitializedProvider.notifier).state = true;
          ref.read(_isInitializingProvider.notifier).state = false;
        }
      }
    } else {
      // No permission, use default location
      if (mounted) {
        ref.read(_hasInitializedProvider.notifier).state = true;
        ref.read(_isInitializingProvider.notifier).state = false;
      }
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    _searchFocusNode.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _fetchAddressFromCoordinates(LatLng position) async {
    // Don't fetch if address is locked (set from search)
    if (_isAddressLocked) {
      return;
    }

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty && mounted) {
        // Check again after async operation
        if (_isAddressLocked) {
          return;
        }

        final placemark = placemarks.first;
        final address = [
          placemark.street,
          placemark.locality,
          placemark.administrativeArea,
          placemark.country,
        ].where((e) => e != null && e.isNotEmpty).join(', ');

        ref.read(_addressTextProvider.notifier).state =
            address.isNotEmpty ? address : null;
      }
    } catch (e) {
      // Error fetching address, keep current address or show coordinates
    }
  }

  void _debouncedFetchAddress(LatLng position) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 800), () {
      _fetchAddressFromCoordinates(position);
    });
  }

  Future<void> _moveToCurrentLocation() async {
    // Prevent multiple simultaneous requests
    if (ref.read(_isInitializingProvider)) return;

    try {
      // Fetch position without showing loading yet
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      final currentLocation = LatLng(position.latitude, position.longitude);
      final currentSelectedPosition = ref.read(_selectedPositionProvider);

      // Check if already at current location (within ~10 meters)
      final distance = Geolocator.distanceBetween(
        currentSelectedPosition.latitude,
        currentSelectedPosition.longitude,
        currentLocation.latitude,
        currentLocation.longitude,
      );

      if (distance < 10) {
        // Already at current location, no need to do anything
        return;
      }

      // Now show loading since we're actually going to update
      if (mounted) {
        ref.read(_isInitializingProvider.notifier).state = true;
      }

      ref.read(_selectedPositionProvider.notifier).state = currentLocation;

      // Mark as programmatic move
      _isProgrammaticMove = true;

      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(currentLocation, 15),
      );

      // Fetch address for current location
      await _fetchAddressFromCoordinates(currentLocation);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unable to get current location: $e')),
        );
      }
    } finally {
      if (mounted) {
        ref.read(_isInitializingProvider.notifier).state = false;
      }
    }
  }

  void _onCameraMove(CameraPosition position) {
    ref.read(_selectedPositionProvider.notifier).state = position.target;
    // Only unlock address if this is a manual move (not programmatic)
    if (!_isProgrammaticMove) {
      _isAddressLocked = false;
    }
  }

  void _onCameraIdle() {
    // Only fetch address if it's not locked (locked when set from search)
    if (!_isAddressLocked) {
      // Fetch address after camera stops moving
      _debouncedFetchAddress(ref.read(_selectedPositionProvider));
    }

    // Reset programmatic move flag AFTER checking lock
    // This prevents late _onCameraMove calls from unlocking the address
    _isProgrammaticMove = false;
  }

  void _confirmLocation() {
    final selectedPosition = ref.read(_selectedPositionProvider);
    final addressText = ref.read(_addressTextProvider);

    final location = SelectedLocation(
      latitude: selectedPosition.latitude,
      longitude: selectedPosition.longitude,
      address: addressText,
      placeName: null,
    );
    Navigator.pop(context, location);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: GlassAppBar(
        leadingWidth: MediaQuery.of(context).size.width * 0.1,
        height: 65,
        title: GooglePlaceAutoCompleteTextField(
          textEditingController: _searchController,
          googleAPIKey: _googleApiKey,
          focusNode: _searchFocusNode,
          textInputAction: TextInputAction.done,
          boxDecoration: const BoxDecoration(),
          containerHorizontalPadding: 0,
          containerVerticalPadding: 0,
          isCrossBtnShown: true,
          formSubmitCallback: () {
            // Dismiss keyboard when "done" button is pressed
            _searchFocusNode.unfocus();
          },
          inputDecoration: InputDecoration(
            prefixIcon: Icon(
              Icons.search,
              color: context.colors.textSecondary,
              size: iconSizeMedium,
            ),
            hintText: 'Search for a place',
            hintStyle: captionStyle.copyWith(
              color: context.colors.textSecondary,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radiusMedium),
              borderSide: BorderSide(
                color: context.colors.border,
                width: borderWidthDefault,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radiusMedium),
              borderSide: BorderSide(
                color: context.colors.border,
                width: borderWidthDefault,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radiusMedium),
              borderSide: BorderSide(
                color: brandPrimary,
                width: 2,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radiusMedium),
              borderSide: BorderSide(
                color: context.colors.border,
                width: borderWidthDefault,
              ),
            ),
            filled: true,
            fillColor: context.colors.bgSecondary,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: spacing16,
              vertical: spacing12,
            ),
          ),
          textStyle: bodyTextStyle.copyWith(
            color: context.colors.textPrimary,
          ),
          debounceTime: 600,
          isLatLngRequired: true,
          getPlaceDetailWithLatLng: (Prediction prediction) {
            // Move map to selected place
            if (prediction.lat != null && prediction.lng != null) {
              final location = LatLng(
                double.parse(prediction.lat!),
                double.parse(prediction.lng!),
              );

              // Cancel any pending address fetch timers
              _debounceTimer?.cancel();

              // CRITICAL: Set programmatic flag FIRST, before anything else!
              // This prevents any camera move events from unlocking the address
              _isProgrammaticMove = true;

              // Now lock the address
              _isAddressLocked = true;

              // Set the address
              ref.read(_addressTextProvider.notifier).state =
                  prediction.description;

              // Update position and animate
              ref.read(_selectedPositionProvider.notifier).state = location;

              _mapController?.animateCamera(
                CameraUpdate.newLatLngZoom(location, 15),
              );

              // Dismiss keyboard after selecting location
              _searchFocusNode.unfocus();
            }
          },
          itemClick: (Prediction prediction) {
            _searchController.text = prediction.description ?? '';
            _searchController.selection = TextSelection.fromPosition(
              TextPosition(offset: _searchController.text.length),
            );

            // Dismiss keyboard after selecting from suggestions
            _searchFocusNode.unfocus();
          },
        ),
        centerTitle: false,
      ),
      body: GestureDetector(
        onTap: () {
          // Dismiss keyboard when tapping on map
          _searchFocusNode.unfocus();
        },
        child: Stack(
          children: [
            // Google Map — scoped Consumer so only the map rebuilds on permission change
            Consumer(
              builder: (context, ref, _) {
                final hasLocationPermission = ref
                    .watch(locationPermissionProvider)
                    .when(
                      data: (p) => p,
                      loading: () => false,
                      error: (_, __) => false,
                    );
                return GoogleMap(
                  onMapCreated: (controller) {
                    _mapController = controller;
                    // Animate to selected position if it's not default
                    final pos = ref.read(_selectedPositionProvider);
                    if (pos != _defaultLocation) {
                      _isProgrammaticMove = true;
                      controller.animateCamera(
                        CameraUpdate.newLatLngZoom(pos, 15),
                      );
                    }
                  },
                  initialCameraPosition: CameraPosition(
                    target: ref.read(_selectedPositionProvider),
                    zoom: 15,
                  ),
                  onCameraMove: _onCameraMove,
                  onCameraIdle: _onCameraIdle,
                  myLocationEnabled: hasLocationPermission,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  mapToolbarEnabled: false,
                  compassEnabled: false,
                  buildingsEnabled: true,
                );
              },
            ),

            // Center pin indicator — only rebuilds when isInitializing changes
            Consumer(
              builder: (context, ref, _) {
                final isInitializing = ref.watch(_isInitializingProvider);
                if (isInitializing) return const SizedBox.shrink();
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.location_pin,
                        size: 48,
                        color: brandPrimary,
                      ),
                      const SizedBox(height: 48), // Offset for visual centering
                    ],
                  ),
                );
              },
            ),

            // Current location button (only if permission granted)
            Consumer(
              builder: (context, ref, _) {
                final hasLocationPermission = ref
                    .watch(locationPermissionProvider)
                    .when(
                      data: (p) => p,
                      loading: () => false,
                      error: (_, __) => false,
                    );
                if (!hasLocationPermission) return const SizedBox.shrink();
                final isInitializing = ref.watch(_isInitializingProvider);
                return Positioned(
                  bottom: 220,
                  right: spacing16,
                  child: Material(
                      color: context.colors.bgPrimary,
                      borderRadius: BorderRadius.circular(radiusMedium),
                      elevation: 4,
                      child: InkWell(
                        onTap: isInitializing ? null : _moveToCurrentLocation,
                        borderRadius: BorderRadius.circular(radiusMedium),
                        child: Container(
                          padding: const EdgeInsets.all(spacing12),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: context.colors.border,
                              width: borderWidthDefault,
                            ),
                            borderRadius: BorderRadius.circular(radiusMedium),
                          ),
                          child: isInitializing
                              ? SizedBox(
                                  width: iconSizeMedium,
                                  height: iconSizeMedium,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      brandPrimary,
                                    ),
                                  ),
                                )
                              : Icon(
                                  Icons.my_location,
                                  color: context.colors.textPrimary,
                                  size: iconSizeLarge,
                                ),
                        ),
                      ),
                    ),
                  );
                },
              ),

            // Bottom panel — rebuilds only when loading/address/position changes
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Consumer(
                builder: (context, ref, _) {
                  final isInitializing = ref.watch(_isInitializingProvider);
                  final addressText = ref.watch(_addressTextProvider);
                  final selectedPosition = ref.watch(_selectedPositionProvider);
                  return SafeArea(
                    child: Container(
                      margin: const EdgeInsets.all(spacing16),
                      padding: const EdgeInsets.all(spacing16),
                      decoration: BoxDecoration(
                        color: context.colors.bgPrimary,
                        borderRadius: BorderRadius.circular(radiusLarge),
                        border: Border.all(
                          color: context.colors.border,
                          width: borderWidthDefault,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Address display
                          Text(
                            'Selected Location',
                            style: bodySmallStyle.copyWith(
                              color: context.colors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: spacing4),
                          if (isInitializing)
                            Row(
                              children: [
                                SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      brandPrimary,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: spacing8),
                                Text(
                                  'Fetching location...',
                                  style: bodyTextStyle.copyWith(
                                    color: context.colors.textSecondary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            )
                          else
                            Text(
                              addressText ??
                                  '${selectedPosition.latitude.toStringAsFixed(6)}, ${selectedPosition.longitude.toStringAsFixed(6)}',
                              style: bodyTextStyle.copyWith(
                                color: context.colors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          const SizedBox(height: spacing16),

                          // Confirm button — scoped so map drags don't rebuild it
                          Consumer(
                            builder: (context, ref, _) {
                              final isInitializing =
                                  ref.watch(_isInitializingProvider);
                              return PrimaryButton(
                                text: 'Confirm Location',
                                onPressed:
                                    isInitializing ? null : _confirmLocation,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
