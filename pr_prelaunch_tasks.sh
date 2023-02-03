dart format --set-exit-if-changed .
if [ $? -eq 1 ]; then
  dart format lib
  git add .
  git commit -m "chore: run flutter format ."
  echo "push changes? [y/n]"
  read -r pushResponse
  if [ "$pushResponse" = "y" ]; then
    git push origin
  fi
fi
echo "Run dart fix --dry-run? [y/n]"
read -r dryRunResponse
if [ "$dryRunResponse" = "y" ]; then
  dart fix --dry-run
fi
echo "Run dart fix --apply? [y/n]"
read -r applyResponse
if [ "$applyResponse" = "y" ]; then
  dart fix --apply
  if [ -z "$(git status --porcelain)" ]; then
    echo "No changes to commit"
  else
    git add .
    git commit -m "chore: run dart fix --apply"
    echo "push changes? [y/n]"
    read -r pushResponse
    if [ "$pushResponse" = "y" ]; then
      git push origin
    fi
  fi
fi
echo "Run tests? [y/n]"
read -r testResponse
if [ "$testResponse" = "y" ]; then
  flutter test
else
  exit 0
fi