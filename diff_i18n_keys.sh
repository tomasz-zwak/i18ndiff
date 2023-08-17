#!/bin/bash

# Save the current working directory
SCRIPT_DIR="$(pwd)"

# Initialize variables
COMPARE_WITH_BRANCH=""
REPO_PATH=""
OUT_PATH=""
PATTERN=""

# Parse named arguments
while [ $# -gt 0 ]; do
  case $1 in
    --compareWithBranch)
      COMPARE_WITH_BRANCH="$2"
      shift 2
      ;;
    --path)
      REPO_PATH="$2"
      shift 2
      ;;
    --outPath)
      OUT_PATH="$2"
      shift 2
      ;;
    --pattern)
      PATTERN="$2"
      shift 2
      ;;
    *)
      echo "Invalid option: $1"
      exit 1
      ;;
  esac
done

# Check if the compareWithBranch name is provided
if [ -z "$COMPARE_WITH_BRANCH" ]; then
  echo "ERROR: Git branch name to compare with is not provided." >&2
  exit 1
fi

# Check if the repo path is provided
if [ -z "$REPO_PATH" ]; then
  echo "ERROR: Git repository path is not provided." >&2
  exit 1
fi

# Check if the output path is provided
if [ -z "$OUT_PATH" ]; then
  echo "ERROR: Output path is not provided." >&2
  exit 1
fi

# Check if the pattern is provided
if [ -z "$PATTERN" ]; then
  echo "ERROR: Pattern is not provided." >&2
  exit 1
fi

# Change to the specified repository directory
cd "$REPO_PATH" || exit 1

# Create the output folder if it doesn't exist
mkdir -p "$OUT_PATH"

# Get the name of the current Git branch
ORIGINAL_BRANCH="$(git rev-parse --abbrev-ref HEAD)"
ORIGINAL_BRANCH_DASHED="$(echo "$ORIGINAL_BRANCH" | sed 's#/#-#g')"

# Run the i18next command and rename the output file
i18next "$PATTERN" -o "$OUT_PATH/$ORIGINAL_BRANCH_DASHED.json"

# Switch to the specified Git branch to compare with
if ! git checkout "$COMPARE_WITH_BRANCH"; then
  echo "ERROR: Git branch '$COMPARE_WITH_BRANCH' does not exist." >&2
  exit 1
fi

# Get the name of the compareWithBranch
COMPARE_WITH_BRANCH_NAME="$(git rev-parse --abbrev-ref HEAD)"
COMPARE_WITH_BRANCH_NAME_DASHED="$(echo "$COMPARE_WITH_BRANCH_NAME" | sed 's#/#-#g')"

# Run the i18next command again and rename the output file using the new branch name
i18next "$PATTERN" -o "$OUT_PATH/$COMPARE_WITH_BRANCH_NAME_DASHED.json"

# Switch back to the original Git branch
git checkout "$ORIGINAL_BRANCH"

cd "$SCRIPT_DIR" || exit 1

node compare.js "$OUT_PATH/$COMPARE_WITH_BRANCH_NAME_DASHED.json" "$OUT_PATH/$ORIGINAL_BRANCH_DASHED.json"
