import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'exam_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.pink.shade50,
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // Logo
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.pink.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.favorite,
                      size: 60,
                      color: Colors.pink.shade400,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Title
                  Text(
                    'BreastCare',
                    style: GoogleFonts.poppins(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.pink.shade400,
                    ),
                  ),

                  Text(
                    'AI Coach',
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.w300,
                      color: Colors.grey.shade700,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Description
                  Text(
                    'Intelligent assistant for\nself-breast examination',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                      fontSize: 18,
                      color: Colors.grey.shade600,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 48),

                  // Stats
                  _buildStatCard(
                    '91%',
                    'Model Accuracy',
                    Icons.check_circle,
                  ),

                  const SizedBox(height: 16),

                  _buildStatCard(
                    '1ms',
                    'Response Time',
                    Icons.flash_on,
                  ),

                  const SizedBox(height: 48),

                  // Main button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ExamScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink.shade400,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 48,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 4,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.play_arrow, size: 28),
                        const SizedBox(width: 12),
                        Text(
                          'Start Exam',
                          style: GoogleFonts.roboto(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Secondary button
                  TextButton(
                    onPressed: () {
                      _showInfoDialog(context);
                    },
                    child: Text(
                      'How does it work?',
                      style: TextStyle(
                        color: Colors.pink.shade400,
                        fontSize: 16,
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Footer
                  Text(
                    'Made with ❤️ for women\'s health',
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 12,
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String value, String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.pink.shade100.withOpacity(0.5),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.pink.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.pink.shade400, size: 28),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink.shade400,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('How does it work?'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildStep('1', 'Place the phone on your wrist'),
              _buildStep('2', 'Perform slow circular movements'),
              _buildStep('3', 'Receive real-time feedback'),
              _buildStep('4', 'Complete all 4 quadrants'),
              const SizedBox(height: 16),
              Text(
                'The AI detects if your movements are correct and guides you to the proper technique.',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it!'),
          ),
        ],
      ),
    );
  }

  Widget _buildStep(String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.pink.shade400,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text),
          ),
        ],
      ),
    );
  }
}
