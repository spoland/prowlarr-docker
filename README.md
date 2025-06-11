# Prowlarr Docker

A simple Docker setup for running [Prowlarr](https://prowlarr.com/), an indexer manager/proxy for various media download clients.

## Project Structure

```
prowlarr-docker/
├── Dockerfile
├── .dockerignore
└── README.md
```

## Prerequisites

- [Docker](https://docs.docker.com/get-docker/) installed on your system.

## Building the Docker Image

1. Clone or download this repository and navigate to the project directory:

   ```bash
   cd prowlarr-docker
   ```

2. Build the Docker image:

   ```bash
   docker build -t prowlarr-docker .
   ```

## Running the Docker Container

To start a Prowlarr container:

```bash
docker run -d \
  --name prowlarr \
  -p 9696:9696 \
  prowlarr-docker
```

The web UI will be available at: [http://localhost:9696](http://localhost:9696).

If you're running Docker on a remote server, replace localhost with the IP address of your Docker host machine.

### Optional: Persisting Data

To persist Prowlarr data, mount a local directory as a volume:

```bash
docker run -d \
  --name prowlarr \
  -p 9696:9696 \
  -v /path/to/prowlarr/data:/config \
  prowlarr-docker
```

Replace `/path/to/prowlarr/data` with your preferred local directory.

## Updating

To update Prowlarr, rebuild the image and recreate the container.

## License

This project is provided as-is and is not affiliated with the Prowlarr project.