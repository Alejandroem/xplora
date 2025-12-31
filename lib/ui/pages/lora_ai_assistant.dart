import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../theme.dart';

/// LORA AI Assistant - AI-powered travel assistant
class LoraAiAssistant extends ConsumerStatefulWidget {
  const LoraAiAssistant({super.key});

  @override
  ConsumerState<LoraAiAssistant> createState() => _LoraAiAssistantState();
}

class _LoraAiAssistantState extends ConsumerState<LoraAiAssistant> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GlassAppBar(
        title: 'LORA Assistant',
      ),
      body: GradientBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // LORA Logo/Icon
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: brandPrimary,
                  border: Border.all(
                    color: brandPrimary.withOpacity(0.5),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: brandPrimary.withOpacity(0.4),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    Icons.auto_awesome,
                    color: textPrimary,
                    size: 50,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Coming Soon Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: brandPrimary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: brandPrimary.withOpacity(0.5),
                    width: 1,
                  ),
                ),
                child: Text(
                  'Coming Soon',
                  style: h3Style.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Description
              GlassContainer(
                borderRadius: 16,
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.stars,
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'About LORA',
                          style: h3Style.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'L.O.R.A. (Location-Optimized Recommendation Assistant) is your AI-powered travel companion. Get personalized trip suggestions, quest hints, navigation help, and intelligent trip planning.',
                      style: bodyTextStyle.copyWith(
                        fontSize: 15,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Stay tuned for the AI-powered features that will enhance your exploration experience!',
                      style: bodyTextStyle.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Feature Cards
              _buildFeatureCard(
                icon: Icons.explore,
                title: 'Trip Suggestions',
                description: 'Get AI-powered recommendations for places to visit',
              ),

              const SizedBox(height: 16),

              _buildFeatureCard(
                icon: Icons.lightbulb_outline,
                title: 'Quest Hints',
                description: 'Receive helpful hints to complete your quests',
              ),

              const SizedBox(height: 16),

              _buildFeatureCard(
                icon: Icons.navigation,
                title: 'Navigation',
                description: 'Smart navigation to guide you on your adventures',
              ),

              const SizedBox(height: 16),

              _buildFeatureCard(
                icon: Icons.map_outlined,
                title: 'Trip Planner',
                description: 'Plan your trips with AI-assisted itinerary creation',
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
    Color? color,
  }) {
    color = iconColor;
    return GlassContainer(
      borderRadius: 12,
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: bodyTextStyle,
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: bodyTextStyle.copyWith(
                    fontSize: 13,
                    color: textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
