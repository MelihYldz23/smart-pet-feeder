import 'package:flutter/material.dart';

class PetInfoScreen extends StatefulWidget {
  const PetInfoScreen({Key? key}) : super(key: key);

  @override
  _PetInfoScreenState createState() => _PetInfoScreenState();
}

class _PetInfoScreenState extends State<PetInfoScreen> {
  final _formKey = GlobalKey<FormState>();

  // Custom colors
  final Color primaryColor = Color(0xFF6C63FF);
  final Color secondaryColor = Color(0xFFF5F6FA);
  final Color textColor = Color(0xFF2D3436);

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  String? _selectedType;

  final List<String> _petTypes = ['Kedi', 'Köpek', 'Kuş', 'Diğer'];

  void _savePetInfo() {
    if (_formKey.currentState!.validate()) {
      String name = _nameController.text.trim();
      String type = _selectedType ?? 'Belirtilmedi';
      int age = int.tryParse(_ageController.text) ?? 0;
      double weight = double.tryParse(_weightController.text) ?? 0.0;
      String notes = _notesController.text.trim();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Hayvan bilgisi kaydedildi: $name'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      appBar: AppBar(
        title: Text(
          'Evcil Hayvan Bilgisi',
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
        child: Form(
          key: _formKey,
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
                        'Evcil Hayvan Bilgileri',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Evcil hayvanınızın bilgilerini giriniz',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 24),
              // İsim
              TextFormField(
                controller: _nameController,
                        decoration: InputDecoration(
                  labelText: 'İsim',
                          hintText: 'Evcil hayvanınızın adı',
                          prefixIcon: Icon(Icons.pets, color: primaryColor),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: primaryColor),
                          ),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'İsim zorunlu' : null,
              ),
                      SizedBox(height: 16),
              // Tür Dropdown
              DropdownButtonFormField<String>(
                value: _selectedType,
                items: _petTypes
                            .map((type) => DropdownMenuItem(
                                  value: type,
                                  child: Text(type),
                                ))
                    .toList(),
                onChanged: (val) => setState(() => _selectedType = val),
                        decoration: InputDecoration(
                  labelText: 'Tür',
                          prefixIcon: Icon(Icons.category, color: primaryColor),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: primaryColor),
                          ),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Tür seçiniz' : null,
              ),
                      SizedBox(height: 16),
              // Yaş
              TextFormField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                  labelText: 'Yaş',
                          hintText: 'Evcil hayvanınızın yaşı',
                          prefixIcon: Icon(Icons.cake, color: primaryColor),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: primaryColor),
                          ),
                ),
                validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'Yaş zorunlu';
                  final n = int.tryParse(value);
                          if (n == null || n < 0)
                            return 'Geçerli yaş giriniz';
                  return null;
                },
              ),
                      SizedBox(height: 16),
              // Ağırlık
              TextFormField(
                controller: _weightController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                  labelText: 'Ağırlık (kg)',
                          hintText: 'Evcil hayvanınızın ağırlığı',
                          prefixIcon: Icon(Icons.monitor_weight, color: primaryColor),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: primaryColor),
                          ),
                ),
                validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'Ağırlık zorunlu';
                  final n = double.tryParse(value);
                          if (n == null || n <= 0)
                            return 'Geçerli ağırlık giriniz';
                  return null;
                },
              ),
                      SizedBox(height: 16),
              // Notlar
              TextFormField(
                controller: _notesController,
                maxLines: 4,
                        decoration: InputDecoration(
                  labelText: 'Notlar',
                          hintText: 'Eklemek istediğiniz notlar',
                          prefixIcon: Icon(Icons.note, color: primaryColor),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
              ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: primaryColor),
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                onPressed: _savePetInfo,
                          icon: Icon(Icons.save),
                          label: Text(
                            'Bilgileri Kaydet',
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
      ),
    );
  }
}
