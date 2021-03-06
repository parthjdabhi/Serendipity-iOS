set -e
set -o pipefail

CRASHLYTICS_BETA_TEAM=team
CRASHLYTICS_BETA_NOTIFICATIONS=NO
case $CIRCLE_BRANCH in
	master)
		BN=${CIRCLE_BUILD_NUM}d
		XCCONFIG_NAME=Dev
		;;
	beta)
		BN=${CIRCLE_BUILD_NUM}b
		XCCONFIG_NAME=Beta
		CRASHLYTICS_BETA_TEAM=private-beta-1
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
export CRASHLYTICS_BETA_TEAM=$CRASHLYTICS_BETA_TEAM
export CRASHLYTICS_BETA_NOTIFICATIONS=$CRASHLYTICS_BETA_NOTIFICATIONS
