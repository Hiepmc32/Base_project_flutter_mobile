import 'package:fresh_base_project/core/constants/base/base.dart';
import 'package:fresh_base_project/features/users/domain/entities/user_entity.dart';

/// Reusable presentation card for a user item.
class UserCard extends StatelessWidget with BaseMixin {
  const UserCard({super.key, required this.user, this.onTap});

  final UserEntity user;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: color.primary,
                    child: Text(
                      user.name.substring(0, 1).toUpperCase(),
                      style: textStyle.bold(color: Colors.white, size: 18),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          user.name,
                          style: textStyle.bold(size: 16),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '@${user.username}',
                          style: textStyle.regular(
                            color: Colors.grey,
                            size: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _InfoRow(icon: Icons.email, text: user.email),
              const SizedBox(height: 8),
              _InfoRow(icon: Icons.phone, text: user.phone),
              const SizedBox(height: 8),
              _InfoRow(
                icon: Icons.location_on,
                text: '${user.address.city}, ${user.address.street}',
              ),
              const SizedBox(height: 8),
              _InfoRow(icon: Icons.business, text: user.company.name),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 8),
        Expanded(
          child: Text(text, maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }
}
