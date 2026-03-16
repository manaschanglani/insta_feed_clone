Instagram Feed Clone – Flutter Assignment

## Overview

This project is a recreation of the Instagram Home Feed built using Flutter.
The goal of the assignment was to replicate the look and feel of Instagram’s feed while maintaining **clean architecture, smooth scrolling performance, and realistic touch interactions**.

The implementation focuses on:

* Pixel-accurate layout
* Smooth infinite scrolling
* Gesture interactions such as **pinch-to-zoom and double-tap like**
* Clean separation of concerns using **Riverpod state management**

---

# Architecture

The project follows a **layered clean architecture** pattern to keep UI, logic, and data separate.

```
lib/
│
├── core/
│   ├── constants
│   └── theme
│
├── domain/
│   ├── entities
│   └── repositories
│
├── data/
│   ├── sources
│   └── repositories
│
├── presentation/
│   ├── pages
│   ├── widgets
│   └── providers
│
└── main.dart
```

### Layer responsibilities

**Presentation**

* UI widgets
* Screens
* Riverpod providers

**Domain**

* Business entities
* Repository contracts

**Data**

* Repository implementations
* Mock data source
* Latency simulation

---

# State Management

This project uses **Riverpod** for state management.

### Why Riverpod

Riverpod was chosen because it provides:

* Compile-time safety
* Easy dependency injection
* Predictable state updates
* Better separation of UI and business logic
* Scalable architecture compared to simple Provider usage

### State Flow

```
UI Widgets
   ↓
Riverpod Providers
   ↓
Repository Layer
   ↓
Mock Data Source
```

### Feed State Management

The feed is controlled by a **StateNotifier** which manages:

* Stories
* Posts
* Pagination
* Loading states
* Like/Save toggles

Example responsibilities of the provider:

* Fetch initial feed
* Load more posts when scrolling
* Toggle like state
* Toggle save state

---

# Features Implemented

### UI Features

* Instagram-style top navigation bar
* Stories tray with gradient borders
* Post feed with pixel-accurate spacing
* Image carousel for multi-image posts

### Interactions

* Double-tap like animation
* Pinch-to-zoom overlay interaction
* Save / like toggle state
* Snackbar for unimplemented actions

### Performance

* Cached network images
* Image prefetching
* Lazy loading pagination
* Bouncing scroll physics

### Loading States

* Shimmer skeleton loading
* Separate shimmer for posts and stories

---

# Pagination

The feed implements **lazy loading**.

When the user scrolls near the bottom:

```
User scrolls
      ↓
Trigger loadMorePosts()
      ↓
Repository fetches next page
      ↓
Posts appended to feed
```

Each page loads **10 posts** with simulated network latency.

---

# Mock Data Layer

To simulate a backend API:

* A **PostRepository** interface defines data contracts
* A **MockFeedSource** generates dummy content
* A **1.5 second delay** simulates network latency

Images are loaded from **public URLs** instead of bundled assets.

---

# Dependencies Used

Main packages used in this project:

```
flutter_riverpod
cached_network_image
shimmer
flutter_hooks
freezed / json_serializable
```

These packages were chosen to ensure:

* Efficient state management
* Smooth image loading and caching
* Realistic loading skeletons
* Clean immutable models

---

# How to Run the Project

## 1. Clone the repository

```
git clone <repository-url>
```

## 2. Navigate into the project

```
cd instagram_feed_clone
```

## 3. Install dependencies

```
flutter pub get
```

## 4. Run the app

```
flutter run
```

You can run the project on:

* Android Emulator
* iOS Simulator
* Physical device

---

# Notes

The project focuses on **deep polish of a single screen rather than implementing multiple screens**, prioritizing visual fidelity and interaction quality.

The architecture allows the mock data source to easily be replaced by a real backend API in the future.

---

