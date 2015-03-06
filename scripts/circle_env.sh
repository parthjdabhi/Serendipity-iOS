set -e
set -o pipefail

case $CIRCLE_BRANCH in
	master)
		BN=${CIRCLE_BUILD_NUM}d
		XCCONFIG_NAME=Dev
		;;
	beta)
		BN=${CIRCLE_BUILD_NUM}b
		XCCONFIG_NAME=Beta
		;;
	prod)
		BN=${CIRCLE_BUILD_NUM}
		XCCONFIG_NAME=Prod
		;;
	*)
		BN=${CIRCLE_BUILD_NUM}\*
		XCCONFIG_NAME=Dev
		;;
esac

export BN=$BN
export XCCONFIG_NAME=$XCCONFIG_NAME