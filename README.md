# Containerized VyOS image

## VyOS rolling release image

This is a containerized VyOS rolling release image.

### Building

```
docker build -t sysoleg/vyos-container:latest .
```

### Running

```
docker run -d --name vyos --privileged -v /lib/modules:/lib/modules sysoleg/vyos-container:latest
```

### Logging in
```
docker exec -it vyos su vyos
```
