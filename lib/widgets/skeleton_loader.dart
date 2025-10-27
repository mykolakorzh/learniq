import 'package:flutter/material.dart';

/// A shimmer skeleton loader widget for loading states
class SkeletonLoader extends StatefulWidget {
  final double? width;
  final double height;
  final BorderRadius? borderRadius;

  const SkeletonLoader({
    super.key,
    this.width,
    this.height = 20,
    this.borderRadius,
  });

  @override
  State<SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<SkeletonLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(4),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Colors.grey[300]!,
                Colors.grey[100]!,
                Colors.grey[300]!,
              ],
              stops: [
                _animation.value - 0.3,
                _animation.value,
                _animation.value + 0.3,
              ].map((e) => e.clamp(0.0, 1.0)).toList(),
            ),
          ),
        );
      },
    );
  }
}

/// A skeleton card for topic list items
class SkeletonTopicCard extends StatelessWidget {
  const SkeletonTopicCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: SkeletonLoader(
          width: 60,
          height: 60,
          borderRadius: BorderRadius.circular(12),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SkeletonLoader(width: 150, height: 18),
            SizedBox(height: 8),
            SkeletonLoader(width: 80, height: 14),
          ],
        ),
        trailing: SkeletonLoader(
          width: 24,
          height: 24,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

/// A skeleton for flashcard content
class SkeletonFlashcard extends StatelessWidget {
  const SkeletonFlashcard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Progress bar skeleton
          SkeletonLoader(
            width: double.infinity,
            height: 4,
            borderRadius: BorderRadius.circular(2),
          ),
          const SizedBox(height: 8),
          const SkeletonLoader(width: 60, height: 14),

          const SizedBox(height: 24),

          // Card skeleton
          Expanded(
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Image skeleton
                    Expanded(
                      flex: 2,
                      child: SkeletonLoader(
                        width: double.infinity,
                        height: double.infinity,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Article + word skeleton
                    SkeletonLoader(
                      width: 200,
                      height: 48,
                      borderRadius: BorderRadius.circular(8),
                    ),

                    const SizedBox(height: 16),

                    // Translation skeleton
                    const SkeletonLoader(width: 150, height: 20),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),
          const SkeletonLoader(width: 180, height: 14),
        ],
      ),
    );
  }
}

/// A skeleton for statistics cards
class SkeletonStatCard extends StatelessWidget {
  const SkeletonStatCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SkeletonLoader(
                  width: 28,
                  height: 28,
                  borderRadius: BorderRadius.circular(14),
                ),
                const SizedBox(width: 12),
                const SkeletonLoader(width: 150, height: 20),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      SkeletonLoader(
                        width: 32,
                        height: 32,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      const SizedBox(height: 8),
                      const SkeletonLoader(width: 60, height: 24),
                      const SizedBox(height: 4),
                      const SkeletonLoader(width: 40, height: 12),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      SkeletonLoader(
                        width: 32,
                        height: 32,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      const SizedBox(height: 8),
                      const SkeletonLoader(width: 60, height: 24),
                      const SizedBox(height: 4),
                      const SkeletonLoader(width: 40, height: 12),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
