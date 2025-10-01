if [ ! -d ".build" ]; then
  mkdir .build
fi

sudo chown -R $(whoami):$(id -gn) .build
chmod -R u+w .build
