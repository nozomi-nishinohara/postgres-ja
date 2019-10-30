TAG=$1

if [ "${TAG}" = "" ]; then
    echo "TAGを指定して下さい。"
    exit 1
fi

docker build -t nozominishinohara/postgres-ja:${TAG} -f ${TAG}/Dockerfile ${TAG}
docker push nozominishinohara/postgres-ja:${TAG}