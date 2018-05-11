import shutil 
import os
import sys

sdkVersion = 'YumiMediationSDK_v'+ sys.argv[1]
thirdPartys = ['AdColony','AdMob','Applovin','Baidu','Centrixlink','Chartboost','Domob','Facebook','GDT','InMobi','IronSource','Mobvista','StartApp','Unity','Vungle','OneWay','TouTiao']
podDir = './Pods/'
mediationSDKPath = podDir + sdkVersion
thirdPartyPathName = mediationSDKPath +'/YumiMediationThirdPartys'
debugcenterPathName = mediationSDKPath +'/YumiMediationDebugCenter-iOS'
yumiMediationSDKPathName = mediationSDKPath +'/YumiMediationSDK'

# adapter
def archiveAdapter(adapterName):
	thirdYumiSDKName = 'Yumi' + adapterName
	thirdYumiMediationAdapterName = 'YumiMediation' + adapterName
	#copy adapters
	srcAdapterPath = podDir + 'YumiMediationAdapters' + '/'+ thirdYumiMediationAdapterName
	targetAdapterPath = thirdPartyPathName + '/'+ thirdYumiMediationAdapterName
	srcThirdSDKPath = podDir + thirdYumiSDKName
	targetThirdSDkPath = thirdPartyPathName + '/'+ thirdYumiMediationAdapterName + '/' +thirdYumiSDKName

	shutil.copytree(srcAdapterPath,targetAdapterPath,symlinks=True)
	shutil.copytree(srcThirdSDKPath,targetThirdSDkPath,symlinks=True)
	shutil.make_archive(targetAdapterPath,'bztar',targetAdapterPath)
	shutil.rmtree(targetAdapterPath)

# zip 会变大 ，gztar 和bztar差不多  tar体积没有变化
def archiveThirdAdapters():
	for thirdParty in thirdPartys:
		print('is copying %s' % thirdParty)
		archiveAdapter(thirdParty)

	if os.path.exists(thirdPartyPathName):
		print('is archived Adapters')
		shutil.make_archive(thirdPartyPathName,'bztar',thirdPartyPathName)
		shutil.rmtree(thirdPartyPathName)

# debugcenter 
def  archiveDebugcenter():
	#copy debugcenter
	print('is copying debugcenter')
	srcDebugcenterPath = podDir + 'YumiMediationDebugCenter-iOS'

	shutil.copytree(srcDebugcenterPath,debugcenterPathName,symlinks = True)
	if os.path.exists(debugcenterPathName):
		print('is archived debugcenter')
		shutil.make_archive(debugcenterPathName,'bztar',debugcenterPathName)
		shutil.rmtree(debugcenterPathName)

def  archiveYumiMediationSDK():
	#copy YumiMediationSDK
	print('is copying YumiMediationSDK')
	srcYumiMediationSDKPath = podDir + 'YumiMediationSDK'
	shutil.copytree(srcYumiMediationSDKPath,yumiMediationSDKPathName,symlinks = True)
	if os.path.exists(yumiMediationSDKPathName):
		print('is archived YumiMediationSDK')
		shutil.make_archive(yumiMediationSDKPathName,'bztar',yumiMediationSDKPathName)
		shutil.rmtree(yumiMediationSDKPathName)

def  archiveReleaseSDK():
	if os.path.exists(mediationSDKPath):
		shutil.rmtree(mediationSDKPath)
	archiveThirdAdapters()
	archiveDebugcenter()
	archiveYumiMediationSDK()
	#copy xcconfig
	podPath = os.path.dirname(podDir)
	xcconfigPath = os.path.dirname(podPath) + "/YumiMediationSDKConfig.xcconfig"
	if os.path.exists(xcconfigPath):	
		print('is copying YumiMediationSDKConfig.xcconfig')
		shutil.copy(xcconfigPath,mediationSDKPath)

	shutil.make_archive(mediationSDKPath,'bztar',mediationSDKPath)
	print("archive yumi mediation sdk successed")

# release archive yumi mediation sdk
archiveReleaseSDK()
