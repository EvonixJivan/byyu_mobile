import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

class NewSideDrawer extends StatefulWidget {
  /// Optional callbacks for taps
  final VoidCallback? onClose;
  final ValueChanged<String>? onSearch;
  final ValueChanged<int>? onCategoryTap;
  final ValueChanged<int>? onChipTap;

  const NewSideDrawer({
    Key? key,
    this.onClose,
    this.onSearch,
    this.onCategoryTap,
    this.onChipTap,
    FirebaseAnalytics? analytics,
    FirebaseAnalyticsObserver? observer,
  }) : super(key: key);

  @override
  State<NewSideDrawer> createState() => _NewSideDrawerState();
}

class _NewSideDrawerState extends State<NewSideDrawer> {
  final TextEditingController _searchController = TextEditingController();

  // Example data — replace with your real model/data
  final List<_CategoryItem> _categories = [
    _CategoryItem(
        title: 'Celebrate',
        imageUrl: 'https://picsum.photos/seed/celebrate/400'),
    _CategoryItem(
        title: 'Recipients',
        imageUrl: 'https://picsum.photos/seed/recipients/400'),
    _CategoryItem(
        title: 'Express Delivery',
        imageUrl: 'https://picsum.photos/seed/express/400'),
  ];

  final List<_ChipItem> _chips = [
    _ChipItem(
        title: 'Flowers & Gifts',
        iconUrl: 'https://picsum.photos/seed/gift/80'),
    _ChipItem(
        title: 'Flowers & Plants',
        iconUrl: 'https://picsum.photos/seed/plants/80'),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleSearchSubmitted(String text) {
    widget.onSearch?.call(text);
  }

  @override
  Widget build(BuildContext context) {
    // Drawer width can be adjusted based on screen size
    final double drawerWidth = MediaQuery.of(context).size.width * 0.92;

    return SafeArea(
      child: Container(
        width: drawerWidth,
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row with title and close button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Explore',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF5A3E36), // soft brown as example
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed:
                        widget.onClose ?? () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Search field
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: const Color(0xFFE7DCDC)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        textInputAction: TextInputAction.search,
                        onSubmitted: _handleSearchSubmitted,
                        decoration: const InputDecoration(
                          hintText:
                              'Search for flowers , cakes , gifts and more',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () =>
                          _handleSearchSubmitted(_searchController.text),
                    )
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // Circular category tiles (horizontal)
              SizedBox(
                height: 130,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final cat = _categories[index];
                    return GestureDetector(
                      onTap: () => widget.onCategoryTap?.call(index),
                      child: Column(
                        children: [
                          // Circle image
                          Container(
                            width: 92,
                            height: 92,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: NetworkImage(cat.imageUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: 92,
                            child: Text(
                              cat.title,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 18),

              // Chips row
              Wrap(
                spacing: 12,
                runSpacing: 8,
                children: List.generate(_chips.length, (i) {
                  final chip = _chips[i];
                  return GestureDetector(
                    onTap: () => widget.onChipTap?.call(i),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: const Color(0xFFEEDFD9)),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x0F000000),
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // small image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              chip.iconUrl,
                              width: 28,
                              height: 28,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            chip.title,
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 18),

              // Promo/cards grid (two cards)
              Column(
                children: [
                  _PromoCard(
                    title: 'CORPORATE GIFTS',
                    imageUrl: 'https://picsum.photos/seed/corp/900/300',
                    onTap: () {},
                  ),
                  const SizedBox(height: 12),
                  _PromoCard(
                    title: 'ADD AS REMINDER',
                    imageUrl: 'https://picsum.photos/seed/reminder/900/300',
                    onTap: () {},
                  ),
                ],
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

/// Small internal model-like classes for sample data
class _CategoryItem {
  final String title;
  final String imageUrl;
  _CategoryItem({required this.title, required this.imageUrl});
}

class _ChipItem {
  final String title;
  final String iconUrl;
  _ChipItem({required this.title, required this.iconUrl});
}

/// Reusable promo card used in drawer
class _PromoCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final VoidCallback? onTap;

  const _PromoCard({
    Key? key,
    required this.title,
    required this.imageUrl,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: 5 / 1.8, // wide banner feel
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            image: DecorationImage(
              image: NetworkImage(imageUrl),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(Colors.black26, BlendMode.darken),
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w700,
              shadows: [
                Shadow(
                    blurRadius: 6, color: Colors.black45, offset: Offset(0, 2))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
