
# CIRCLE_BRANCH=random
# CIRCLE_BUILD_NUM=1123

case $CIRCLE_BRANCH in
	master) 
		BN=${CIRCLE_BUILD_NUM}d 
		XCCONFIG_NAME=Dev
		;;
	beta)
		BN=${CIRCLE_BUILD_NUM}d 
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
