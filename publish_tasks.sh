# MAINTAINER ONLY SCRIPT. DO NOT RUN THIS SCRIPT UNLESS YOU ARE THE MAINTAINER.
pana --no-warning
echo "Are you ready to dry-run publish macos_ui? [y/n]"
read dryRunResponse
if [ "$dryRunResponse" = "y" ]; then
  flutter pub publish --dry-run
else
  exit 0
fi
echo "Are you ready to publish macos_ui to pub.dev? [y/n]"
read publishResponse
if [ "$publishResponse" = "y" ]; then
  flutter pub publish
else
  exit 0
fi