# AutoHotkey-LoRMatchHistory

AHK script for creating a GUI to show the player's match history listed with "date", "opponent name", "game outcome", and "deckcode used by opponent" metadata.
This enables the player to quickly assess recent perfomance and import deck codes to learn how to optimize performance against certain deck types.

This script is using the official Riot API endpoints as follows:
----------------------------------------------------------------
- LOR-MATCH-V1 - to fetch the last 20 games of the player based on puuid input and to analyze game details pulled, including the following fields:
  - game_start_time_utc, game_outcome, opponent puuid, opponent deck_code
- ACCOUNT-V1 - to pull opponent's details by using opponent puuid in order to list the gamename , including the following fields:
  - gameName
  
The script then parses and lists this data into human-readable format via AHK GUI, where the user can copy the opponent deckcode into the clipboard with a click of a button and import it in-game.
  
