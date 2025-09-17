# Development Methodology

Use test-driven development (TDD) when writing code. This is nonnegotiable. Before implementing a feature or fixing a bug, first write a failing test that attempts to manifest the desired behavior in a minimal manner. Then, implement the code such that the test passes. Iterate until the overall task is complete. Once the functionality is implemented and known to work, review the implementation and ensure that the abstractions are sensible, there are no obvious performance issues, and that the code is clear and extensible. Use Vitest as the testing framework.

A task is not considered complete until all tests pass and there are no type or lint errors. Linter warnings are unacceptable. Iterate until functionality is implemented and tested and all diagnostic checks pass.

# TypeScript Style Guide

This section outlines the TypeScript coding style and conventions for Chitchatter Pro. Adhering to these guidelines will help maintain code quality, readability, and consistency.

## Core Principles

The following principles are the foundation of our coding style.

### 1. Immutability

**Never mutate data.** Treat all data structures (objects, arrays) as immutable.

- Instead of changing an existing object or array, create a new one with the updated values.
- This is enforced by the `functional/immutable-data` ESLint rule.
- Use immutable techniques like `[...array, newItem]` for adding to arrays, or `array.map()` and `array.filter()` which return new arrays.

**Example:**

```typescript
// Good
const newArray = [...oldArray, newItem]
const newObject = { ...oldObject, newProperty: 'value' }

// Bad
oldArray.push(newItem)
oldObject.newProperty = 'value'
```

### 2. Pure Functions

Strive to write pure functions, especially for business logic and state transformations (reducers).

- A pure function's return value is determined only by its input values.
- It has no side effects (e.g., network requests, modifying global state).

### 3. Type Safety

Leverage TypeScript's type system to make the code as type-safe as possible.

- `"strict": true` is enabled in `tsconfig.json`. Understand and adhere to strict mode rules.
- Avoid `any` whenever possible. Use `unknown` for values that are truly unknown and perform type checking.
- Avoid the `as` keyword, especially in application code. It is acceptable to use it sparingly in tests when necessary.
- Use type guards to narrow down types within conditional blocks.

## TypeScript Language Features

- **Types vs. Interfaces:** Favor using `interface` over `type`.
- **Type Guards:** Use type guard functions (e.g., `isCat(obj): obj is Cat`) to assert types in a way that the TypeScript compiler can understand.
- **Generics:** Use generics (`<T>`) to create reusable, type-safe functions and classes (e.g., in services).
- **Enums:** Favor using `enum` liberally, especially instead of string union types (`'cat' | 'dog'`).

## Services and Utilities

- Services are classes (often singletons) that provide a set of related utility functions.
- Methods within services must be pure and immutable.
- Export a single instance of the service for use throughout the application.

## Formatting and Linting

The project uses Prettier and ESLint to enforce a consistent code style. The configuration is in `.prettierrc.json` and `eslint.config.mjs`.

- **Semicolons:** No semicolons.
- **Quotes:** Single quotes.
- **Trailing Commas:** Yes (`es5`).
- **Import Order:** Imports are automatically sorted.

## Naming Conventions

- **Variables and Functions:** `camelCase`.
- **Classes and Components:** `PascalCase`.
- **Interfaces:** `PascalCase`.
- **Types:** `PascalCase`.
- **Files:** `PascalCase` for components (`MyComponent.tsx`), `kebab-case` for directories (`my-component`).

## Comments and JSDoc

- Use JSDoc for public-facing functions and methods in services to explain their purpose, parameters, and return values.
- Use inline comments (`//`) to explain complex or non-obvious logic. Avoid redundant comments.

## Client-side code

### File and Directory Structure

- **Component Structure:** A component should be in its own directory (e.g., `src/ui/components/MyComponent/`).
  - `index.ts`: Exports the component and related types.
  - `MyComponent.tsx`: The component implementation.
  - `types.ts`: Type definitions for the component's props and internal state.
- **Reducer Structure:** State transformation logic is organized by action. Each action has its own directory (e.g., `src/reducers/my-action/`).
  - `index.ts`: Contains the pure function that performs the state transformation.
- **Services:** Business logic classes are grouped into services (e.g., `src/services/QuotaManagement/`).
  - `index.ts`: Defines a class for the service and exports a singleton convenience instance.
  - `index.test.ts`: Unit tests for the service.
- **Libraries**: General purpose classes and functions are grouped into libraries (e.g., `src/lib/formatting/numbers.ts`).

## State Management (Reducers)

- Reducers are pure functions that take the current state and an action's payload, and return a new state.
- The reducer's signature should be `(currentState, payload) => newState`.
- All state updates must be immutable.

### React Components

- **Function Components:** All components must be function components.
- **Props:**
  - Define props in a `types.ts` file.
  - Use object destructuring to access props.
- **State:** Prefer lifting state up. Components should be as stateless as possible. When local state is necessary, use `useState` or `useReducer`.
- **Styling:** Styling is handled via a global MUI theme and inline `sx` prop styles as necessary.
