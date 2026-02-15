import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../models/swipe_file.dart';

/// Individual swipe card with file preview
class SwipeCard extends StatelessWidget {
  final SwipeFile file;
  final bool isFront;
  final double stackIndex;

  const SwipeCard({
    super.key,
    required this.file,
    this.isFront = true,
    this.stackIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Scale and offset for stacked cards
    final scale = 1.0 - (stackIndex * 0.05);
    final offset = stackIndex * -8.0;
    final opacity = 1.0 - (stackIndex * 0.15);

    return Transform.translate(
      offset: Offset(0, offset),
      child: Transform.scale(
        scale: scale,
        child: Opacity(
          opacity: opacity.clamp(0.0, 1.0),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.surface(context),
              borderRadius: BorderRadius.circular(AppConstants.radiusCard),
              boxShadow: isFront
                  ? [
                      BoxShadow(
                        offset: const Offset(0, 4),
                        blurRadius: 16,
                        color: Colors.black.withOpacity(0.12),
                      ),
                    ]
                  : [
                      BoxShadow(
                        offset: const Offset(0, 2),
                        blurRadius: 8,
                        color: Colors.black.withOpacity(0.08),
                      ),
                    ],
            ),
            child: Column(
              children: [
                // Thumbnail area (70% of card)
                Expanded(
                  flex: 7,
                  child: Container(
                    decoration: BoxDecoration(
                      color: file.typeColor(context).withOpacity(0.08),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(AppConstants.radiusCard),
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        file.typeIcon,
                        size: 96,
                        color: file.typeColor(context).withOpacity(0.7),
                      ),
                    ),
                  ),
                ),
                
                // File info area (30% of card)
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(AppConstants.spacingMd),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Filename
                        Text(
                          file.name,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: AppConstants.spacingXs),
                        
                        // Size and date
                        Text(
                          '${file.formattedSize} · ${file.formattedDate}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.muted(context),
                          ),
                        ),
                        const SizedBox(height: AppConstants.spacingSm),
                        
                        // Type badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppConstants.spacingSm,
                            vertical: AppConstants.spacingXxs,
                          ),
                          decoration: BoxDecoration(
                            color: file.typeColor(context).withOpacity(0.12),
                            borderRadius: BorderRadius.circular(AppConstants.radiusBadge),
                          ),
                          child: Text(
                            file.typeLabel,
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: file.typeColor(context),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
