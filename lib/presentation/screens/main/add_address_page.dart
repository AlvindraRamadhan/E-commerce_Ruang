import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 
import 'package:provider/provider.dart';
import 'package:ruang/l10n/app_strings.dart';
import 'package:ruang/presentation/providers/locale_provider.dart';

class AddAddressPage extends StatefulWidget {
  const AddAddressPage({super.key});

  @override
  State<AddAddressPage> createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _provinceController = TextEditingController();
  final _postalCodeController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _provinceController.dispose();
    _postalCodeController.dispose();
    super.dispose();
  }

  Future<void> _saveAddress() async {
    final locale = context.read<LocaleProvider>().locale;
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        setState(() => _isLoading = false);
        return;
      }

      try {
        final addressData = {
          'fullName': _fullNameController.text,
          'phoneNumber': _phoneController.text,
          'address': _addressController.text,
          'city': _cityController.text,
          'province': _provinceController.text,
          'postalCode': _postalCodeController.text,
          'isDefault': false,
        };

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('addresses')
            .add(addressData);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(AppStrings.get(locale, 'addressSavedSuccess'))),
          );
          Navigator.of(context).pop();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text('${AppStrings.get(locale, 'addressSavedFailed')} $e')),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleProvider>().locale;

    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.get(locale, 'addAddressTitle'))),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _fullNameController,
                decoration: InputDecoration(
                    labelText: AppStrings.get(locale, 'fullNameLabel')),
                validator: (value) => value!.isEmpty
                    ? AppStrings.get(locale, 'fieldCannotBeEmpty')
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                    labelText: AppStrings.get(locale, 'phoneLabel')),
                keyboardType: TextInputType.phone,
                validator: (value) => value!.isEmpty
                    ? AppStrings.get(locale, 'fieldCannotBeEmpty')
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                    labelText: AppStrings.get(locale, 'addressLabel')),
                validator: (value) => value!.isEmpty
                    ? AppStrings.get(locale, 'fieldCannotBeEmpty')
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _cityController,
                decoration: InputDecoration(
                    labelText: AppStrings.get(locale, 'cityLabel')),
                validator: (value) => value!.isEmpty
                    ? AppStrings.get(locale, 'fieldCannotBeEmpty')
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _provinceController,
                decoration: InputDecoration(
                    labelText: AppStrings.get(locale, 'provinceLabel')),
                validator: (value) => value!.isEmpty
                    ? AppStrings.get(locale, 'fieldCannotBeEmpty')
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _postalCodeController,
                decoration: InputDecoration(
                    labelText: AppStrings.get(locale, 'postalCodeLabel')),
                keyboardType: TextInputType.number,
                // PERUBAHAN: Menambahkan formatter untuk hanya menerima angka
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) => value!.isEmpty
                    ? AppStrings.get(locale, 'fieldCannotBeEmpty')
                    : null,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveAddress,
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(color: Colors.white))
                      : Text(AppStrings.get(locale, 'saveAddressButton')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
