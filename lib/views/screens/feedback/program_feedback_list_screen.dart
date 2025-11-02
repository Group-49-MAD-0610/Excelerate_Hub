import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/theme_constants.dart';
import '../../../controllers/feedback_controller.dart';
import '../../../models/entities/feedback_model.dart';

/// Screen to display all feedback/reviews for a specific program
class ProgramFeedbackListScreen extends StatefulWidget {
  final String programId;
  final String? programTitle;

  const ProgramFeedbackListScreen({
    super.key,
    required this.programId,
    this.programTitle,
  });

  @override
  State<ProgramFeedbackListScreen> createState() =>
      _ProgramFeedbackListScreenState();
}

class _ProgramFeedbackListScreenState extends State<ProgramFeedbackListScreen> {
  @override
  void initState() {
    super.initState();
    // Schedule the feedback loading after the first frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadFeedback();
    });
  }

  Future<void> _loadFeedback() async {
    if (!mounted) return;
    final feedbackController = Provider.of<FeedbackController>(
      context,
      listen: false,
    );
    await feedbackController.loadProgramFeedback(widget.programId);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: ThemeConstants.appBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Reviews & Feedback',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
      ),
      body: Consumer<FeedbackController>(
        builder: (context, feedbackController, child) {
          if (feedbackController.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: ThemeConstants.accentColor,
              ),
            );
          }

          if (feedbackController.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: ThemeConstants.errorColor,
                  ),
                  const SizedBox(height: ThemeConstants.spacing16),
                  Text(
                    'Error loading feedback',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: ThemeConstants.errorColor,
                    ),
                  ),
                  const SizedBox(height: ThemeConstants.spacing8),
                  Text(
                    feedbackController.error!,
                    style: theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: ThemeConstants.spacing24),
                  ElevatedButton(
                    onPressed: _loadFeedback,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ThemeConstants.accentColor,
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final feedbackList = feedbackController.programFeedback;

          if (feedbackList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.feedback_outlined,
                    size: 64,
                    color: theme.colorScheme.onSurface.withOpacity(0.3),
                  ),
                  const SizedBox(height: ThemeConstants.spacing16),
                  Text(
                    'No reviews yet',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: ThemeConstants.spacing8),
                  Text(
                    'Be the first to review this program!',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Statistics Header
              _buildStatisticsHeader(
                theme,
                feedbackController.averageRating,
                feedbackList.length,
                feedbackController.ratingDistribution,
              ),

              const Divider(height: 1),

              // Feedback List
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _loadFeedback,
                  color: ThemeConstants.accentColor,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(ThemeConstants.spacing16),
                    itemCount: feedbackList.length,
                    itemBuilder: (context, index) {
                      return _buildFeedbackCard(
                        theme,
                        feedbackList[index],
                        feedbackController,
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// Build statistics header
  Widget _buildStatisticsHeader(
    ThemeData theme,
    double averageRating,
    int totalReviews,
    Map<int, int> distribution,
  ) {
    return Container(
      padding: const EdgeInsets.all(ThemeConstants.spacing24),
      decoration: BoxDecoration(
        color: theme.cardColor,
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Program Title
          if (widget.programTitle != null)
            Padding(
              padding: const EdgeInsets.only(bottom: ThemeConstants.spacing16),
              child: Text(
                widget.programTitle!,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),

          Row(
            children: [
              // Average Rating
              Expanded(
                child: Column(
                  children: [
                    Text(
                      averageRating.toStringAsFixed(1),
                      style: theme.textTheme.displayMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: ThemeConstants.accentColor,
                      ),
                    ),
                    const SizedBox(height: ThemeConstants.spacing4),
                    _buildStarRating(averageRating),
                    const SizedBox(height: ThemeConstants.spacing8),
                    Text(
                      '$totalReviews ${totalReviews == 1 ? 'review' : 'reviews'}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),

              // Rating Distribution
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    for (int star = 5; star >= 1; star--)
                      _buildRatingBar(
                        theme,
                        star,
                        distribution[star] ?? 0,
                        totalReviews,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Build star rating display
  Widget _buildStarRating(double rating) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        if (index < rating.floor()) {
          return const Icon(
            Icons.star,
            color: ThemeConstants.accentColor,
            size: 20,
          );
        } else if (index < rating) {
          return const Icon(
            Icons.star_half,
            color: ThemeConstants.accentColor,
            size: 20,
          );
        } else {
          return Icon(
            Icons.star_border,
            color: ThemeConstants.accentColor.withOpacity(0.3),
            size: 20,
          );
        }
      }),
    );
  }

  /// Build rating distribution bar
  Widget _buildRatingBar(ThemeData theme, int star, int count, int total) {
    final percentage = total > 0 ? (count / total) : 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text('$star', style: theme.textTheme.bodySmall),
          const SizedBox(width: 4),
          Icon(Icons.star, size: 12, color: ThemeConstants.accentColor),
          const SizedBox(width: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: percentage,
                backgroundColor: theme.colorScheme.onSurface.withOpacity(0.1),
                valueColor: const AlwaysStoppedAnimation<Color>(
                  ThemeConstants.accentColor,
                ),
                minHeight: 6,
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 30,
            child: Text(
              '$count',
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  /// Build individual feedback card
  Widget _buildFeedbackCard(
    ThemeData theme,
    FeedbackModel feedback,
    FeedbackController controller,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: ThemeConstants.spacing16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ThemeConstants.borderRadiusMedium),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(ThemeConstants.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Info & Rating
            Row(
              children: [
                // User Avatar
                CircleAvatar(
                  radius: 20,
                  backgroundColor: ThemeConstants.accentColor.withOpacity(0.2),
                  backgroundImage: feedback.userAvatar != null
                      ? NetworkImage(feedback.userAvatar!)
                      : null,
                  child: feedback.userAvatar == null
                      ? Text(
                          feedback.userName.isNotEmpty
                              ? feedback.userName[0].toUpperCase()
                              : '?',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: ThemeConstants.accentColor,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: ThemeConstants.spacing12),

                // User Name & Date
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        feedback.userName,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _formatDate(feedback.createdAt),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),

                // Star Rating
                Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      index < feedback.rating ? Icons.star : Icons.star_border,
                      color: ThemeConstants.accentColor,
                      size: 18,
                    );
                  }),
                ),
              ],
            ),

            const SizedBox(height: ThemeConstants.spacing12),

            // Comment
            Text(feedback.comment, style: theme.textTheme.bodyMedium),

            const SizedBox(height: ThemeConstants.spacing12),

            // Helpful Button
            Row(
              children: [
                TextButton.icon(
                  onPressed: () => _toggleHelpful(feedback, controller),
                  icon: Icon(
                    Icons.thumb_up_outlined,
                    size: 16,
                    color: ThemeConstants.accentColor,
                  ),
                  label: Text(
                    'Helpful (${feedback.helpfulCount})',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: ThemeConstants.accentColor,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Format date to readable string
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'Just now';
        }
        return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
      }
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    }
  }

  /// Toggle helpful status
  Future<void> _toggleHelpful(
    FeedbackModel feedback,
    FeedbackController controller,
  ) async {
    // Get current user ID (you might need to get this from AuthController)
    const currentUserId = 'user-001'; // Replace with actual user ID

    await controller.toggleHelpful(
      feedbackId: feedback.id,
      userId: currentUserId,
    );
  }
}
