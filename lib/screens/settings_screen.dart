import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../l10n/app_localizations.dart';
import '../services/settings_service.dart';
import '../services/subscription_service.dart';
import '../services/progress_service.dart';
import '../services/notification_service.dart';
import 'package:package_info_plus/package_info_plus.dart' as pkg_info;
import '../app.dart';
import '../widgets/modern_components.dart';
import '../widgets/animations.dart';
import '../core/theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _soundEffects = true;
  bool _hapticFeedback = true;
  bool _ttsEnabled = true;
  String _language = 'en';
  bool _isLoading = true;
  bool _hasPremium = false;
  DateTime? _subscriptionDate;
  bool _notificationsEnabled = false;
  String _notificationTime = '19:00';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final soundEffects = await SettingsService.getSoundEffectsEnabled();
    final hapticFeedback = await SettingsService.getHapticFeedbackEnabled();
    final language = await SettingsService.getLanguage();
    final ttsEnabled = await SettingsService.getTTSEnabled();

    // Load subscription status
    final subscriptionService = await SubscriptionService.getInstance();
    final hasPremium = await subscriptionService.hasActiveSubscription();
    final subscriptionDate = await subscriptionService.getSubscriptionDate();

    // Load notification settings
    final notificationsEnabled = await NotificationService.areNotificationsEnabled();
    final notificationTime = await NotificationService.getNotificationTime();

    setState(() {
      _soundEffects = soundEffects;
      _hapticFeedback = hapticFeedback;
      _language = language;
      _ttsEnabled = ttsEnabled;
      _hasPremium = hasPremium;
      _subscriptionDate = subscriptionDate;
      _notificationsEnabled = notificationsEnabled;
      _notificationTime = notificationTime;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.backgroundLight,
              AppTheme.surfaceLight,
            ],
          ),
        ),
        child: SafeArea(
          child: _isLoading
              ? const Center(
                  child: ModernLoadingIndicator(
                    message: 'Loading settings...',
                  ),
                )
              : ListView(
                  children: [
                    // Modern header
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              gradient: AppTheme.primaryGradient,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.primaryIndigo.withValues(alpha: 0.3),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.settings,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.settingsTitle,
                                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.textPrimary,
                                  ),
                                ),
                                Text(
                                  'Customize your experience',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Settings sections
                    StaggeredAnimation(
                      children: [
                        _buildModernSection(
                          title: l10n.settingsAppPreferences,
                          icon: Icons.tune,
                          children: [
                            _buildModernSwitchTile(
                              title: l10n.settingsSoundEffects,
                              subtitle: l10n.settingsSoundEffectsSubtitle,
                              icon: Icons.volume_up,
                              value: _soundEffects,
                              onChanged: (value) async {
                                HapticFeedback.lightImpact();
                                await SettingsService.setSoundEffectsEnabled(value);
                                setState(() => _soundEffects = value);
                              },
                            ),
                            _buildModernSwitchTile(
                              title: l10n.settingsHapticFeedback,
                              subtitle: l10n.settingsHapticFeedbackSubtitle,
                              icon: Icons.vibration,
                              value: _hapticFeedback,
                              onChanged: (value) async {
                                if (value) HapticFeedback.lightImpact();
                                await SettingsService.setHapticFeedbackEnabled(value);
                                setState(() => _hapticFeedback = value);
                              },
                            ),
                            _buildModernSwitchTile(
                              title: l10n.settingsTts,
                              subtitle: l10n.settingsTtsSubtitle,
                              icon: Icons.record_voice_over,
                              value: _ttsEnabled,
                              onChanged: (value) async {
                                HapticFeedback.lightImpact();
                                await SettingsService.setTTSEnabled(value);
                                setState(() => _ttsEnabled = value);
                              },
                            ),
                          ],
                        ),

                        _buildModernSection(
                          title: 'Notifications',
                          icon: Icons.notifications_active,
                          children: [
                            _buildModernSwitchTile(
                              title: 'Daily Reminders',
                              subtitle: 'Get reminded to practice German every day',
                              icon: Icons.alarm,
                              value: _notificationsEnabled,
                              onChanged: (value) async {
                                HapticFeedback.lightImpact();
                                await NotificationService.setNotificationsEnabled(value);
                                setState(() => _notificationsEnabled = value);

                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        value
                                            ? 'Daily reminders enabled!'
                                            : 'Daily reminders disabled',
                                      ),
                                      backgroundColor: value ? AppTheme.accentGreen : Colors.grey,
                                    ),
                                  );
                                }
                              },
                            ),
                            if (_notificationsEnabled)
                              _buildModernActionTile(
                                title: 'Reminder Time',
                                subtitle: _notificationTime,
                                icon: Icons.access_time,
                                iconColor: AppTheme.primaryIndigo,
                                onTap: () => _showTimePicker(),
                              ),
                            _buildModernActionTile(
                              title: 'Test Notification',
                              subtitle: 'Send a test notification now',
                              icon: Icons.notifications,
                              iconColor: Colors.orange,
                              onTap: () async {
                                HapticFeedback.lightImpact();
                                await NotificationService.showTestNotification();
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Test notification sent!'),
                                      backgroundColor: AppTheme.accentGreen,
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),

                        _buildModernSection(
                          title: 'Premium Subscription',
                          icon: Icons.workspace_premium,
                          children: [
                            _buildPremiumStatusCard(),
                            _buildModernSwitchTile(
                              title: 'Testing Mode: Premium Access',
                              subtitle: 'Toggle premium subscription for testing',
                              icon: Icons.bug_report,
                              value: _hasPremium,
                              onChanged: (value) async {
                                HapticFeedback.lightImpact();
                                final subscriptionService = await SubscriptionService.getInstance();
                                if (value) {
                                  await subscriptionService.activateSubscription();
                                } else {
                                  await subscriptionService.deactivateSubscription();
                                }
                                await _loadSettings();
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        value
                                            ? 'Premium activated! All topics unlocked.'
                                            : 'Premium deactivated. Only free topics available.',
                                      ),
                                      backgroundColor: value ? AppTheme.accentGreen : Colors.orange,
                                    ),
                                  );
                                }
                              },
                            ),
                            _buildModernActionTile(
                              title: 'Manage Subscription',
                              subtitle: 'View premium features and benefits',
                              icon: Icons.shopping_bag,
                              iconColor: Colors.orange,
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Premium features coming soon!'),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),

                        _buildModernSection(
                          title: l10n.settingsLanguage,
                          icon: Icons.language,
                          children: [
                            _buildModernRadioTile(
                              title: l10n.settingsLanguageEnglish,
                              value: 'en',
                              groupValue: _language,
                              onChanged: (value) async {
                                HapticFeedback.lightImpact();
                                await SettingsService.setLanguage(value!);
                                setState(() => _language = value);
                                if (mounted) {
                                  LearniqApp.setLocale(context, value);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(l10n.settingsLanguageChanged),
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                }
                              },
                            ),
                            _buildModernRadioTile(
                              title: l10n.settingsLanguageRussian,
                              value: 'ru',
                              groupValue: _language,
                              onChanged: (value) async {
                                HapticFeedback.lightImpact();
                                await SettingsService.setLanguage(value!);
                                setState(() => _language = value);
                                if (mounted) {
                                  LearniqApp.setLocale(context, value);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(l10n.settingsLanguageChangedRu),
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                }
                              },
                            ),
                            _buildModernRadioTile(
                              title: l10n.settingsLanguageUkrainian,
                              value: 'uk',
                              groupValue: _language,
                              onChanged: (value) async {
                                HapticFeedback.lightImpact();
                                await SettingsService.setLanguage(value!);
                                setState(() => _language = value);
                                if (mounted) {
                                  LearniqApp.setLocale(context, value);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(l10n.settingsLanguageChangedUk),
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),

                        _buildModernSection(
                          title: l10n.settingsData,
                          icon: Icons.storage,
                          children: [
                            _buildModernActionTile(
                              title: l10n.settingsClearProgress,
                              subtitle: l10n.settingsClearProgressSubtitle,
                              icon: Icons.delete_forever,
                              iconColor: AppTheme.dieColor,
                              onTap: () => _showClearProgressDialog(),
                            ),
                            _buildModernActionTile(
                              title: l10n.settingsResetToDefaults,
                              subtitle: l10n.settingsResetToDefaultsSubtitle,
                              icon: Icons.restore,
                              iconColor: Colors.orange,
                              onTap: () => _showResetSettingsDialog(),
                            ),
                          ],
                        ),

                        _buildModernSection(
                          title: l10n.settingsAbout,
                          icon: Icons.info_outline,
                          children: [
                            FutureBuilder<pkg_info.PackageInfo>(
                              future: pkg_info.PackageInfo.fromPlatform(),
                              builder: (context, snapshot) {
                                final version = snapshot.data?.version ?? '1.0.0';
                                final buildNumber = snapshot.data?.buildNumber ?? '1';
                                return _buildModernInfoTile(
                                  title: l10n.settingsVersion,
                                  subtitle: '$version ($buildNumber)',
                                  icon: Icons.info,
                                );
                              },
                            ),
                            _buildModernInfoTile(
                              title: l10n.settingsDeveloper,
                              subtitle: l10n.settingsDeveloperName,
                              icon: Icons.person,
                            ),
                            _buildModernActionTile(
                              title: l10n.settingsPrivacyPolicy,
                              subtitle: l10n.settingsPrivacyPolicySubtitle,
                              icon: Icons.privacy_tip,
                              iconColor: AppTheme.primaryIndigo,
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(l10n.settingsPrivacyPolicyMessage),
                                  ),
                                );
                              },
                            ),
                            _buildModernInfoTile(
                              title: l10n.settingsLicense,
                              subtitle: l10n.settingsLicenseSubtitle,
                              icon: Icons.gavel,
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Row(
            children: [
              Icon(icon, size: 20, color: Colors.grey[700]),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
        ...children,
        const Divider(height: 1),
      ],
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      secondary: Icon(icon, color: Theme.of(context).primaryColor),
      value: value,
      onChanged: onChanged,
    );
  }

  Widget _buildRadioTile({
    required String title,
    required String value,
    required String groupValue,
    required ValueChanged<String?> onChanged,
  }) {
    return ListTile(
      title: Text(title),
      leading: Radio<String>(
        value: value,
        groupValue: groupValue,
        onChanged: onChanged,
      ),
      onTap: () => onChanged(value),
    );
  }

  Widget _buildActionTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
    );
  }

  Widget _buildInfoTile({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[600]),
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }

  void _showClearProgressDialog() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.settingsClearProgressDialogTitle),
        content: Text(
          l10n.settingsClearProgressDialogMessage,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.settingsClearProgressDialogCancel),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              // Clear all progress data
              try {
                await ProgressService.clearAllProgress();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.settingsClearProgressSuccess),
                      backgroundColor: AppTheme.accentGreen,
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.settingsClearProgressError(e.toString())),
                      backgroundColor: AppTheme.dieColor,
                    ),
                  );
                }
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(l10n.settingsClearProgressDialogConfirm),
          ),
        ],
      ),
    );
  }

  void _showResetSettingsDialog() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.settingsResetDialogTitle),
        content: Text(
          l10n.settingsResetDialogMessage,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.settingsResetDialogCancel),
          ),
          TextButton(
            onPressed: () async {
              await SettingsService.resetToDefaults();
              await _loadSettings();
              if (mounted) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.settingsResetSuccess),
                  ),
                );
              }
            },
            child: Text(l10n.settingsResetDialogConfirm),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }

  Widget _buildModernSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: ModernCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ModernSectionHeader(
              title: title,
              icon: icon,
            ),
            const SizedBox(height: 8),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildModernSwitchTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: CustomAnimatedScale(
        onTap: () => onChanged(!value),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: value 
                ? AppTheme.primaryIndigo.withValues(alpha: 0.1)
                : AppTheme.textSecondary.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: value 
                  ? AppTheme.primaryIndigo.withValues(alpha: 0.3)
                  : AppTheme.textSecondary.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: value 
                      ? AppTheme.primaryIndigo.withValues(alpha: 0.2)
                      : AppTheme.textSecondary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: value ? AppTheme.primaryIndigo : AppTheme.textSecondary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: value,
                onChanged: onChanged,
                thumbColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return AppTheme.primaryIndigo;
                  }
                  return null;
                }),
                trackColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return AppTheme.primaryIndigo.withValues(alpha: 0.3);
                  }
                  return null;
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernActionTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: CustomAnimatedScale(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.textSecondary.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.textSecondary.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: AppTheme.textSecondary,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernRadioTile({
    required String title,
    required String value,
    required String groupValue,
    required ValueChanged<String?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: CustomAnimatedScale(
        onTap: () => onChanged(value),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: value == groupValue 
                ? AppTheme.primaryIndigo.withValues(alpha: 0.1)
                : AppTheme.textSecondary.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: value == groupValue 
                  ? AppTheme.primaryIndigo.withValues(alpha: 0.3)
                  : AppTheme.textSecondary.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Radio<String>(
                value: value,
                groupValue: groupValue,
                onChanged: onChanged,
                activeColor: AppTheme.primaryIndigo,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernInfoTile({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.textSecondary.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.textSecondary.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.textSecondary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: AppTheme.textSecondary,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumStatusCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: _hasPremium
              ? AppTheme.successGradient
              : LinearGradient(
                  colors: [
                    AppTheme.textSecondary.withValues(alpha: 0.1),
                    AppTheme.textSecondary.withValues(alpha: 0.05),
                  ],
                ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _hasPremium
                ? AppTheme.accentGreen.withValues(alpha: 0.3)
                : AppTheme.textSecondary.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _hasPremium ? Icons.verified : Icons.lock,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _hasPremium ? 'Premium Active' : 'Free Version',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _subscriptionDate != null
                        ? 'Activated: ${_formatDate(_subscriptionDate!)}'
                        : 'Only 1 free topic available',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),
            if (_hasPremium)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'PRO',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _showTimePicker() async {
    final parts = _notificationTime.split(':');
    final initialTime = TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );

    final picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppTheme.primaryIndigo,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppTheme.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final newTime = '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      await NotificationService.setNotificationTime(newTime);
      setState(() => _notificationTime = newTime);

      if (mounted) {
        HapticFeedback.lightImpact();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Reminder time updated to $newTime'),
            backgroundColor: AppTheme.accentGreen,
          ),
        );
      }
    }
  }
}
