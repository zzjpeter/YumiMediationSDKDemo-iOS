import shutil 

thirdPartys = ['PlayableAds','AdColony','AdMob','Applovin','Baidu','Centrixlink','ChartBoost','Domob','Facebook','GDT','InMobi','IronSource','Mobvista','StartApp','Unity','Vungle']

for thirdParty in thirdPartys:
	print('is moving %s' % thirdParty)
	if thirdParty == 'PlayableAds':
		shutil.move("./Pods/%s/" % thirdParty, "./Pods/YumiMediationAdapters/YumiMediationPlayableAds/")
		continue
	thirdAdapter = 'YumiMediation' + thirdParty
	thirdParty = 'Yumi' + thirdParty
	shutil.move("./Pods/%s/" % thirdParty, "./Pods/YumiMediationAdapters/%s/" % thirdAdapter)
