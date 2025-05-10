# 🛒 Flutter Shopping App (DummyJSON API)

A sample Flutter shopping app using BLoC & HydratedBLoC for state management. Built with clean architecture practices and real-time API data from [DummyJSON](https://dummyjson.com/products). Supports:

- Infinite scroll (pagination)
- Product detail screen
- Add/remove favorites (wishlist)
- Favorites persisted with HydratedBLoC

## 🚀 Features

- 📦 Product list with pagination (`limit` + `skip`)
- ❤️ Wishlist (Favorites) using `HydratedBloc`
- 🧾 Product details page
- 🧪 Clean and modular BLoC pattern
- 🧼 Error handling, loading indicators
- 🔄 State persistence across app restarts

## 📷 Screenshots

| Product List | Product Detail | Favorites |
|--------------|----------------|-----------|
| ![Product List](screenshots/product_list.png) | ![Product Detail](screenshots/product_detail.png) | ![Favorites](screenshots/favorites.png) |

## 📦 Packages Used

- [flutter_bloc](https://pub.dev/packages/flutter_bloc)
- [hydrated_bloc](https://pub.dev/packages/hydrated_bloc)
- [http](https://pub.dev/packages/http)
- [path_provider](https://pub.dev/packages/path_provider)

## 🛠️ Setup

```bash
git clone https://github.com/your-username/flutter-shopping-app-dummyjson-bloc.git
cd flutter-shopping-app-dummyjson-bloc
flutter pub get
flutter run
```

---

🌐 API Reference
Uses DummyJSON for product data.

Example endpoints:

https://dummyjson.com/products?limit=6&skip=0

https://dummyjson.com/products/1

---

🗂️ Folder Structure

```
lib/
├── blocs/               # BLoC files (product, favorites)
│   ├── product/
│   ├── favorites/
├── models/              # Product model
├── screens/             # UI screens (list, details, favorites)
├── widgets/             # UI components (ProductCard)
└── main.dart 
```

