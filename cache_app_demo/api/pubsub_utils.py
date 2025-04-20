from google.cloud import pubsub_v1
import json
import os
import logging
import traceback
from concurrent.futures import TimeoutError
from django.conf import settings

logger = logging.getLogger(__name__)

def publish_message(message_data):
    """Publish a message to the specified Pub/Sub topic."""
    publisher = pubsub_v1.PublisherClient()
    topic_path = publisher.topic_path(settings.PUBSUB_PROJECT_ID, settings.PUBSUB_TOPIC_ID)
    
    # Encode the message as JSON
    message_json = json.dumps(message_data).encode('utf-8')
    
    # Publish the message
    future = publisher.publish(topic_path, data=message_json)
    message_id = future.result()
    
    return message_id

def subscribe_messages(max_messages=10):
    """Subscribe to messages from the specified Pub/Sub subscription."""
    try:
        logger.info(f"Attempting to subscribe to Pub/Sub with project_id: {settings.PUBSUB_PROJECT_ID}, subscription_id: {settings.PUBSUB_SUBSCRIPTION_ID}")
        
        subscriber = pubsub_v1.SubscriberClient()
        subscription_path = subscriber.subscription_path(
            settings.PUBSUB_PROJECT_ID, 
            settings.PUBSUB_SUBSCRIPTION_ID
        )
        
        logger.info(f"Subscription path: {subscription_path}")
        
        messages = []
        
        def callback(message):
            try:
                logger.debug(f"Received message with ID: {message.message_id}")
                message_data = json.loads(message.data.decode('utf-8'))
                messages.append({
                    'data': message_data,
                    'message_id': message.message_id,
                    'publish_time': message.publish_time.isoformat()
                })
                message.ack()
                logger.debug(f"Successfully processed message: {message.message_id}")
            except Exception as e:
                logger.error(f"Error processing message: {str(e)}\n{traceback.format_exc()}")
                message.nack()
        
        streaming_pull_future = subscriber.subscribe(subscription_path, callback=callback)
        logger.info("Successfully created subscription")
        
        try:
            # Wait for messages for a short time
            streaming_pull_future.result(timeout=5)
            logger.info(f"Retrieved {len(messages)} messages")
        except TimeoutError:
            logger.info("No messages received within timeout period")
            # Don't raise an error for timeout, just return empty list
        except Exception as e:
            logger.error(f"Error during subscription: {str(e)}\n{traceback.format_exc()}")
            streaming_pull_future.cancel()
            raise
        finally:
            streaming_pull_future.cancel()
            logger.info("Subscription cancelled")
        
        return messages[:max_messages]
    except Exception as e:
        error_details = {
            'error': str(e),
            'traceback': traceback.format_exc(),
            'project_id': settings.PUBSUB_PROJECT_ID,
            'subscription_id': settings.PUBSUB_SUBSCRIPTION_ID
        }
        logger.error(f"Pub/Sub subscription error: {json.dumps(error_details)}")
        raise Exception(json.dumps(error_details))