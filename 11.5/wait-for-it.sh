CHECK_HOST=${MASTER_HOST:-''}
CHECK_PORT=${MASTER_PORT:-0}
WAITTIME=${WAITTIME:-10}
WAITCNT=${z:-5}

wait_for()
{
    cnt=0
    while [ $WAITCNT -gt $cnt ]
    do
        echo "$CHECK_HOST"
        echo "$CHECK_PORT"
        nc -z $CHECK_HOST $CHECK_PORT
        WAITFORIT_result=$?
        if [ $WAITFORIT_result -eq 0 ]; then
            break
        fi
        echo "wait"
        sleep $WAITTIME
        cnt=$((cnt + 1))
    done
    return $WAITFORIT_result
}

for OPT in "$@"
do
    case $OPT in
        -h)
            if [ $CHECK_HOST = '' ]; then
                CHECK_HOST="$2"
            fi
        ;;
        -p)
            if [ $CHECK_PORT -eq 0 ]; then
                CHECK_PORT=$2
            fi
        ;;
        -wt)
            WAITTIME=$2
        ;;
        -wc)
            WAITCNT=$2
        ;;
        --)
            shift
            WAITFORIT_CLI=("$@")
    esac
    shift
done
wait_for
exec "${WAITFORIT_CLI[@]}"