set -eou pipefail

options=$(getopt -o h,p:,r: -l help,path:,repo: -n "$0" -- "$@") || exit
eval set -- "$options"

print_usage() {
  echo "USAGE: $(basename "$0") [OPTION]..."
  echo "Ensures that a repo exists."
  echo ""
  echo "Options:"
  echo "  -p, --path      The path to the repo."
  echo "  -r, --repo      The remote URL for the repo."
  echo "  -h, --help      Display this help message."
}

arg_path=""
arg_repo=""

while true; do
  case "$1" in
    -h|--help) print_usage; exit 0 ;;
    -p|--path) arg_path="$2"; shift 2 ;;
    -r|--repo) arg_repo="$2"; shift 2 ;;
    --) shift; break ;;
    *) echo "Invalid option: $1" >&2; print_usage >&2; exit 1 ;;
  esac
done

if [ -z "$arg_path" ]; then
  echo "--path <path> is required" >&2
  exit 1
fi

if [ -z "$arg_repo" ]; then
  echo "--repo <repo> is required" >&2
  exit 1
fi

if [ -d "$arg_path" ]; then
  exit 0
fi

mkdir -p "$(dirname "$arg_path")"
git clone "$arg_repo" "$arg_path"
