# generate:
# 	@protoc -I proto proto/runner/*.proto --go_out=./gen/golang --go_opt=paths=source_relative --go-grpc_out=./gen/golang --go-grpc_opt=paths=source_relative

LOCAL_BIN:=$(CURDIR)/bin

install-deps:
	GOBIN=$(LOCAL_BIN) go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.28.1
	GOBIN=$(LOCAL_BIN) go install -mod=mod google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.2
	GOBIN=$(LOCAL_BIN) go install github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-grpc-gateway@v2.15.2


generate:
	@protoc --proto-path proto/runner --proto-path vendor.protogen \
	--go_out=./gen/golang --go_opt=paths=source_relative \
	--plugin=protoc-gen-go=bin/protoc-gen-go \
	--go-grpc_out=./gen/golang --go-grpc_opt=paths=source_relative \
	--plugin=protoc-gen-go-grpc=bin/protoc-gen-go-grpc \
	--grpc-gateway_out=./gen/golang --grpc-gateway_opt=paths=source_relative \
	--plugin=protoc-gen-grpc-gateway=bin/protoc-gen-grpc-gateway \
	proto/runner/runner.go


# protto:
# 	@protoc -I proto proto/runner/runner.proto \
# 		--go_out=./gen/golang \
# 		--go_opt=paths=source_relative \
# 		--go-grpc_out=./gen/golang \
# 		--go-grpc_opt=paths=source_relative \
# 		--grpc-gateway_out=./gen/golang \
# 		--grpc-gateway_opt=paths=source_relative

vendor-proto:
		@if [ ! -d vendor.protogen/google ]; then \
			git clone https://github.com/googleapis/googleapis vendor.protogen/googleapis &&\
			mkdir -p  vendor.protogen/google/ &&\
			mv vendor.protogen/googleapis/google/api vendor.protogen/google &&\
			rm -rf vendor.protogen/googleapis ;\
		fi
