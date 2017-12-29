import shutil 
import os
import sys


sdkVersion = 'YumiMediationSDK_v'+ sys.argv[1]
thirdPartys = ['PlayableAds','AdColony','AdMob','Applovin','Baidu','Centrixlink','ChartBoost','Domob','Facebook','GDT','InMobi','IronSource','Mobvista','StartApp','Unity','Vungle']

for thirdParty in thirdPartys:
	print('is moving %s' % thirdParty)
	if thirdParty == 'PlayableAds':
		shutil.move("./Pods/%s/" % thirdParty, "./Pods/YumiMediationAdapters/YumiMediationPlayableAds/")
		shutil.make_archive('./Pods/YumiMediationAdapters/YumiMediationPlayableAds','zip','./Pods/YumiMediationAdapters/YumiMediationPlayableAds')
		shutil.rmtree('./Pods/YumiMediationAdapters/YumiMediationPlayableAds')
		continue
	thirdAdapter = 'YumiMediation' + thirdParty
	thirdParty = 'Yumi' + thirdParty
	shutil.move("./Pods/%s/" % thirdParty, "./Pods/YumiMediationAdapters/%s/" % thirdAdapter)
	shutil.make_archive("./Pods/YumiMediationAdapters/%s/" % thirdAdapter,'zip',"./Pods/YumiMediationAdapters/%s/" % thirdAdapter)
	shutil.rmtree('./Pods/YumiMediationAdapters/%s/' % thirdAdapter)

os.mkdir('./Pods/%s' % sdkVersion)
os.rename('./Pods/YumiMediationAdapters', './Pods/YumiMediationThirdPartys')

shutil.make_archive('./Pods/YumiMediationThirdPartys', 'zip','./Pods/YumiMediationThirdPartys')
shutil.rmtree('./Pods/YumiMediationThirdPartys')
shutil.move('./Pods/YumiMediationThirdPartys.zip', './Pods/%s' % sdkVersion)

shutil.move('./Pods/YumiMediationDebugCenter-iOS/YumiMediationDebugCenter-iOS.framework', './Pods/YumiMediationSDK/YumiMediationDebugCenter-iOS.framework')
shutil.make_archive('./Pods/YumiMediationSDK', 'zip','./Pods/YumiMediationSDK')
shutil.rmtree('./Pods/YumiMediationSDK')
shutil.rmtree('./Pods/YumiMediationDebugCenter-iOS')
shutil.move('./Pods/YumiMediationSDK.zip', './Pods/%s' % sdkVersion)

shutil.copy('./YumiMediationSDKConfig.xcconfig', './Pods/%s' % sdkVersion)

shutil.make_archive('./Pods/%s' % sdkVersion, 'zip','./Pods/%s' % sdkVersion)
shutil.rmtree('./Pods/%s' % sdkVersion)

