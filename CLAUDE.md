# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a personal portfolio website (https://torben.website) built with TypeScript, WebComponents, and weboptimizer. The project demonstrates modern frontend development with strong emphasis on build optimization, type safety, internationalization (English/German), and responsive design.

## Build System: weboptimizer

All build, lint, test, and serve commands are orchestrated through **weboptimizer**, a comprehensive abstraction over Webpack. Configuration is specified in `package.json` under the `webOptimizer` key rather than separate config files (no tsconfig.json, .eslintrc, or jest.config.js at the root).

Key features of weboptimizer in this project:
- TypeScript compilation with Babel
- PostCSS preprocessing with plugins (mixins, nested, sprites, font handling)
- EJS template processing for index.html
- Custom webpack snapshot exclusions for certain dependencies
- Jest testing with jsdom environment

## Commands

### Building
- `yarn build` - Build the project for production (output to `build/` directory)
- `yarn build:stats` - Build with webpack profiling and output stats to `/tmp/stats.json`
- `yarn watch` - Build in watch mode for development

### Development
- `yarn serve` or `yarn start` - Start dev server with hot reload (uses weboptimizer serve)
- `yarn clear` - Clear build artifacts and cache

### Testing
- `yarn test` - Run all Jest tests (clears first)
- `yarn test:browser` - Run tests in browser environment
- `yarn test:coverage` - Generate code coverage report
- `yarn test:coverage:report` - Generate and display coverage report

### Linting & Type Checking
- `yarn check:types` - Run TypeScript type checking only
- `yarn lint` - Run all linting (ESLint for JS/TS, Stylelint for CSS)
- `yarn check` - Run both type checking and linting

### Documentation
- `yarn document` - Generate JSDoc documentation

## Architecture

### Structure
```
source/
├── index.ts          # Main TypeScript application (WebComponent-based)
├── index.html.ejs    # EJS template for HTML generation
├── index.css         # PostCSS stylesheets
├── test.ts           # Jest test suite
├── robots.txt        # SEO configuration
├── data/             # Static assets (PDFs, vCard, SSH key)
└── image/            # Images including carousel images
```

### Technology Stack

**Core:**
- TypeScript with Babel transpilation
- WebComponents via `web-component-wrapper` library
- EJS templating for dynamic HTML generation

**Styling:**
- PostCSS with plugins:
  - `postcss-mixins` and `postcss-nested` for CSS preprocessing
  - `postcss-sprites` for sprite generation
  - `postcss-fontpath` for font handling
  - `postcss-url` and `postcss-import`

**Utilities & Dependencies:**
- `clientnode` - Custom utility library (DOM manipulation, logging, etc.)
- `web-internationalization` - i18n support for English (enUS) and German (deDE)
- `website-utilities` - Portfolio-specific utilities
- `swiper` - Carousel/slider component for portfolio showcase
- `errorreporter` - Error tracking and reporting
- `ua-parser-js` - User agent parsing

**Testing:**
- Jest (v30.3.0) with jsdom environment for DOM testing
- Located in `source/test.ts`

**Code Quality:**
- ESLint with TypeScript support and Google config
- Stylelint for CSS linting
- JSDoc for documentation
- Babel ESLint parser

**Build Tool:**
- weboptimizer (v3.0.22) wrapping Webpack
- Favicons plugin for favicon generation
- Mini CSS Extract Plugin for CSS bundling

### Key Architectural Patterns

1. **WebComponent Pattern**: The main application is built as a WebComponent using decorators from `web-component-wrapper`
2. **Internationalization**: Content is defined in EJS template with language-keyed objects (enUS/deDE keys) for dual-language support
3. **Custom Element Wrapper**: Uses `@property` decorator from web-component-wrapper for reactive properties
4. **Plugin System**: Utilities register plugins that augment the "$" (DOM query) scope on import

### Entry Points

- **HTML**: Generated from `source/index.html.ejs` which includes EJS preprocessing with language switching logic
- **JavaScript**: `source/index.ts` exports a Website WebComponent class that initializes on page load
- **Styling**: `source/index.css` processed through PostCSS with custom plugins
- **Build Output**: `build/index.html` (main entry point specified in package.json)

### Internationalization

The project supports English and German:
- DEFAULT_LANGUAGE: enUS
- ALTERNATE_LANGUAGE: deDE
- Language switching defined in EJS template with `swapCase()` utility
- Content keys use format: `{enUS: "...", deDE: "..."}`

## CI/CD

GitHub Actions workflows run on branch/tag creation and manual trigger:

- `build.yaml` - Runs `yarn build`
- `lint.yaml` - Runs `yarn lint`
- `check-types.yaml` - Runs `yarn check:types`
- `test-coverage-report.yaml` - Runs tests and reports to Coveralls.io

All workflows use custom action `thaibault/install-npm-package-dependencies-action@main` for setup.

## Prerequisites

- Node.js >= 24
- npm >= 11
- Yarn >= 4.14.1 (package manager)

The project uses Yarn 4 with node-modules linker enabled. Dependencies are locked in yarn.lock.

## Important Notes

- Build configuration is entirely within `package.json` under `webOptimizer` key
- Special webpack snapshot exclusions exist for clientnode, web-component-wrapper, web-internationalization, and website-utilities (see package.json)
- Yarn patches are applied to the `globals` package (see `.yarn/patches/`)
- The project has no separate ESLint or TypeScript configuration files; all config comes from weboptimizer defaults and package.json
