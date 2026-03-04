# Flutter GitHub Explorer - MVVM & MobX Implementation

This repository demonstrates a robust implementation of a Flutter application utilizing the **MVVM (Model-View-ViewModel)** architectural pattern and **MobX** for reactive state management.

The project serves as a technical showcase of how to build scalable, maintainable, and testable cross-platform applications while consuming real-world data from the GitHub API.

## 🏗 Architecture & Design Patterns

To ensure a high level of code quality and separation of concerns, the project follows these principles:

- **MVVM Pattern:** Strict decoupling of the UI (View) from the business logic (ViewModel) and data sources (Model).

- **Reactive State Management:** Utilizing MobX with Observables, Actions, and Computed values to create a seamless, reactive user experience with minimal boilerplate.

- **Dependency Injection:** Ensuring modularity and easier testing by decoupling object creation from usage.

- **Service Layer:** Dedicated services for API communication, abstracting the networking logic (Dio/Http) from the rest of the application.

## 🚀 Key Features

- **GitHub Repository Search:** Real-time fetching of repositories using the GitHub REST API.

- **Reactive UI:** Instant UI updates based on state changes without manual `setState` calls.

- **Error Handling:** Robust management of API states (Loading, Success, and Error) to provide a smooth UX.

- **Clean Code:** Written with a focus on readability, maintainability, and SOLID principles.

## 🛠 Tech Stack

| Category        | Technology                          |
| --------------- | ----------------------------------- |
| Language        | Dart                                |
| Framework       | Flutter                             |
| State Management| MobX & Flutter MobX                 |
| Networking      | Dio (or Http) for RESTful API integration |
| Architecture    | MVVM                                |

## 🧪 Why MobX?

The choice of MobX reflects a preference for **transparent functional reactive programming**. By using transparent tracking, the application ensures that only the components that truly depend on a specific piece of state are re-rendered, optimizing performance on both Android and iOS devices.
