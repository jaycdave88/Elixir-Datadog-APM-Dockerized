#!/bin/sh
# Running a Phoenix 1.3 project with docker-compose

set -e


# Ensure the app's dependencies are installed
mix deps.get

# # Prepare Dialyzer if the project has Dialyxer set up
# if mix help dialyzer >/dev/null 2>&1
# then
#   echo "\nFound Dialyxer: Setting up PLT..."
#   mix do deps.compile, dialyzer --plt
# else
#   echo "\nNo Dialyxer config: Skipping setup..."
# fi

# Install JS libraries
echo "\nInstalling JS..."
cd assets && npm install
cd ..

# Wait for Postgres to become available.
# until psql -h db -U "postgres" -c 'ueberauth_example_dev' 2>/dev/null; do
#   >&2 echo "Postgres is unavailable - sleeping"
#   sleep 1
# done

echo "\nPostgres is available: continuing with database setup..."

# Potentially Set up the database
mix ecto.create
# mix ecto.migrate

# echo "\nTesting the installation..."
# # "Prove" that install was successful by running the tests
# mix test

echo "\n Launching Phoenix web server..."
# Start the phoenix web server
mix phx.server