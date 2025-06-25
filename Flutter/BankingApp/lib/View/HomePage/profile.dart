import 'package:flutter/material.dart';
import 'package:bankingapp/Model/User.dart';
import 'package:bankingapp/Model/Account.dart';
import '../Profile/account_details_sheet.dart';
import '../Profile/edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  final User user;
  final List<Account> accounts; // ✅ Add this line

  const ProfileScreen({
    super.key,
    required this.user,
    required this.accounts, // ✅ Add this line
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = false;
  List<Account> _userAccounts = [];

  @override
  void initState() {
    super.initState();
    _userAccounts = widget.accounts; // ✅ Use passed accounts
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() => _isLoading = true);
    // Here you would fetch additional user data if needed
    setState(() => _isLoading = false);
  }

  Future<void> _handleLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() => _isLoading = true);
      // await AuthService.logout();
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
            context,
            '/login',
                (route) => false
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _navigateToEditProfile(),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 24),
            _buildAccountSection(),
            const SizedBox(height: 24),
            _buildPersonalInfoSection(),
            const SizedBox(height: 24),
            _buildSecuritySection(),
            const SizedBox(height: 40),
            _buildLogoutButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: NetworkImage(
            // widget.user.profileImageUrl ??
                'https://randomuser.me/api/portraits/men/1.jpg',
          ),
        ),
        const SizedBox(height: 16),
        Text(
          widget.user.username ?? 'User',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (widget.user.email != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              widget.user.email!,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildAccountSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Accounts',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            if (_userAccounts.isEmpty)
              const Text('No accounts found'),
            ..._userAccounts.map((account) => ListTile(
              leading: const Icon(Icons.account_balance),
              title: Text(account.accountType ?? 'Account'),
              subtitle: Text(account.accountNumber ?? ''),
              trailing: Text(
                '\$${account.balance?.toStringAsFixed(2) ?? '0.00'}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () => _viewAccountDetails(account),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalInfoSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Personal Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            // _buildInfoRow('Full Name', widget.user.fullName ?? 'Not provided'),
            _buildInfoRow('Email', widget.user.email ?? 'Not provided'),
            // _buildInfoRow('Phone', widget.user.phone ?? 'Not provided'),
            // _buildInfoRow(
            //     // 'Member Since',
            //     // widget.user.joinDate != null
            //     //     ? '${widget.user.joinDate!.toLocal()}'.split(' ')[0]
            //     //     : 'Not available'
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildSecuritySection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Security',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.lock),
              title: const Text('Change Password'),
              trailing: const Icon(Icons.chevron_right),
              onTap: _navigateToChangePassword,
            ),
            ListTile(
              leading: const Icon(Icons.fingerprint),
              title: const Text('Biometric Login'),
              // trailing: Switch(
              //   // value: widget.user.biometricEnabled ?? false,
              //   onChanged: _toggleBiometricAuth,
              // ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.red,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: _handleLogout,
        child: const Text(
          'Logout',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  void _navigateToEditProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(user: widget.user),
      ),
    );
  }

  void _navigateToChangePassword() {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => const ChangePasswordScreen()),
    // );
  }

  void _viewAccountDetails(Account account) {
    showModalBottomSheet(
      context: context,
      builder: (context) => AccountDetailsSheet(account: account),
    );
  }

  Future<void> _toggleBiometricAuth(bool enabled) async {
    setState(() => _isLoading = true);
    // try {
    //   await AuthService.setBiometricPreference(enabled);
    //   if (mounted) {
    //     setState(() {
    //       widget.user.biometricEnabled = enabled;
    //     });
    //   }
    // } catch (e) {
    //   if (mounted) {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(content: Text('Failed to update setting: $e')),
    //     );
    //   }
    // } finally {
    //   if (mounted) {
    //     setState(() => _isLoading = false);
    //   }
    // }
  }
}