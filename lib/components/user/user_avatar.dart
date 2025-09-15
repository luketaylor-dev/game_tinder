import 'package:flutter/material.dart';

/// Reusable user avatar component
class UserAvatar extends StatelessWidget {
  final String? avatarUrl;
  final String? displayName;
  final double radius;

  const UserAvatar({
    super.key,
    this.avatarUrl,
    this.displayName,
    this.radius = 30,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
      child: avatarUrl != null && avatarUrl!.isNotEmpty
          ? ClipOval(
              child: Image.network(
                avatarUrl!,
                width: radius * 2,
                height: radius * 2,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.person,
                    size: radius,
                    color: Theme.of(context).colorScheme.primary,
                  );
                },
              ),
            )
          : Icon(
              Icons.person,
              size: radius,
              color: Theme.of(context).colorScheme.primary,
            ),
    );
  }
}
