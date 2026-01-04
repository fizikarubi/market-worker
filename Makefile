.PHONY: build test docker-build docker-run ecs-run install-hooks

AWS_REGION := us-east-1
ECS_CONTAINER_NAME := market-worker

install-hooks:
	cp .github/hooks/pre-push .git/hooks/pre-push
	chmod +x .git/hooks/pre-push

run-create:
	@env $$(grep -v '^#' .env.local | xargs) cargo run -- create btcusd

build:
	cargo build --release

test:
	cargo test

docker-build:
	docker build -t market-worker .

docker-run-create:
	docker run --env-file .env.local market-worker create btcusd

ECS_STG_CLUSTER := stg-roman-api-cluster
ECS_STG_TASK_DEF := stg-market-worker
# ECS_STG_SUBNET := subnet-0602ccdda8990aa6b # default subnet
ECS_STG_SUBNET := subnet-0f0f5a281049d7610
ECS_STG_SG := sg-0b8eb59b694b14293  # default sg 
CMD := ["create","btcusd"]

ecs-run-stg:
	aws ecs run-task \
		--cluster $(ECS_STG_CLUSTER) \
		--task-definition $(ECS_STG_TASK_DEF) \
		--launch-type FARGATE \
		--network-configuration "awsvpcConfiguration={subnets=[$(ECS_STG_SUBNET)],securityGroups=[$(ECS_STG_SG)],assignPublicIp=ENABLED}" \
		--overrides '{"containerOverrides":[{"name":"$(ECS_CONTAINER_NAME)","command":$(CMD)}]}' \
		--region $(AWS_REGION)
