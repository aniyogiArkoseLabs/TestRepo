#!/bin/sh
#This Script is to create XCFramework from existing framework

#clear
#Deleting the outputDirectory if it is found at location
CURR_DIR='../../ALSDK-iOS-Private'
OUTPUT_DIR='../output'
PROD_DIR='../output/publishing'
DEV_DIR='../output/development'
OPTION=0
if [ -d "$OUTPUT_DIR" ]; then
    rm -rf $OUTPUT_DIR
    echo "Existing Output directory: $OUTPUT_DIR deleted"
fi

#Making the output Directory
mkdir $OUTPUT_DIR
echo "$OUTPUT_DIR created"


while getopts ":p" opt; do
  case $opt in
    p)
      OPTION=1
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done

if [ $OPTION -eq 1 ]; then
#Create prod and dev folder
mkdir $PROD_DIR $DEV_DIR

#Create dev build

#Create archive for simulator
xcodebuild archive  -project ArkoseLabsKit.xcodeproj \
	-scheme ArkoseLabsKit \
	-destination "generic/platform=iOS Simulator" \
	-archivePath "${DEV_DIR}/ALSDK-Sim" \
	SKIP_INSTALL=NO \
	BUILD_LIBRARY_FOR_DISTRIBUTION=YES
#clear

exit 0;

#Create archive for iOS Device
xcodebuild archive  -project ArkoseLabsKit.xcodeproj \
	-scheme ArkoseLabsKit \
	-destination "generic/platform=iOS" \
	-archivePath "${DEV_DIR}/ALSDK-iOS" \
	SKIP_INSTALL=NO \
	BUILD_LIBRARY_FOR_DISTRIBUTION=YES
#clear
#Change path to dev folder
cd $DEV_DIR

#Create xcframework from archive
xcodebuild -create-xcframework \
	-framework ./ALSDK-iOS.xcarchive/Products/Library/Frameworks/ArkoseLabsKit.framework \
	-framework ./ALSDK-Sim.xcarchive/Products/Library/Frameworks/ArkoseLabsKit.framework \
	-output ./AL-SDK.xcframework

#Clean up the archives
rm -r ./ALSDK-iOS.xcarchive
rm -r ./ALSDK-Sim.xcarchive
cd $CURR_DIR
#Create prod build

#Create archive for iOS Device
xcodebuild archive  -project ArkoseLabsKit.xcodeproj \
	-scheme ArkoseLabsKit \
	-destination "generic/platform=iOS" \
	-archivePath "${PROD_DIR}/ALSDK-iOS" \
	SKIP_INSTALL=NO \
	BUILD_LIBRARY_FOR_DISTRIBUTION=YES
#clear
#Change path to dev folder
cd $PROD_DIR

#Create xcframework from archive
xcodebuild -create-xcframework \
	-framework ./ALSDK-iOS.xcarchive/Products/Library/Frameworks/ArkoseLabsKit.framework \
	-output ./AL-SDK.xcframework

#Clean up the archives
rm -r ./ALSDK-iOS.xcarchive
cd $CURR_DIR
else
#Create archive for simulator
xcodebuild archive  -project ArkoseLabsKit.xcodeproj \
	-scheme ArkoseLabsKit \
	-destination "generic/platform=iOS Simulator" \
	-archivePath ../output/ALSDK-Sim \
	SKIP_INSTALL=NO \
	BUILD_LIBRARY_FOR_DISTRIBUTION=YES
#clear

#Create archive for iOS Device
xcodebuild archive  -project ArkoseLabsKit.xcodeproj \
	-scheme ArkoseLabsKit \
	-destination "generic/platform=iOS" \
	-archivePath ../output/ALSDK-iOS \
	SKIP_INSTALL=NO \
	BUILD_LIBRARY_FOR_DISTRIBUTION=YES
#clear
#Change path to output folder
cd $OUTPUT_DIR

#Create xcframework from archive
xcodebuild -create-xcframework \
	-framework ./ALSDK-iOS.xcarchive/Products/Library/Frameworks/ArkoseLabsKit.framework \
	-framework ./ALSDK-Sim.xcarchive/Products/Library/Frameworks/ArkoseLabsKit.framework \
	-output ./AL-SDK.xcframework


#Clean up the archives
rm -r ./ALSDK-iOS.xcarchive
rm -r ./ALSDK-Sim.xcarchive
fi
