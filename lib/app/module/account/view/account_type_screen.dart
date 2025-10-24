import 'package:flutter/material.dart';

class SelectAccountTypeScreen extends StatelessWidget {
  const SelectAccountTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Select Account Type',
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCategory(
                context,
                'Cash',
                [
                  _buildAccountCard(context, 'assets/icons/bank.png', 'Bank'),
                  _buildAccountCard(context, 'assets/icons/dollar.png', 'Cash'),
                  _buildAccountCard(context, 'assets/icons/wallet.png', 'Wallet'),
                  _buildAccountCard(context, 'assets/icons/saving.png', 'Savings'),
                  _buildAccountCard(context, 'assets/icons/borrow.png', 'Lending'),
                ],
              ),
              _buildCategory(
                context,
                'Credit',
                [
                  _buildAccountCard(context, 'assets/icons/credit.png', 'Credit'),
                  _buildAccountCard(context, 'assets/icons/line-of-credit.png', 'Line of Credit'),
                ],
              ),
              _buildCategory(
                context,
                'Investment',
                [
                  _buildAccountCard(context, 'assets/icons/retirement.png', 'Retirement'),
                  _buildAccountCard(context, 'assets/icons/brokerage.png', 'Brokerage'),
                  _buildAccountCard(context, 'assets/icons/investment.png', 'Investment'),
                  _buildAccountCard(context, 'assets/icons/insurance.png', 'Insurance'),
                  _buildAccountCard(context, 'assets/icons/bitcoin.png', 'Crypto'),
                ],
              ),
              _buildCategory(
                context,
                'Loans',
                [
                  _buildAccountCard(context, 'assets/icons/loan.png', 'Loan'),
                  _buildAccountCard(context, 'assets/icons/mortgage.png', 'Mortgage'),
                  _buildAccountCard(context, 'assets/icons/debt.png', 'Borrowing'),
                ],
              ),
              _buildCategory(
                context,
                'Assets',
                [
                  _buildAccountCard(context, 'assets/icons/assets.png', 'Property'),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategory(BuildContext context, String title, List<Widget> items) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 1.35,
            children: items,
          ),
        ],
      ),
    );
  }

  Widget _buildAccountCard(BuildContext context, String icon, String label) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.zero,
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(icon, width: 40, height: 40,),
              const SizedBox(height: 4),
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.labelMedium?.copyWith(
                  fontSize: 15,
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
