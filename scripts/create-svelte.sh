#!/bin/sh

# prompt for organization type using simple read
get_org_type() {
  while true; do
    printf "Select organization type:\n1) personal\n2) quantum\nEnter number (1-2): " >&2
    read -r choice
    case "$choice" in
    1)
      echo "personal"
      break
      ;;
    2)
      echo "quantum"
      break
      ;;
    *) echo "Invalid option. Please select 1 or 2." >&2 ;;
    esac
  done
}

# prompt for project name if not provided
get_project_name() {
  if [ -z "$1" ]; then
    printf "Enter project name: " >&2
    read -r project_name
    if [ -z "$project_name" ]; then
      echo "Error: Project name cannot be empty" >&2
      exit 1
    fi
    echo "$project_name"
  else
    echo "$1"
  fi
}

# check if dependencies exist
check_dependencies() {
  commands="pnpm git gh curl mkdir"
  for cmd in $commands; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
      echo "Error: Required command '$cmd' not found" >&2
      exit 1
    fi
  done

  # Check if gh cli is authenticated
  if ! gh auth status >/dev/null 2>&1; then
    echo "Error: GitHub CLI not authenticated. Please run 'gh auth login' first" >&2
    exit 1
  fi
}

# Main script
main() {
  # Check dependencies first
  check_dependencies

  # Get organization type
  org_type=$(get_org_type)

  # Get project name
  project_name=$(get_project_name "$1")

  # Create new project and initialize
  pnpx sv create --no-install --template minimal --types ts "$project_name" || exit 1
  cd "$project_name" || exit 1
  git init

  # Replace `npm` with `pnpm` and fix unused var
  sed -i '' 's/npm/pnpm/g' package.json
  sed -i '' 's/unit": "vitest"/unit": "vitest run"/g' package.json
  sed -i '' 's/text, //g' src/lib/server/db/schema.ts

  # Install and setup oxc
  pnpm install -D oxlint@latest

  # Create oxc config file
  cat >.oxc.json <<EOF
{
  "\$schema": "https://raw.githubusercontent.com/oxc-project/oxc/main/crates/config/schema.json",
  "files": {
    "include": ["src/**/*.{js,ts,svelte}"]
  },
  "extends": ["plugin:svelte/recommended"],
  "rules": {
    "no-unused-vars": "error",
    "no-console": "warn"
  }
}
EOF

  # Add oxlint script to package.json
  sed -i '' 's/prettier --check ./oxlint/g' package.json

  # Setup commitlint
  pnpm install -D @commitlint/cli @commitlint/config-conventional
  printf "export default { extends: ['@commitlint/config-conventional'] };" >commitlint.config.js

  # Setup Husky
  pnpm install -D husky
  pnpx husky init
  printf "pnpx commitlint --edit %s" "$1" >.husky/commit-msg
  printf "pnpm run format && pnpm run lint && pnpm run test:unit && pnpm run check" >.husky/pre-commit

  # Initial build and format
  pnpm build && pnpm format

  # Create initial commit and push
  git add .
  git commit -m "chore: 🎉 initialize project

Setup development environment:
- Configure SvelteKit as frontend framework
- Integrate oxc for fast, modern linting
- Configure Vitest for unit testing infrastructure
- Install and configure TailwindCSS for styling
- Setup commitlint to enforce conventional commit messages
- Implement husky pre-commit hooks for automated checks"

  # Create repository based on organization type and push changes
  case "$org_type" in
  personal)
    gh repo create "$project_name" --public --remote origin --source .
    ;;
  quantum)
    gh repo create "$project_name" --private --team wearequantum --remote origin --source .
    ;;
  esac
  git push
}

# Execute main function with provided argument
main "$1"
