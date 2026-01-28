import 'package:flutter/material.dart';
import 'package:astrobharataiuser/widgets/address_autocomplete_field.dart';

/// Example: How to integrate Google Maps Autocomplete in your forms
///
/// This example shows how to replace a regular TextField with AddressAutocompleteField
/// to get smooth address suggestions with automatic coordinate fetching.

class AddressInputExample extends StatefulWidget {
  const AddressInputExample({Key? key}) : super(key: key);

  @override
  State<AddressInputExample> createState() => _AddressInputExampleState();
}

class _AddressInputExampleState extends State<AddressInputExample> {
  // Controllers
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();
  final TextEditingController _timezoneController = TextEditingController();

  @override
  void dispose() {
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _countryController.dispose();
    _pincodeController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    _timezoneController.dispose();
    super.dispose();
  }

  void _handlePlaceSelected(Map<String, dynamic> placeDetails) {
    setState(() {
      // Auto-fill all fields from the selected place
      _cityController.text = placeDetails['city'] ?? '';
      _stateController.text = placeDetails['state'] ?? '';
      _countryController.text = placeDetails['country'] ?? '';
      _pincodeController.text = placeDetails['pincode'] ?? '';
      _latitudeController.text = placeDetails['latitude']?.toString() ?? '';
      _longitudeController.text = placeDetails['longitude']?.toString() ?? '';
      _timezoneController.text = placeDetails['timezone'] ?? '';
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Address selected: ${placeDetails['displayName']}'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Address Autocomplete Example')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Instructions
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue.shade700),
                        const SizedBox(width: 8),
                        Text(
                          'How to use:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '1. Start typing an address in the field below\n'
                      '2. Wait for suggestions to appear\n'
                      '3. Select a suggestion from the dropdown\n'
                      '4. All fields will be auto-filled!',
                      style: TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Autocomplete Address Field
            const Text(
              'Search Address',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            AddressAutocompleteField(
              controller: _addressController,
              hintText: 'Start typing address...',
              labelText: 'Address',
              country: 'in', // Restrict to India (optional)
              onPlaceSelected: _handlePlaceSelected,
            ),
            const SizedBox(height: 24),

            // Auto-filled fields
            const Text(
              'Auto-filled Details',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // City
            TextField(
              controller: _cityController,
              decoration: const InputDecoration(
                labelText: 'City',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_city),
              ),
              readOnly: true,
            ),
            const SizedBox(height: 12),

            // State
            TextField(
              controller: _stateController,
              decoration: const InputDecoration(
                labelText: 'State',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.map),
              ),
              readOnly: true,
            ),
            const SizedBox(height: 12),

            // Country
            TextField(
              controller: _countryController,
              decoration: const InputDecoration(
                labelText: 'Country',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.flag),
              ),
              readOnly: true,
            ),
            const SizedBox(height: 12),

            // Pincode
            TextField(
              controller: _pincodeController,
              decoration: const InputDecoration(
                labelText: 'Pincode',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.pin_drop),
              ),
              readOnly: true,
            ),
            const SizedBox(height: 12),

            // Coordinates Row
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _latitudeController,
                    decoration: const InputDecoration(
                      labelText: 'Latitude',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.my_location),
                    ),
                    readOnly: true,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _longitudeController,
                    decoration: const InputDecoration(
                      labelText: 'Longitude',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.my_location),
                    ),
                    readOnly: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Timezone
            TextField(
              controller: _timezoneController,
              decoration: const InputDecoration(
                labelText: 'Timezone',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.access_time),
              ),
              readOnly: true,
            ),
            const SizedBox(height: 24),

            // Clear button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _addressController.clear();
                    _cityController.clear();
                    _stateController.clear();
                    _countryController.clear();
                    _pincodeController.clear();
                    _latitudeController.clear();
                    _longitudeController.clear();
                    _timezoneController.clear();
                  });
                },
                icon: const Icon(Icons.clear),
                label: const Text('Clear All'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// INTEGRATION GUIDE FOR EXISTING FORMS:
/// 
/// To add autocomplete to your existing forms, replace:
/// 
/// OLD CODE:
/// ```dart
/// TextField(
///   controller: addressController,
///   decoration: InputDecoration(labelText: 'Address'),
/// )
/// ```
/// 
/// NEW CODE:
/// ```dart
/// AddressAutocompleteField(
///   controller: addressController,
///   labelText: 'Address',
///   country: 'in', // Optional: restrict to specific country
///   onPlaceSelected: (placeDetails) {
///     // Auto-fill other fields
///     cityController.text = placeDetails['city'] ?? '';
///     latitudeController.text = placeDetails['latitude']?.toString() ?? '';
///     longitudeController.text = placeDetails['longitude']?.toString() ?? '';
///     // ... etc
///   },
/// )
/// ```
