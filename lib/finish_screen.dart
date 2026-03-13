import 'package:flutter/material.dart';

class FinishClassScreen extends StatefulWidget {
  const FinishClassScreen({super.key});

  @override
  State<FinishClassScreen> createState() => _FinishClassScreenState();
}

class _FinishClassScreenState extends State<FinishClassScreen> {
  String? _location;

  void _handleScan() {
    Future.delayed(const Duration(milliseconds: 600), () {
      setState(() {
        _location = "37.7749° N, 122.4194° W";
      });
    });
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
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

  Widget _buildTextArea(String hint, int lines) {
    return TextField(
      maxLines: lines,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              children: [
                const SizedBox(height: 16),
                const Text(
                  'Reflection',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600, letterSpacing: -0.5),
                ),
                const SizedBox(height: 4),
                Text(
                  "Wrap up today's session",
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
                ),
                const SizedBox(height: 32),
                
                _buildLabel('Key Takeaways'),
                _buildTextArea('What did you learn today?', 4),
                const SizedBox(height: 24),
                
                _buildLabel('Feedback'),
                _buildTextArea('Any thoughts for the instructor?', 3),
                const SizedBox(height: 32),
                
                // Scan Button
                InkWell(
                  onTap: _handleScan,
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: _location != null ? Colors.green.shade50 : Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _location != null ? Colors.green.shade200 : Colors.grey.shade300,
                        style: _location != null ? BorderStyle.solid : BorderStyle.none,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _location != null ? Icons.location_on : Icons.qr_code_scanner,
                          color: _location != null ? Colors.green.shade700 : Colors.grey.shade500,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _location != null ? 'Location Verified' : 'Scan QR Code',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: _location != null ? Colors.green.shade700 : Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (_location != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      _location!,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade400, fontFamily: 'monospace'),
                    ),
                  ),
                const SizedBox(height: 32),
              ],
            ),
          ),
          
          // Submit Button
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: const Text('Submit Reflection', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}