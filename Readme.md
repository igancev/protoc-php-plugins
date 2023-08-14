# protoc-php-plugins

Docker image with compiled binary protoc, grpc_php_plugin and downloaded protoc-gen-php-grpc
(plugin by Roadrunner project)

Image based on `php:8.2-cli-alpine3.18`, and contains:

- `protoc`
- `/usr/bin/protoc-gen-php-grpc` - plugin by [Roadrunner](https://roadrunner.dev/docs/plugins-grpc/current/en) project
- `/usr/bin/grpc_php_plugin` - official plugin, compiled from sources

## Usage

You can find usage examples in my article [https://igancev.ru/2023-08-14-grpc-server-on-symfony](https://igancev.ru/2023-08-14-grpc-server-on-symfony) 

Use `/usr/bin/protoc-gen-php-grpc`:

```shell
docker run -u $(id -u):$(id -g) -v `pwd`:/app \
  ghcr.io/igancev/protoc-php-plugins:latest protoc \
  --plugin=protoc-gen-grpc=/usr/bin/grpc_php_plugin \
  --php_out=./generated \
  --grpc_out=./generated \
  ./proto/shortener.proto
```

Or use `/usr/bin/grpc_php_plugin`:

```shell
docker run -u $(id -u):$(id -g) -v `pwd`:/app \
  ghcr.io/igancev/protoc-php-plugins:latest protoc \
  --plugin=protoc-gen-grpc=/usr/bin/grpc_php_plugin \
  --php_out=./generated \
  --grpc_out=./generated \
  ./proto/shortener.proto
```
