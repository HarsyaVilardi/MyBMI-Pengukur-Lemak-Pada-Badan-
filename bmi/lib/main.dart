import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyBMIApp());
}

class MyBMIApp extends StatelessWidget {
  const MyBMIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyBMI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.teal, useMaterial3: true),
      home: const BMIInputPage(),
    );
  }
}

class BMIInputPage extends StatefulWidget {
  const BMIInputPage({super.key});

  @override
  State<BMIInputPage> createState() => _BMIInputPageState();
}

class _BMIInputPageState extends State<BMIInputPage> {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _calculateBMI() {
    if (_formKey.currentState!.validate()) {
      final weight = double.parse(_weightController.text);
      final height = double.parse(_heightController.text) / 100;
      final bmi = weight / (height * height);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BMIResultPage(bmi: bmi)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.teal.shade50,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Image.asset('assets/logo.png', fit: BoxFit.contain),
                ),
                const SizedBox(height: 20),
                Text(
                  'MyBMI',
                  style: GoogleFonts.poppins(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 40),
                Text(
                  'Please fill your information below :',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 30),
                _buildInputField(
                  controller: _weightController,
                  label: 'Weight(kg)',
                  icon: CupertinoIcons.cube_box_fill,
                  iconAsset: 'assets/weight.png',
                ),
                const SizedBox(height: 20),
                _buildInputField(
                  controller: _heightController,
                  label: 'Height(cm)',
                  icon: CupertinoIcons.arrow_up_down,
                  iconAsset: 'assets/height.png',
                ),
                const SizedBox(height: 40),
                Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.teal.withOpacity(0.4),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: _calculateBMI,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal.shade400,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'CALCULATE BMI',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String iconAsset,
  }) {
    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.teal.shade400,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Image.asset(
            iconAsset,
            width: 30,
            height: 30,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: TextFormField(
            controller: controller,
            keyboardType: TextInputType.number,
            style: GoogleFonts.poppins(fontSize: 16),
            decoration: InputDecoration(
              labelText: label,
              labelStyle: GoogleFonts.poppins(color: Colors.grey.shade600),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.teal.shade200),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.teal.shade400, width: 2),
              ),
              errorBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a value';
              }
              if (double.tryParse(value) == null) {
                return 'Please enter a valid number';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }
}

class BMIResultPage extends StatelessWidget {
  final double bmi;

  const BMIResultPage({super.key, required this.bmi});

  BMICategory _getBMICategory() {
    if (bmi < 18.5) {
      return BMICategory.underweight;
    } else if (bmi >= 18.5 && bmi < 25) {
      return BMICategory.normal;
    } else {
      return BMICategory.overweight;
    }
  }

  Color _getBackgroundColor() {
    switch (_getBMICategory()) {
      case BMICategory.underweight:
        return const Color(0xFFF1C40F);
      case BMICategory.normal:
        return const Color(0xFF1ABC9C);
      case BMICategory.overweight:
        return const Color(0xFFE74C3C);
    }
  }

  String _getCategoryText() {
    switch (_getBMICategory()) {
      case BMICategory.underweight:
        return 'You have an UnderWeight!';
      case BMICategory.normal:
        return 'You have a Normal Weight!';
      case BMICategory.overweight:
        return 'You have an OverWeight!';
    }
  }

  String _getImageAsset() {
    switch (_getBMICategory()) {
      case BMICategory.underweight:
        return 'assets/exclamationMark.png';
      case BMICategory.normal:
        return 'assets/correct.png';
      case BMICategory.overweight:
        return 'assets/warning.png';
    }
  }

  List<AdviceItem> _getAdviceList() {
    switch (_getBMICategory()) {
      case BMICategory.underweight:
        return [
          AdviceItem(
            icon: 'assets/nosugar.png',
            text: "Don't drink water before meals",
          ),
          AdviceItem(icon: 'assets/bigmeal.png', text: 'Use bigger plates'),
          AdviceItem(icon: 'assets/sleep.png', text: 'Get quality sleep'),
        ];
      case BMICategory.normal:
        return [
          AdviceItem(icon: 'assets/active.png', text: 'Stay active.'),
          AdviceItem(
            icon: 'assets/salad.png',
            text: 'Choose the right foods and Cook by yourself.',
          ),
          AdviceItem(
            icon: 'assets/sleep.png',
            text: 'Focus on relaxation and sleep.',
          ),
        ];
      case BMICategory.overweight:
        return [
          AdviceItem(
            icon: 'assets/nosugar.png',
            text: 'Drink water a half hour before meals',
          ),
          AdviceItem(
            icon: 'assets/twoeggs.png',
            text:
                'Eat only two meals per day and make sure that they contains a high protein',
          ),
          AdviceItem(
            icon: 'assets/nosugar.png',
            text: 'Drink coffee or tea and Avoid sugary food',
          ),
        ];
    }
  }

  String _getAdviceHeader() {
    switch (_getBMICategory()) {
      case BMICategory.underweight:
        return 'Here are some advices To help you increase your weight';
      case BMICategory.normal:
        return 'Here are some advices To help you keep your weight';
      case BMICategory.overweight:
        return 'Here are some advices To help you decrease your weight';
    }
  }

  @override
  Widget build(BuildContext context) {
    final category = _getBMICategory();
    final backgroundColor = _getBackgroundColor();

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // BMI Value
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Your BMI = ',
                        style: GoogleFonts.poppins(
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        bmi.toStringAsFixed(2),
                        style: GoogleFonts.poppins(
                          fontSize: 38,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 150,
                    child: Image.asset(_getImageAsset(), fit: BoxFit.contain),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _getCategoryText(),
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24.0),
                child: FutureBuilder(
                  future: Future.delayed(const Duration(seconds: 2)),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CircularProgressIndicator(
                              color: Colors.white,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Loading advices...',
                              style: GoogleFonts.poppins(
                                color: Colors.white70,
                                fontSize: 16,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getAdviceHeader(),
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          child: ListView.builder(
                            itemCount: _getAdviceList().length,
                            itemBuilder: (context, index) {
                              final advice = _getAdviceList()[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.3),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: const EdgeInsets.all(8),
                                      child: Image.asset(
                                        advice.icon,
                                        fit: BoxFit.contain,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          top: 8.0,
                                        ),
                                        child: Text(
                                          advice.text,
                                          style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            color:
                                                category == BMICategory.normal
                                                ? Colors.black87
                                                : Colors.black87,
                                            height: 1.4,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum BMICategory { underweight, normal, overweight }

class AdviceItem {
  final String icon;
  final String text;

  AdviceItem({required this.icon, required this.text});
}
