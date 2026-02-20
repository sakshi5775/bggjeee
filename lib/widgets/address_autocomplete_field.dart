import 'package:flutter/material.dart';
import 'package:astrobharataiuser/utils/address_helper.dart';

/// Autocomplete Address TextField Widget
///
/// This widget provides Google Maps Places Autocomplete functionality
/// Usage example:
/// ```dart
/// AddressAutocompleteField(
///   controller: _addressController,
///   onPlaceSelected: (placeDetails) {
///     // Handle selected place
///     print('Selected: ${placeDetails['displayName']}');
///     print('Lat: ${placeDetails['latitude']}, Lon: ${placeDetails['longitude']}');
///   },
/// )
/// ```
class AddressAutocompleteField extends StatefulWidget {
  final TextEditingController controller;
  final Function(Map<String, dynamic>) onPlaceSelected;
  final String? hintText;
  final String? labelText;
  final String? country; // Optional country code filter (e.g., 'in' for India)
  final InputDecoration? decoration;

  const AddressAutocompleteField({
    Key? key,
    required this.controller,
    required this.onPlaceSelected,
    this.hintText = 'Enter address',
    this.labelText = 'Address',
    this.country,
    this.decoration,
  }) : super(key: key);

  @override
  State<AddressAutocompleteField> createState() =>
      _AddressAutocompleteFieldState();
}

class _AddressAutocompleteFieldState extends State<AddressAutocompleteField> {
  List<Map<String, dynamic>> _suggestions = [];
  bool _isLoading = false;
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    _focusNode.removeListener(_onFocusChanged);
    _focusNode.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _onFocusChanged() {
    if (!_focusNode.hasFocus) {
      _removeOverlay();
    }
  }

  void _onTextChanged() async {
    final text = widget.controller.text;

    if (text.isEmpty) {
      setState(() {
        _suggestions = [];
      });
      _removeOverlay();
      return;
    }

    if (text.length < 3) {
      return; // Wait for at least 3 characters
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final suggestions = await AddressHelper.getAddressSuggestions(
        input: text,
        country: widget.country,
      );

      setState(() {
        _suggestions = suggestions;
        _isLoading = false;
      });

      if (suggestions.isNotEmpty) {
        _showOverlay();
      } else {
        _removeOverlay();
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching suggestions: $e');
    }
  }

  void _showOverlay() {
    _removeOverlay();

    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0.0, size.height + 5.0),
          child: Material(
            elevation: 4.0,
            borderRadius: BorderRadius.circular(8.0),
            child: Container(
              constraints: BoxConstraints(maxHeight: 200),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: _suggestions.length,
                itemBuilder: (context, index) {
                  final suggestion = _suggestions[index];
                  return ListTile(
                    dense: true,
                    leading: Icon(Icons.location_on, color: Colors.red),
                    title: Text(
                      suggestion['mainText'] ?? suggestion['description'] ?? '',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    subtitle: suggestion['secondaryText'] != null
                        ? Text(
                            suggestion['secondaryText']!,
                            style: TextStyle(fontSize: 12),
                          )
                        : null,
                    onTap: () => _onSuggestionSelected(suggestion),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onSuggestionSelected(Map<String, dynamic> suggestion) async {
    final placeId = suggestion['placeId'];
    if (placeId == null) return;

    _removeOverlay();
    // Unfocus the field to prevent overlay from showing again
    _focusNode.unfocus();
    
    setState(() {
      _isLoading = true;
      _suggestions = [];
    });

    try {
      // Get detailed place information
      final placeDetails = await AddressHelper.getPlaceDetails(
        placeId: placeId,
      );

      if (placeDetails != null) {
        // Temporarily remove listener to prevent triggering search when updating text
        widget.controller.removeListener(_onTextChanged);
        
        // Update the text field with the selected address
        widget.controller.text = placeDetails['displayName'] ?? '';

        // Re-add listener after a short delay
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted) {
            widget.controller.addListener(_onTextChanged);
          }
        });

        // Notify parent widget
        widget.onPlaceSelected(placeDetails);
      }
    } catch (e) {
      print('Error getting place details: $e');
      // Re-add listener if there was an error
      if (mounted) {
        widget.controller.addListener(_onTextChanged);
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: TextField(
        controller: widget.controller,
        focusNode: _focusNode,
        decoration:
            widget.decoration ??
            InputDecoration(
              labelText: widget.labelText,
              hintText: widget.hintText,
              suffixIcon: _isLoading
                  ? Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
      ),
    );
  }
}
