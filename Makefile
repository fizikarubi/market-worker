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
ECS_STG_SUBNET := subnet-c6a0e4a0
ECS_STG_SG := sg-f0e8acf6
CMD := ["create","btcusd"]

ecs-run-stg:
	aws ecs run-task \
		--cluster $(ECS_STG_CLUSTER) \
		--task-definition $(ECS_STG_TASK_DEF) \
		--launch-type FARGATE \
		--network-configuration "awsvpcConfiguration={subnets=[$(ECS_STG_SUBNET)],securityGroups=[$(ECS_STG_SG)],assignPublicIp=ENABLED}" \
		--overrides '{"containerOverrides":[{"name":"$(ECS_CONTAINER_NAME)","command":$(CMD)}]}' \
		--region $(AWS_REGION)

