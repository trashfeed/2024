import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ticket_web/core/extension/is_mobile.dart';
import 'package:ticket_web/feature/auth/data/auth_notifier.dart';
import 'package:ticket_web/gen/i18n/strings.g.dart';

class TicketCards extends ConsumerWidget {
  const TicketCards({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile = MediaQuery.sizeOf(context).isMobile;

    final isLoggedIn = ref.watch(authNotifierProvider) != null;

    final children = [
      _NormalTicketCard(
        isLoggedIn: isLoggedIn,
        onPurchasePressed: () async {},
        onSignInPressed:
            ref.read(authNotifierProvider.notifier).signInWithGoogle,
      ),
      _InvitationTicketCard(
        isLoggedIn: isLoggedIn,
        onApplyCodePressed: (code) async {},
        onSignInPressed:
            ref.read(authNotifierProvider.notifier).signInWithGoogle,
      ),
    ];
    if (isMobile) {
      return Column(
        children: children,
      );
    }
    return IntrinsicHeight(
      child: Row(
        children: children.map((child) => Expanded(child: child)).toList(),
      ),
    );
  }
}

/// 一般チケットのカード
class _NormalTicketCard extends StatelessWidget {
  const _NormalTicketCard({
    required this.isLoggedIn,
    this.onPurchasePressed,
    this.onSignInPressed,
  });

  final bool isLoggedIn;
  final VoidCallback? onPurchasePressed;
  final VoidCallback? onSignInPressed;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final i18n = Translations.of(context);

    return Card.outlined(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(),
            Text(
              i18n.homePage.tickets.normal.name,
              style: textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              i18n.homePage.tickets.normal.description,
              style: textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              i18n.homePage.tickets.normal.price(
                price: NumberFormat('#,###').format(3000),
              ),
              style: textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              onPressed: isLoggedIn
                  ? () async {
                      // TODO(YumNumm): チケットを購入する
                    }
                  : null,
              icon: const Icon(Icons.shopping_cart),
              label: Text(i18n.homePage.tickets.buyTicket),
            ),
          ],
        ),
      ),
    );
  }
}

/// 招待チケット・クーポンコードのカード
class _InvitationTicketCard extends HookWidget {
  const _InvitationTicketCard({
    required this.isLoggedIn,
    this.onApplyCodePressed,
    this.onSignInPressed,
  });

  final bool isLoggedIn;
  final void Function(String code)? onApplyCodePressed;
  final VoidCallback? onSignInPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final i18n = Translations.of(context);

    final textController = useTextEditingController();

    return Card.outlined(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(),
            Text(
              i18n.homePage.tickets.invitation.name,
              style: textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              i18n.homePage.tickets.invitation.description,
            ),
            const SizedBox(height: 16),
            TextField(
              enabled: isLoggedIn,
              controller: textController,
              decoration: InputDecoration(
                labelText: i18n.homePage.tickets.invitation.textBoxTitle,
                hintText: i18n.homePage.tickets.invitation.textBoxDescription,
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
              ),
              onSubmitted: (value) {
                // TODO(YumNumm): クーポンコードを適用する
              },
            ),
            const SizedBox(height: 8),
            FilledButton.icon(
              icon: const Icon(Icons.check),
              label: Text(i18n.homePage.tickets.invitation.applyCodeButton),
              style: FilledButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              onPressed: isLoggedIn
                  ? () async => onApplyCodePressed?.call(textController.text)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
