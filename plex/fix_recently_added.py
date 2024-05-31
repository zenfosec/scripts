from plexapi.server import PlexServer
from datetime import datetime

PLEX_SERVER_URL = 'http://localhost:32400'
PLEX_SERVER_TOKEN = 'INSERT_YOUR_PLEX_SERVER_TOKEN_HERE'

# Connect to the Plex server
plex = PlexServer(PLEX_SERVER_URL, PLEX_SERVER_TOKEN)

# Get the 'Movies' library
movies_library = plex.library.section('Movies')

# Get all movies in the library
movies = movies_library.all()

# Define the epoch time thresholds
THRESHOLD_EPOCH = 1716666757  # Saturday, May 25, 2024 7:52:37 PM GMT
NEW_EPOCH = 1617425329  # Saturday, April 3, 2021 4:48:49 AM GMT

# Update the addedAt timestamp for each movie
for movie in movies:
    current_added_at = movie.addedAt.timestamp()
    if current_added_at > THRESHOLD_EPOCH:
        new_added_at = datetime.fromtimestamp(NEW_EPOCH)
        movie.editAddedAt(new_added_at)

print("'addedAt' timestamps have been updated for movies added after the threshold date.")