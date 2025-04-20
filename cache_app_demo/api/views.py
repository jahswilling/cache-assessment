from rest_framework.decorators import api_view
from rest_framework.response import Response
from datetime import datetime
from .models import HealthCheck
from .pubsub_utils import publish_message, subscribe_messages
import json

@api_view(['GET'])
def health_check(request):
    """Health check endpoint that writes to Pub/Sub and PostgreSQL."""
    # Create timestamp
    timestamp = datetime.now().isoformat()
    
    # Create health check message
    message = {
        'service': 'cache_app_demo',
        'status': 'healthy',
        'timestamp': timestamp,
        'message': 'Service is running properly'
    }
    
    # Write to PostgreSQL
    health_record = HealthCheck.objects.create(
        status='healthy',
        message=f"Health check at {timestamp}"
    )
    
    # Write to Pub/Sub
    try:
        message_id = publish_message(message)
        message['pubsub_message_id'] = message_id
        print(f"✅ Successfully published message with ID: {message_id}")
    except Exception as e:
        message['pubsub_error'] = str(e)
    
    return Response(message)

@api_view(['GET'])
def get_messages(request):
    """Endpoint to retrieve recent Pub/Sub messages."""
    try:
        max_messages = int(request.query_params.get('limit', 10))
        messages = subscribe_messages(max_messages=max_messages)
        
        if not messages:
            return Response({
                'status': 'success',
                'message': 'No messages found in the subscription',
                'message_count': 0,
                'messages': []
            })
            
        return Response({
            'status': 'success',
            'message_count': len(messages),
            'messages': messages
        })
    except Exception as e:
        try:
            # Try to parse the error details if they're in JSON format
            error_details = json.loads(str(e))
        except json.JSONDecodeError:
            # If not JSON, use the raw error message
            error_details = {'error': str(e)}
        
        error_message = error_details.get('error', '')
        if "not found" in error_message.lower():
            return Response({
                'status': 'error',
                'message': 'Pub/Sub subscription not found. Please check if the subscription exists and is properly configured.',
                'details': error_details
            }, status=404)
        elif "permission" in error_message.lower():
            return Response({
                'status': 'error',
                'message': 'Permission denied. Please check your Pub/Sub credentials and permissions.',
                'details': error_details
            }, status=403)
        else:
            return Response({
                'status': 'error',
                'message': 'Failed to retrieve messages from Pub/Sub.',
                'details': error_details
            }, status=500)