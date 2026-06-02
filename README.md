# Rideal Vendor - Premium Vehicle Rental Management App

A stunning ultra-modern Vendor Vehicle Rental Mobile App UI built with Flutter, featuring a premium luxury dark theme and realistic dummy data. This app is designed for vendors/partners who manage Scooty, Bike, and Car rentals for tourists and local users.

## 🎨 Design Features

### Theme & Style
- **Luxury Modern UI** with glassmorphism effects
- **Dark Futuristic Dashboard** inspired by Tesla, Uber Driver, Rapido Captain
- **Premium Color Palette:**
  - Background: #121212
  - Card Color: #1E1E1E
  - Primary Gradient: #8B5CF6 to #6366F1
  - Accent Color: #EC4899
  - White Text: #F5F5F5
  - Grey Text: #9CA3AF

### UI Elements
- ✨ Blur glass effects
- 🎯 Rounded corners with premium spacing
- 🌊 Floating glassmorphism bottom navbar
- 💫 Soft shadows and neon glow highlights
- 🎭 Smooth animations and transitions
- 📱 Responsive Android/iOS layout

### Typography
- Poppins (Primary font)
- SF Pro Display style
- Inter-inspired spacing

## 📱 Screens

### 1. Splash Screen
- Premium animated logo
- Luxury vehicle background
- Smooth fade animation
- Dark futuristic gradient

### 2. Login Screen
- Modern luxury login page
- Email & Password fields
- Remember me checkbox
- Forgot password option
- Continue with Google
- Glassmorphism login card
- **Dummy Credentials:**
  - Email: vendor@rideal.com
  - Password: 123456

### 3. Signup Screen
- Vendor registration form
- Profile photo upload
- City dropdown selection
- Terms & conditions
- Modern premium layout

### 4. Dashboard Screen
- Welcome message with location
- Stats cards (Total Vehicles, Active Bookings, Today Earnings, Monthly Revenue)
- Revenue analytics chart (Last 7 days)
- Quick action buttons
- Floating glowing cards

### 5. Vehicle Listing Screen
- Filter by vehicle type (All, Scooty, Bike, Car)
- Vehicle cards with:
  - Vehicle image placeholder
  - Status badge (Available/Booked)
  - Rating display
  - Price per hour/day
  - Edit & Delete buttons
- Floating "Add Vehicle" button

**Dummy Vehicles:**
- Honda Activa 6G (Scooty) - ₹149/hr, ₹799/day - 4.8★
- Royal Enfield Classic 350 (Bike) - ₹299/hr, ₹1499/day - 4.9★
- Hyundai Creta (Car) - ₹599/hr, ₹2999/day - 4.7★
- TVS Jupiter (Scooty) - ₹139/hr, ₹749/day - 4.6★
- KTM Duke 390 (Bike) - ₹399/hr, ₹1999/day - 4.9★
- Maruti Swift (Car) - ₹499/hr, ₹2499/day - 4.8★

### 6. Add Vehicle Screen
- Vehicle image upload section
- Form fields:
  - Vehicle Name
  - Vehicle Type dropdown
  - Number Plate
  - Fuel Type dropdown
  - Price per Hour/Day
  - Description
  - Availability toggle
- Gradient save button

### 7. Booking Management Screen
- Tabbed interface:
  - Upcoming Bookings
  - Active Bookings
  - Completed Bookings
  - Cancelled Bookings
- Booking cards with:
  - Customer profile
  - Vehicle details
  - Pickup/Drop locations
  - Duration & Amount
  - Accept/Reject buttons (for pending)
  - Status chips

**Dummy Bookings:**
- Rahul Sharma - Hyundai Creta - ₹2,499 (Pending)
- Priya Patel - Royal Enfield - ₹1,196 (Pending)
- Amit Kumar - Honda Activa - ₹799 (Active)
- Sneha Reddy - Maruti Swift - ₹4,998 (Active)

