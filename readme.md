#build docker image
docker build --platform=linux/arm64 -t <image-name>:<version>-arm64 .

#run container
docker run -d -p 5000:5000 --name python-app python:v1-arm6


docker build --platform=linux/amd64 -t <image-name>:<version>-amd64 .