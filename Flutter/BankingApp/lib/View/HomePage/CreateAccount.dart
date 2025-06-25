import 'package:flutter/material.dart';
import '../../Model/AuthService.dart';
import '../../Services/CreateAccount/AccountService.dart';
import '../Auth/login.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  String _selectedAccountType = 'savings';
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;

  final List<String> _accountTypes = ['savings', 'checking'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Open New Account'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _isSubmitting ? null : () => Navigator.pop(context),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAccountTypeDropdown(),
            const SizedBox(height: 25),
            _buildAccountFeatures(),
            const SizedBox(height: 30),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountTypeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Account Type',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),
        DropdownButtonFormField<String>(
          value: _selectedAccountType,
          items: _accountTypes.map((type) {
            return DropdownMenuItem(
              value: type,
              child: Text(type[0].toUpperCase() + type.substring(1)), // Capitalize
            );
          }).toList(),
          onChanged: _isSubmitting ? null : (value) {
            setState(() => _selectedAccountType = value!);
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            filled: true,
            fillColor: Colors.grey[100],
          ),
        ),
      ],
    );
  }

  Widget _buildAccountFeatures() {
    final features = {
      'savings': [
        'Interest rate: 2.5% p.a.',
        'No minimum balance',
        'Free online banking',
        'ATM card included'
      ],
      'checking': [
        'Higher interest rates',
        'Market-linked returns',
        'Tax benefits',
        'Minimum deposit: \$1,000'
      ],
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Account Features',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ...?features[_selectedAccountType]?.map((feature) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 20),
              const SizedBox(width: 10),
              Expanded(child: Text(feature)),
            ],
          ),
        )),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: Colors.blue[800],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: _isSubmitting ? null : _submitAccountRequest,
        child: _isSubmitting
            ? const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2,
          ),
        )
            : const Text(
          'Create Account',
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }

  Future<void> _submitAccountRequest() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final response = await AccountService.createAccount(
        accountType: _selectedAccountType,
      );

      if (!mounted) return;

      if (response.shouldLogout) {
        _handleSessionExpired();
        return;
      }

      if (response.success) {
        _showSuccessDialog(response);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  void _handleSessionExpired() {
    AuthService.clearAuthData();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Session expired. Please login again.'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccessDialog(AccountResponse response) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Account Created Successfully'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Account Type: ${response.account?.accountType ?? 'N/A'}'),
            Text('Account Number: ${response.account?.accountNumber ?? 'N/A'}'),
            Text('Initial Balance: \$${response.account?.balance.toStringAsFixed(2) ?? '0.00'}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context, true); // Return success to previous screen
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}