from plexapi.server import PlexServer
import os
from datetime import datetime

# Replace with your Plex server URL and token
PLEX_SERVER_URL = 'http://localhost:32400'
PLEX_SERVER_TOKEN = 'INSERT_YOUR_PLEX_SERVER_TOKEN_HERE'

# Connect to the Plex server
plex = PlexServer(PLEX_SERVER_URL, PLEX_SERVER_TOKEN)

# Get the 'Movies' library
movies_library = plex.library.section('Movies')

# Get all movies in the library
movies = movies_library.all()

# Update the addedAt timestamp for each movie
for movie in movies:
    file_path = movie.locations[0]
    file_mod_time = os.path.getmtime(file_path)
    new_added_at = datetime.fromtimestamp(file_mod_time)
    movie.editAddedAt(new_added_at)

print("'addedAt' timestamps have been updated based on file modification times.")