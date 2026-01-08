import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import '../../application/providers/location_providers.dart';
import '../../theme.dart';
import '../widgets/primary_button.dart';
import 'submit_place_page.dart';

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
  LatLng _selectedPosition = const LatLng(33.5651, 73.0169); // Default: Rawalpindi
  String? _addressText;
  bool _isLoading = false;
  bool _hasInitialized = false;

  // Rawalpindi default coordinates
  static const LatLng _defaultLocation = LatLng(33.5651, 73.0169);

  @override
  void initState() {
    super.initState();
    // Set initial position if provided
    if (widget.initialLocation != null) {
      _selectedPosition = LatLng(
        widget.initialLocation!.latitude,
        widget.initialLocation!.longitude,
      );
      _addressText = widget.initialLocation!.address;
      _hasInitialized = true;
    } else {
      // Try to get current location if permission granted
      _initializeLocation();
    }
  }

  Future<void> _initializeLocation() async {
    final hasPermission = await ref.read(locationPermissionProvider.future);

    if (hasPermission && !_hasInitialized) {
      try {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        if (mounted) {
          setState(() {
            _selectedPosition = LatLng(position.latitude, position.longitude);
            _hasInitialized = true;
          });

          // Animate camera to current location when map is ready
          _mapController?.animateCamera(
            CameraUpdate.newLatLngZoom(_selectedPosition, 15),
          );
        }
      } catch (e) {
        // If error getting location, keep default Rawalpindi location
        if (mounted) {
          setState(() {
            _hasInitialized = true;
          });
        }
      }
    } else {
      // No permission, use default location
      if (mounted) {
        setState(() {
          _hasInitialized = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _moveToCurrentLocation() async {
    setState(() => _isLoading = true);
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      final currentLocation = LatLng(position.latitude, position.longitude);

      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(currentLocation, 15),
      );

      setState(() {
        _selectedPosition = currentLocation;
        _addressText = null; // Will be fetched by reverse geocoding if implemented
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unable to get current location: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _onCameraMove(CameraPosition position) {
    setState(() {
      _selectedPosition = position.target;
      _addressText = null; // Clear address when moving map
    });
  }

  void _confirmLocation() {
    final location = SelectedLocation(
      latitude: _selectedPosition.latitude,
      longitude: _selectedPosition.longitude,
      address: _addressText,
      placeName: null,
    );
    Navigator.pop(context, location);
  }

  @override
  Widget build(BuildContext context) {
    final locationPermission = ref.watch(locationPermissionProvider);
    final hasLocationPermission = locationPermission.when(
      data: (hasPermission) => hasPermission,
      loading: () => false,
      error: (_, __) => false,
    );

    return Scaffold(
      body: Stack(
        children: [
          // Google Map
          GoogleMap(
            onMapCreated: (controller) {
              _mapController = controller;
              // Animate to selected position if it's not default
              if (_selectedPosition != _defaultLocation) {
                controller.animateCamera(
                  CameraUpdate.newLatLngZoom(_selectedPosition, 15),
                );
              }
            },
            initialCameraPosition: CameraPosition(
              target: _selectedPosition,
              zoom: 15,
            ),
            onCameraMove: _onCameraMove,
            myLocationEnabled: hasLocationPermission,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            compassEnabled: false,
            buildingsEnabled: true,
          ),

          // Center pin indicator
          Center(
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
          ),

          // Top app bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Container(
                margin: const EdgeInsets.all(spacing16),
                decoration: BoxDecoration(
                  color: context.colors.bgPrimary,
                  borderRadius: BorderRadius.circular(radiusMedium),
                  border: Border.all(
                    color: context.colors.border,
                    width: borderWidthDefault,
                  ),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: context.colors.textPrimary,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Text(
                        'Drop Pin',
                        style: h3Style.copyWith(
                          color: context.colors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Current location button (only if permission granted)
          if (hasLocationPermission)
            Positioned(
              top: 100,
              right: spacing16,
              child: SafeArea(
                child: Material(
                  color: context.colors.bgPrimary,
                  borderRadius: BorderRadius.circular(radiusMedium),
                  elevation: 4,
                  child: InkWell(
                    onTap: _isLoading ? null : _moveToCurrentLocation,
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
                      child: _isLoading
                          ? SizedBox(
                              width: iconSizeLarge,
                              height: iconSizeLarge,
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
              ),
            ),

          // Bottom panel with address and confirm button
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
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
                    Text(
                      _addressText ??
                          '${_selectedPosition.latitude.toStringAsFixed(6)}, ${_selectedPosition.longitude.toStringAsFixed(6)}',
                      style: bodyTextStyle.copyWith(
                        color: context.colors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: spacing16),

                    // Confirm button
                    PrimaryButton(
                      text: 'Confirm Location',
                      onPressed: _confirmLocation,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
