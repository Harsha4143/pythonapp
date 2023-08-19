# Stage 1: Build the application
FROM python:3.8 AS builder
WORKDIR /src
COPY . /src
RUN pip install flask
RUN pip install flask_restful

# Stage 2: Create the final image
FROM python:3.8-slim
COPY --from=builder /src /src
WORKDIR /src
EXPOSE 3333
ENTRYPOINT ["python"]
CMD ["./src/helloworld.py"]
