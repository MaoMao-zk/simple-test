# S3
## Amazon S3
    https://docs.aws.amazon.com/s3/index.html
## Boto3 - The AWS SDK for Python
* [Install & config](https://boto3.amazonaws.com/v1/documentation/api/latest/guide/quickstart.html)
* [S3 example](https://boto3.amazonaws.com/v1/documentation/api/latest/guide/s3-examples.html)
* API ref：https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/s3.html
## minio S3 Docker server
* https://hub.docker.com/r/bitnami/minio
* https://github.com/bitnami/bitnami-docker-minio
* Usage:
    * 启动：`docker run -d --name minio-server bitnami/minio:latest`
        * Data必须挂载在/data：`--volume /path/to/minio-persistence:/data`
        * Cert必须挂载在/certs: `--volume /path/to/certs:/certs`
    * 管理：`docker exec minio mc admin info local`（默认TARGET为local）