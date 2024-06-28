generate:
	@protoc -I proto proto/sso/*.proto --go_out=./gen/golang --go_opt=paths=source_relative --go-grpc_out=./gen/golang --go-grpc_opt=paths=source_relative
