import os
import sys
import django

# Add the project root directory to the Python path
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

# Set up Django environment
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'cache_app_demo.settings')
django.setup()

from api.pubsub_utils import publish_message

def test_publish_message():
    """Test publishing a message to Pub/Sub."""
    try:
        # Test message data
        test_data = {
            "test": "Hello, Pub/Sub!",
            "timestamp": "2024-04-20T12:00:00Z"
        }
        
        # Publish the message
        message_id = publish_message(test_data)
        
        print(f"✅ Successfully published message with ID: {message_id}")
        return True
    except Exception as e:
        print(f"❌ Error publishing message: {str(e)}")
        return False

if __name__ == "__main__":
    test_publish_message() 