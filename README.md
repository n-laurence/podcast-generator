# Podcast Generator

Podcast Generator is a GitHub Action that turns a podcast configuration file into an RSS 2.0 podcast feed. It reads a YAML definition, generates an XML feed containing your episodes, and commits the result back to your repository.

This is useful for maintaining a podcast feed in source control without manually creating XML by hand.

## Features

- Reads a `feed.yaml` file from the repository root
- Generates a valid RSS podcast feed as `podcast.xml`
- Supports common podcast metadata such as title, subtitle, author, description, category, language, and image
- Includes episode details like title, published date, duration, and audio file URL
- Works as a GitHub Action and commits the generated feed automatically

## How it works

The action runs a small Python script that parses `feed.yaml` and writes an RSS document using the standard XML library. The resulting file is saved as `podcast.xml` and committed to the repository.

## Repository layout

- `feed.py` – script that reads `feed.yaml` and writes `podcast.xml`
- `entrypoint.sh` – GitHub Action entrypoint that configures git and runs the generator
- `action.yaml` – action metadata and inputs
- `Dockerfile` – Ubuntu-based container that installs Python and YAML support

## Usage

Add a workflow like the following to your repository:

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

This action expects the repository to contain a `feed.yaml` file and will generate a `podcast.xml` feed as part of the workflow.

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
- enclosure metadata for the audio file URL and file size

## Notes

- `link` is used as the base URL for image and media URLs.
- The script assumes media files are available at the paths referenced in `feed.yaml`.
- The generated feed should be served from a public URL if you want it to be consumed by podcast apps.

## License

This project is licensed under the MIT License. See the `LICENSE` file for details.
