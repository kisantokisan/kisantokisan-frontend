import 'package:flutter/material.dart';
import '../design/tokens/tokens.dart';
import '../widgets/components.dart';

class ComponentsPreview extends StatelessWidget {
  ComponentsPreview({super.key});
  final _c1 = TextEditingController();
  final _c2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Components Preview')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Text('Buttons', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: PrimaryButton(label: 'Primary', onPressed: () {}),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: OutlineButtonX(label: 'Outline', onPressed: () {}),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          Text('Inputs', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: AppSpacing.sm),
          InputField(
            controller: _c1,
            label: 'Email',
            helper: 'We never share your email',
          ),
          const SizedBox(height: AppSpacing.md),
          InputField(
            controller: _c2,
            label: 'Password',
            obscure: true,
            errorText: 'Password is too short',
          ),
          const SizedBox(height: AppSpacing.lg),

          Text('Chips', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            children: const [
              AppChip(label: 'Health', selected: true),
              AppChip(label: 'Work'),
              AppChip(label: 'Home'),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          Text('Card', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: AppSpacing.sm),
          const AppCard(child: Text('I am inside a card with padding')),
        ],
      ),
    );
  }
}
