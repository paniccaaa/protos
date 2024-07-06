# generate:
# 	@protoc -I proto proto/runner/*.proto --go_out=./gen/golang --go_opt=paths=source_relative --go-grpc_out=./gen/golang --go-grpc_opt=paths=source_relative

LOCAL_BIN:=$(CURDIR)/bin
PROTO_DIR=proto
OUT_DIR=gen/golang

install-deps:
	GOBIN=$(LOCAL_BIN) go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.28.1
	GOBIN=$(LOCAL_BIN) go install -mod=mod google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.2
	GOBIN=$(LOCAL_BIN) go install github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-grpc-gateway@v2.15.2

get-deps:
	go get -u google.golang.org/protobuf/cmd/protoc-gen-go
	go get -u google.golang.org/grpc/cmd/protoc-gen-go-grpc
	go get -u github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-grpc-gateway

# generate:
# 	@protoc --proto_path proto/runner --proto_path vendor.protogen \
# 	--go_out=./gen/golang --go_opt=paths=source_relative \
# 	--plugin=protoc-gen-go=bin/protoc-gen-go \
# 	--go-grpc_out=./gen/golang --go-grpc_opt=paths=source_relative \
# 	--plugin=protoc-gen-go-grpc=bin/protoc-gen-go-grpc \
# 	--grpc-gateway_out=./gen/golang --grpc-gateway_opt=paths=source_relative \
# 	--plugin=protoc-gen-grpc-gateway=bin/protoc-gen-grpc-gateway \
# 	proto/runner/*.proto

generate:
	@protoc -I $(PROTO_DIR) \
		--proto_path $(PROTO_DIR)/runner \
		--proto_path vendor.protogen \
		--go_out=$(OUT_DIR) --go_opt=paths=source_relative \
		--plugin=protoc-gen-go=bin/protoc-gen-go \
		--go-grpc_out=$(OUT_DIR) --go-grpc_opt=paths=source_relative \
		--plugin=protoc-gen-go-grpc=bin/protoc-gen-go-grpc \
		--grpc-gateway_out=$(OUT_DIR) --grpc-gateway_opt=paths=source_relative \
		--plugin=protoc-gen-grpc-gateway=bin/protoc-gen-grpc-gateway \
		$(PROTO_DIR)/runner/*.proto

	# Перемещаем файлы в поддиректорию runner
	@mkdir -p $(OUT_DIR)/runner
	@mv $(OUT_DIR)/*.pb.go $(OUT_DIR)/runner/

vendor-proto:
		@if [ ! -d vendor.protogen/google ]; then \
			git clone https://github.com/googleapis/googleapis vendor.protogen/googleapis &&\
			mkdir -p  vendor.protogen/google/ &&\
			mv vendor.protogen/googleapis/google/api vendor.protogen/google &&\
			rm -rf vendor.protogen/googleapis ;\
		fi
