import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_diary/app/module/label/controller/label_controller.dart';

import '../../general/view/general_settings_screen.dart';
import '../../label/view/label_list_screen.dart';


class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
            // Profile Header
            Container(
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: colorScheme.onPrimary,
                    child: Text(
                      'AJ',
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Alex Johnson',
                    style: TextStyle(
                      color: colorScheme.onPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Premium Member',
                    style: TextStyle(
                      color: colorScheme.onPrimary.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatItem('3', 'Accounts', colorScheme),
                      _buildStatItem('2', 'Cards', colorScheme),
                      _buildStatItem('2020', 'Member Since', colorScheme),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Manage Section
            _buildSectionTitle(context, 'Manage'),
            _buildSettingItem(context,
                icon: Icons.account_balance,
                title: 'Accounts',
                subtitle: 'Manage your bank and wallet accounts'),
            _buildSettingItem(context,
                icon: Icons.category,
                title: 'Categories',
                subtitle: 'Organize income and expense category'),
            _buildSettingItem(context,
                icon: Icons.store,
                title: 'Merchants',
                subtitle: 'Track where you spend or earn'),
            _buildSettingItem(context,
                icon: Icons.label,
                title: 'Labels',
                subtitle: 'Tag and group transactions easily',
                onTap: () => {
                  Get.to(() => LabelListScreen(), binding: BindingsBuilder((){
                    Get.lazyPut(() => LabelController(), fenix: true);
                  }))
                }
            ),
            _buildSettingItem(context,
                icon: Icons.swap_horiz,
                title: 'Transactions',
                subtitle: 'View, edit, or delete transactions'),

            const SizedBox(height: 24),

            // Settings Section
            _buildSectionTitle(context, 'Settings'),
            _buildSettingItem(context,
                icon: Icons.tune,
                title: 'General',
                subtitle: 'Customize app preferences',
                onTap: () => Get.to(GeneralSettingsScreen())),
            _buildSettingItem(context,
                icon: Icons.backup,
                title: 'Backup / Restore',
                subtitle: 'Securely backup or restore data'),
            _buildSettingItem(context,
                icon: Icons.file_download,
                title: 'Export',
                subtitle: 'Export data to Excel or CSV'),
            _buildSettingItem(context,
                icon: Icons.file_upload,
                title: 'Import',
                subtitle: 'Import transactions or data'),
            _buildSettingItem(context,
                icon: Icons.notifications,
                title: 'Notification',
                subtitle: 'Manage your alerts and reminders'),
            _buildSettingItem(context,
                icon: Icons.lock,
                title: 'Security',
                subtitle: 'Set password, PIN, or biometric lock'),

            const SizedBox(height: 24),

            // Application Section
            _buildSectionTitle(context, 'Application'),
            _buildSettingItem(context,
                icon: Icons.info,
                title: 'About',
                subtitle: 'Learn more about this app'),
            _buildSettingItem(context,
                icon: Icons.verified,
                title: 'Version',
                subtitle: 'App version and update info'),

            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurface.withOpacity(0.6),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet), label: 'Wallet'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Analytics'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  // Stat item
  Widget _buildStatItem(String value, String label, ColorScheme colorScheme) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: colorScheme.onPrimary.withOpacity(0.9),
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  // Section title
  Widget _buildSectionTitle(BuildContext context, String title) {
    final colorScheme = Theme.of(context).colorScheme;
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          title,
          style: TextStyle(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  // Setting item with single-line subtitle
  Widget _buildSettingItem(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String subtitle,
        VoidCallback? onTap,
      }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 0,
      child: ListTile(
        leading: Icon(icon, color: colorScheme.primary),
        title: Text(
          title,
          style: TextStyle(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: colorScheme.onSurface.withOpacity(0.7),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing:
        Icon(Icons.chevron_right, color: colorScheme.onSurface.withOpacity(0.6)),
        onTap: onTap
      ),
    );
  }
}