### 8. Earnings Screen
- Wallet balance card with withdraw button
- Earnings stats:
  - Today: ₹12,450 (+8.5%)
  - This Week: ₹68,000 (+12.3%)
  - This Month: ₹1,24,000 (+15.7%)
  - Total: ₹8,45,000 (+22.1%)
- Monthly revenue bar chart (Last 6 months)
- Recent transactions list
- Premium analytics cards

### 9. Profile Screen
- Vendor profile with verification badge
- Stats display (Vehicles, Bookings, Rating)
- Contact information
- Menu options:
  - Edit Profile
  - Documents
  - Notifications
  - Privacy
  - Help & Support
  - About
- Logout with confirmation dialog

## 🎯 Bottom Navigation Bar

Floating glassmorphism navbar with 5 tabs:
1. **Dashboard** - Overview and analytics
2. **Bookings** - Manage bookings
3. **Vehicles** - Vehicle fleet management
4. **Earnings** - Revenue tracking
5. **Profile** - Vendor profile

**Active Tab Features:**
- Circular glowing gradient
- Smooth scale animation
- Floating neon effect

**Inactive Tab Features:**
- Minimal monochrome icons
- Soft opacity

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.10.7 or higher)
- Dart SDK
- Android Studio / VS Code
- Android Emulator / iOS Simulator / Physical Device

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd rentalvender
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  google_fonts: ^6.1.0
  flutter_svg: ^2.0.9
  shimmer: ^3.0.0
  fl_chart: ^0.66.0
  smooth_page_indicator: ^1.1.0
  cached_network_image: ^3.3.1
```

## 🎨 Project Structure

```
lib/
├── main.dart                 # App entry point
├── utils/
│   └── app_theme.dart       # Theme colors, gradients, styles
├── models/
│   ├── vehicle_model.dart   # Vehicle data model
│   └── booking_model.dart   # Booking data model
├── widgets/
│   ├── glass_card.dart      # Glassmorphism card widget
│   ├── gradient_button.dart # Gradient button widget
│   └── custom_text_field.dart # Custom input field
└── screens/
    ├── splash_screen.dart
    ├── login_screen.dart
    ├── signup_screen.dart
    ├── main_navigation.dart
    ├── dashboard_screen.dart
    ├── vehicles_screen.dart
    ├── add_vehicle_screen.dart
    ├── bookings_screen.dart
    ├── earnings_screen.dart
    └── profile_screen.dart
```

## ⚠️ Important Notes

- **Frontend Only**: This project is ONLY for frontend UI design with dummy data
- **No Backend**: No Firebase, API integration, authentication logic, or database functionality
- **Production-Level UI**: Focus completely on premium production-level UI/UX
- **Dummy Data**: All data is hardcoded for demonstration purposes

## 🎯 Features

✅ Premium luxury dark theme
✅ Glassmorphism effects
✅ Smooth animations
✅ Responsive design
✅ Modern UI components
✅ Interactive charts
✅ Floating navigation
✅ Neon glow effects
✅ Professional typography
✅ Skeleton loading states
✅ Empty states
✅ Hero transitions

## 📱 Supported Platforms

- ✅ Android
- ✅ iOS
- ⚠️ Web (with limitations)
- ⚠️ Desktop (with limitations)

## 🎨 Design Inspiration

- Tesla Dashboard
- Uber Driver App
- Rapido Captain App
- Airbnb Host App
- Revolut Banking App
- Modern Fintech Apps
- Travel-tech Applications

## 📄 License

This project is for demonstration purposes only.

## 👨‍💻 Developer Notes

This is a complete UI implementation with:
- Clean code architecture
- Reusable widgets
- Consistent theming
- Smooth animations
- Professional design patterns
- Production-ready structure

Perfect for:
- Portfolio projects
- UI/UX demonstrations
- Flutter learning
- Startup MVPs
- Client presentations

---

**Built with ❤️ using Flutter**
