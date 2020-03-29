import json
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)


def lambda_handler(event, context):
    data = json.dumps({
        'message_id': event['Records'][0]['messageId'],
        'message_body': event['Records'][0]['body']

    })
    logger.info(data)

    return {
        'statusCode': 200,
        'body': data
    }
