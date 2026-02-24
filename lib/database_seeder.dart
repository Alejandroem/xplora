import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:typed_data';

class DatabaseSeeder {

  static Future<String?> _uploadIcon(String? fileName) async {
    if (fileName == null || fileName.isEmpty) return "";

    try {
      // 1. Load the asset as bytes instead of using File()
      final ByteData bytes = await rootBundle.load('assets/category_icons/$fileName');
      final Uint8List list = bytes.buffer.asUint8List();

      // 2. Set the correct content type
      String contentType = fileName.endsWith('.svg') ? 'image/svg+xml' : 'image/png';

      // 3. Reference in Storage
      Reference ref = FirebaseStorage.instance.ref().child('category_icons/$fileName');

      // 4. Use putData (for bytes) instead of putFile (for physical files)
      UploadTask uploadTask = ref.putData(
          list,
          SettableMetadata(contentType: contentType)
      );

      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      print("Uploaded $fileName: $downloadUrl");
      return downloadUrl;
    } catch (e) {
      // This will now catch if the asset path is wrong in pubspec.yaml
      print("Error uploading $fileName: $e");
      return "";
    }
  }

  static Future<void> seedCategories() async {
    final firestore = FirebaseFirestore.instance;

    final List<Map<String, dynamic>> schema = [
      {
        "name": "Outdoors & Nature",
        "interestName": "Nature",
        "isVisibleInInterests": true,
        "iconFile": "nature.svg",
        "placeOrder": 1,
        "interestsOrder": 1,
        "children": [
          {"name": "Park", "iconFile": "park.svg", "placeOrder": 1},
          {
            "name": "Beach",
            "interestName": "Beaches",
            "isVisibleInInterests": true,
            "iconFile": "beach.svg",
            "placeOrder": 2,
            "interestsOrder": 7
          },
          {"name": "Trail", "iconFile": "trail.svg", "placeOrder": 3},
          {"name": "Scenic Views", "iconFile": "views.svg", "placeOrder": 4},
          {
            "name": "Nature Reserve",
            "iconFile": "reserve.svg",
            "placeOrder": 5
          },
          {"name": "Camping", "iconFile": "camping.svg", "placeOrder": 6},
          {
            "name": "River",
            "interestName": "Rivers",
            "isVisibleInInterests": true,
            "iconFile": "river.svg",
            "placeOrder": 7,
            "interestsOrder": 12
          },
          {"name": "Lake", "iconFile": "lake.svg", "placeOrder": 8},
          {"name": "Picnic", "iconFile": "picnic.svg", "placeOrder": 9},
        ]
      },
      {
        "name": "Sports & Fitness",
        "interestName": "Sports",
        "isVisibleInInterests": true,
        "iconFile": "sports.svg",
        "placeOrder": 2,
        "interestsOrder": 4,
        "children": [
          {
            "name": "Running",
            "interestName": "Running",
            "isVisibleInInterests": true,
            "iconFile": "running.svg",
            "placeOrder": 1,
            "interestsOrder": 9
          },
          {
            "name": "Hiking",
            "interestName": "Hiking",
            "isVisibleInInterests": true,
            "iconFile": "hiking.svg",
            "placeOrder": 2,
            "interestsOrder": 14
          },
          {"name": "Walking", "iconFile": "walking.svg", "placeOrder": 3},
          {"name": "Soccer/futbol", "iconFile": "soccer.svg", "placeOrder": 4},
          {"name": "Basketball", "iconFile": "basketball.svg", "placeOrder": 5},
          {"name": "Tennis", "iconFile": "tennis.svg", "placeOrder": 6},
          {"name": "Pickleball", "iconFile": "pickleball.svg", "placeOrder": 7},
          {"name": "Skateboarding", "iconFile": "skate.svg", "placeOrder": 8},
          {"name": "Cycling", "iconFile": "cycling.svg", "placeOrder": 9},
          {
            "name": "Physical Activities",
            "iconFile": "physical.svg",
            "placeOrder": 10
          },
          {"name": "Gym", "iconFile": "gym.svg", "placeOrder": 11},
          {
            "name": "Weightlifting",
            "iconFile": "weights.svg",
            "placeOrder": 12
          },
          {"name": "Racing", "iconFile": "racing.svg", "placeOrder": 13},
        ]
      },
      {
        "name": "Art & Culture",
        "interestName": "Art & Culture",
        "isVisibleInInterests": true,
        "iconFile": "art_culture.svg",
        "placeOrder": 3,
        "interestsOrder": 3,
        "children": [
          {"name": "Street Art", "iconFile": "street_art.svg", "placeOrder": 1},
          {
            "name": "Landmark",
            "interestName": "History",
            "isVisibleInInterests": true,
            "iconFile": "history.svg",
            "placeOrder": 2,
            "interestsOrder": 1
          },
          {"name": "Art Markets", "iconFile": "market.svg", "placeOrder": 3},
          {
            "name": "Fashion",
            "interestName": "Fashion",
            "isVisibleInInterests": true,
            "iconFile": "fashion.svg",
            "placeOrder": 4,
            "interestsOrder": 11
          },
        ]
      },
      {
        "name": "Entertainment",
        "isVisibleInInterests": false,
        "iconFile": "entertainment.svg",
        "placeOrder": 4,
        "children": [
          {
            "name": "Live Music",
            "interestName": "Live Music",
            "isVisibleInInterests": true,
            "iconFile": "music.svg",
            "placeOrder": 1,
            "interestsOrder": 10
          },
          {"name": "Pop-up", "iconFile": "popup.svg", "placeOrder": 2},
          {"name": "Nightlife", "iconFile": "nightlife.svg", "placeOrder": 3},
          {"name": "Event Venue", "iconFile": "nightlife.svg", "placeOrder": 4},
          {"name": "Theater", "iconFile": "theater.svg", "placeOrder": 5},
          {"name": "Comedy", "iconFile": "comedy.svg", "placeOrder": 6},
          {"name": "Poetry", "iconFile": "poetry.svg", "placeOrder": 7},
        ]
      },
      {
        "name": "Food & Drink",
        "interestName": "Food & Cafes",
        "isVisibleInInterests": true,
        "iconFile": "food.svg",
        "placeOrder": 5,
        "interestsOrder": 5,
        "children": []
      },
      {
        "name": "Vibe Tag",
        "isVisibleInInterests": false,
        "iconFile": "vibe.svg",
        "placeOrder": 6,
        "children": [
          {"name": "Chill", "iconFile": "chill.svg", "placeOrder": 1},
          {
            "name": "Social",
            "interestName": "Social",
            "isVisibleInInterests": true,
            "iconFile": "social.svg",
            "placeOrder": 2,
            "interestsOrder": 13
          },
          {
            "name": "Adventurous",
            "interestName": "Exploring",
            "isVisibleInInterests": true,
            "iconFile": "exploring.svg",
            "placeOrder": 3,
            "interestsOrder": 6
          },
          {
            "name": "High-Energy",
            "iconFile": "scenic_vibe.svg",
            "placeOrder": 4
          },
          {"name": "Romantic", "iconFile": "romantic.svg", "placeOrder": 5},
          {"name": "Creative", "iconFile": "romantic.svg", "placeOrder": 6},
          {"name": "Competitive", "iconFile": "romantic.svg", "placeOrder": 7},
          {"name": "Scenic", "iconFile": "scenic_vibe.svg", "placeOrder": 8},
        ]
      },
      {
        "name": "Other",
        "isVisibleInInterests": false,
        "placeOrder": 7,
        "iconFile": "spiritual.svg",
        "children": [
          {
            "name": "Secret Spot",
            "interestName": "Hidden Spots",
            "isVisibleInInterests": true,
            "iconFile": "hidden_spots.svg",
            "placeOrder": 1,
            "interestsOrder": 8
          },
          {
            "name": "Family-Friendly",
            "iconFile": "family.svg",
            "placeOrder": 2
          },
          {
            "name": "Spiritual Site",
            "iconFile": "spiritual.svg",
            "placeOrder": 4
          },
          {
            "name": "Public Transport",
            "iconFile": "spiritual.svg",
            "placeOrder": 5
          },
        ]
      },
      {
        "name": "Group Type",
        "isVisibleInInterests": false,
        "placeOrder": 8,
        "iconFile": "spiritual.svg",
        "children": [
          {"name": "Solo", "iconFile": "spiritual.svg", "placeOrder": 1},
          {"name": "Couple", "iconFile": "spiritual.svg", "placeOrder": 2},
          {"name": "Friends", "iconFile": "spiritual.svg", "placeOrder": 3},
          {"name": "Family", "iconFile": "spiritual.svg", "placeOrder": 4},
          {"name": "Groups", "iconFile": "spiritual.svg", "placeOrder": 5}
        ]
      },
      {
        "name": "Cost Range",
        "isVisibleInInterests": false,
        "placeOrder": 9,
        "iconFile": "spiritual.svg",
        "children": [
          {"name": "Free", "iconFile": "spiritual.svg", "placeOrder": 1},
          {"name": "Low", "iconFile": "spiritual.svg", "placeOrder": 2},
          {"name": "Medium", "iconFile": "spiritual.svg", "placeOrder": 3},
          {"name": "Premium", "iconFile": "spiritual.svg", "placeOrder": 4}
        ]
      },
      {
        "name": "Difficulty",
        "isVisibleInInterests": false,
        "placeOrder": 9,
        "iconFile": "spiritual.svg",
        "children": [
          {"name": "Easy", "iconFile": "spiritual.svg", "placeOrder": 1},
          {"name": "Moderate", "iconFile": "spiritual.svg", "placeOrder": 2},
          {"name": "Hard", "iconFile": "spiritual.svg", "placeOrder": 3}
        ]
      },
      {
        "name": "Best time to visit",
        "isVisibleInInterests": false,
        "iconFile": "spiritual.svg",
        "placeOrder": 10,
        "children": [
          {"name": "Morning", "iconFile": "spiritual.svg", "placeOrder": 1},
          {"name": "Afternoon", "iconFile": "spiritual.svg", "placeOrder": 2},
          {"name": "Evening", "iconFile": "spiritual.svg", "placeOrder": 3},
          {"name": "Night", "iconFile": "spiritual.svg", "placeOrder": 4}
        ]
      },
    ];

    for (var root in schema) {
      String? rootUrl = await _uploadIcon(root["iconFile"]);
      DocumentReference pRef = firestore.collection('adminCategories').doc();

      await pRef.set({
        "id": pRef.id,
        "name": root["name"],
        "interestName": root["interestName"],
        "icon": rootUrl,
        "parentId": null,
        "ancestorIds": [],
        "level": 0,
        "placeOrder": root["placeOrder"] ?? 0,
        "interestsOrder": root["interestsOrder"] ?? 0,
        "isVisibleInInterests": root["isVisibleInInterests"] ?? false,
        "isActive": true,
        "createdAt": Timestamp.now(),
        "updatedAt": Timestamp.now(),
      });

      if (root["children"] != null) {
        for (var child in root["children"]) {
          String? cUrl = await _uploadIcon(child["iconFile"]);
          DocumentReference cRef = firestore.collection('adminCategories').doc();
          await cRef.set({
            "id": cRef.id,
            "name": child["name"],
            "interestName": child["interestName"],
            "icon": cUrl,
            "parentId": pRef.id,
            "ancestorIds": [pRef.id],
            "level": 1,
            "placeOrder": child["placeOrder"] ?? 0,
            "interestsOrder": child["interestsOrder"] ?? 0,
            "isVisibleInInterests": child["isVisibleInInterests"] ?? false,
            "isActive": true,
            "createdAt": Timestamp.now(),
            "updatedAt": Timestamp.now(),
          });
        }
      }
    }

    print('Categories database seeding completed');
  }
}
