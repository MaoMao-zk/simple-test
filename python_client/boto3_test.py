import boto3

s3 = boto3.resource('s3', 
  endpoint_url='http://172.17.0.1:9000', 
#   config=boto3.session.Config(signature_version='s3v4'),
  aws_access_key_id='admin',
  aws_secret_access_key='123456789'
)

# asasd
s3.meta.client.upload_file('./boto3_test.py', 'test', 'boto3_test.py')

for bucket in s3.buckets.all():
    print("bucket.name -> " + bucket.name)
    for obj in bucket.objects.all():
        print(obj.key)
        # s3.meta.client.download_file('mybucket', 'hello.txt', '/tmp/hello.txt')
        s3.meta.client.download_file('test', obj.key, '/mnt/host/tmp/' + obj.key)