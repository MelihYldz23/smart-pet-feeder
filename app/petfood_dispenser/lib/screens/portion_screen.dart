import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PortionScreen extends StatefulWidget {
  @override
  _PortionScreenState createState() => _PortionScreenState();
}

class _PortionScreenState extends State<PortionScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  double portionAngle = 30; // Varsayılan 30 derece
  final String espUrl = "http://172.20.10.4"; // ESP IP adresini güncelle

  // Custom colors
  final Color primaryColor = Color(0xFF6C63FF);
  final Color secondaryColor = Color(0xFFF5F6FA);
  final Color textColor = Color(0xFF2D3436);

  bool isSending = false;
  String message = "";

  // Açıyı grama çeviren fonksiyon (30° = 15g)
  double angleToGrams(double angle) {
    return (angle * 0.5).roundToDouble();
  }

  // Gramı açıya çeviren fonksiyon (15g = 30°)
  double gramsToAngle(double grams) {
    return (grams * 2).roundToDouble();
  }

  @override
  void initState() {
    super.initState();
    _loadSavedPortion();
    // Ensure initial value is at least 15g (30 degrees)
    if (portionAngle < 30) {
      portionAngle = 30;
    }
  }

  Future<void> _loadSavedPortion() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedPortion = prefs.getDouble('portionAngle');
      if (savedPortion != null) {
        setState(() {
          // Ensure loaded value is at least 15g (30 degrees)
          portionAngle = savedPortion < 30 ? 30 : savedPortion;
        });
      }
    } catch (e) {
      print('Değer yüklenirken hata: $e');
    }
  }

  Future<void> _savePortion(double angle) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('portionAngle', angle);
    } catch (e) {
      print('Değer kaydedilirken hata: $e');
    }
  }

  Future<void> sendPortionSetting() async {
    setState(() {
      isSending = true;
    });

    final url = Uri.parse('$espUrl/set_portion?angle=${portionAngle.toInt()}');
    try {
      await http.get(url);
    } catch (e) {
      // Silently continue on error
    } finally {
      await _savePortion(portionAngle);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Mama miktarı başarıyla kaydedildi'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
          margin: EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      setState(() {
        isSending = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: secondaryColor,
      appBar: AppBar(
        title: Text(
          "Mama Miktarı Ayarı",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Mama Miktarı Kontrolü",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Servo motorun dönme açısını ayarlayarak mama miktarını kontrol edebilirsiniz.",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Mama Miktarı",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: textColor,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "${angleToGrams(portionAngle).toInt()} g",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    SliderTheme(
                      data: SliderThemeData(
                        activeTrackColor: primaryColor,
                        inactiveTrackColor: primaryColor.withOpacity(0.2),
                        thumbColor: primaryColor,
                        overlayColor: primaryColor.withOpacity(0.1),
                        valueIndicatorColor: primaryColor,
                        valueIndicatorTextStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      child: Slider(
                        min: 30, // 15g = 30 degrees
                        max: 180,
                        divisions: 5,
                        value: portionAngle,
                        label: "${angleToGrams(portionAngle).toInt()} g",
                        onChanged: (value) {
                          // Convert to grams first
                          double grams = angleToGrams(value);
                          // Round to nearest multiple of 15
                          grams = (grams / 15).round() * 15;
                          // Ensure minimum of 15g
                          grams = grams < 15 ? 15 : grams;
                          // Convert back to angle
                          double newAngle = gramsToAngle(grams);
                          setState(() {
                            portionAngle = newAngle;
                          });
                          _savePortion(newAngle);
                        },
                      ),
                    ),
                    SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: isSending ? null : sendPortionSetting,
                        icon: isSending
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Icon(Icons.save),
                        label: Text(
                          isSending ? "Gönderiliyor..." : "Ayarı Kaydet",
                          style: TextStyle(fontSize: 16),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
