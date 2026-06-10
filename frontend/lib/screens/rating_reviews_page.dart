import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../state/app_state.dart';
import '../models/product.dart';

class RatingReviewsPage extends StatefulWidget {
  final Product product;
  const RatingReviewsPage({super.key, required this.product});

  @override
  State<RatingReviewsPage> createState() => _RatingReviewsPageState();
}

class _RatingReviewsPageState extends State<RatingReviewsPage> {
  String? selectedPhotoUrl;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AppState>(context, listen: false).fetchProductReviews(widget.product.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final _reviews = appState.getReviews(widget.product.id);
    
    int totalReviews = _reviews.length;
    double averageRating = totalReviews > 0 ? _reviews.map((r) => r.rating).reduce((a, b) => a + b) / totalReviews : 0.0;
    List<int> starCounts = [0, 0, 0, 0, 0, 0];
    for (var r in _reviews) {
      if (r.rating >= 1 && r.rating <= 5) starCounts[r.rating]++;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () async => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Rating and reviews',
              style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        averageRating.toStringAsFixed(1),
                        style: const TextStyle(fontSize: 44, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '$totalReviews ratings',
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      _buildRatingBar(5, starCounts[5], totalReviews),
                      const SizedBox(height: 4),
                      _buildRatingBar(4, starCounts[4], totalReviews),
                      const SizedBox(height: 4),
                      _buildRatingBar(3, starCounts[3], totalReviews),
                      const SizedBox(height: 4),
                      _buildRatingBar(2, starCounts[2], totalReviews),
                      const SizedBox(height: 4),
                      _buildRatingBar(1, starCounts[1], totalReviews),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_reviews.length} reviews',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Checkbox(value: true, onChanged: null),
                    Text('With photo', style: TextStyle(fontSize: 14)),
                  ],
                ),
              ],
            ),
            ..._reviews.map((r) => Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: _buildReviewCard(r),
            )).toList(),
          ],
        ),
      ),
      floatingActionButton: Builder(
        builder: (context) {
          final myReviewOpt = appState.getReviews(widget.product.id).where((r) => r.name == appState.userName).toList();
          final myReview = myReviewOpt.isNotEmpty ? myReviewOpt.first : null;
          final hasReviewed = myReview != null;

          return FloatingActionButton.extended(
            onPressed: () async {
              _showWriteReviewBottomSheet(context, appState, existingReview: myReview);
            },
            backgroundColor: const Color(0xFFDB3022),
            icon: const Icon(Icons.edit, color: Colors.white),
            label: Text(hasReviewed ? 'Edit your review' : 'Write a review', style: const TextStyle(color: Colors.white)),
          );
        }
      ),
    );
  }

  void _showWriteReviewBottomSheet(BuildContext context, AppState appState, {ReviewData? existingReview}) {
    int selectedStars = existingReview?.rating ?? 0;
    final TextEditingController textController = TextEditingController(text: existingReview?.text ?? '');
    String? selectedPhotoUrl = existingReview?.imageUrl;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(34)),
      ),
      builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
              return SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                  Container(
                    width: 60,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('What is your rate?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index < selectedStars ? Icons.star : Icons.star_border,
                          color: index < selectedStars ? const Color(0xFFFFBA49) : Colors.grey,
                          size: 36,
                        ),
                        onPressed: () async {
                          setModalState(() {
                            selectedStars = index + 1;
                          });
                        },
                      );
                    }),
                  ),
                  const SizedBox(height: 24),
                  const Text('Please share your opinion', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  TextField(
                    controller: textController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: 'Your review',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 16),
                  StatefulBuilder(
                    builder: (context, setPhotoState) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                if (selectedPhotoUrl != null)
                                  Padding(
                                    padding: const EdgeInsets.only(right: 16),
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        Container(
                                          width: 104,
                                          height: 104,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                            image: DecorationImage(
                                              image: selectedPhotoUrl!.startsWith('http') 
                                                  ? NetworkImage(selectedPhotoUrl!) as ImageProvider 
                                                  : FileImage(File(selectedPhotoUrl!)),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: -8,
                                          right: -8,
                                          child: InkWell(
                                            onTap: () {
                                              setPhotoState(() {
                                                selectedPhotoUrl = null;
                                              });
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.circle,
                                                boxShadow: [
                                                  BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4),
                                                ],
                                              ),
                                              child: const Icon(Icons.close, color: Colors.black, size: 16),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                InkWell(
                                  onTap: () async {
                                    showDialog(
                                      context: context,
                                      builder: (dialogContext) => AlertDialog(
                                        title: const Text('Select Photo'),
                                        content: const Text('Do you want to take a photo or choose from gallery?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () async {
                                              Navigator.pop(dialogContext);
                                              final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
                                              if (image != null) {
                                                setPhotoState(() {
                                                  selectedPhotoUrl = image.path;
                                                });
                                              }
                                            },
                                            child: const Text('Gallery'),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              Navigator.pop(dialogContext);
                                              final XFile? photo = await ImagePicker().pickImage(source: ImageSource.camera);
                                              if (photo != null) {
                                                setPhotoState(() {
                                                  selectedPhotoUrl = photo.path;
                                                });
                                              }
                                            },
                                            child: const Text('Camera'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: 104,
                                    height: 104,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [
                                        BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: const [
                                        Icon(Icons.camera_alt, color: Color(0xFFDB3022), size: 36),
                                        SizedBox(height: 8),
                                        Text('Add your photos', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                              onPressed: () async {
                                if (selectedStars == 0) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Please select a star rating'), backgroundColor: Colors.red),
                                  );
                                  return;
                                }
                                
                                try {
                                  await appState.addReview(widget.product.id, ReviewData(
                                    name: appState.userName,
                                    date: 'Just now',
                                    rating: selectedStars,
                                    text: textController.text,
                                    hasPhotos: selectedPhotoUrl != null,
                                    imageUrl: selectedPhotoUrl,
                                  ));
                                  if (context.mounted) {
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Review submitted successfully!'), backgroundColor: Colors.green),
                                    );
                                  }
                                } catch (e) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
                                    );
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFDB3022),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                              child: const Text('SEND REVIEW', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),
            ],
          ),
        ),
      );
    }
  );
      },
    );
  }

  Widget _buildRatingBar(int stars, int count, int total) {
    return Row(
      children: [
        SizedBox(
          width: 75,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: List.generate(stars, (index) {
              return const Icon(
                Icons.star,
                color: Color(0xFFFFBA49),
                size: 14,
              );
            }),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: LinearProgressIndicator(
            value: total > 0 ? count / total : 0,
            backgroundColor: Colors.transparent,
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFDB3022)),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 20,
          child: Text(
            count.toString(),
            textAlign: TextAlign.right,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ),
      ],
    );
  }

  Widget _buildReviewCard(ReviewData r) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20, left: 16),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(r.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: List.generate(5, (index) {
                      return Icon(
                        index < r.rating ? Icons.star : Icons.star_border,
                        color: index < r.rating ? const Color(0xFFFFBA49) : Colors.grey.shade300,
                        size: 14,
                      );
                    }),
                  ),
                  Text(r.date, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 12),
              Text(r.text, style: const TextStyle(fontSize: 14, height: 1.5)),
              if (r.hasPhotos || r.imageUrl != null)
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Row(
                    children: [
                      Container(
                        width: 104,
                        height: 104,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(4),
                          image: r.imageUrl != null ? DecorationImage(
                            image: r.imageUrl!.startsWith('http') 
                                ? NetworkImage(r.imageUrl!) as ImageProvider 
                                : FileImage(File(r.imageUrl!)),
                            fit: BoxFit.cover,
                          ) : null,
                        ),
                        child: r.imageUrl == null ? const Icon(Icons.image, color: Colors.grey) : null,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        Positioned(
          top: 0,
          left: -4,
          child: CircleAvatar(
            radius: 24,
            backgroundImage: NetworkImage(r.avatarUrl),
          ),
        ),
      ],
    );
  }
}
