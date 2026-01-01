import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../infrastructure/constants.dart';
import '../../application/providers/local_storage_providers.dart';
import '../../theme.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  late PageController _pageController;
  int _currentPage = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  Future<void> _finishOnboarding() async {
    setState(() {
      _isLoading = true;
    });
    final localStorage = ref.read(localStorageProvider);
    await localStorage.save(
      kHasFinishedOnboardingKey,
      'true',
    );

    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  children: [
                    // Carousel 1: Explore. Evolve. Earn.
                    _buildCarouselPage(
                      icon: Icons.explore_rounded,
                      iconSize: 120,
                      text: 'Explore. Evolve. Earn.',
                    ),
                    // Carousel 2: Discover hidden gems near you
                    _buildCarouselPage(
                      svgAsset: 'assets/svg/find-next-adventure.svg',
                      text: 'Discover hidden gems near you.',
                    ),
                    // Carousel 3: Complete quests to level up
                    _buildCarouselPage(
                      svgAsset: 'assets/svg/earn-rewards.svg',
                      text: 'Complete quests to level up.',
                    ),
                  ],
                ),
              ),
              // Page indicators
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    3,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentPage == index ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: _currentPage == index
                            ? brandPrimary
                            : context.colors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ),
              // CTA Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
                child: SizedBox(
                  width: double.infinity,
                  child: PrimaryButton(
                    text: _currentPage == 2 ? _isLoading ? 'Loading...' : 'Start' : 'Next',
                    onPressed: _currentPage == 2
                        ? _isLoading ? null : _finishOnboarding
                        : () {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                    fontSize: 18,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCarouselPage({
    IconData? icon,
    String? svgAsset,
    double iconSize = 100,
    required String text,
  }) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image or Icon
          if (svgAsset != null)
            SizedBox(
              height: 250,
              child: SvgPicture.asset(
                svgAsset,
                colorFilter: ColorFilter.mode(
                  context.colors.iconColor,
                  BlendMode.srcIn,
                ),
              ),
            )
          else if (icon != null)
            Icon(
              icon,
              size: iconSize,
              color: context.colors.iconColor,
            ),
          const SizedBox(height: 50),
          // Text
          Text(
            text,
            textAlign: TextAlign.center,
            style: h1Style,
          ),
        ],
      ),
    );
  }
}
