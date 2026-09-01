import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../app/di/injection.dart';
import '../providers/transaction_provider.dart';
import '../widgets/common/empty_state.dart';
import '../widgets/common/loading_shimmer.dart';
import '../widgets/payments/payments_tab.dart';
import '../widgets/appointments/appointments_tab.dart';
import '../widgets/others/others_tab.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ Fix: Wrap with ChangeNotifierProvider to provide TransactionProvider to the widget tree
    return ChangeNotifierProvider(
      create: (_) => getIt<TransactionProvider>()..fetchTransactions(),
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: Colors.grey.shade50,
          appBar: AppBar(
            title: const Text("Past Transactions"),
            backgroundColor: const Color(0xFF00456A),
            foregroundColor: Colors.white,
            bottom: const TabBar(
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              tabs: [
                Tab(text: "Payments"),
                Tab(text: "Appointments"),
                Tab(text: "Others"),
              ],
            ),
          ),
          body: Consumer<TransactionProvider>(
            builder: (context, provider, _) {
              if (provider.isLoading) {
                return const LoadingShimmer();
              }

              if (provider.errorMessage != null) {
                return Center(child: Text(provider.errorMessage!));
              }

              if (provider.transactions.isEmpty) {
                return const EmptyState();
              }

              return TabBarView(
                children: [
                  PaymentsTab(transactions: provider.transactions),
                  AppointmentsTab(transactions: provider.transactions),
                  OthersTab(transactions: provider.transactions),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
