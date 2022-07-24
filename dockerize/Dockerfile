# Build Stage
# First pull Golang image
FROM golang:1.17-alpine 
ENV GO111MODULE=on
#GOPATH MUST BE OUTSIDE OF GOROOT directory!!!
ENV GOPATH=/app
ENV PATH=$PATH:$GOPATH
ENV GOROOT=/usr/local/go
ENV PATH=$PATH:$GOROOT/bin
# Set environment variable
# Copy application data into image

WORKDIR /app/app.com
COPY ./app.com .
# RUN go mod download
# Budild application
RUN CGO_ENABLED=0 go build webserver.go 

# Expose application port
EXPOSE 8080
 
# Start app
CMD ./server
