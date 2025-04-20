# Cache App Demo

A Django application that provides a health check endpoint and publishes messages to Google Cloud Pub/Sub.

## Features

- Simple health check endpoint (`/api/health/`)
- Pub/Sub message publishing
- Containerized with Docker
- Automated deployment to Google Cloud Artifact Registry via GitHub Actions

## Prerequisites

- Python 3.11+
- Docker
- Google Cloud Platform account
- Pub/Sub topic and project ID

## Environment Variables

Create a `.env` file in the root directory with the following variables:

```env
DEBUG=True
SECRET_KEY=your-secret-key-here
PUBSUB_PROJECT_ID=your-project-id
PUBSUB_TOPIC_ID=cache-app-topic
```

## Local Development

1. Create and activate a virtual environment:
```bash
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
```

2. Install dependencies:
```bash
pip install -r requirements.txt
```

3. Run migrations:
```bash
python manage.py migrate
```

4. Start the development server:
```bash
python manage.py runserver
```

## Docker

Build the Docker image:
```bash
docker build -t cache-app-demo .
```

Run the container:
```bash
docker run -p 8000:8000 --env-file .env cache-app-demo
```

## API Endpoints

### Health Check
- **URL**: `/api/health/`
- **Method**: `GET`
- **Response**: JSON with service status and Pub/Sub message ID

## GitHub Actions

The repository includes a GitHub Actions workflow that automatically builds and pushes the Docker image to Google Cloud Artifact Registry on pushes to the main branch.

Required secrets:
- `GCP_SA_KEY`: Google Cloud service account key
- `GCP_PROJECT_ID`: Google Cloud project ID
- `GCP_ARTIFACT_REGISTRY`: Artifact Registry repository name

