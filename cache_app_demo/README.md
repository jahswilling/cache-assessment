# Cache App Demo

A Django application that provides health check and message endpoints, publishing messages to Google Cloud Pub/Sub.

## Features

- Health check endpoint (`/api/health/`)
- Message publishing and retrieval endpoints
- Containerized with Docker
- Automated deployment to Google Cloud Artifact Registry via GitHub Actions
- Load balanced deployment on GKE

## Production Access

The application is accessible via the load balancer:
- **URL**: http://34.169.247.6/

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

### Message Endpoints

#### Publish Message
- **URL**: `/api/messages/`
- **Method**: `POST`
- **Request Body**:
  ```json
  {
    "message": "Your message content"
  }
  ```
- **Response**: JSON with message ID and status

#### Get Messages
- **URL**: `/api/messages/`
- **Method**: `GET`
- **Response**: JSON array of published messages

#### Get Message by ID
- **URL**: `/api/messages/<message_id>/`
- **Method**: `GET`
- **Response**: JSON with message details

## GitHub Actions

The repository includes a GitHub Actions workflow that automatically builds and pushes the Docker image to Google Cloud Artifact Registry on pushes to the main branch.

Required secrets:
- `GCP_SA_KEY`: Google Cloud service account key
- `GCP_PROJECT_ID`: Google Cloud project ID
- `GCP_ARTIFACT_REGISTRY`: Artifact Registry repository name

## Testing the API

You can test the API using curl or any HTTP client:

1. Health Check:
```bash
curl http://34.169.247.6/api/health/
```

2. Publish a Message:
```bash
curl -X POST http://34.169.247.6/api/messages/ \
  -H "Content-Type: application/json" \
  -d '{"message": "Hello, World!"}'
```

3. Get All Messages:
```bash
curl http://34.169.247.6/api/messages/
```

4. Get Specific Message:
```bash
curl http://34.169.247.6/api/messages/<message_id>/
```

