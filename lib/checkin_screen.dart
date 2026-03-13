import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'data/local_store.dart';
import 'qr_scan_screen.dart';

class CheckInScreen extends StatefulWidget {
  const CheckInScreen({super.key});

  @override
  State<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _studentIdController = TextEditingController();
  final _previousTopicController = TextEditingController();
  final _expectedTopicController = TextEditingController();

  int? _selectedMood;
  bool _isSubmitting = false;
  bool _isCapturing = false;
  String? _qrCodeData;
  Position? _position;

  @override
  void initState() {
    super.initState();
    _loadLastStudentId();
  }

  @override
  void dispose() {
    _studentIdController.dispose();
    _previousTopicController.dispose();
    _expectedTopicController.dispose();
    super.dispose();
  }

  Future<void> _loadLastStudentId() async {
    final lastStudentId = await LocalStore.getLastStudentId();
    if (!mounted || lastStudentId == null || lastStudentId.isEmpty) {
      return;
    }

    _studentIdController.text = lastStudentId;
  }

  Future<void> _scanAndCapture() async {
    setState(() => _isCapturing = true);

    try {
      final qrCode = await Navigator.push<String>(
        context,
        MaterialPageRoute(builder: (_) => const QrScanScreen()),
      );

      if (!mounted || qrCode == null || qrCode.isEmpty) {
        return;
      }

      final position = await _getCurrentPosition();
      if (!mounted || position == null) {
        return;
      }

      setState(() {
        _qrCodeData = qrCode;
        _position = position;
      });
    } finally {
      if (mounted) {
        setState(() => _isCapturing = false);
      }
    }
  }

  Future<Position?> _getCurrentPosition() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showMessage('Location service is disabled.');
      return null;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      _showMessage('Location permission is required for check-in.');
      return null;
    }

    return Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<void> _submit() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }

    if (_selectedMood == null) {
      _showMessage('Please select your mood (1-5).');
      return;
    }

    if (_position == null || _qrCodeData == null) {
      _showMessage('Please scan QR and capture location first.');
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final record = <String, dynamic>{
        'studentId': _studentIdController.text.trim(),
        'timestamp': DateTime.now().toIso8601String(),
        'latitude': _position!.latitude,
        'longitude': _position!.longitude,
        'qrCodeData': _qrCodeData,
        'previousTopic': _previousTopicController.text.trim(),
        'expectedTopic': _expectedTopicController.text.trim(),
        'mood': _selectedMood,
      };

      await LocalStore.saveCheckIn(record);
      await LocalStore.saveLastStudentId(_studentIdController.text.trim());

      if (!mounted) {
        return;
      }

      _showMessage('Check-in saved successfully.');
      Navigator.pop(context);
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade400,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Required field';
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400),
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.all(16),
      ),
    );
  }

  Widget _buildScanCard() {
    final hasData = _position != null && _qrCodeData != null;
    final lat = _position?.latitude.toStringAsFixed(6) ?? '-';
    final lng = _position?.longitude.toStringAsFixed(6) ?? '-';

    return InkWell(
      onTap: _isCapturing ? null : _scanAndCapture,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: hasData ? Colors.green.shade50 : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: hasData ? Colors.green.shade200 : Colors.grey.shade300,
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _isCapturing
                      ? Icons.sync
                      : hasData
                          ? Icons.verified
                          : Icons.qr_code_scanner,
                  color: hasData ? Colors.green.shade700 : Colors.grey.shade600,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  _isCapturing
                      ? 'Scanning & Capturing Location...'
                      : hasData
                          ? 'QR + Location Verified'
                          : 'Scan QR & Capture Location',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: hasData ? Colors.green.shade700 : Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            if (hasData) ...[
              const SizedBox(height: 8),
              Text(
                'QR: $_qrCodeData',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 4),
              Text(
                'Lat: $lat, Lng: $lng',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  const SizedBox(height: 16),
                  const Text(
                    'Check-in',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Prepare for today's session",
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
                  ),
                  const SizedBox(height: 32),
                  _buildLabel('Student ID'),
                  _buildTextField(
                    controller: _studentIdController,
                    hint: 'Enter your student ID',
                  ),
                  const SizedBox(height: 24),
                  _buildLabel('Previous Topic'),
                  _buildTextField(
                    controller: _previousTopicController,
                    hint: 'What did we cover last time?',
                  ),
                  const SizedBox(height: 24),
                  _buildLabel('Expected Topic'),
                  _buildTextField(
                    controller: _expectedTopicController,
                    hint: 'What are we learning today?',
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildLabel('Mood Before Class'),
                      if (_selectedMood != null)
                        Text(
                          '$_selectedMood/5',
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(5, (index) {
                      final mood = index + 1;
                      final isSelected = _selectedMood == mood;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedMood = mood),
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Colors.black
                                    : Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                mood.toString(),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.grey.shade400,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 32),
                  _buildScanCard(),
                  const SizedBox(height: 32),
                ],
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    _isSubmitting ? 'Saving...' : 'Submit Check-in',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
