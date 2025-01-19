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
  commands="deno git gh curl mkdir"
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
  deno run -A npm:sv create --no-install --template minimal --types ts "$project_name" || exit 1
  cd "$project_name" || exit 1
  git init

  # Replace `npm` with `deno` and fix unused var
  sed -i '' 's/npm/deno/g' package.json
  sed -i '' 's/unit": "vitest"/unit": "vitest run"/g' package.json
  sed -i '' 's/text, //g' src/lib/server/db/schema.ts

  # Setup commitlint
  deno install -D npm:@commitlint/cli npm:@commitlint/config-conventional
  printf "export default { extends: ['@commitlint/config-conventional'] };" >commitlint.config.js

  # Setup Husky - type `A` a few times to allow during script
  deno install -D npm:husky
  deno run --allow-env npm:husky init
  printf "deno run npm:commitlint --edit %s" "$1" >.husky/commit-msg
  printf "deno run format && deno run test:unit && deno run lint && deno run check" >.husky/pre-commit

  # Initial build and format
  deno task build && deno task format

  # Create initial commit and push
  git add .
  git commit -m "chore: 🎉 initialize project

Setup development environment:
- Configure SvelteKit as frontend framework
- Integrate ESLint and Prettier for code quality
- Configure Vitest for unit testing infrastructure
- Install and configure TailwindCSS for styling
- Setup commitlint to enforce conventional commit messages
- Implement husky pre-commit hooks for automated checks"

  # Create repository based on organization type
  case "$org_type" in
  personal)
    gh repo create "$project_name" --public --remote origin --source .
    ;;
  quantum)
    gh repo create "$project_name" --private --team wearequantum --remote origin --source .
    ;;
  esac
}

# Execute main function with provided argument
main "$1"
