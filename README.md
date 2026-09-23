# Podcast Generator

Podcast Generator is a GitHub Action that transforms a podcast configuration file into an RSS 2.0 feed for podcast apps and directories. It reads a YAML definition, generates the XML feed for your episodes, and commits the result back to your repository.

This project is designed for teams and creators who want to maintain a podcast feed in version control without hand-writing RSS XML.

## Features

- Reads a `feed.yaml` file from the repository root
- Produces a valid podcast RSS feed as `podcast.xml`
- Supports standard metadata including title, subtitle, author, description, category, language, and artwork
- Includes episode details such as title, publish date, duration, and audio file metadata
- Runs as a GitHub Action and automatically commits the generated feed

## How it works

The action executes a small Python script that parses `feed.yaml` and generates an RSS document using Python’s standard XML library. The resulting file is written to `podcast.xml` and committed to the repository.

## Repository layout

- `feed.py` — reads `feed.yaml` and generates the RSS feed
- `entrypoint.sh` — configures git and runs the generator in the action container
- `action.yaml` — GitHub Action metadata and input definitions
- `Dockerfile` — installs the dependencies required to run the generator

## Usage

Add a workflow similar to the following to your repository:

```yaml
name: Update podcast feed

on:
  push:
    paths:
      - 'feed.yaml'
      - 'episodes/**'

jobs:
  podcast:
    runs-on: ubuntu-latest
    permissions:
      contents: write

    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Generate podcast feed
        uses: n-laurence/podcast-generator@main
        with:
          email: ci@example.com
          name: Podcast Bot
```

The action expects a `feed.yaml` file in the repository root and will generate a `podcast.xml` feed as part of the workflow.

## Example `feed.yaml`

```yaml
link: "https://example.com"
title: "My Podcast"
format: "audio"
subtitle: "A weekly show about software and culture"
author: "Jane Doe"
description: "A podcast covering ideas, tools, and interviews."
image: "/images/podcast-cover.jpg"
language: "en-us"
category: "Technology"
item:
  - title: "Episode 001"
    description: "Welcome to the show."
    duration: "00:12:34"
    published: "Mon, 03 Jun 2024 09:00:00 GMT"
    file: "/audio/episode-001.mp3"
    length: "761234"
  - title: "Episode 002"
    description: "A deeper look at the tools we use every day."
    duration: "00:18:45"
    published: "Mon, 10 Jun 2024 09:00:00 GMT"
    file: "/audio/episode-002.mp3"
    length: "1124567"
```

## Generated output

The action writes an RSS document named `podcast.xml` that includes:

- channel metadata
- podcast artwork
- category and language information
- one `<item>` entry per episode
- enclosure metadata for the audio URL and file size

## Notes

- `link` is used as the base URL for image and media resources.
- The script assumes the audio files referenced in `feed.yaml` are available at those paths.
- The generated feed should be publicly accessible if you want it to be consumed by podcast apps and directories.

## License

This project is licensed under the MIT License. See the `LICENSE` file for details.
