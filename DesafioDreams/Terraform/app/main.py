import boto3
from datetime import datetime
import os

def handler(event, context):
    """
    Esta função é acionada pelo EventBridge e cria um arquivo em um bucket S3.
    """
  
    bucket_name = os.environ['TARGET_BUCKET_NAME']
    
    
    now = datetime.now()
    filename = f"execucao-{now.strftime('%Y-%m-%d_%H-%M-%S')}.txt"
    
  
    file_content = f"Tarefa executada com sucesso em: {now.isoformat()}"
    
    
    s3_client = boto3.client('s3')
    
    try:
       
        s3_client.put_object(
            Bucket=bucket_name,
            Key=filename,
            Body=file_content
        )
        print(f"Sucesso! Arquivo '{filename}' criado no bucket '{bucket_name}'.")
        return {
            'statusCode': 200,
            'body': "Arquivo criado com sucesso."
        }
    except Exception as e:
        print(f"Erro ao criar arquivo: {e}")
        raise e