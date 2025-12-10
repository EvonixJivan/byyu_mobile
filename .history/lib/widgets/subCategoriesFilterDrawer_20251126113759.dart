import 'package:flutter/material.dart';

/// FiltersSideDrawer
/// Call FiltersSideDrawer.show(context, productsFound: 5191)
/// Returns Map<String, List<String>> when user taps Apply, or null if dismissed.
class FiltersSideDrawer {
  static Future<Map<String, List<String>>?> show(
    BuildContext context, {
    int productsFound = 0,
  }) {
    return showGeneralDialog<Map<String, List<String>>?>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Filters',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation1, animation2) {
        // pageBuilder must build the widget but transitions run in transitionBuilder
        return const SizedBox.shrink();
      },
      transitionBuilder: (context, anim, secondaryAnim, child) {
        final width = MediaQuery.of(context).size.width;
        final drawerWidth = width * 0.95; // almost full screen like flipkart
        return Stack(
          children: [
            // semi-transparent backdrop
            Opacity(
              opacity: Curves.easeOut.transform(anim.value) * 0.5,
              child: GestureDetector(
                onTap: () => Navigator.of(context).maybePop(),
                child: Container(color: Colors.black),
              ),
            ),

            // Slide-in panel from left
            Transform.translate(
              offset: Offset(-(drawerWidth) * (1 - anim.value), 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: drawerWidth,
                  height: MediaQuery.of(context).size.height,
                  child: _FiltersPanel(
                    productsFound: productsFound,
                    onApply: (selected) {
                      Navigator.of(context).pop(selected);
                    },
                    onClose: () => Navigator.of(context).pop(),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Internal widget that renders the two-column filters UI and calls back on Apply
class _FiltersPanel extends StatefulWidget {
  final int productsFound;
  final void Function(Map<String, List<String>> selectedFilters) onApply;
  final VoidCallback onClose;

  const _FiltersPanel({
    Key? key,
    required this.onApply,
    required this.onClose,
    this.productsFound = 0,
  }) : super(key: key);

  @override
  State<_FiltersPanel> createState() => _FiltersPanelState();
}

class _FiltersPanelState extends State<_FiltersPanel> {
  final List<String> _categories = [
    'Brand',
    'Gender',
    'Deliver At',
    'Color',
    'Occasion',
    'Size - UK/India',
    'Price',
    'Customer Ratings',
    'Discount',
    'Collections',
    'F-Assured',
    'Delivery in 1 Day',
    'Offers',
    'New Arrivals',
  ];

  final Map<String, List<String>> _staticOptions = {
    'Brand': [
      'Bata',
      'ADIDAS',
      'PUMA',
      'RED TAPE',
      'CAMPUS',
      'WOODLAND',
      'Sparx',
      'REEBOK',
      'asian',
      'Abros'
    ],
    'Gender': ['Male', 'Female', 'Unisex'],
    'Deliver At': ['Home', 'Store Pickup', 'Courier Locker'],
    'Color': ['Black', 'White', 'Blue', 'Green', 'Red'],
    'Occasion': ['Casual', 'Formal', 'Sports'],
    'Size - UK/India': ['6', '7', '8', '9', '10'],
    'Price': ['0-499', '500-999', '1000-1999', '2000+'],
    'Customer Ratings': ['4★ & above', '3★ & above', '2★ & above'],
    'Discount': ['10%+', '20%+', '30%+'],
    'Collections': ['Summer', 'Winter'],
    'F-Assured': ['Yes'],
    'Delivery in 1 Day': ['Yes'],
    'Offers': ['Buy 1 Get 1', 'Season Sale'],
    'New Arrivals': ['Last 7 days', 'Last 30 days'],
  };

  final Map<String, Set<String>> _selectedOptions = {};
  int _selectedCategoryIndex = 0;
  String _searchText = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    for (var c in _categories) {
      _selectedOptions[c] = <String>{};
    }
  }

  String get _currentCategory => _categories[_selectedCategoryIndex];

  void _toggleOption(String category, String option) {
    final set = _selectedOptions[category]!;
    setState(() {
      if (set.contains(option))
        set.remove(option);
      else
        set.add(option);
    });
  }

  Widget _leftColumn() {
    return Container(
      width: 120,
      color: const Color(0xFFF2F5F7),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 12),
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(height: 6),
        itemBuilder: (context, idx) {
          final selected = idx == _selectedCategoryIndex;
          return InkWell(
            onTap: () => setState(() => _selectedCategoryIndex = idx),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
              color: selected ? const Color(0xFFEFF5F9) : Colors.transparent,
              child: Row(
                children: [
                  if (selected)
                    const Icon(Icons.check, color: Colors.blue, size: 18)
                  else
                    const SizedBox(width: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _categories[idx],
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight:
                              selected ? FontWeight.w600 : FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _rightColumn() {
    final allOptions = _staticOptions[_currentCategory] ?? [];
    final filtered = _searchText.isEmpty
        ? allOptions
        : allOptions
            .where((o) => o.toLowerCase().contains(_searchText.toLowerCase()))
            .toList();

    return Expanded(
      child: Column(
        children: [
          // header row: search
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search $_currentCategory',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300)),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                      suffixIcon: const Icon(Icons.search),
                    ),
                    onChanged: (s) => setState(() => _searchText = s),
                  ),
                ),
                const SizedBox(width: 12),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedOptions[_currentCategory]!.clear();
                      _searchController.clear();
                      _searchText = '';
                    });
                  },
                  child: const Text('Clear'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 6),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text('Popular Filters',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ),
          const SizedBox(height: 12),

          // options
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ListView.builder(
                itemCount: filtered.length + 1,
                itemBuilder: (context, idx) {
                  if (idx == filtered.length) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18.0, vertical: 8),
                      child: GestureDetector(
                        onTap: () {
                          // show more
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: Text('More $_currentCategory'),
                              content: const Text('Show more options here.'),
                              actions: [
                                TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Close'))
                              ],
                            ),
                          );
                        },
                        child: const Text('View More',
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.w600)),
                      ),
                    );
                  }

                  final option = filtered[idx];
                  final checked =
                      _selectedOptions[_currentCategory]!.contains(option);

                  return CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    value: checked,
                    onChanged: (_) => _toggleOption(_currentCategory, option),
                    title: Text(option),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 18),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, -2))
        ],
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${widget.productsFound}',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w700)),
              const SizedBox(height: 2),
              Text('products found',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
            ],
          ),
          const Spacer(),
          SizedBox(
            height: 46,
            width: 140,
            child: ElevatedButton(
              onPressed: () {
                final Map<String, List<String>> result = {};
                for (var key in _selectedOptions.keys)
                  result[key] = _selectedOptions[key]!.toList();
                widget.onApply(result);
              },
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8))),
              child: const Text('Apply',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        color: Colors.white,
        child: Column(
          children: [
            // header
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: widget.onClose,
                  ),
                  const SizedBox(width: 8),
                  const Text('Filters',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        for (var key in _selectedOptions.keys)
                          _selectedOptions[key]!.clear();
                      });
                    },
                    child: const Text('Clear Filters'),
                  )
                ],
              ),
            ),

            // body: left + right
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _leftColumn(),
                  const SizedBox(width: 12),
                  _rightColumn(),
                ],
              ),
            ),

            // bottom bar
            _bottomBar(),
          ],
        ),
      ),
    );
  }
}
