import 'package:bankingapp/View/HomePage/profile.dart';
import 'package:flutter/material.dart';
import '../../Model/User.dart';
import '../../Model/Account.dart';
import '../../Services/CreateAccount/GetDataService.dart';
import 'package:bankingapp/Components/Dashboard/account_balance_card.dart';
import 'package:bankingapp/Components/Dashboard/promo_banner.dart';
import 'package:bankingapp/Components/Dashboard/quick_actions.dart';
import 'package:bankingapp/Components/Dashboard/recent_transactions.dart';
import 'package:bankingapp/Components/Dashboard/welcome_header.dart';
import 'package:bankingapp/View/HomePage/CreateAccount.dart';
import 'package:bankingapp/View/HomePage/History.dart';
import 'package:bankingapp/View/HomePage/Transfer.dart';

class Dashboard extends StatefulWidget {
  final User user;
  const Dashboard({
    super.key,
    required this.user,
  });

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool _balanceVisible = false;
  List<Account> _accounts = [];
  double _totalBalance = 0.0;
  bool _isLoading = true;
  int _currentIndex = 0;
  final List<Map<String, dynamic>> _quickActions = [
    {'icon': Icons.send, 'label': 'Transfer'},
    {'icon': Icons.account_balance, 'label': 'Add Account'},
    {'icon': Icons.payment, 'label': 'Pay'},
    {'icon': Icons.history, 'label': 'History'},
  ];

  final List<Map<String, dynamic>> _recentTransactions = [
    {
        'title': 'Grocery Store',
      'amount': -85.50,
      'date': DateTime.now().subtract(const Duration(hours: 2)),
      'icon': Icons.shopping_cart
    },
    // Add more transactions as needed...
  ];

  @override
  void initState() {
    super.initState();
    _fetchAccounts();
  }

  Future<void> _fetchAccounts() async {
    setState(() {
      _isLoading = true;
    });
    final response = await GetDataService.getAccountsByUserId();
    if (response.success && response.accounts != null) {
      double total = response.accounts!
          .map((acc) => acc.balance ?? 0.0)
          .fold(0.0, (a, b) => a + b);
      setState(() {
        _accounts = response.accounts!;
        _totalBalance = total;
        _isLoading = false;
      });
    } else {
      setState(() {
        _accounts = [];
        _totalBalance = 0.0;
        _isLoading = false;
      });
      // Optionally, show an error message using response.message
    }
  }

  void _toggleBalanceVisibility() {
    setState(() {
      _balanceVisible = !_balanceVisible;
    });
  }

  void _onQuickActionSelected(String action) {
    if (action == 'Transfer') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TransferScreen(accounts: _accounts),
        ),
      );
    } else if (action == 'History') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HistoryScreen(accounts: _accounts),
        ),
      );
    } else if (action == 'Add Account') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CreateAccountScreen()),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Dashboard')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _fetchAccounts,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              WelcomeHeader(
                userName: widget.user.username ?? 'User',
                profileImageUrl: 'https://randomuser.me/api/portraits/men/1.jpg',
              ),
              const SizedBox(height: 16),
              AccountBalanceCard(
                balanceVisible: _balanceVisible,
                onVisibilityChanged: _toggleBalanceVisibility,
                totalBalance: _totalBalance,
                accounts: _accounts.map((acc) => {
                  'name': acc.accountType,
                  'balance': acc.balance,
                }).toList(),
              ),
              const SizedBox(height: 24),
              // QuickActions(
              //   actions: _quickActions,
              //   onActionSelected: (action) => _onQuickActionSelected(action['label']),
              // ),
              QuickActions(
                actions: _quickActions,
                onActionSelected: _onQuickActionSelected,
              ),

              const SizedBox(height: 24),
              RecentTransactions(
                transactions: _recentTransactions,
                onViewAll: () {
                  // Navigate to full transactions screen
                },
                onTransactionTap: (transaction) {
                  // Handle transaction tap
                },
              ),
              const SizedBox(height: 24),
              const PromoBanner(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        // currentIndex: 0,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileScreen(
                  user: widget.user,
                  accounts: _accounts,
                ),
              ),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.credit_card),
            label: 'Cards',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
