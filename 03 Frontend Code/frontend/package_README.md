{
  /*
   * ============================================================
   * Project Information
   * ============================================================
   * The project metadata identifies the application and provides
   * basic information used by Node.js and npm.
   *
   * Engineering Rationale:
   * The project is marked as private because Café Fausse is an
   * academic application rather than a reusable npm package.
   */
  "name": "cafefausse-frontend",
  "version": "1.0.0",
  "private": true,

  /*
   * ============================================================
   * Scripts
   * ============================================================
   * Scripts provide convenient shortcuts for common development
   * activities. Instead of remembering long commands, developers
   * execute simple npm commands.
   */
  "scripts": {

    /*
     * Starts the Vite development server.
     *
     * Why?
     * Vite provides extremely fast startup and Hot Module
     * Replacement (HMR), allowing changes to appear immediately
     * in the browser during development.
     *
     * Usage:
     * npm run dev
     */
    "dev": "vite",

    /*
     * Builds the application for production.
     *
     * During the build Vite:
     * • Bundles JavaScript modules
     * • Removes unused code
     * • Minifies assets
     * • Optimises performance
     *
     * Output:
     * dist/
     */
    "build": "vite build",

    /*
     * Serves the production build locally.
     *
     * Purpose:
     * Allows verification of the compiled application before
     * deployment.
     */
    "preview": "vite preview",

    /*
     * Executes automated frontend tests.
     *
     * Testing confirms that React components continue to function
     * correctly after modifications.
     */
    "test": "vitest",

    /*
     * Runs Vitest in watch mode.
     *
     * Tests automatically rerun whenever project files change,
     * providing rapid developer feedback.
     */
    "test:watch": "vitest --watch",

    /*
     * Performs static code analysis.
     *
     * ESLint detects:
     * • unused variables
     * • syntax problems
     * • React best-practice violations
     * • inconsistent coding styles
     * • potential bugs
     */
    "lint": "eslint ."
  },

  /*
   * ============================================================
   * Production Dependencies
   * ============================================================
   * These libraries become part of the deployed application.
   * They provide the functionality required while Café Fausse
   * is running in production.
   */
  "dependencies": {

    /*
     * Axios
     *
     * Purpose:
     * Sends HTTP requests between the React frontend and the
     * Flask REST API.
     *
     * Architecture:
     *
     * React
     *   │
     * Axios
     *   │
     * Flask REST API
     *   │
     * PostgreSQL
     *
     * Engineering Decision:
     * Axios was selected because it provides cleaner syntax,
     * automatic JSON handling and improved error management
     * compared with the native fetch() API.
     */
    "axios": "^1.5.0",

    /*
     * React
     *
     * Purpose:
     * Provides the component-based frontend architecture.
     *
     * Typical reusable components include:
     * • Navigation Bar
     * • Hero Banner
     * • Menu Cards
     * • Reservation Form
     * • Newsletter Form
     * • Footer
     *
     * Engineering Decision:
     * Reusable components reduce duplicated code and improve
     * maintainability and scalability.
     */
    "react": "^18.2.0",

    /*
     * ReactDOM
     *
     * Purpose:
     * Renders React components into the browser Document Object
     * Model (DOM), allowing users to interact with the interface.
     */
    "react-dom": "^18.2.0",

    /*
     * React Router
     *
     * Purpose:
     * Provides client-side routing.
     *
     * Example routes:
     * /
     * /menu
     * /reservations
     * /contact
     *
     * Engineering Decision:
     * Client-side routing creates a smoother user experience
     * because navigation occurs without refreshing the browser.
     */
    "react-router-dom": "^6.14.1"
  },

  /*
   * ============================================================
   * Development Dependencies
   * ============================================================
   * These packages assist development and testing only.
   * They are excluded from the production application.
   */
  "devDependencies": {

    /*
     * Jest DOM
     *
     * Adds additional assertions that make React component
     * tests easier to understand.
     */
    "@testing-library/jest-dom": "^6.0.0",

    /*
     * React Testing Library
     *
     * Provides utilities for testing React components from the
     * user's perspective.
     */
    "@testing-library/react": "^14.0.0",

    /*
     * Vite React Plugin
     *
     * Enables Vite to compile JSX syntax used by React.
     */
    "@vitejs/plugin-react": "^4.0.0",

    /*
     * ESLint
     *
     * Static analysis tool that improves software quality by
     * identifying programming errors before runtime.
     */
    "eslint": "^8.57.0",

    /*
     * React ESLint Plugin
     *
     * Adds React-specific coding rules to ESLint.
     */
    "eslint-plugin-react": "^7.34.0",

    /*
     * React Hooks Plugin
     *
     * Validates compliance with React's Rules of Hooks,
     * preventing subtle runtime errors.
     */
    "eslint-plugin-react-hooks": "^4.6.2",

    /*
     * jsdom
     *
     * Creates a simulated browser environment inside Node.js,
     * allowing React components to access window and document
     * during automated testing.
     */
    "jsdom": "^22.1.0",

    /*
     * Vite
     *
     * Modern frontend build tool.
     *
     * Responsibilities:
     * • Development server
     * • Hot Module Replacement
     * • Module bundling
     * • Production optimisation
     *
     * Engineering Decision:
     * Vite was selected because it provides significantly faster
     * build performance than older React toolchains.
     */
    "vite": "^5.0.0",

    /*
     * Vitest
     *
     * Automated testing framework designed specifically for Vite.
     *
     * Supports:
     * • Unit tests
     * • Component tests
     * • Regression testing
     */
    "vitest": "^1.3.0"
  },

  /*
   * ============================================================
   * Vitest Configuration
   * ============================================================
   * Configures the automated testing environment.
   */
  "vitest": {

    /*
     * Browser Simulation
     *
     * jsdom creates a browser-like environment so React
     * components can access browser APIs during testing.
     */
    "environment": "jsdom",

    /*
     * Global Test Functions
     *
     * Makes testing functions such as:
     * • describe()
     * • test()
     * • it()
     * • expect()
     * • beforeEach()
     *
     * available globally without importing them into every file.
     */
    "globals": true
  }
}