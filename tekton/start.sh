# 1. 기존 PipelineRun 삭제
kubectl delete pipelinerun spring-boot-ci-run-001 -n demo-app

# 2. 수정된 Docker Task 재배포
kubectl apply -f tekton/task-docker-build.yaml

# 3. 새 PipelineRun 실행
kubectl apply -f tekton/pipelinerun.yaml

# 4. 상태 확인
tkn pipelinerun logs spring-boot-ci-run-001 -f -n demo-app