/************************************************************************************************************************************************
// Another Animation Helper v0.994b
// This script was made by Shagg_E, 2017-2026
************************************************************************************************************************************************/

global NewBH_Number = 1000
global NewHI_Number = 0
--global NewHIE_Number = 0
global NewAO_Number = 0
global NewAOParent_Number = 0
global NewBiped_Number = 1000
global NewSM_Number = 0
global AAHHelperLayer
global AAHControllerLayer
global SE_AAH_Process_Rollout
callbacks.removeScripts id:#se_aah_processinfo
global SE_AAH_Rig_Tuner_Rollout
callbacks.removeScripts id:#se_aah_rigtuner
global SE_AAH_Anim_Adapt_Rollout
callbacks.removeScripts id:#se_aah_aahaaupdate

--callbacks.removeScripts id:#se_aah_boneidsupdate
global SE_AAH_AutoSubIDSetToolEnabled = false
global SE_AAH_ManualSubIDSetToolEnabled = false
global SE_AAH_DrawSubIDsTrigger = false
global SE_AAH_DrawSubIDType = 1
unRegisterRedrawViewsCallback SE_AAH_ShowSubIDsInViewport

global SE_AAH_ProcessUpdateFreezeTrigger = false

try (DestroyDialog AutoSubIDSetTool) catch()
try (DestroyDialog ManualSubIDSetTool) catch()
try (DestroyDialog AboutDialog) catch()

global ACAnimRangeStartKeyframe = undefined
global ACAnimRangeEndKeyframe = undefined

struct HierarchyAnalyseInfo (hierAA, subAA, hierKams, subKams, hierSeggaeman, subSeggaeman, hieraap, subaap)
struct HierarchyFinalBoneCalc (hFBoneLevel, hFCurrentBone)
struct AdaptedHierarchyInfo (adaptedMeshes, adaptedBones)

struct CharacterHierarchy (spinelinks, leglinks, taillinks, fingersnumber, fingerlinks, toesnumber, toelinks, headid)

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

fn SE_AAH_UpdateOrCreateAAHHelperLayer =
(
	--local layerName = "AAH Temp Helpers Layer"
	AAHHelperLayer = LayerManager.getLayerFromName "!AAH Temp Helpers Layer"--layerName
	--AAHHelperLayer.nodes &thenodes
	--select thenodes
	if AAHHelperLayer == undefined do
	(
		AAHHelperLayer = LayerManager.newLayer()
		AAHHelperLayer.setname "!AAH Temp Helpers Layer"
		AAHHelperLayer.isHidden = true
	)
)

fn SE_AAH_UpdateOrCreateAAHControllerLayer =
(
	--local layerName = "AAH Temp Helpers Layer"
	AAHControllerLayer = LayerManager.getLayerFromName "!AAH Controllers Layer"--layerName
	--AAHControllerLayer.nodes &thenodes
	--select thenodes
	if AAHControllerLayer == undefined do
	(
		AAHControllerLayer = LayerManager.newLayer()
		AAHControllerLayer.setname "!AAH Controllers Layer"
		AAHControllerLayer.isHidden = false
	)
)

fn SE_AAH_UpdateAnimRangeStartAndEnd sHier animKeysRangeType posKeysTrigger rotKeysTrigger sclKeysTrigger rollKeysTrigger fovKeysTrigger prefAnimRangeStart prefAnimRangeEnd showUpdateTextInfoTrigger =
(
	if showUpdateTextInfoTrigger do
	(
		SE_AAH_Process_Rollout.lbl_PrcssAAH.text = "Updating Anim Range info"
		try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
	)
	local pgbCount = 0
	local pgbCountTotal = selection.count
	ACAnimRangeStartKeyframe = undefined
	ACAnimRangeEndKeyframe = undefined
	for s in sHier do
	(
		if animKeysRangeType == 1 or animKeysRangeType == 3 then
		(
			if posKeysTrigger == true and s.position.controller.keys.count > 0 do
			(
				for i = 1 to s.position.controller.keys.count do
				(
					if animKeysRangeType == 1 or (animKeysRangeType == 3 and isKeySelected s.position.controller i) do
					(
						if ACAnimRangeStartKeyframe != undefined then
						(
							if ACAnimRangeStartKeyframe > s.position.controller.keys[i].time do ACAnimRangeStartKeyframe = s.position.controller.keys[i].time
						)
						else ACAnimRangeStartKeyframe = s.position.controller.keys[i].time
						if ACAnimRangeEndKeyframe != undefined then
						(
							if ACAnimRangeEndKeyframe < s.position.controller.keys[i].time do ACAnimRangeEndKeyframe = s.position.controller.keys[i].time
						)
						else ACAnimRangeEndKeyframe = s.position.controller.keys[i].time
					)
				)
			)
			if rotKeysTrigger == true or rollKeysTrigger == true do
			(
				if s.target != undefined and rollKeysTrigger == true then --ClassOf s == targetcamera or ClassOf s == VRayPhysicalCamera
				(
					if s.controller.roll_angle.controller.keys.count > 0 do
					(
						for i = 1 to s.controller.roll_angle.controller.keys.count do
						(
							if animKeysRangeType == 1 or (animKeysRangeType == 3 and isKeySelected s.controller.roll_angle.controller i) do
							(
								if ACAnimRangeStartKeyframe != undefined then
								(
									if ACAnimRangeStartKeyframe > s.controller.roll_angle.controller.keys[i].time do ACAnimRangeStartKeyframe = s.controller.roll_angle.controller.keys[i].time
								)
								else ACAnimRangeStartKeyframe = s.controller.roll_angle.controller.keys[i].time
								if ACAnimRangeEndKeyframe != undefined then
								(
									if ACAnimRangeEndKeyframe < s.controller.roll_angle.controller.keys[i].time do ACAnimRangeEndKeyframe = s.controller.roll_angle.controller.keys[i].time
								)
								else ACAnimRangeEndKeyframe = s.controller.roll_angle.controller.keys[i].time
							)
						)
					)
				)
				else if rotKeysTrigger == true and s.rotation.controller.keys.count > 0 do
				(
					for i = 1 to s.rotation.controller.keys.count do
					(
						if animKeysRangeType == 1 or (animKeysRangeType == 3 and isKeySelected s.rotation.controller i) do
						(
							if ACAnimRangeStartKeyframe != undefined then
							(
								if ACAnimRangeStartKeyframe > s.rotation.controller.keys[i].time do ACAnimRangeStartKeyframe = s.rotation.controller.keys[i].time
							)
							else ACAnimRangeStartKeyframe = s.rotation.controller.keys[i].time
							if ACAnimRangeEndKeyframe != undefined then
							(
								if ACAnimRangeEndKeyframe < s.rotation.controller.keys[i].time do ACAnimRangeEndKeyframe = s.rotation.controller.keys[i].time
							)
							else ACAnimRangeEndKeyframe = s.rotation.controller.keys[i].time
						)
					)
				)
			)
			if sclKeysTrigger == true and s.scale.controller.keys.count > 0 do
			(
				s.scale.controller = ScaleXYZ()
				for i = 1 to s.scale.controller.keys.count do
				(
					if animKeysRangeType == 1 or (animKeysRangeType == 3 and isKeySelected s.scale.controller i) do
					(
						if ACAnimRangeStartKeyframe != undefined then
						(
							if ACAnimRangeStartKeyframe > s.scale.controller.keys[i].time do ACAnimRangeStartKeyframe = s.scale.controller.keys[i].time
						)
						else ACAnimRangeStartKeyframe = s.scale.controller.keys[i].time
						if ACAnimRangeEndKeyframe != undefined then
						(
							if ACAnimRangeEndKeyframe < s.scale.controller.keys[i].time do ACAnimRangeEndKeyframe = s.scale.controller.keys[i].time
						)
						else ACAnimRangeEndKeyframe = s.scale.controller.keys[i].time
					)
				)
			)
			if fovKeysTrigger == true and (ClassOf s == targetcamera or ClassOf s == VRayPhysicalCamera or ClassOf s == freecamera) do
			(
				if s.FOV.controller.keys.count > 0 do
				(
					for i = 1 to s.FOV.controller.keys.count do
					(
						if animKeysRangeType == 1 or (animKeysRangeType == 3 and isKeySelected s.FOV.controller i) do
						(
							if ACAnimRangeStartKeyframe != undefined then
							(
								if ACAnimRangeStartKeyframe > s.FOV.controller.keys[i].time do ACAnimRangeStartKeyframe = s.FOV.controller.keys[i].time
							)
							else ACAnimRangeStartKeyframe = s.FOV.controller.keys[i].time
							if ACAnimRangeEndKeyframe != undefined then
							(
								if ACAnimRangeEndKeyframe < s.FOV.controller.keys[i].time do ACAnimRangeEndKeyframe = s.FOV.controller.keys[i].time
							)
							else ACAnimRangeEndKeyframe = s.FOV.controller.keys[i].time
						)
					)
				)
			)
		)
		else
		(
			ACAnimRangeStartKeyframe = 1.0f * prefAnimRangeStart
			ACAnimRangeEndKeyframe = 1.0f * prefAnimRangeEnd
		)
		if ACAnimRangeStartKeyframe == undefined or ACAnimRangeEndKeyframe == undefined or ACAnimRangeStartKeyframe > ACAnimRangeEndKeyframe then
		(
			ACAnimRangeStartKeyframe = undefined
			ACAnimRangeEndKeyframe = undefined
			if showUpdateTextInfoTrigger do SE_AAH_Process_Rollout.lbl_PrcssAAH.text = "Anim Range not found"
		)
		else if showUpdateTextInfoTrigger do
		(
			SE_AAH_Process_Rollout.lbl_PrcssAAH.text = "Anim Range found"
		)
		if showUpdateTextInfoTrigger do
		(
			pgbCount = pgbCount + 1
			SE_AAH_Process_Rollout.prgb_AAH.value = 100.*pgbCount/pgbCountTotal
		)
	)
	if showUpdateTextInfoTrigger do
	(
		if ACAnimRangeStartKeyframe != undefined and ACAnimRangeEndKeyframe != undefined do
		(
			SE_AAH_Process_Rollout.lbl_PrcssAAH.text = "Anim Range found"
			formattedPrint ACAnimRangeStartKeyframe
			formattedPrint ACAnimRangeEndKeyframe
			--local info_str_msg = "Anim Range Start: " + (ACAnimRangeStartKeyframe as string) + "\nAnim Range End: " + (ACAnimRangeEndKeyframe as string)
			--messagebox info_str_msg title:"Done!"
		)
		SE_AAH_Process_Rollout.prgb_AAH.value = 0
		try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
	)
)

fn SE_AAH_IncreaseBHNumber =
(
	for obj in objects do
	(
		if getUserProp obj "BHNumber" != undefined then
		(
			local OldBH_Number = getUserProp obj "BHNumber"
			if OldBH_Number > NewBH_Number then NewBH_Number = OldBH_Number
		)
	)
	NewBH_Number = NewBH_Number + 1
)	

fn SE_AAH_IncreaseIKBoneNumber =
(	
	local OldHI_Number = -1
	for obj in objects do
	(
		if getUserProp obj "HIBoneNumber" != undefined then
		(
			OldHI_Number = getUserProp obj "HIBoneNumber"
			if OldHI_Number > NewHI_Number then NewHI_Number = OldHI_Number
			OldHI_Number = -1
		)
		if getUserProp obj "HICBoneNumber" != undefined then
		(
			OldHI_Number = getUserProp obj "HICBoneNumber"
			if OldHI_Number > NewHI_Number then NewHI_Number = OldHI_Number
			OldHI_Number = -1
		)
		/*if getUserProp obj "HIGCBoneNumber" != undefined then
		(
			OldHI_Number = getUserProp obj "HIGCBoneNumber"
			if OldHI_Number > NewHI_Number then NewHI_Number = OldHI_Number
			OldHI_Number = -1
		)*/
		if getUserProp obj "HIHelperNumber" != undefined then
		(
			OldHI_Number = getUserProp obj "HIHelperNumber"
			if OldHI_Number > NewHI_Number then NewHI_Number = OldHI_Number
			OldHI_Number = -1
		)
		if getUserProp obj "HICHelperNumber" != undefined then
		(
			OldHI_Number = getUserProp obj "HICHelperNumber"
			if OldHI_Number > NewHI_Number then NewHI_Number = OldHI_Number
			OldHI_Number = -1
		)
		if getUserProp obj "HIGCHelperNumber" != undefined then
		(
			OldHI_Number = getUserProp obj "HIGCHelperNumber"
			if OldHI_Number > NewHI_Number then NewHI_Number = OldHI_Number
			OldHI_Number = -1
		)
	)
	NewHI_Number = NewHI_Number + 1
)

/*
fn SE_AAH_IncreaseHIEyesNumber =
(	
	for obj in objects do
	(
		if getUserProp obj "HIEyesNumber" != undefined then
		(
			local OldHIE_Number = getUserProp obj "HIEyesNumber"
			if OldHIE_Number > NewHIE_Number then NewHIE_Number = OldHIE_Number
		)
	)
	NewHIE_Number = NewHIE_Number + 1
)*/

fn SE_AAH_IncreaseAONumber =
(	
	local OldAO_Number = -1
	for obj in objects do
	(
		if getUserProp obj "AOControllerNumber" != undefined then
		(
			OldAO_Number = getUserProp obj "AOControllerNumber"
			if OldAO_Number > NewAO_Number then NewAO_Number = OldAO_Number
			OldAO_Number = -1
		)
		if getUserProp obj "AOHelperNumber" != undefined then
		(
			OldAO_Number = getUserProp obj "AOHelperNumber"
			if OldAO_Number > NewAO_Number then NewAO_Number = OldAO_Number
			OldAO_Number = -1
		)
		if getUserProp obj "AObjectNumber" != undefined then
		(
			OldAO_Number = getUserProp obj "AObjectNumber"
			if OldAO_Number > NewAO_Number then NewAO_Number = OldAO_Number
			OldAO_Number = -1
		)
	)
	NewAO_Number = NewAO_Number + 1
)

fn SE_AAH_IncreaseAOParentNumber =
(	
	local OldAOParent_Number = -1
	for obj in objects do
	(
		if getUserProp obj "AOParentPNumber" != undefined then
		(
			OldAOParent_Number = getUserProp obj "AOParentPNumber"
			if OldAOParent_Number > NewAOParent_Number then NewAOParent_Number = OldAOParent_Number
			OldAOParent_Number = -1
		)
		if getUserProp obj "AOParentCNumber" != undefined then
		(
			OldAOParent_Number = getUserProp obj "AOParentCNumber"
			if OldAOParent_Number > NewAOParent_Number then NewAOParent_Number = OldAOParent_Number
			OldAOParent_Number = -1
		)
	)
	NewAOParent_Number = NewAOParent_Number + 1
)

fn SE_AAH_IncreaseBipedNumber =
(
	for obj in objects do
	(
		if getUserProp obj "BipedNumber" != undefined then
		(
			local OldBiped_Number = getUserProp obj "BipedNumber"
			if OldBiped_Number > NewBiped_Number then NewBiped_Number = OldBiped_Number
		)
	)
	NewBiped_Number = NewBiped_Number + 1
)

fn SE_AAH_IncreaseSkinMeshNumber =
(
	for obj in objects do
	(
		if getUserProp obj "SkinMeshNumber" != undefined then
		(
			local OldSM_Number = getUserProp obj "SkinMeshNumber"
			if OldSM_Number > NewSM_Number then NewSM_Number = OldSM_Number
		)
	)
	NewSM_Number = NewSM_Number + 1
)

fn SE_AAH_GetAndOffAnimKeys =
(
	local aKStateG = 0
	if animButtonState == true do aKStateG = aKStateG + 1
	if maxOps.setKeyMode == true do aKStateG = aKStateG + 2
	animButtonState = false
	maxOps.setKeyMode = false
	return aKStateG
)

fn SE_AAH_SetOffAnimKeys =
(
	animButtonState = false
	maxOps.setKeyMode = false
)

fn SE_AAH_SetBackAnimKeys aKStateS =
(
	animButtonState = false
	maxOps.setKeyMode = false
	if aKStateS > 1 do
	(
		maxOps.setKeyMode = true
		aKStateS = aKStateS - 2		
	)
	if aKStateS > 0 do
	(
		animButtonState = true
		--aKStateS = aKStateS - 1		-- just because I can
	)
)

fn SE_AAH_GetRoot obj =
(
	if obj.parent != undefined then
	(
		SE_AAH_GetRoot obj.parent
	)
	else
	(
		return obj
	)	
)

fn SE_AAH_AppendAllChildren obj aH = --&aH:#() =
(
	if obj.children.count > 0 do
	(
		for child in obj.children do
		(
			append aH child
			SE_AAH_AppendAllChildren child aH --:aH
		)
	)
)

fn SE_AAH_GetAllHierarchy obj exceptRoot =
(
	local aH = #()
	local rootObj = SE_AAH_GetRoot obj
	if rootObj != undefined do 
	(
		if exceptRoot == 0 do append aH rootObj
		SE_AAH_AppendAllChildren rootObj aH --:aH
	)
	return aH
)

fn SE_AAH_GetSortedHierarchy objHier =
(
	local aSH = #()
	local allHier = SE_AAH_GetAllHierarchy objHier[1] 0
	for allHierBone in allHier do
	(
		for objHierBone in objHier do
		(
			if objHierBone == allHierBone do append aSH allHierBone
		)
	)
	return aSH
)

fn SE_AAH_GetSelectionRoot objRHier =
(
	local greatestBoneIndex
	local currentBoneIndex
	local selRootBone
	for objRHierBone in objRHier do
	(
		currentBoneIndex = getUserProp objRHierBone "BoneIndex"
		if greatestBoneIndex == undefined or greatestBoneIndex > currentBoneIndex do
		(
			greatestBoneIndex = currentBoneIndex
			selRootBone = objRHierBone
		)
	)
	if selRootBone != undefined then return selRootBone
	else return objRHier[1]
)

fn SE_AAH_GetChildrenHierarchy objHier exceptRoot =
(
	local acH = #()
	local selRootObj
	if objHier.count > 1 then	selRootObj = SE_AAH_GetSelectionRoot objHier
	else selRootObj = objHier[1]
	if exceptRoot != 1 do append acH selRootObj
	SE_AAH_AppendAllChildren selRootObj acH
	return acH
)

fn SE_AAH_FindDeeperChildren gCurFB gCurFBTemp = --&aH:#() =
(
	if gCurFBTemp.hFCurrentBone.children.count > 0 do
	(
		gCurFBTemp.hFBoneLevel = gCurFBTemp.hFBoneLevel + 1
		for child in gCurFBTemp.hFCurrentBone.children do
		(
			gCurFBTemp.hFCurrentBone = child
			gCurFBTemp = SE_AAH_FindDeeperChildren gCurFB gCurFBTemp
		)
		if gCurFBTemp.hFBoneLevel > gCurFB.hFBoneLevel do
		(
			gCurFB.hFCurrentBone = gCurFBTemp.hFCurrentBone
			gCurFB.hFBoneLevel = gCurFBTemp.hFBoneLevel
		)
	)
	return gCurFBTemp
)

fn SE_AAH_GetFinalBone objBone =
(
	local hCurrentFBoneLevel = 0
	local hCurrentFBone = objBone
	--local hCurrentFBoneLevelTemp = 0
	--local hCurrentFBoneTemp = objBone
	
	local gFB = HierarchyFinalBoneCalc hCurrentFBoneLevel hCurrentFBone
	local gFBTemp = HierarchyFinalBoneCalc hCurrentFBoneLevel hCurrentFBone
	--HierarchyFinalBoneCalc (hFBoneLevel, hFCurrentBone)
	gFBTemp = SE_AAH_FindDeeperChildren gFB gFBTemp --hCurrentFBoneLevel hCurrentFBone hCurrentFBoneLevelTemp hCurrentFBoneTemp
	return gFB.hFCurrentBone
)

fn SE_AAH_GetSubID subIDType gSINode =
(
	local nodeSubID = -1
	if subIDType == 0 then -- in this case, we trying to get any type of this ID parameter, in special order (SubID > BoneID > BoneId > tag)
	(
		if getUserProp gSINode "SubID" != undefined or getUserProp gSINode "BoneID" != undefined or getUserProp gSINode "BoneId" != undefined or getUserProp gSINode "tag" != undefined do
		(
			if getUserProp gSINode "SubID" != undefined then nodeSubID = getUserProp gSINode "SubID" -- AA scripts
			else if getUserProp gSINode "BoneID" != undefined then nodeSubID = getUserProp gSINode "BoneID" -- Kam's scripts
			else if getUserProp gSINode "BoneId" != undefined then nodeSubID = getUserProp gSINode "BoneId" -- Seggaeman's DFF plugin
			else if getUserProp gSINode "tag" != undefined do nodeSubID = getUserProp gSINode "tag" -- The Hero/aap's DFF plugin
		)
	)
	else -- in this case, we only get the selected type of ID parameter
	(
		if subIDType == 1 and getUserProp gSINode "SubID" != undefined then nodeSubID = getUserProp gSINode "SubID" -- AA scripts
		else if subIDType == 2 and getUserProp gSINode "BoneID" != undefined then nodeSubID = getUserProp gSINode "BoneID" -- Kam's scripts
		else if subIDType == 3 and getUserProp gSINode "BoneId" != undefined then nodeSubID = getUserProp gSINode "BoneId" -- Seggaeman's DFF plugin
		else if subIDType == 4 and getUserProp gSINode "tag" != undefined do nodeSubID = getUserProp gSINode "tag" -- The Hero/aap's DFF plugin
	)
	return nodeSubID
)

fn SE_AAH_CheckAndFindFreeSubID sH startID =
(
	local finalID = startID
	local freeBoneIDTrigger = true
	for nrtbnHierNode in sH while freeBoneIDTrigger == true do
	(
		if finalID == (SE_AAH_GetSubID 0 nrtbnHierNode) do
		(
			freeBoneIDTrigger = false
		)
	)
	if freeBoneIDTrigger == false do
	(
		freeBoneIDTrigger = true
		do -- trying to predict optimal SubID value depending on the free SubIDs in the hierarchy
		(
			freeBoneIDTrigger = true
			for nrtbnHierNode in sH while freeBoneIDTrigger == true do
			(
				if finalID == (SE_AAH_GetSubID 0 nrtbnHierNode) do
				(
					finalID = finalID + 1
					freeBoneIDTrigger = false
				)
			)
		)
		while freeBoneIDTrigger == false
	)
	return finalID
)

fn SE_AAH_ResetBonesIndexes sHierNow =
(
	for s in sHierNow do setUserProp s "BoneIndex" -1
)

fn SE_AAH_CheckBonesIndexesnTypes sHierNow =
(
	local indexesExists = true
	local indexesCheck = true
	local typesCheck = true
	local resultCheck = 0
	local newBoneIndex = 0
	for s in sHierNow do
	(
		if getUserProp s "BoneIndex" != undefined then
		(
			if getUserProp s "BoneIndex" != newBoneIndex do indexesCheck = false
			--setUserProp s "BoneIndex" newBoneIndex
		)
		else
		(
			indexesExists = false
			indexesCheck = false
		)
		newBoneIndex = newBoneIndex + 1
	)
	local a = #()
	local childrenLevel = 0
	local previousBoneIndex = 0
	if indexesExists == true then
	(
		for s in sHierNow do
		(
			if getUserProp s "BoneType" == undefined do typesCheck = false
		)
		if typesCheck == true do
		(
			for s in sHierNow do
			(
				local p = s.parent
				if p == undefined then
				(
					if getUserProp s "BoneType" != 0 do typesCheck = false --// is the last or only child, has children
					--setUserProp s "BoneType" "0" --// is the last or only child, has children
				)
				else
				(
					if getUserProp p "BoneIndex" == previousBoneIndex then
					(
						childrenLevel = childrenLevel + 1
						a[childrenLevel*3+1] = 0
						a[childrenLevel*3+3] = getUserProp p "BoneIndex"
					)
					else
					(
						while getUserProp p "BoneIndex" != a[childrenLevel*3+3] do
						(
							childrenLevel = childrenLevel - 1
						)
					)
					a[childrenLevel*3+1] = a[childrenLevel*3+1] + 1
					a[childrenLevel*3+2] = getUserProp p "BoneIndex"
					if a[childrenLevel*3+1] == p.children.count then
					(
						if s.children.count == 0 then
						(
							if getUserProp s "BoneType" != 1 do typesCheck = false --// is the last or only child, hasn't children
							--setUserProp s "BoneType" "1" --// is the last or only child, hasn't children
						)
						else
						(
							if getUserProp s "BoneType" != 0 do typesCheck = false --// is the last or only child, has children
							--setUserProp s "BoneType" "0" --// is the last or only child, has children
						)
					)
					else
					(
						if s.children.count == 0 then
						(
							if getUserProp s "BoneType" != 3 do typesCheck = false --// not the only and not last child, hasn't children
							--setUserProp s "BoneType" "3" --// not the only and not last child, hasn't children
						)
						else
						(
							if getUserProp s "BoneType" != 2 do typesCheck = false --// not the only and not last child, has children
							--setUserProp s "BoneType" "2" --// not the only and not last child, has children
						)
					)
					previousBoneIndex = getUserProp s "BoneIndex"
				)
			)
		)
	)
	else typesCheck = false
	if indexesCheck == true do resultCheck = resultCheck + 1
	if typesCheck == true do resultCheck = resultCheck + 10
	return resultCheck
)

fn SE_AAH_SetBonesIndexesnTypes sHierNow =
(
	local newBoneIndex = 0
	for s in sHierNow do
	(
		setUserProp s "BoneIndex" newBoneIndex
		newBoneIndex = newBoneIndex + 1
	)
	local a = #()
	local childrenLevel = 0
	local previousBoneIndex = 0
	for s in sHierNow do
	(
		local p = s.parent
		if p == undefined then
		(
			setUserProp s "BoneType" "0" --// is the last or only child, has children
		)
		else
		(
			if getUserProp p "BoneIndex" == previousBoneIndex then
			(
				childrenLevel = childrenLevel + 1
				a[childrenLevel*3+1] = 0
				a[childrenLevel*3+3] = getUserProp p "BoneIndex"
			)
			else
			(
				while getUserProp p "BoneIndex" != a[childrenLevel*3+3] do
				(
					childrenLevel = childrenLevel - 1
				)
			)
			a[childrenLevel*3+1] = a[childrenLevel*3+1] + 1
			a[childrenLevel*3+2] = getUserProp p "BoneIndex"
			if a[childrenLevel*3+1] == p.children.count then
			(
				if s.children.count == 0 then
				(
					setUserProp s "BoneType" "1" --// is the last or only child, hasn't children
				)
				else
				(
					setUserProp s "BoneType" "0" --// is the last or only child, has children
				)
			)
			else
			(
				if s.children.count == 0 then
				(
					setUserProp s "BoneType" "3" --// not the only and not last child, hasn't children
				)
				else
				(
					setUserProp s "BoneType" "2" --// not the only and not last child, has children
				)
			)
			previousBoneIndex = getUserProp s "BoneIndex"
		)
	)
)

fn SE_AAH_CheckSubIDParams sH subIDName =
(
	local totalSubIDParams = 0
	for sHBone in sH do
	(
		if getUserProp sHBone subIDName != undefined do totalSubIDParams = totalSubIDParams + 1
	)
	return totalSubIDParams
)

fn SE_AAH_CheckUniqueSubIDParams sH subIDName =
(
	local totalUniqueSubIDParams = 0
	for sHBone in sH do
	(
		if getUserProp sHBone subIDName != undefined do
		(
			local sHBoneSubID = getUserProp sHBone subIDName
			local sHBoneSubIDIsUnique = true
			for sHBone2 in sH while sHBoneSubIDIsUnique == true do
			(
				if getUserProp sHBone2 subIDName != undefined do
				(
					local sHBone2SubID = getUserProp sHBone2 subIDName
					if sHBone != sHBone2 and sHBoneSubID == sHBone2SubID do sHBoneSubIDIsUnique = false
				)
			)
			if sHBoneSubIDIsUnique == true do totalUniqueSubIDParams = totalUniqueSubIDParams + 1
		)
	)
	return totalUniqueSubIDParams
)

fn SE_AAH_CheckIfSubIDIsCorrect sH subIDName =
(
	local checkResult = false
	local boneIDsCount = SE_AAH_CheckSubIDParams sH subIDName
	local boneIDsUniqueCount = SE_AAH_CheckUniqueSubIDParams sH subIDName
	if sH.count == boneIDsCount and sH.count == boneIDsUniqueCount do checkResult = true
	return checkResult
)

fn SE_AAH_AnalyseHierarchy obj showMessage =
(
	local sHier = SE_AAH_GetAllHierarchy obj 0
	local info_str_msg = "Total bones in hierarchy: " + sHier.count as string
	
	info_str_msg = info_str_msg + "\n\nAA scripts hierarchy:"
	local boneIDsCount = SE_AAH_CheckSubIDParams sHier "SubID"
	info_str_msg = info_str_msg + "\nTotal SubIDs params set: " + boneIDsCount as string
	local boneIDsUniqueCount = SE_AAH_CheckUniqueSubIDParams sHier "SubID"
	info_str_msg = info_str_msg + "\nTotal Unique SubIDs params set: " + boneIDsUniqueCount as string
	local finalSubIDsResult = false
	if sHier.count ==  boneIDsCount and sHier.count == boneIDsUniqueCount do finalSubIDsResult = true
	info_str_msg = info_str_msg + "\nSubID parameters: "
	if finalSubIDsResult == true then info_str_msg = info_str_msg + "CORRECT!"
	else info_str_msg = info_str_msg + "INCORRECT!!!"
	
	info_str_msg = info_str_msg + "\n\nKam's scripts hierarchy:"
	boneIDsCount = SE_AAH_CheckSubIDParams sHier "BoneID"
	info_str_msg = info_str_msg + "\nTotal BoneIDs params set: " + boneIDsCount as string
	boneIDsUniqueCount = SE_AAH_CheckUniqueSubIDParams sHier "BoneID"
	info_str_msg = info_str_msg + "\nTotal Unique BoneIDs params set: " + boneIDsUniqueCount as string
	local finalBoneIDsResult = false
	if sHier.count ==  boneIDsCount and sHier.count == boneIDsUniqueCount do finalBoneIDsResult = true
	info_str_msg = info_str_msg + "\nBoneID parameters: "
	if finalBoneIDsResult == true then info_str_msg = info_str_msg + "CORRECT!"
	else info_str_msg = info_str_msg + "INCORRECT!!!"
	
	local sSPunknown = getUserProp sHier[1] "SPunknown"
	local sSPunknownKamsFinalResult = false
	info_str_msg = info_str_msg + "\n\nSPunknown parameter: "
	if sSPunknown == undefined then info_str_msg = info_str_msg + "UNKNOWN!!!\n(may produce character's export problems)"
	else
	(
		sSPunknownKamsFinalResult = true
		info_str_msg = info_str_msg + sSPunknown as string
		if sSPunknown == 0 then	info_str_msg = info_str_msg + "\n(VC character)"
		else if sSPunknown == 4 or sSPunknown == 3 then info_str_msg = info_str_msg + "\n(SA character)"
		else
		(
			sSPunknownKamsFinalResult = false
			info_str_msg = info_str_msg + "\n(unknown, may, or may not produce character's export problems)"
		)
	)
	
	info_str_msg = info_str_msg + "\n\nSeggaeman's DFF plugin hierarchy:"
	boneIDsCount = SE_AAH_CheckSubIDParams sHier "BoneId"
	info_str_msg = info_str_msg + "\nTotal BoneIds params set: " + boneIDsCount as string
	boneIDsUniqueCount = SE_AAH_CheckUniqueSubIDParams sHier "BoneId"
	info_str_msg = info_str_msg + "\nTotal Unique BoneIds params set: " + boneIDsUniqueCount as string
	local finalBoneIdsSeggaemanResult = false
	if sHier.count ==  boneIDsCount and sHier.count == boneIDsUniqueCount do finalBoneIdsSeggaemanResult = true
	info_str_msg = info_str_msg + "\nBoneId parameters: "
	if finalBoneIdsSeggaemanResult == true then info_str_msg = info_str_msg + "CORRECT!"
	else info_str_msg = info_str_msg + "INCORRECT!!!"
	
	local checkBonesIndexesnTypesResult = SE_AAH_CheckBonesIndexesnTypes sHier
	info_str_msg = info_str_msg + "\n\nBoneIndex parameters: "
	if checkBonesIndexesnTypesResult ==  1 or checkBonesIndexesnTypesResult ==  11 then info_str_msg = info_str_msg + "CORRECT!"
	else info_str_msg = info_str_msg + "INCORRECT!!!" -- (" + checkBonesIndexesnTypesResult as string + ")"
	
	info_str_msg = info_str_msg + "\n\nBoneType parameters: "
	if checkBonesIndexesnTypesResult ==  10 or checkBonesIndexesnTypesResult ==  11 then info_str_msg = info_str_msg + "CORRECT!" --+ checkBonesIndexesnTypesResult as string
	else info_str_msg = info_str_msg + "INCORRECT!!!" -- (" + checkBonesIndexesnTypesResult as string + ")"
	
	info_str_msg = info_str_msg + "\n\nThe Hero/aap's DFF plugin hierarchy:"
	boneIDsCount = SE_AAH_CheckSubIDParams sHier "tag"
	info_str_msg = info_str_msg + "\nTotal tags params set: " + boneIDsCount as string
	boneIDsUniqueCount = SE_AAH_CheckUniqueSubIDParams sHier "tag"
	info_str_msg = info_str_msg + "\nTotal Unique tags params set: " + boneIDsUniqueCount as string
	local finaltagResult = false
	if sHier.count ==  boneIDsCount and sHier.count == boneIDsUniqueCount do finaltagResult = true
	info_str_msg = info_str_msg + "\ntag parameters: "
	if finaltagResult == true then info_str_msg = info_str_msg + "CORRECT!"
	else info_str_msg = info_str_msg + "INCORRECT!!!"
	
	-- also, it's better to check aap's childNum parameters, but I can't test skin export on this plugin: it's not working!
	
	info_str_msg = info_str_msg + "\n\n\nRESULTS:"
	
	local hierAAFinalResult = false
	if finalSubIDsResult == true and checkBonesIndexesnTypesResult == 11 do hierAAFinalResult = true
	info_str_msg = info_str_msg + "\n\nAA scripts hierarchy: "
	if hierAAFinalResult == true then info_str_msg = info_str_msg + "CORRECT!"
	else info_str_msg = info_str_msg + "INCORRECT!!!"
	
	local hierKamsFinalResult = false
	if finalBoneIDsResult == true and checkBonesIndexesnTypesResult == 11 and sSPunknownKamsFinalResult == true do hierKamsFinalResult = true
	info_str_msg = info_str_msg + "\n\nKam's scripts hierarchy: "
	if hierKamsFinalResult == true then info_str_msg = info_str_msg + "CORRECT!"
	else info_str_msg = info_str_msg + "INCORRECT!!!"
	
	local hierSeggaemansFinalResult = false
	if finalBoneIdsSeggaemanResult == true and checkBonesIndexesnTypesResult == 11 do hierSeggaemansFinalResult = true
	info_str_msg = info_str_msg + "\n\nSeggaeman's DFF plugin hierarchy: "
	if hierSeggaemansFinalResult == true then info_str_msg = info_str_msg + "CORRECT!"
	else info_str_msg = info_str_msg + "INCORRECT!!!"
	
	local hieraapsFinalResult = false
	if finaltagResult == true do hieraapsFinalResult = true
	info_str_msg = info_str_msg + "\n\nThe Hero/aap's DFF plugin hierarchy: "
	if hieraapsFinalResult == true then info_str_msg = info_str_msg + "CORRECT!"
	else info_str_msg = info_str_msg + "INCORRECT!!!"
	
	if hierAAFinalResult == true and hierKamsFinalResult == true and hierSeggaemansFinalResult == true and hieraapsFinalResult == true then info_str_msg = info_str_msg + "\n\n\nYour character's hierarchy is just FINE!\n\n\nHave fun!!!"
	else
	(
		info_str_msg = info_str_msg + "\n\n\nTIPS:"
		if checkBonesIndexesnTypesResult != 11 then info_str_msg = info_str_msg + "\n\nRecalculate Bone Indexes and Types with the relevant Calculation tool, to prepare it for Kam's scripts and Seggaeman's DFF plugin export process."
		else info_str_msg = info_str_msg + "\n\nBone Indexes and Types are just FINE for Kam's scripts and Seggaeman's DFF plugin, and ready for character's export."
		if sSPunknownKamsFinalResult == true then
		(
			info_str_msg = info_str_msg + "\n\nSPunknown parameter is just FINE for Kam's scripts and ready for "
			if sSPunknown == 0 then	info_str_msg = info_str_msg + "VC character's export."
			else if sSPunknown == 4 or sSPunknown == 3 then info_str_msg = info_str_msg + "SA character's export."
		)
		else info_str_msg = info_str_msg + "\n\nSPunknown parameter is UNKNOWN and may produce character's export problems in Kam's scripts.\nUse Bone Indexes and Types' Calculation tool to set it automatically, or set it to the Root bone's Properties manually."
		if finalSubIDsResult == true and finalBoneIDsResult == true and finalBoneIdsSeggaemanResult == true and finaltagResult == true then info_str_msg = info_str_msg + "\n\nSubID/BoneID/BoneId/Tag parameters are just FINE and ready for character's export."
		else
		(
			if finalSubIDsResult == false and finalBoneIDsResult == false and finalBoneIdsSeggaemanResult == false and finaltagResult == false then info_str_msg = info_str_msg + "\n\nALL the SubID/BoneID/BoneId/Tag parameters are WRONG, set them manually in the correct way or recalculate them with the relevant Auto.../Calculation tool."
			else
			(
				info_str_msg = info_str_msg + "\n\nSOME SubID/BoneID/BoneId/Tag parameters are WRONG, use the relemant tool to Auto.../Unify them by one of these:"
				if finalSubIDsResult == true do info_str_msg = info_str_msg + "\n- AA's SubID"
				if finalBoneIDsResult == true do info_str_msg = info_str_msg + "\n- Kam's BoneID"
				if finalBoneIdsSeggaemanResult == true do info_str_msg = info_str_msg + "\n- Seggaeman's BoneId"
				if finaltagResult == true do info_str_msg = info_str_msg + "\n- aap's tag"
			)
		)
		info_str_msg = info_str_msg + "\n\n\nYou can do it!!!"
	)
	if showMessage == true do messagebox info_str_msg title:"SubID / BoneID / Tag analyse result:"
	return HierarchyAnalyseInfo hierAAFinalResult finalSubIDsResult hierKamsFinalResult finalBoneIDsResult hierSeggaemansFinalResult finalBoneIdsSeggaemanResult hieraapsFinalResult finaltagResult
)

fn SE_AAH_UnifySubIDParamsFinally subIDType subIDName subIDMain subID1 subID2 subID3 showMessages =
(
	local finalHierAnalyseInfo = SE_AAH_AnalyseHierarchy selection[1] false -- hierAA, subAA, hierKams, subKams, hierSeggaeman, subSeggaeman, hieraap, subaap
	local isEverythingReady = false
	local subIDWereSet = 0
	if subIDType == 1 then
	(
		if finalHierAnalyseInfo.subAA == true do isEverythingReady = true
	)
	else if subIDType == 2 then
	(
		if finalHierAnalyseInfo.subKams == true do isEverythingReady = true
	)
	else if subIDType == 3 then
	(
		if finalHierAnalyseInfo.subSeggaeman == true do isEverythingReady = true
	)
	else if subIDType == 4 do
	(
		if finalHierAnalyseInfo.subaap == true do isEverythingReady = true
	)
	local info_str_msg = subIDName
	if isEverythingReady == false do
	(
		if showMessages == true then
		(
			info_str_msg = subIDName + " parameters are WRONG!\nAre SURE you want to CONTINUE?"
			if (queryBox info_str_msg title:"ATTENTION") do
			(
				isEverythingReady = true
			)
		)
		else isEverythingReady = true
	)
	if isEverythingReady == true then
	(
		local sHier = SE_AAH_GetAllHierarchy selection[1] 0
		for s in sHier do
		(
			local unifyPropSubID = getUserProp s subIDMain
			if unifyPropSubID != undefined do
			(
				setUserProp s subID1 unifyPropSubID
				setUserProp s subID2 unifyPropSubID
				setUserProp s subID3 unifyPropSubID
				subIDWereSet = subIDWereSet + 1
			)
		)
		if showMessages == true do
		(
			info_str_msg = "Unify process is finished!\nTotal bones in hierarchy: " + sHier.count as string + "\nTotal converted bones: " + subIDWereSet as string
			messageBox info_str_msg title:"DONE!"
		)
	)
	else if showMessages == true do messageBox "Canceled!" title:"ERROR"
)

fn SE_AAH_GetBoundingBoxOfHierarchy sHier =
(
	--SE_AAH_UpdateOrCreateAAHHelperLayer()
	local boundingBox = box()
	boundingBox.wirecolor = sHier[1].wirecolor
	boundingBox.name = sHier[1].name + " Hierarchy Bounding Box"
	if ((getVisController boundingBox) == undefined) do
	(
		boundingBox.visibility = bezier_float()
	)
	boundingBox.visibility.controller.value = 0.6
	boundingBox.backfaceCull = true
	local bbMinX = sHier[1].transform.position.x
	local bbMaxX = sHier[1].transform.position.x
	local bbMinY = sHier[1].transform.position.y
	local bbMaxY = sHier[1].transform.position.y
	local bbMinZ = sHier[1].transform.position.z
	local bbMaxZ = sHier[1].transform.position.z
	for bbBone in sHier do
	(
		if bbBone.transform.position.x <  bbMinX do bbMinX = bbBone.transform.position.x
		if bbBone.transform.position.x >  bbMaxX do bbMaxX = bbBone.transform.position.x
		if bbBone.transform.position.y <  bbMinY do bbMinY = bbBone.transform.position.y
		if bbBone.transform.position.y >  bbMaxY do bbMaxY = bbBone.transform.position.y
		if bbBone.transform.position.z <  bbMinZ do bbMinZ = bbBone.transform.position.z
		if bbBone.transform.position.z >  bbMaxZ do bbMaxZ = bbBone.transform.position.z
	)
	boundingBox.width = bbMaxX - bbMinX
	boundingBox.length = bbMaxY - bbMinY
	boundingBox.height = bbMaxZ - bbMinZ
	boundingBox.pivot = boundingBox.center --CenterPivot boundingBox
	boundingBox.position.x = bbMaxX - (bbMaxX - bbMinX)/2
	boundingBox.position.y = bbMaxY - (bbMaxY - bbMinY)/2
	boundingBox.position.z = bbMaxZ - (bbMaxZ - bbMinZ)/2
	--local showBBInfo = (bbMinX as string) + " " + (bbMaxX as string) + "\n" + (bbMinY as string) + " " + (bbMaxY as string) + "\n" + (bbMinZ as string) + " " + (bbMaxZ as string)
	--messageBox showBBInfo
	
	--AAHHelperLayer.addnode boundingBox
	return boundingBox
)

fn SE_AAH_GetAngleBetweenVectors vector1 vector2 =
(
	theAngle = acos(dot (normalize vector1) (normalize vector2))
	return theAngle
)

fn SE_AAH_GetHierarchyFacingVector sHier fullBB =
(
	local realCharRoot
	for sHierBone in sHier do
	(
		if sHierBone.children.count > 2 and realCharRoot == undefined do realCharRoot = sHierBone
	)
	if realCharRoot != undefined then
	(
		format "Real Root is %. Found children bones: %\n" realCharRoot.name realCharRoot.children.count
		
		local realCharThigh
		
		local realRootHelper = point size:0.1
		realRootHelper.name = realCharRoot.name + " RRHelper"
		in coordsys world realRootHelper.transform = in coordsys world realCharRoot.transform
		
		local realRootHChild1= point size:0.1
		realRootHChild1.name = realCharRoot.children[1].name + " RRHelper1"
		in coordsys world realRootHChild1.transform = in coordsys world realCharRoot.children[1].transform
		realRootHChild1.parent = realRootHelper
		if realCharRoot.children[1].children.count > 0 do
		(
			local realRootHChild1Child= point size:0.1
			realRootHChild1Child.name = realCharRoot.children[1].children[1].name + " RRHelper1Child"
			in coordsys world realRootHChild1Child.transform = in coordsys world realCharRoot.children[1].children[1].transform
			realRootHChild1Child.parent = realRootHChild1
		)
		local realRootHChild2= point size:0.1
		realRootHChild2.name = realCharRoot.children[2].name + " RRHelper2"
		in coordsys world realRootHChild2.transform = in coordsys world realCharRoot.children[2].transform
		realRootHChild2.parent = realRootHelper
		if realCharRoot.children[2].children.count > 0 do
		(
			local realRootHChild2Child= point size:0.1
			realRootHChild2Child.name = realCharRoot.children[2].children[1].name + " RRHelper2Child"
			in coordsys world realRootHChild2Child.transform = in coordsys world realCharRoot.children[2].children[1].transform
			realRootHChild2Child.parent = realRootHChild2
		)
		local realRootHChild3= point size:0.1
		realRootHChild3.name = realCharRoot.children[3].name + " RRHelper3"
		in coordsys world realRootHChild3.transform = in coordsys world realCharRoot.children[3].transform
		realRootHChild3.parent = realRootHelper
		if realCharRoot.children[3].children.count > 0 do
		(
			local realRootHChild3Child= point size:0.1
			realRootHChild3Child.name = realCharRoot.children[3].children[1].name + " RRHelper3Child"
			in coordsys world realRootHChild3Child.transform = in coordsys world realCharRoot.children[3].children[1].transform
			realRootHChild3Child.parent = realRootHChild3
		)
		
		
		in coordsys world realRootHelper.position = [0.0,0.0,0.0]
		--in coordsys world realRootHelper.rotation = [0.0,0.0,0.0]
		--in coordsys world realRootHelper.rotation.x_rotation = 0.0
		--in coordsys world realRootHelper.rotation.y_rotation = 0.0
		--in coordsys world realRootHelper.rotation.z_rotation = 0.0
		--realRootHelper.transform = matrix3 1

		realRootHelper.rotation = eulerangles 0 0 0
		
		format "Test Pelvis Hierarchy successfully moved to the zero position and rotation\n"
		
		local rRCH1Length = length (realRootHChild1.position - realRootHelper.position)
		local rRCH2Length = length (realRootHChild2.position - realRootHelper.position)
		local rRCH3Length = length (realRootHChild3.position - realRootHelper.position)
		format "% length: %\n" realRootHChild1.name rRCH1Length
		format "% length: %\n" realRootHChild2.name rRCH2Length
		format "% length: %\n" realRootHChild3.name rRCH3Length
		
		local minLengthDiffAxis = 0 -- smaller diff is between L1 and L2
		local minLengthDiff = sqrt ((rRCH1Length - rRCH2Length)^2)
		local minLengthDiff2 = sqrt ((rRCH1Length - rRCH3Length)^2)
		if minLengthDiff > minLengthDiff2 do
		(
			minLengthDiff = minLengthDiff2
			minLengthDiffAxis = 1 -- smaller diff is between L1 and L3
		)
		minLengthDiff2 = sqrt ((rRCH2Length - rRCH3Length)^2)
		if minLengthDiff > minLengthDiff2 do
		(
			minLengthDiff = minLengthDiff2
			minLengthDiffAxis = 2 -- smaller diff is between L2 and L3, otherwise between L1 and L2
		)
		local xAxisBone1
		local xAxisBone2
		local zAxisBone1
		local zAxisBone2 = realRootHelper
		
		if minLengthDiffAxis == 0 then
		(
			format "Smaller diff is between % and %: %\n" realRootHChild1.name realRootHChild2.name minLengthDiff
			xAxisBone1 = realRootHChild1
			xAxisBone2 = realRootHChild2
			zAxisBone1 = realRootHChild3
			if realRootHChild3.children.count > 0 do zAxisBone2 = realRootHChild3.children[1]
			realCharThigh = realCharRoot.children[1]
			format "Real Thigh is: %\n" realCharThigh.name
		)
		if minLengthDiffAxis == 1 then
		(
			format "Smaller diff is between % and %: %\n" realRootHChild1.name realRootHChild3.name minLengthDiff
			xAxisBone1 = realRootHChild1
			xAxisBone2 = realRootHChild3
			zAxisBone1 = realRootHChild2
			if realRootHChild2.children.count > 0 do zAxisBone2 = realRootHChild2.children[1]
			realCharThigh = realCharRoot.children[1]
			format "Real Thigh is: %\n" realCharThigh.name
		)
		if minLengthDiffAxis == 2 then
		(
			format "Smaller diff is between % and %: %\n" realRootHChild2.name realRootHChild3.name minLengthDiff
			xAxisBone1 = realRootHChild2
			xAxisBone2 = realRootHChild3
			zAxisBone1 = realRootHChild1
			if realRootHChild1.children.count > 0 do zAxisBone2 = realRootHChild1.children[1]
			realCharThigh = realCharRoot.children[2]
			format "Real Thigh is: %\n" realCharThigh.name
		)
		
		local xAxisFindXDiffAxis = 0 -- bigger diff is X axis
		local xAxisFindXDiff = sqrt ((xAxisBone1.position.x - xAxisBone2.position.x)^2)
		local xAxisFindXDiff2 = sqrt ((xAxisBone1.position.y - xAxisBone2.position.y)^2)
		if xAxisFindXDiff < xAxisFindXDiff2 do
		(
			xAxisFindXDiff = xAxisFindXDiff2
			xAxisFindXDiffAxis = 1 -- bigger diff is Y axis
		)
		local xAxisFindXDiff2 = sqrt ((xAxisBone1.position.z - xAxisBone2.position.z)^2)
		if xAxisFindXDiff < xAxisFindXDiff2 do
		(
			xAxisFindXDiff = xAxisFindXDiff2
			xAxisFindXDiffAxis = 2 -- bigger diff is Z axis
		)
		
		local xAxisFinalAxisHelper = point size:0.1
		xAxisFinalAxisHelper.name = realCharRoot.name + " X Axis Helper"
		
		if xAxisFindXDiffAxis == 0 then
		(
			format "bigger X diff is X axis: %\n" xAxisFindXDiff
			in coordsys world xAxisFinalAxisHelper.position = [1.0,0.0,0.0]
		)
		else if xAxisFindXDiffAxis == 1 then
		(
			format "bigger X diff is Y axis: %\n" xAxisFindXDiff
			in coordsys world xAxisFinalAxisHelper.position = [0.0,1.0,0.0]
		)
		else --if xAxisFindXDiffAxis == 2 then
		(
			format "bigger X diff is Z axis: %\n" xAxisFindXDiff
			in coordsys world xAxisFinalAxisHelper.position = [0.0,0.0,1.0]
		)
		
		
		local zAxisFindZDiffAxis = 0 -- bigger diff is X axis
		local zAxisFindZDiff = sqrt ((zAxisBone1.position.x - zAxisBone2.position.x)^2)
		local zAxisFindZDiff2 = sqrt ((zAxisBone1.position.y - zAxisBone2.position.y)^2)
		if zAxisFindZDiff < zAxisFindZDiff2 do
		(
			zAxisFindZDiff = zAxisFindZDiff2
			zAxisFindZDiffAxis = 1 -- bigger diff is Y axis
		)
		local zAxisFindZDiff2 = sqrt ((zAxisBone1.position.z - zAxisBone2.position.z)^2)
		if zAxisFindZDiff < zAxisFindZDiff2 do
		(
			zAxisFindZDiff = zAxisFindZDiff2
			zAxisFindZDiffAxis = 2 -- bigger diff is Z axis
		)
		
		local zAxisFinalAxisHelper = point size:0.1
		zAxisFinalAxisHelper.name = realCharRoot.name + " Z Axis Helper"
		
		if zAxisFindZDiffAxis == 0 then
		(
			format "bigger Z diff is X axis: %\n" zAxisFindZDiff
			in coordsys world zAxisFinalAxisHelper.position = [1.0,0.0,0.0]
		)
		else if zAxisFindZDiffAxis == 1 then
		(
			format "bigger Z diff is Y axis: %\n" zAxisFindZDiff
			in coordsys world zAxisFinalAxisHelper.position = [0.0,1.0,0.0]
		)
		else --if zAxisFindZDiffAxis == 2 then
		(
			format "bigger Z diff is Z axis: %\n" zAxisFindZDiff
			in coordsys world zAxisFinalAxisHelper.position = [0.0,0.0,1.0]
		)
		
		local yAxisFinalAxisHelper = point size:0.1
		yAxisFinalAxisHelper.name = realCharRoot.name + " Y Axis Helper"
		local yAxisFinalAxis2Helper = point size:0.1
		yAxisFinalAxis2Helper.name = realCharRoot.name + " Y Axis2 Helper"
		local yAxisFindYDiffAxis = xAxisFindXDiffAxis + zAxisFindZDiffAxis
		if yAxisFindYDiffAxis == 3 then -- 1 + 2
		(
			format "Y is X axis\n"
			in coordsys world yAxisFinalAxisHelper.position = [1.0,0.0,0.0]
			in coordsys world yAxisFinalAxis2Helper.position = [-1.0,0.0,0.0]
		)
		else if yAxisFindYDiffAxis == 2 then -- 0 + 2
		(
			format "Y is Y axis\n"
			in coordsys world yAxisFinalAxisHelper.position = [0.0,1.0,0.0]
			in coordsys world yAxisFinalAxis2Helper.position = [0.0,-1.0,0.0]
		)
		else --if yAxisFindYDiffAxis == 1 then -- 0 + 1
		(
			format "Y is Z axis\n"
			in coordsys world yAxisFinalAxisHelper.position = [0.0,0.0,1.0]
			in coordsys world yAxisFinalAxis2Helper.position = [0.0,0.0,-1.0]
		)
		
		xAxisFinalAxisHelper.parent = realRootHelper
		yAxisFinalAxisHelper.parent = realRootHelper
		yAxisFinalAxis2Helper.parent = realRootHelper
		zAxisFinalAxisHelper.parent = realRootHelper
		
		if realRootHChild1Child != undefined do delete realRootHChild1Child
		delete realRootHChild1
		if realRootHChild2Child != undefined do delete realRootHChild2Child
		delete realRootHChild2
		if realRootHChild3Child != undefined do delete realRootHChild3Child
		delete realRootHChild3
		
		in coordsys world realRootHelper.transform = in coordsys world realCharRoot.transform
		
		local realFinalToe = SE_AAH_GetFinalBone realCharThigh
		format "Final Toe is: %\n" realFinalToe.name
		format "Final Toe parent is: %\n" realFinalToe.parent.name
		
		local realFinalToeAxisHelper = point size:0.1
		realFinalToeAxisHelper.position = (realFinalToe.transform.position - realFinalToe.parent.transform.position)*100 + realFinalToe.parent.transform.position
		
		local yAxisFinalLocalAxisHelper = point size:0.1
		yAxisFinalLocalAxisHelper.name = realCharRoot.name + " Local Y Axis Helper"
		
		local rFTYAxisLength = length (realFinalToeAxisHelper.position - yAxisFinalAxisHelper.position)
		local rFTYAxis2Length = length (realFinalToeAxisHelper.position - yAxisFinalAxis2Helper.position)
		if rFTYAxisLength > rFTYAxis2Length then
		(
			yAxisFinalLocalAxisHelper.position = yAxisFinalAxis2Helper.position
			format "% Local Y Axis is: %\n" realCharRoot.name yAxisFinalAxis2Helper.name
		)
		else
		(
			yAxisFinalLocalAxisHelper.position = yAxisFinalAxisHelper.position
			format "% Local Y Axis is: %\n" realCharRoot.name yAxisFinalAxisHelper.name
		)
		yAxisFinalLocalAxisHelper.parent = realRootHelper
		
		delete realFinalToeAxisHelper
		delete yAxisFinalAxisHelper
		delete yAxisFinalAxis2Helper
		delete xAxisFinalAxisHelper
		delete zAxisFinalAxisHelper
		--select realRootHelper
		
		local v3DCharFacingFinal = (in coordsys world yAxisFinalLocalAxisHelper.position) - (in coordsys world realRootHelper.position)
		
		local newBBofBB= nodeLocalBoundingBox fullBB
		local facingVectorLength = (length(newBBofBB[2] - newBBofBB[1]))*0.5
		
		v3DCharFacingFinal = (v3DCharFacingFinal / (length v3DCharFacingFinal)) * facingVectorLength
		
		local facingBoundingBox = copy fullBB
		facingBoundingBox.name =  sHier[1].name + " Hierarchy Facing Vector"
		in coordsys world facingBoundingBox.scale = [0.05,0.05,0.05]
		in coordsys world facingBoundingBox.position = realRootHelper.position + v3DCharFacingFinal
		facingBoundingBox.parent = fullBB
		
		--local v3DCharFacingFinal = Vector3D FacialVectorX FacialVectorY FacialVectorZ
		
		delete yAxisFinalLocalAxisHelper
		delete realRootHelper
		--delete facingBoundingBox
		
		--v3DCharFacingFinal = [0.0, -1.0, 0.0] -- TEMP DECISION!!!
		
		return v3DCharFacingFinal
	)
	else
	(
		return [0.0,0.0,1.0] -- up-oriented for non-character objects
	)
)

fn SE_AAH_MirrorObjectsTransformRelativelyToAnotherObjectsTransform obj targetObj mirrorAxis mirrorRotations =
(
	local sHierUltimateTempObj = dummy boxsize:([0.001,0.001,0.001]) wirecolor:blue
	local sHierUltimateTempTarget = dummy boxsize:([0.001,0.001,0.001]) wirecolor:blue
	sHierUltimateTempObj.transform = obj.transform
	sHierUltimateTempObj.transform = obj.transform
	sHierUltimateTempTarget.transform = targetObj.transform
	sHierUltimateTempTarget.transform = targetObj.transform
	in coordsys world sHierUltimateTempTarget.rotation.x_rotation = 0.0
	in coordsys world sHierUltimateTempTarget.rotation.y_rotation = 0.0
	in coordsys world sHierUltimateTempTarget.rotation.z_rotation = 0.0
	in coordsys world sHierUltimateTempTarget.rotation.x_rotation = 0.0
	in coordsys world sHierUltimateTempTarget.rotation.y_rotation = 0.0
	in coordsys world sHierUltimateTempTarget.rotation.z_rotation = 0.0
	sHierUltimateTempObj.parent = sHierUltimateTempTarget
	sHierUltimateTempTarget.position = [0.0,0.0,0.0]
	sHierUltimateTempTarget.position = [0.0,0.0,0.0]
	local newXPos = (in coordsys world sHierUltimateTempObj.position.x) * -1.0
	local newYPos = (in coordsys world sHierUltimateTempObj.position.y) * -1.0
	local newZPos = (in coordsys world sHierUltimateTempObj.position.z) * -1.0
	local newXRot = (in coordsys world sHierUltimateTempObj.rotation.x_rotation) * -1.0
	local newYRot = (in coordsys world sHierUltimateTempObj.rotation.y_rotation) * -1.0
	local newZRot = (in coordsys world sHierUltimateTempObj.rotation.z_rotation) * -1.0
	if mirrorAxis == 1 or mirrorAxis == 4 or mirrorAxis == 6 or mirrorAxis == 7 then
	(
		if mirrorRotations == true do
		(
			in coordsys world sHierUltimateTempObj.rotation.y_rotation = newYRot
			in coordsys world sHierUltimateTempObj.rotation.y_rotation = newYRot
			in coordsys world sHierUltimateTempObj.rotation.z_rotation = newZRot
			in coordsys world sHierUltimateTempObj.rotation.z_rotation = newZRot
		)
		sHierUltimateTempObj.position.x = newXPos
		sHierUltimateTempObj.position.x = newXPos
		if mirrorAxis == 4 or mirrorAxis == 7 do
		(
			if mirrorRotations == true do
			(
				newYRot = (in coordsys world sHierUltimateTempObj.rotation.y_rotation) * -1.0
				newZRot = (in coordsys world sHierUltimateTempObj.rotation.z_rotation) * -1.0 - 180.0
				in coordsys world sHierUltimateTempObj.rotation.y_rotation = newYRot
				in coordsys world sHierUltimateTempObj.rotation.y_rotation = newYRot
				in coordsys world sHierUltimateTempObj.rotation.z_rotation = newZRot
				in coordsys world sHierUltimateTempObj.rotation.z_rotation = newZRot
			)
			sHierUltimateTempObj.position.y = newYPos
			sHierUltimateTempObj.position.y = newYPos
		)
		if mirrorAxis == 6 or mirrorAxis == 7 do
		(
			if mirrorRotations == true do
			(
				newXRot = (in coordsys world sHierUltimateTempObj.rotation.x_rotation) * -1.0
				newYRot = (in coordsys world sHierUltimateTempObj.rotation.y_rotation) * -1.0
				in coordsys world sHierUltimateTempObj.rotation.x_rotation = newXRot
				in coordsys world sHierUltimateTempObj.rotation.x_rotation = newXRot
				in coordsys world sHierUltimateTempObj.rotation.y_rotation = newYRot
				in coordsys world sHierUltimateTempObj.rotation.y_rotation = newYRot
			)
			sHierUltimateTempObj.position.z = newZPos
			sHierUltimateTempObj.position.z = newZPos
		)
	)
	else if mirrorAxis == 2 or mirrorAxis == 5 then
	(
		if mirrorRotations == true do
		(
			local newZRot = newZRot - 180.0
			in coordsys world sHierUltimateTempObj.rotation.y_rotation = newYRot
			in coordsys world sHierUltimateTempObj.rotation.y_rotation = newYRot
			in coordsys world sHierUltimateTempObj.rotation.z_rotation = newZRot
			in coordsys world sHierUltimateTempObj.rotation.z_rotation = newZRot
		)
		sHierUltimateTempObj.position.y = newYPos
		sHierUltimateTempObj.position.y = newYPos
		if mirrorAxis == 5 do
		(
			if mirrorRotations == true do
			(
				newXRot = (in coordsys world sHierUltimateTempObj.rotation.x_rotation) * -1.0
				newYRot = (in coordsys world sHierUltimateTempObj.rotation.y_rotation) * -1.0
				in coordsys world sHierUltimateTempObj.rotation.x_rotation = newXRot
				in coordsys world sHierUltimateTempObj.rotation.x_rotation = newXRot
				in coordsys world sHierUltimateTempObj.rotation.y_rotation = newYRot
				in coordsys world sHierUltimateTempObj.rotation.y_rotation = newYRot
			)
			sHierUltimateTempObj.position.z = newZPos
			sHierUltimateTempObj.position.z = newZPos
		)
	)
	else if mirrorAxis == 3 then
	(
		if mirrorRotations == true do
		(
			in coordsys world sHierUltimateTempObj.rotation.x_rotation = newXRot
			in coordsys world sHierUltimateTempObj.rotation.x_rotation = newXRot
			in coordsys world sHierUltimateTempObj.rotation.y_rotation = newYRot
			in coordsys world sHierUltimateTempObj.rotation.y_rotation = newYRot
		)
		sHierUltimateTempObj.position.z = newZPos
		sHierUltimateTempObj.position.z = newZPos
	)
	sHierUltimateTempTarget.position = targetObj.position
	sHierUltimateTempTarget.position = targetObj.position
	obj.transform = sHierUltimateTempObj.transform
	obj.transform = sHierUltimateTempObj.transform
	delete sHierUltimateTempObj
	delete sHierUltimateTempTarget
)


fn SE_AAH_CloneHierarchy sHierCurrentOne sHierDontReplaceBones cloneTransformTrigger transferObjectsTrigger clonedAutoSetID clonedAutoSetIDInSeqOrder clonedMirror clonedMirrorRotations clonedMirrorAxis = -- works only when BoneIndexes are calculated properly!
(
	local clonedH = #()
	local sHierTempCloneRoot
	local sHierUltimateRoot = undefined
	local sHierUltimateTempRoot = undefined
	if sHierCurrentOne[1].parent != undefined then sHierUltimateRoot = sHierCurrentOne[1].parent
	else sHierUltimateTempRoot = dummy boxsize:([0.001,0.001,0.001]) wirecolor:blue pos:[0.0,0.0,0.0]
	if sHierDontReplaceBones == true then
	(
		sHierTempCloneRoot = copy sHierCurrentOne[1]
		if ClassOf sHierCurrentOne[1] == point or ClassOf sHierCurrentOne[1] == bone or ClassOf sHierCurrentOne[1] == dummy do sHierTempCloneRoot.showLinks = true
	)
	else
	(
		sHierTempCloneRoot = dummy boxsize:([0.001,0.001,0.001]) wirecolor:blue --bone pos: [0.0,0.0,0.0] wirecolor:blue
		if cloneTransformTrigger then sHierTempCloneRoot.transform = sHierCurrentOne[1].transform
		else sHierTempCloneRoot.position = sHierCurrentOne[1].position
	)
	sHierTempCloneRoot.name = sHierCurrentOne[1].name
	setUserPropBuffer sHierTempCloneRoot (getUserPropBuffer sHierCurrentOne[1])
	sHierTempCloneRoot.wirecolor = sHierCurrentOne[1].wirecolor
	--local nrtbnTempDummy = dummy boxsize:([0.001,0.001,0.001])
	--sHierTempCloneRoot.baseobject = nrtbnTempDummy
	if sHierDontReplaceBones == false do sHierTempCloneRoot.showLinks = true
	--sHierTempCloneRoot.showLinksOnly = true
	if clonedAutoSetID == true and sHierUltimateRoot != undefined do
	(
		if clonedAutoSetIDInSeqOrder == true do
		(
			local newClonedBoneID = (SE_AAH_GetSubID 0 sHierCurrentOne[1])
			local newClonedHier = SE_AAH_GetAllHierarchy sHierCurrentOne[1] 0
			if newClonedBoneID > -1 then newClonedBoneID = SE_AAH_CheckAndFindFreeSubID newClonedHier newClonedBoneID
			else newClonedBoneID = SE_AAH_CheckAndFindFreeSubID newClonedHier 0
			setUserProp sHierTempCloneRoot "SubID" newClonedBoneID
			setUserProp sHierTempCloneRoot "BoneID" newClonedBoneID
			setUserProp sHierTempCloneRoot "BoneId" newClonedBoneID
			setUserProp sHierTempCloneRoot "tag" newClonedBoneID
		)
	)
	
	if clonedMirror == true do
	(
		if sHierUltimateRoot != undefined then SE_AAH_MirrorObjectsTransformRelativelyToAnotherObjectsTransform sHierTempCloneRoot sHierUltimateRoot clonedMirrorAxis clonedMirrorRotations
		else SE_AAH_MirrorObjectsTransformRelativelyToAnotherObjectsTransform sHierTempCloneRoot sHierUltimateTempRoot clonedMirrorAxis clonedMirrorRotations
	)
	
	append clonedH sHierTempCloneRoot
	if sHierCurrentOne[1].parent != undefined do sHierTempCloneRoot.parent = sHierCurrentOne[1].parent
	local sHierCurrentIndex
	local sHierParentIndex
	local sHierTempCloneMember
	for sHierMember in sHierCurrentOne do
	(
		if sHierMember != sHierCurrentOne[1] do
		(
			sHierCurrentIndex = getUserProp sHierMember "BoneIndex"
			if sHierCurrentIndex > 0 do
			(
				sHierParentIndex = getUserProp sHierMember.parent "BoneIndex"
				--if transferObjectsTrigger == false or ClassOf sHierMember == point or ClassOf sHierMember == bone or ClassOf sHierMember == dummy then
				--(
					if sHierDontReplaceBones == true then
					(
						sHierTempCloneMember = copy sHierMember
						if ClassOf sHierMember == point or ClassOf sHierMember == bone or ClassOf sHierMember == dummy do sHierTempCloneMember.showLinks = true
					)
					else
					(
						sHierTempCloneMember = dummy boxsize:([0.001,0.001,0.001]) wirecolor:blue --bone pos: [0.0,0.0,0.0] wirecolor:blue
						if cloneTransformTrigger then sHierTempCloneMember.transform = sHierMember.transform
						else sHierTempCloneMember.position = sHierMember.position
						if ClassOf sHierMember != point and ClassOf sHierMember != bone and ClassOf sHierMember != dummy do
						(
							setUserProp sHierMember "ClonedHierObject" 1
							setUserProp sHierTempCloneMember "ClonedHierObject" 1
						)
					)
					sHierTempCloneMember.name = sHierMember.name
					setUserPropBuffer sHierTempCloneMember (getUserPropBuffer sHierMember)
					sHierTempCloneMember.wirecolor = sHierMember.wirecolor
					--sHierTempCloneMember.baseobject = nrtbnTempDummy
					if sHierDontReplaceBones == false do sHierTempCloneMember.showLinks = true
					--sHierTempCloneMember.showLinksOnly = true
					
					if clonedAutoSetID == true and sHierUltimateRoot != undefined do
					(
						if clonedAutoSetIDInSeqOrder == true do
						(
							local newClonedBoneID = (SE_AAH_GetSubID 0 sHierMember)
							local newClonedHier = SE_AAH_GetAllHierarchy sHierMember 0
							if newClonedBoneID > -1 then newClonedBoneID = SE_AAH_CheckAndFindFreeSubID newClonedHier newClonedBoneID
							else newClonedBoneID = SE_AAH_CheckAndFindFreeSubID newClonedHier 0
							setUserProp sHierTempCloneMember "SubID" newClonedBoneID
							setUserProp sHierTempCloneMember "BoneID" newClonedBoneID
							setUserProp sHierTempCloneMember "BoneId" newClonedBoneID
							setUserProp sHierTempCloneMember "tag" newClonedBoneID
						)
					)		
					
					if clonedMirror == true do
					(
						if sHierUltimateRoot != undefined then SE_AAH_MirrorObjectsTransformRelativelyToAnotherObjectsTransform sHierTempCloneMember sHierUltimateRoot clonedMirrorAxis clonedMirrorRotations
						else SE_AAH_MirrorObjectsTransformRelativelyToAnotherObjectsTransform sHierTempCloneMember sHierUltimateTempRoot clonedMirrorAxis clonedMirrorRotations
					)
					
					
				--)
				--else sHierTempCloneMember = copy sHierMember --sHierTempCloneMember = sHierMember
				--if transferObjectsTrigger == true and ClassOf sHierMember != point and ClassOf sHierMember != bone and ClassOf sHierMember != dummy do
				--(
					--sHierMember.layer.addnode sHNode
				--)
				for sHierTempCloneMemberParent in clonedH do
				(
					if getUserProp sHierTempCloneMemberParent "BoneIndex" == sHierParentIndex do sHierTempCloneMember.parent = sHierTempCloneMemberParent
				)
				append clonedH sHierTempCloneMember
			)
		)
	)
	--delete nrtbnTempDummy
	if sHierUltimateTempRoot != undefined do delete sHierUltimateTempRoot
	return clonedH
)

fn SE_AAH_CalculateBonesRotations sHierCurrentOne =
(
	local localsHier = SE_AAH_GetAllHierarchy sHierCurrentOne[1] 0
	local boundingBox = SE_AAH_GetBoundingBoxOfHierarchy localsHier
	local v3DCharFacing = SE_AAH_GetHierarchyFacingVector localsHier boundingBox
	local sBBHier = SE_AAH_GetAllHierarchy boundingBox 0
	for sBB in sBBHier do delete sBB
	
	for sHierBone in sHierCurrentOne do
	(
		if sHierBone.parent != undefined do
		(
			local sHierChildren = #()
			--local sHierChildren = sHierBone.children
			local firstChild
			
			if sHierBone.children.count > 0 do
			(
				for sHierChild in sHierBone.children do
				(
					if firstChild == undefined and (getUserProp sHierChild "ClonedHierObject" == undefined or getUserProp sHierChild "ClonedHierObject" != 1) do firstChild = sHierChild
					sHierChild.parent = undefined
					append sHierChildren sHierChild
				)
			)
			--sHierBone
			if firstChild != undefined then
			(
				local bRotHelperY = BoneSys.createBone (in coordsys world sHierBone.transform.position) (in coordsys world firstChild.transform.position) v3DCharFacing -- actually, it's XZ rotation helper, but then we'll rotate it by X-axis and it will be XY rotation helper
				
				in coordsys world sHierBone.rotation.x_rotation = in coordsys world bRotHelperY.rotation.x_rotation
				in coordsys world sHierBone.rotation.y_rotation = in coordsys world bRotHelperY.rotation.y_rotation
				in coordsys world sHierBone.rotation.z_rotation = in coordsys world bRotHelperY.rotation.z_rotation
				
				delete bRotHelperY
				
				in coordsys world sHierBone.transform = in coordsys world ( (rotateXmatrix 90) * sHierBone.transform) -- now Y-axis is pointing to the actual Y-axis of the character (and X-axis - to the children bone)
			)
			else
			(
				sHierBone.rotation.x_rotation = sHierBone.parent.rotation.x_rotation
				sHierBone.rotation.y_rotation = sHierBone.parent.rotation.y_rotation
				sHierBone.rotation.z_rotation = sHierBone.parent.rotation.z_rotation
			)
			
			if sHierChildren.count > 0 do
			(
				for sHierChild in sHierChildren do
				(
					sHierChild.parent = sHierBone
				)
			)
		)
	)
)

fn SE_AAH_GetUniqueHierarchyLayer sHierCurrentOne = -- -2 means impostor nodes in the same layer; -1 means hierarchy lays between different layers; proper layer means hierarchy has a proper unique layer
(
	local currentLayer
	local uniqueHierarchyLayer
	for sHierBone in sHierCurrentOne do
	(
		local boneLayer = sHierBone.layer
		if currentLayer == undefined then currentLayer = boneLayer
		else if currentLayer != boneLayer do uniqueHierarchyLayer = -1
	)
	if uniqueHierarchyLayer != -1 do
	(
		local layerNodes
		currentLayer.nodes &layerNodes
		--local impostorNode = false
		for layerNode in layerNodes do
		(
			if (findItem sHierCurrentOne layerNode) == 0 do uniqueHierarchyLayer = -2--impostorNode = true
		)
	) --if uniqueHierarchyLayer != undefined and uniqueHierarchyLayer != -1 do uniqueHierarchyLayer = currentLayer
	if uniqueHierarchyLayer != -1 and uniqueHierarchyLayer != -2 do uniqueHierarchyLayer = currentLayer
	return uniqueHierarchyLayer
)

fn SE_AAH_FindUniqueLayerName currentLayerName uniqueLayerNameID =
(
		uniqueLayerNameID = uniqueLayerNameID + 1
		local uniqueLayerNameIDString = uniqueLayerNameID as string
		if uniqueLayerNameID < 100 do
		(
			uniqueLayerNameIDString  = "0" + uniqueLayerNameIDString
			if uniqueLayerNameID < 10 do
			(
				uniqueLayerNameIDString  = "0" + uniqueLayerNameIDString
			)
		)
		local currentLayerNameTry = currentLayerName + uniqueLayerNameIDString
		local bonesUniqueNameLayerTry = LayerManager.getLayerFromName currentLayerNameTry
		if bonesUniqueNameLayerTry != undefined then
		(
			SE_AAH_FindUniqueLayerName currentLayerName uniqueLayerNameID
		)
		else
		(
			return currentLayerNameTry
		)	
)

fn SE_AAH_CreateLayerForHierarchy sHier sHierLayerName = 
(
	local bonesUniqueNameLayerTry = LayerManager.getLayerFromName sHierLayerName
	if bonesUniqueNameLayerTry != undefined do
	(
		sHierLayerName = SE_AAH_FindUniqueLayerName sHierLayerName 0 -- start with ID 0
	)
	local cHNewLayer = LayerManager.newLayer()
	cHNewLayer.setname sHierLayerName
	for cHBone in sHier do
	(
		cHNewLayer.addnode cHBone
	)
	return cHNewLayer
)

fn SE_AAH_TransferAnimation sHier sHierCloneArray transferObjectsTrigger =
(
	SE_AAH_UpdateAnimRangeStartAndEnd sHier 1 true true true false false 0.0 100.0 false --get max anim range for the all hierarchy
	local tsAnimBkInterval = 1.0
	local clonedHDeletedNodes = #()
	if ACAnimRangeStartKeyframe != undefined and ACAnimRangeEndKeyframe != undefined do
	(
		local AdoptRangeKeysCount = (((ACAnimRangeEndKeyframe - ACAnimRangeStartKeyframe) as float)/TicksPerFrame) as integer
		if ACAnimRangeEndKeyframe > ACAnimRangeStartKeyframe then animationRange = interval ACAnimRangeStartKeyframe ACAnimRangeEndKeyframe
		else animationRange = interval 0.0 100.0
		local sHierCloneTempArray = SE_AAH_CloneHierarchy sHierCloneArray false true false false false false false 0 -- make a clone of the hierarchy with array of new helpers and copypasted rotations 
		try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
		for sHNode in sHier do
		(
			local sHNodeIndex = getUserProp sHNode "BoneIndex"
			local currentTempNode
			for sHCTANode in sHierCloneTempArray do
			(
				if (getUserProp sHCTANode "BoneIndex") == sHNodeIndex do
				(
					sHCTANode.parent = sHNode
					currentTempNode = sHCTANode
				)
			)
			for sHCANode in sHierCloneArray do
			(
				if (getUserProp sHCANode "BoneIndex") == sHNodeIndex do
				(
					with Animate on
					(
						if transferObjectsTrigger == false or ClassOf sHNode == point or ClassOf sHNode == bone or ClassOf sHNode == dummy then
						(
							for i = 0 to AdoptRangeKeysCount do
							(
								--if (ACAnimRangeStartKeyframe + (i * tsAnimBkInterval)) == 0.0f do isThereAZeroKeyAtAllpos = true
								at time (ACAnimRangeStartKeyframe + (i * tsAnimBkInterval))
								(
									in coordsys world sHCANode.transform = in coordsys world currentTempNode.transform
								)
							)
						)
						else
						(
							currentTempNode.parent = undefined
							for i = 0 to AdoptRangeKeysCount do
							(
								at time (ACAnimRangeStartKeyframe + (i * tsAnimBkInterval))
								(
									in coordsys world currentTempNode.transform = in coordsys world sHNode.transform
								)
							)
							sHNode.parent = undefined --sHCANode.parent
							for i = 0 to AdoptRangeKeysCount do
							(
								at time (ACAnimRangeStartKeyframe + (i * tsAnimBkInterval))
								(
									in coordsys world sHNode.transform = in coordsys world currentTempNode.transform
								)
							)
							--sHCANode.layer.addnode sHNode
							(LayerManager.getLayerFromName "0").addnode sHNode
							append clonedHDeletedNodes sHCANode
							--delete sHCANode
						)
						
						
						
					)
					
				)
			)
		)
			

		for sHCTANode in sHierCloneTempArray do delete sHCTANode
		
		
		--AAHHelperLayer.addnode ikRotation
		if clonedHDeletedNodes.count > 0 do
		(
			for clonedHDNode in clonedHDeletedNodes do delete clonedHDNode
		)
	
	
	
	
	)
)
	
fn SE_AAH_GetCharacterHierarchy obj =
(
	local cHSpineLinks = 2
	local cHLegLinks = 3
	local cHTailLinks = 0
	local cHFingersNumber = 0
	local cHFingerLinks = 1
	local cHToesNumber = 1
	local cHToeLinks = 1
	local cHHeadId = -1
	local aH = #()
	local rootObj = SE_AAH_GetRoot obj
	if rootObj != undefined do 
	(
		append aH rootObj
		SE_AAH_AppendAllChildren rootObj aH
		for aHChild in aH do
		(
			local aHBoneId = SE_AAH_GetSubID 0 aHChild
			if aHBoneId != -1 do
			(
				if aHBoneId > 3 and aHBoneId < 14 do
				(
					local aHChildParent = aHChild.parent
					if aHChild.children.count == 0 then
					(
						if aHChildParent.children.count < 2 then cHHeadId = aHBoneId -- if it's the only head on the neck bone
						else
						(
							for aHChildParentChildren in aHChildParent.children do
							(
								if aHChildParentChildren != aHChild and aHChildParentChildren.children.count > 0 do cHHeadId = aHBoneId -- if it's a head on the neck bone with clavicles
							)
						)
					)
					else
					(
						cHHeadId = aHBoneId
					)
					cHSpineLinks = cHHeadId - 3			
				)
				if aHBoneId == 59 or aHBoneId == 49 do cHLegLinks = 4
				if aHBoneId >= 60 and aHBoneId < 85 do
				(
					cHTailLinks = aHBoneId - 59	
				)
				if aHBoneId >= 25 and aHBoneId < 29 do
				(
					cHFingersNumber = 1
					cHFingerLinks = aHBoneId - 24
				)
				if aHBoneId >= 1210 and aHBoneId < 1244 do
				(
					if cHFingersNumber <= 5 then
					( 
						if aHBoneId >= 1240 and aHBoneId < 1244 do 
						(
							cHFingersNumber = 5
							cHFingerLinks = aHBoneId - 1239
						)
					)
					else if cHFingersNumber <= 4 then
					( 
						if aHBoneId >= 1230 and aHBoneId < 1234 do 
						(
							cHFingersNumber = 4
							cHFingerLinks = aHBoneId - 1229
						)
					)
					else if cHFingersNumber <= 3 then
					( 
						if aHBoneId >= 1220 and aHBoneId < 1224 do 
						(
							cHFingersNumber = 3
							cHFingerLinks = aHBoneId - 1219
						)
					)
					else if cHFingersNumber <= 2 do
					( 
						if aHBoneId >= 1210 and aHBoneId < 1214 do 
						(
							cHFingersNumber = 2
							cHFingerLinks = aHBoneId - 1209
						)
					)
				)
				if aHBoneId >= 55 and aHBoneId < 59 do
				(
					cHToeLinks = aHBoneId - 54
				)
				if aHBoneId >= 1510 and aHBoneId < 1543 do
				(
					if cHToesNumber <= 5 then
					( 
						if aHBoneId >= 1540 and aHBoneId < 1543 do 
						(
							cHToesNumber = 5
							cHToeLinks = aHBoneId - 1539
						)
					)
					else if cHToesNumber <= 4 then
					( 
						if aHBoneId >= 1530 and aHBoneId < 1533 do 
						(
							cHToesNumber = 4
							cHToeLinks = aHBoneId - 1529
						)
					)
					else if cHToesNumber <= 3 then
					( 
						if aHBoneId >= 1520 and aHBoneId < 1523 do 
						(
							cHToesNumber = 3
							cHToeLinks = aHBoneId - 1519
						)
					)
					else if cHToesNumber <= 2 do
					( 
						if aHBoneId >= 1510 and aHBoneId < 1513 do 
						(
							cHToesNumber = 2
							cHToeLinks = aHBoneId - 1509
						)
					)
				)
			)
		)
	)
	local cH = CharacterHierarchy cHSpineLinks cHLegLinks cHTailLinks cHFingersNumber cHFingerLinks cHToesNumber cHToeLinks cHHeadId
	return cH
)

fn SE_AAH_HasSkinModifier obj =
(
	local skinModifierFound = false
	for i = 1 to obj.modifiers.count while skinModifierFound == false do
	(
		if classof obj.modifiers[i] == Skin do
		(
			skinModifierFound = true
		)
	)
	return skinModifierFound
)

fn SE_AAH_GetSkinMeshes selectedBones =
(
	local relatedSkins = #()
	local firstFoundBoneSkinId
	if selectedBones.count == 1 then
	(
		if getUserProp selectedBones[1] "SkinMeshNumber" != undefined and getUserProp selectedBones[1] "SkinMeshNumber" != -1 do firstFoundBoneSkinId = getUserProp selectedBones[1] "SkinMeshNumber"
	)
	else
	(
		for sBFirstFound in selectedBones while firstFoundBoneSkinId == undefined do
		(
			if getUserProp sBFirstFound "SkinMeshNumber" != undefined and getUserProp sBFirstFound "SkinMeshNumber" != -1 do firstFoundBoneSkinId = getUserProp sBFirstFound "SkinMeshNumber"
		)
	)
	if firstFoundBoneSkinId != undefined then
	(
		for obj in geometry do
		(
			if (SE_AAH_HasSkinModifier obj) do
			(
				if getUserProp obj "SkinMeshNumber" != undefined and getUserProp obj "SkinMeshNumber" == firstFoundBoneSkinId do append relatedSkins obj
			)
		)
	)
	else
	(
		local s_Array = selection as array
		for obj in geometry do
		(
			if (SE_AAH_HasSkinModifier obj) do
			(
				local shitFound = false
				if getUserProp obj "SkinMeshNumber" != undefined then
				(
					for i = 1 to selectedBones.count while shitFound == false do
					(
						if getUserProp selectedBones[i] "SkinMeshNumber" != undefined do
						(
							if getUserProp obj "SkinMeshNumber" == getUserProp selectedBones[i] "SkinMeshNumber" do
							(
								append relatedSkins obj
								shitFound = true
							)
						)
					)
				)
				else
				(
					local skTryCatchNumberOfBones
					max modify mode
					for sk in obj.modifiers where iskindof sk Skin while shitFound == false do
					(
						modpanel.setcurrentobject sk
						local sknodes = for n in (refs.dependson sk) where isvalidnode n collect n
						try (skTryCatchNumberOfBones = skinops.getnumberbones sk) catch () --some skinned meshes may cause bugs so that's why it's try-catch
						if skTryCatchNumberOfBones != undefined do
						(
							for i=1 to skTryCatchNumberOfBones while shitFound == false do 
							(
								local sknname = skinops.getbonename sk i 0
								for k = 1 to sknodes.count while shitFound == false do
								(
									if shitFound == false and stricmp sknname sknodes[k].name == 0 do
									(
										for l = 1 to selectedBones.count while shitFound == false do
										(
											if shitFound == false and sknodes[k] == selectedBones[l] do
											(
												append relatedSkins obj
												if getUserProp selectedBones[l] "SkinMeshNumber" == undefined then
												(
													SE_AAH_IncreaseSkinMeshNumber()
													setUserProp obj "SkinMeshNumber" NewSM_Number
													for m = 1 to selectedBones.count do
													(
														setUserProp selectedBones[m] "SkinMeshNumber" NewSM_Number
													)
												)
												else setUserProp obj "SkinMeshNumber" (getUserProp selectedBones[l] "SkinMeshNumber")
												shitFound = true
											)
										)
										for obj2 in objects while shitFound == false do
										(
											if shitFound == false and sknodes[k] == obj2 do
											(
												if getUserProp obj2 "SkinMeshNumber" == undefined then
												(
													SE_AAH_IncreaseSkinMeshNumber()
													setUserProp obj "SkinMeshNumber" NewSM_Number
													local rsHierarchy = SE_AAH_GetAllHierarchy obj2 0
													for rsBones in rsHierarchy do
													(
														setUserProp rsBones "SkinMeshNumber" NewSM_Number
													)
												)
												else setUserProp obj "SkinMeshNumber" (getUserProp obj2 "SkinMeshNumber")
												shitFound = true
											)
										)
									)
								)
							)
						)
					)
				)
			)
		)
		clearselection()
		for obj in s_Array do
		(
			selectmore obj
		)
	)
	return relatedSkins
)

fn SE_AAH_MarkRelatedSkinBones selectedMesh =
(
	local shitFound = false
	if getUserProp selectedMesh "SkinMeshNumber" == undefined or getUserProp selectedMesh "SkinMeshNumber" == -1 do
	(
		local s_Array = selection as array
		local skTryCatchNumberOfBones
		max modify mode
		for sk in selectedMesh.modifiers where iskindof sk Skin while shitFound == false do
		(
			modpanel.setcurrentobject sk
			local sknodes = for n in (refs.dependson sk) where isvalidnode n collect n
			try (skTryCatchNumberOfBones = skinops.getnumberbones sk) catch () --some skinned meshes may cause bugs so that's why it's try-catch
			if skTryCatchNumberOfBones != undefined do
			(
				for i=1 to skTryCatchNumberOfBones while shitFound == false do 
				(
					sknname = skinops.getbonename sk i 0
					for k = 1 to sknodes.count while shitFound == false do
					(
						if shitFound == false and stricmp sknname sknodes[k].name == 0 do
						(
							for obj in objects while shitFound == false do
							(
								if shitFound == false and sknodes[k] == obj do
								(
									if getUserProp obj "SkinMeshNumber" == undefined then
									(
										SE_AAH_IncreaseSkinMeshNumber()
										setUserProp selectedMesh "SkinMeshNumber" NewSM_Number
										local rsHierarchy = SE_AAH_GetAllHierarchy obj 0
										for rsBones in rsHierarchy do
										(
											setUserProp rsBones "SkinMeshNumber" NewSM_Number
										)
									)
									else setUserProp selectedMesh "SkinMeshNumber" (getUserProp obj "SkinMeshNumber")
									shitFound = true
								)
							)
						)
					)
				)
			)
		)
		clearselection()
		for obj in s_Array do
		(
			selectmore obj
		)
	)
	--return shitFound
)

fn SE_AAH_MarkAllSkinsAndBonesInScene =
(
	local littleShit = point size:0.1
	local littleShittyArray = #()
	append littleShittyArray littleShit
	SE_AAH_GetSkinMeshes littleShittyArray
	delete littleShit
)

fn SE_AAH_GetRelatedSkinMeshes selectedMesh =
(
	local relatedSkins = #()
	if getUserProp selectedMesh "SkinMeshNumber" != undefined and getUserProp selectedMesh "SkinMeshNumber" != -1 do
	(
		local currentSkinMeshNumber = getUserProp selectedMesh "SkinMeshNumber"
		for obj in geometry do
		(
			if (SE_AAH_HasSkinModifier obj) do
			(
				if getUserProp obj "SkinMeshNumber" != undefined and getUserProp obj "SkinMeshNumber" == currentSkinMeshNumber do append relatedSkins obj
			)
		)
	)
	return relatedSkins
)

fn SE_AAH_GetRelatedSkinBones selectedMesh =
(
	local relatedBones = #()
	if getUserProp selectedMesh "SkinMeshNumber" != undefined and getUserProp selectedMesh "SkinMeshNumber" != -1 do
	(
		local currentSkinMeshNumber = getUserProp selectedMesh "SkinMeshNumber"
		for obj in objects do
		(
			if (SE_AAH_HasSkinModifier obj == false) do
			(
				if getUserProp obj "SkinMeshNumber" != undefined and getUserProp obj "SkinMeshNumber" == currentSkinMeshNumber do append relatedBones obj
			)
		)
	)
	return relatedBones
)

fn SE_AAH_GetSkinMeshBones cMCMLMesh = --currentBonesTemp =
(
	local relatedBones = #()
	local shitFound = false
	
	--local s_Array = selection as array
	local skTryCatchNumberOfBones
	max modify mode
	for sk in cMCMLMesh.modifiers where iskindof sk Skin while shitFound == false do
	(
		modpanel.setcurrentobject sk
		local sknodes = for n in (refs.dependson sk) where isvalidnode n collect n
		try (skTryCatchNumberOfBones = skinops.getnumberbones sk) catch () --some skinned meshes may cause bugs so that's why it's try-catch
		format "%: skTryCatchNumberOfBones: %, sknodes: %\n" cMCMLMesh.name skTryCatchNumberOfBones sknodes.count
		
		if skTryCatchNumberOfBones != undefined do
		(
			for i=1 to skTryCatchNumberOfBones while shitFound == false do 
			(
				sknname = skinops.getbonename sk i 0
				for k = 1 to sknodes.count while shitFound == false do
				(
					if shitFound == false and stricmp sknname sknodes[k].name == 0 do
					(
						for obj in objects while shitFound == false do
						(
							if shitFound == false and sknodes[k] == obj do
							(
								append relatedBones obj
								--format "%: Found Bone: %\n" cMCMLMesh.name obj.name
								--shitFound = true
							)
						)
					)
				)
			)
		)
	)
	--clearselection()
	--for obj in s_Array do
	--(
	--	selectmore obj
	--)
	
	return relatedBones
)

fn SE_AAH_GetSkinMeshClonedBones skinMeshBonesList currentBonesCloneArray =
(
	local relatedClonedBones = #()
	for currentBCloneANode in currentBonesCloneArray do
	(
		if (getUserProp currentBCloneANode "BoneIndex") != undefined and (getUserProp currentBCloneANode "BoneIndex") != -1 do
		(
			local currentCBBoneIndex = (getUserProp currentBCloneANode "BoneIndex")
			for skinMBLNode in skinMeshBonesList do
			(
				if (getUserProp skinMBLNode "BoneIndex") != undefined and (getUserProp skinMBLNode "BoneIndex") == currentCBBoneIndex do
				(
					append relatedClonedBones currentBCloneANode
				)
			)
		)
	)
	return relatedClonedBones
)

fn SE_AAH_GetSkinMeshLastLeftClonedBones currentBonesCloneArray skinMeshCloneBonesList =
(
	local relatedLastLeftClonedBones = #()
	local shitFound = false
	for currentBCloneANode in currentBonesCloneArray do
	(
		if (getUserProp currentBCloneANode "BoneIndex") != undefined and (getUserProp currentBCloneANode "BoneIndex") != -1 do
		(
			local currentCBBoneIndex = (getUserProp currentBCloneANode "BoneIndex")
			shitFound = false
			for skinMBLNode in skinMeshCloneBonesList do
			(
				if (getUserProp skinMBLNode "BoneIndex") != undefined and (getUserProp skinMBLNode "BoneIndex") == currentCBBoneIndex do
				(
					shitFound = true
				)
			)
			if shitFound == false do append relatedLastLeftClonedBones currentBCloneANode
		)
	)
	return relatedLastLeftClonedBones
)

fn SE_AAH_CreateWeightMesh cMCMLMesh =
(
	for obj in objects do
	(
		if obj.name == ("SkinData_" + cMCMLMesh.name) do obj.name = obj.name + " old data"--("SkinDataOld_" + cMCMLMesh.name)
	)
	skinUtils.ExtractSkinData cMCMLMesh
	local skinWeightMesh = getNodeByName ("SkinData_" + cMCMLMesh.name)
	return skinWeightMesh
)

--SE_AAH_CheckHierNamesMatch currentBones newBones
--matchBonesCount = SE_AAH_CheckHierBoneIDsMatch currentBones newBones

fn SE_AAH_CheckHierNamesMatch currentBones newBones matchBonesIndexesBTW =
(
	local matchedBones = #()
	if matchBonesIndexesBTW do
	(
		SE_AAH_SetBonesIndexesnTypes currentBones
		SE_AAH_ResetBonesIndexes newBones
	)
	for curBone in currentBones do
	(
		local matchFound = false
		for nwBone in newBones while matchFound == false do
		(
			if curBone.name == nwBone.name do
			(
				local boneUnique = true
				if matchedBones.count > 0 do
				(
					for mtchdBone in matchedBones do
					(
						if nwBone == mtchdBone do boneUnique = false
					)
				)
				if boneUnique do
				(
					append matchedBones nwBone
					if matchBonesIndexesBTW do setUserProp nwBone "BoneIndex" (getUserProp curBone "BoneIndex")
					matchFound = true
				)
			)
		)
	)
	return matchedBones.count
)

fn SE_AAH_CheckHierBoneIDsMatch currentBones newBones matchBonesIndexesBTW =
(
	local matchedBones = #()
	if matchBonesIndexesBTW do
	(
		SE_AAH_SetBonesIndexesnTypes currentBones
		SE_AAH_ResetBonesIndexes newBones
	)
	for curBone in currentBones do
	(
		local curBoneBoneID = SE_AAH_GetSubID 0 curBone
		if curBoneBoneID > -1 do
		(
			local matchFound = false
			for nwBone in newBones while matchFound == false do
			(
				local nwBoneBoneID = SE_AAH_GetSubID 0 nwBone
				if nwBoneBoneID > -1 do
				(
					if curBoneBoneID == nwBoneBoneID do
					(
						local boneUnique = true
						if matchedBones.count > 0 do
						(
							for mtchdBone in matchedBones do
							(
								if nwBone == mtchdBone do boneUnique = false
							)
						)
						if boneUnique do
						(
							append matchedBones nwBone
							if matchBonesIndexesBTW do setUserProp nwBone "BoneIndex" (getUserProp curBone "BoneIndex")
							nwBone.name = curBone.name
							matchFound = true
						)
					)
				)
			)
		)
	)
	return matchedBones.count
)

fn SE_AAH_CheckHierIndexesMatch currentBones newBones =
(
	local matchedBones = #()
	for curBone in currentBones do
	(
		local curBoneBoneIndex = -1
		if (getUserProp curBone "BoneIndex") != undefined do curBoneBoneIndex = getUserProp curBone "BoneIndex"
		if curBoneBoneIndex > -1 do
		(
			local matchFound = false
			for nwBone in newBones while matchFound == false do
			(
				local nwBoneBoneIndex = -1
				if (getUserProp nwBone "BoneIndex") != undefined do nwBoneBoneIndex = getUserProp nwBone "BoneIndex"
				if nwBoneBoneIndex > -1 do
				(
					if curBoneBoneIndex == nwBoneBoneIndex do
					(
						local boneUnique = true
						if matchedBones.count > 0 do
						(
							for mtchdBone in matchedBones do
							(
								if nwBone == mtchdBone do boneUnique = false
							)
						)
						if boneUnique do
						(
							append matchedBones nwBone
							nwBone.name = curBone.name
							local curBoneBoneID = SE_AAH_GetSubID 0 curBone
							if curBoneBoneID > -1 do
							(
								setUserProp nwBone "SubID" curBoneBoneID
								setUserProp nwBone "BoneID" curBoneBoneID
								setUserProp nwBone "BoneId" curBoneBoneID
							)
							matchFound = true
						)
					)
				)
			)
		)
	)
	return matchedBones.count
)

--local adBnsCount = SE_AAH_TransferWeights currentMeshes currentBones newBones chkbx_BATransferAnimation.state chkbx_BAResetScale.state chkbx_BATransferObjects.state chkbx_BASaveOriginal.state chkbx_BACleanModifiersList.state

fn SE_AAH_TransferWeights currentMeshes currentBones newBones BATransferAnimation BAResetScale BATransferObjects BASaveOriginal BACleanModifiersList =
(
	--local  adHierInfo = AdaptedHierarchyInfo 0 0
	--adHierInfo.adaptedMeshes += 1
	--adHierInfo.adaptedBones += 1
	local adBonesCount = 0
	
	SE_AAH_Process_Rollout.lbl_PrcssAAH.text = "Layers preparation..."
	SE_AAH_Process_Rollout.prgb_AAH.value = 20
	try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
	
	local newLayerName
	local oldBonesLayer = SE_AAH_GetUniqueHierarchyLayer currentBones -- -2 means impostor nodes in the same layer; -1 means hierarchy lays between different layers; proper layer means hierarchy has a proper unique layer
	if oldBonesLayer == -1 or oldBonesLayer == -2 do
	(
		oldBonesLayer = SE_AAH_CreateLayerForHierarchy currentBones ("Bones " + currentBones[1].name + " old layer")
	)
	oldBonesLayer.isHidden = true
	
	SE_AAH_Process_Rollout.lbl_PrcssAAH.text = "Animation transfering..."
	SE_AAH_Process_Rollout.prgb_AAH.value = 40
	try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
	
	if BATransferAnimation == true do SE_AAH_TransferAnimation currentBones newBones BATransferObjects
	newBones = SE_AAH_GetAllHierarchy newBones[1] 0 -- reasigning the array cause of the possible changings after SE_AAH_TransferAnimation
	
	if BACleanModifiersList == true do
	(
		SE_AAH_Process_Rollout.lbl_PrcssAAH.text = "Cleaning modifier list..."
		SE_AAH_Process_Rollout.prgb_AAH.value = 60
		try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
		for cMCMLMesh in currentMeshes do
		(
			if cMCMLMesh.modifiers.count > 0 do
			(
				for m in cMCMLMesh.modifiers do
				(
					if iskindof m Edit_Mesh or iskindof m Edit_Poly or iskindof m Skin then format "%: Found modifier: %\n" cMCMLMesh.name m.name
					else deleteModifier cMCMLMesh m
				)
			)
		)
	)
	
	SE_AAH_Process_Rollout.lbl_PrcssAAH.text = "Transfering bones' weights..."
	SE_AAH_Process_Rollout.prgb_AAH.value = 70
	try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
	
	local oldSliderTime = sliderTime
	sliderTime = 0.0f
	at time 0.0f -- sliderTime
	(
		for cMCMLMesh in currentMeshes do
		(
			local skinMeshBonesList = SE_AAH_GetSkinMeshBones cMCMLMesh --currentBonesTemp
			local skinMeshNewBonesList = SE_AAH_GetSkinMeshClonedBones skinMeshBonesList newBones
			local skinMeshNewTheLastofBonesList = SE_AAH_GetSkinMeshLastLeftClonedBones newBones skinMeshNewBonesList
			format "skinMeshBonesList: %, skinMeshNewBonesList: %, newBones: %, skinMeshNewTheLastofBonesList: %\n" skinMeshBonesList.count skinMeshNewBonesList.count newBones.count skinMeshNewTheLastofBonesList.count
			
			local skinWeightMesh = SE_AAH_CreateWeightMesh cMCMLMesh
			select cMCMLMesh
			collapseStack cMCMLMesh
			
			unfreeze cMCMLMesh DoLayer:true
			addModifier cMCMLMesh (Skin())
			setCommandPanelTaskMode #modify
			modPanel.setCurrentObject cMCMLMesh.skin --cMCMLMesh.modifiers[#Skin]
				
			for currentBCloneANode in skinMeshNewBonesList do
			(
				if currentBCloneANode != undefined do skinOps.addbone cMCMLMesh.modifiers[1] currentBCloneANode 1
			)
			
			clearselection()
			select cMCMLMesh
			selectmore skinWeightMesh
			skinUtils.ImportSkinDataNoDialog true false false false false 1.0 0
			
			select cMCMLMesh
			unfreeze cMCMLMesh DoLayer:true
			setCommandPanelTaskMode #modify
			modPanel.setCurrentObject cMCMLMesh.skin --cMCMLMesh.modifiers[#Skin]
			
			for currentBCloneANode in skinMeshNewTheLastofBonesList do
			(
				if currentBCloneANode != undefined do skinOps.addbone cMCMLMesh.modifiers[1] currentBCloneANode 1 -- add the left bones after SkinUtils because of the stupid Max "Exception" error. But we need these bones to make our skins more stable in other programs like Blender.
			)
			
			cMCMLMesh.wirecolor = (color 255 144 0)
			delete skinWeightMesh
		)
	)
	sliderTime = oldSliderTime
	
	if BASaveOriginal == false do
	(
		SE_AAH_Process_Rollout.lbl_PrcssAAH.text = "Deleting old hierarchy..."
		SE_AAH_Process_Rollout.prgb_AAH.value = 90
		try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
		
		for currentBonesDNode in currentBones do
		(
			if BATransferObjects == false or ClassOf currentBonesDNode == point or ClassOf currentBonesDNode == bone or ClassOf currentBonesDNode == dummy do
			(
				delete currentBonesDNode
			)
		)
		try (LayerManager.deleteLayerByName oldBonesLayer.name) catch()
	)
	adBonesCount = newBones.count
	
	--select currentBonesCloneArray[1]
	
	SE_AAH_Process_Rollout.lbl_PrcssAAH.text = "Skin weights transfering finished!"
	SE_AAH_Process_Rollout.prgb_AAH.value = 0
	try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
	
	
	
	
	return adBonesCount
)


-- struct AdaptedHierarchyInfo (adaptedMeshes, adaptedBones)
--local adBnsCount = SE_AAH_AdaptBones currentMeshes currentBones chkbx_BATransferAnimation.state chkbx_BAResetScale.state chkbx_BATransferObjects.state chkbx_BASaveOriginal.state chkbx_BACleanModifiersList.state

fn SE_AAH_AdaptBones currentMeshes currentBones BATransferAnimation BAResetScale BATransferObjects BASaveOriginal BACleanModifiersList =
(
	--local  adHierInfo = AdaptedHierarchyInfo 0 0
	--adHierInfo.adaptedMeshes += 1
	--adHierInfo.adaptedBones += 1
	local adBonesCount = 0
	
	
	
	SE_AAH_Process_Rollout.lbl_PrcssAAH.text = "Cloning hierarchy..."
	SE_AAH_Process_Rollout.prgb_AAH.value = 10
	try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
	
	if BAResetScale == true do
	(
		for currentBonesRSNode in currentBones do
		(
			if ClassOf currentBonesRSNode == point or ClassOf currentBonesRSNode == bone or ClassOf currentBonesRSNode == dummy or BATransferObjects == false do
			(
				if currentBonesRSNode != currentBones[1] do
				(
					if (in coordsys parent currentBonesRSNode.scale.x < 0.7) or (in coordsys parent currentBonesRSNode.scale.x > 1.3) or (in coordsys parent currentBonesRSNode.scale.y < 0.7) or (in coordsys parent currentBonesRSNode.scale.y > 1.3) or (in coordsys parent currentBonesRSNode.scale.z < 0.7) or (in coordsys parent currentBonesRSNode.scale.z > 1.3) do in coordsys parent currentBonesRSNode.scale = [1,1,1]
				)
			)
		)
	)
	SE_AAH_SetBonesIndexesnTypes currentBones
	try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
	
	local currentBonesCloneArray = SE_AAH_CloneHierarchy currentBones false false BATransferObjects false false false false 0 -- make a clone of the hierarchy with array of new helpers and new rotations
	SE_AAH_Process_Rollout.lbl_PrcssAAH.text = "Layers preparation..."
	SE_AAH_Process_Rollout.prgb_AAH.value = 20
	try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
	
	local newLayerName
	local oldBonesLayer = SE_AAH_GetUniqueHierarchyLayer currentBones -- -2 means impostor nodes in the same layer; -1 means hierarchy lays between different layers; proper layer means hierarchy has a proper unique layer
	if oldBonesLayer == -1 or oldBonesLayer == -2 then
	(
		oldBonesLayer = SE_AAH_CreateLayerForHierarchy currentBones ("Bones " + currentBones[1].name + " old layer")
		newLayerName = ("Bones " + currentBones[1].name + " clone layer")
	)
	else newLayerName = (oldBonesLayer.name + " clone layer")
	oldBonesLayer.isHidden = true
	local cHLayer = SE_AAH_CreateLayerForHierarchy currentBonesCloneArray newLayerName
	SE_AAH_Process_Rollout.lbl_PrcssAAH.text = "Bone rotations calculation..."
	SE_AAH_Process_Rollout.prgb_AAH.value = 30
	try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
	
	SE_AAH_CalculateBonesRotations currentBonesCloneArray  
	SE_AAH_Process_Rollout.lbl_PrcssAAH.text = "Animation transfering..."
	SE_AAH_Process_Rollout.prgb_AAH.value = 40
	try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
	
	if BATransferAnimation == true do SE_AAH_TransferAnimation currentBones currentBonesCloneArray BATransferObjects
	currentBonesCloneArray = SE_AAH_GetAllHierarchy currentBonesCloneArray[1] 0 -- reasigning the array cause of the possible changings after SE_AAH_TransferAnimation
	
	if BACleanModifiersList == true do
	(
		SE_AAH_Process_Rollout.lbl_PrcssAAH.text = "Cleaning modifier list..."
		SE_AAH_Process_Rollout.prgb_AAH.value = 60
		try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
		for cMCMLMesh in currentMeshes do
		(
			if cMCMLMesh.modifiers.count > 0 do
			(
				for m in cMCMLMesh.modifiers do
				(
					if iskindof m Edit_Mesh or iskindof m Edit_Poly or iskindof m Skin then format "%: Found modifier: %\n" cMCMLMesh.name m.name
					else deleteModifier cMCMLMesh m
				)
			)
		)
	)
	
	SE_AAH_Process_Rollout.lbl_PrcssAAH.text = "Transfering bones' weights..."
	SE_AAH_Process_Rollout.prgb_AAH.value = 70
	try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
	
	local oldSliderTime = sliderTime
	sliderTime = 0.0f
	at time 0.0f -- sliderTime
	(
		for cMCMLMesh in currentMeshes do
		(
			local skinMeshBonesList = SE_AAH_GetSkinMeshBones cMCMLMesh --currentBonesTemp
			local skinMeshCloneBonesList = SE_AAH_GetSkinMeshClonedBones skinMeshBonesList currentBonesCloneArray
			local skinMeshCloneTheLastofBonesList = SE_AAH_GetSkinMeshLastLeftClonedBones currentBonesCloneArray skinMeshCloneBonesList
			format "skinMeshBonesList: %, skinMeshCloneBonesList: %, currentBonesCloneArray: %, skinMeshCloneTheLastofBonesList: %\n" skinMeshBonesList.count skinMeshCloneBonesList.count currentBonesCloneArray.count skinMeshCloneTheLastofBonesList.count
			
			local skinWeightMesh = SE_AAH_CreateWeightMesh cMCMLMesh
			select cMCMLMesh
			collapseStack cMCMLMesh
			
			unfreeze cMCMLMesh DoLayer:true
			addModifier cMCMLMesh (Skin())
			setCommandPanelTaskMode #modify
			modPanel.setCurrentObject cMCMLMesh.skin --cMCMLMesh.modifiers[#Skin]
				
			for currentBCloneANode in skinMeshCloneBonesList do
			(
				if currentBCloneANode != undefined do skinOps.addbone cMCMLMesh.modifiers[1] currentBCloneANode 1
			)
			
			clearselection()
			select cMCMLMesh
			selectmore skinWeightMesh
			skinUtils.ImportSkinDataNoDialog true false false false false 1.0 0
			
			select cMCMLMesh
			unfreeze cMCMLMesh DoLayer:true
			setCommandPanelTaskMode #modify
			modPanel.setCurrentObject cMCMLMesh.skin --cMCMLMesh.modifiers[#Skin]
			
			for currentBCloneANode in skinMeshCloneTheLastofBonesList do
			(
				if currentBCloneANode != undefined do skinOps.addbone cMCMLMesh.modifiers[1] currentBCloneANode 1 -- add the left bones after SkinUtils because of the stupid Max "Exception" error. But we need these bones to make our skins more stable in other programs like Blender.
			)
			
			cMCMLMesh.wirecolor = (color 255 144 0)
			delete skinWeightMesh
		)
	)
	sliderTime = oldSliderTime
	
	if BASaveOriginal == false do
	(
		SE_AAH_Process_Rollout.lbl_PrcssAAH.text = "Deleting old hierarchy..."
		SE_AAH_Process_Rollout.prgb_AAH.value = 90
		try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
		
		for currentBonesDNode in currentBones do
		(
			if BATransferObjects == false or ClassOf currentBonesDNode == point or ClassOf currentBonesDNode == bone or ClassOf currentBonesDNode == dummy do
			(
				delete currentBonesDNode
			)
		)
		try (LayerManager.deleteLayerByName oldBonesLayer.name) catch()
	)
	adBonesCount = currentBonesCloneArray.count
	
	--select currentBonesCloneArray[1]
	
	SE_AAH_Process_Rollout.lbl_PrcssAAH.text = "Bone adaptation finished!"
	SE_AAH_Process_Rollout.prgb_AAH.value = 0
	try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
	
	
	
	
	return adBonesCount
)

fn SE_AAH_RoundUp2 RValue RAccValue =
(
	return ((ceil (RValue / RAccValue)) * RAccValue)
)

fn SE_AAH_CopyPasteTransform pickedTm targetTm pos rot scl =
(
	if pos do pickedTm.row4 = targetTm.row4
	if rot then
	(
		if scl then
		(
			pickedTm.row1 = targetTm.row1
			pickedTm.row2 = targetTm.row2
			pickedTm.row3 = targetTm.row3
		)
		else
		(
			pickedTm.row1 = (length pickedTm.row1) * normalize targetTm.row1
			pickedTm.row2 = (length pickedTm.row2) * normalize targetTm.row2
			pickedTm.row3 = (length pickedTm.row3) * normalize targetTm.row3
		)
	)
	else if scl do
	(
		pickedTm.row1 = (normalize pickedTm.row1) * length targetTm.row1
		pickedTm.row2 = (normalize pickedTm.row2) * length targetTm.row2
		pickedTm.row3 = (normalize pickedTm.row3) * length targetTm.row3
	)
	return pickedTm
)

fn SE_AAH_CopyPasteTransformToObject pickedObj targetTm parentCoords pos rot scl =
(
	if parentCoords == false then
	(
		if pos do pickedObj.transform.row4 = targetTm.row4
		if rot then
		(
			if scl then
			(
				pickedObj.transform.row1 = targetTm.row1
				pickedObj.transform.row2 = targetTm.row2
				pickedObj.transform.row3 = targetTm.row3
			)
			else
			(
				pickedObj.transform.row1 = (length pickedObj.transform.row1) * normalize targetTm.row1
				pickedObj.transform.row2 = (length pickedObj.transform.row2) * normalize targetTm.row2
				pickedObj.transform.row3 = (length pickedObj.transform.row3) * normalize targetTm.row3
			)
		)
		else if scl do
		(
			pickedObj.transform.row1 = (normalize pickedObj.transform.row1) * length targetTm.row1
			pickedObj.transform.row2 = (normalize pickedObj.transform.row2) * length targetTm.row2
			pickedObj.transform.row3 = (normalize pickedObj.transform.row3) * length targetTm.row3
		)
	)
	else
	(
		if pos do in coordsys parent pickedObj.transform.row4 = targetTm.row4
		if rot then
		(
			if scl then
			(
				in coordsys parent pickedObj.transform.row1 = targetTm.row1
				in coordsys parent pickedObj.transform.row2 = targetTm.row2
				in coordsys parent pickedObj.transform.row3 = targetTm.row3
			)
			else
			(
				in coordsys parent pickedObj.transform.row1 = (length (in coordsys parent pickedObj.transform.row1)) * normalize targetTm.row1
				in coordsys parent pickedObj.transform.row2 = (length (in coordsys parent pickedObj.transform.row2)) * normalize targetTm.row2
				in coordsys parent pickedObj.transform.row3 = (length (in coordsys parent pickedObj.transform.row3)) * normalize targetTm.row3
			)
		)
		else if scl do
		(
			in coordsys parent pickedObj.transform.row1 = (normalize (in coordsys parent pickedObj.transform.row1)) * length targetTm.row1
			in coordsys parent pickedObj.transform.row2 = (normalize (in coordsys parent pickedObj.transform.row2)) * length targetTm.row2
			in coordsys parent pickedObj.transform.row3 = (normalize (in coordsys parent pickedObj.transform.row3)) * length targetTm.row3
		)
	)
)


fn SE_AAH_ShowSubIDsInViewport =
(
	if SE_AAH_DrawSubIDsTrigger do
	(
		gw.setTransform(Matrix3 1) -- set active viewport’s graphics window transformation matrix to the world matrix
		if selection[1] != undefined and (selection[1].children.count > 0 OR selection[1].parent != undefined) do
		(
			local sHierBI = SE_AAH_GetAllHierarchy selection[1] 0
			for sHBINode in sHierBI do
			(
				local sHBINodeID = SE_AAH_GetSubID SE_AAH_DrawSubIDType sHBINode
				if sHBINodeID == -1 then gw.text sHBINode.pos ("-X-") color:red
				else 	gw.text sHBINode.pos ("ID: " + sHBINodeID as string) color:orange
			)
		)
		gw.enlargeUpdateRect #whole
		gw.updateScreen()
	)
)

/*********************************************************************************************************************************************************************/
--// PROCESS ROLLOUT
/*********************************************************************************************************************************************************************/

rollout SE_AAH_Process_Rollout "Process Info" width:132 height:30
(
	progressbar prgb_AAH color:orange tooltip:"Current process progress bar"
	label lbl_PrcssAAH "AAH is ready for use" align:#left tooltip:"Current process info"
	
	/*---------------------------------------------------------------------------------------------------*/
	/*---------------------------------------------------------------------------------------------------*/
	/*---------------------------------------------------------------------------------------------------*/
	
	fn ProgressInfoStatusUpdate =
	(
		if SE_AAH_ProcessUpdateFreezeTrigger == false do
		(
			if selection.count == 1 then
			(
				lbl_PrcssAAH.text = "Selected: " + $.name
				--try (lbl_PrcssAAH.tooltip = "Selected: " + $.name) catch() -- It works! Will update the script later.
			)
			else if selection.count > 1 then
			(
				lbl_PrcssAAH.text = "Selected few objects"
				--try (lbl_PrcssAAH.tooltip = "Current process info") catch()
			)
			else
			(
				lbl_PrcssAAH.text = "AAH is ready for use"
				--try (lbl_PrcssAAH.tooltip = "Current process info") catch()
			)
		)
	)
	
	/*---------------------------------------------------------------------------------------------------*/
	/*---------------------------------------------------------------------------------------------------*/
	/*---------------------------------------------------------------------------------------------------*/

	on SE_AAH_Process_Rollout open do
	(
		callbacks.addScript #selectionSetChanged "SE_AAH_Process_Rollout.ProgressInfoStatusUpdate()" id:#se_aah_processinfo
		ProgressInfoStatusUpdate() 
	)

	on SE_AAH_Process_Rollout close do
	(
		callbacks.removeScripts id:#se_aah_processinfo
	)
	
) --// end rollout

/*********************************************************************************************************************************************************************/
--// RIG TUNER ROLLOUT
/*********************************************************************************************************************************************************************/

rollout SE_AAH_Rig_Tuner_Rollout "Rig Tuner" width:132 height:170
(
	group "Create bones"
	(
		button btn_CreateRootB "Root" width:45 height:16 align:#left across:3 tooltip:"Creates a Root bone at the center of the scene."
		button btn_CreateChildB "+ Child" width:50 height:16 tooltip:"Adds children bone for the selected one.\n\nSelect ONE bone and push this button."
		button btn_CreateRollB "+ Roll" width:45 height:16 align:#right tooltip:"Adds roll/twist bone for the selected one.\n\nRoll/twist bone will be created halfway between selected bone and target one.\n\nSelect ONE bone and push this button."
	)
	group "Set SubID / BoneID / tag"
	(
		spinner spn_SubID "Set ID: " range:[-1, 100000, 0] type:#integer align:#left offset:[2,0] fieldwidth:45 across:2
		button btn_SubIDSet "Set!" width:27 height:16 pos:[112,72] tooltip:"Applies SubID/BoneID/Tag for selected sub-object/bone."
		--checkbutton btn_SubIDSet "Set!" width:27 height:18 pos:[112,75] highlightcolor:orange enabled:false tooltip:"Applies SubID/BoneID for selected sub-object/bone."
		--checkbutton cbtn_ReplaceAnim "Replace" width:52 align:#left highlightcolor:orange checked:true tooltip:"Completely replaces object's animation with the selected one since frame 0.\nOtherwise applies selected animation after selected frame." across:2 enabled:false
		button btn_AutoSetSubIDs "Auto..." height:16 across:2 tooltip:"Tools for automatic set of SubID/BoneID/Tag parameters for hierarchy.\n\nSelect any sub-object/bone of hierarchy and push this button."
		button btn_ManualSetSubIDs "Manual..." height:16 across:2 tooltip:"UNDER DEVELOPMENT.\nUse this tool to manually set SubID/BoneID/Tag parameters for hierarchy.\n\nSelect any sub-object/bone of hierarchy and push this button."
	)
	group "Indexes and Types of bones"
	(
		button btn_SetBoneIdxsnTypes "Calculate for all hierarchy" width:140 height:16 tooltip:"Automatically calculates BoneType and BoneIndex parameters for custom bone hierarchy.\n\nQuick tip: it's better to calculate these values automatically.\n\nBoneIndex:\nJust the index of the bone. It need to be in order one after the other.\n\nBoneType:\nSpecial additional value that indicates the bone's type for the engine (does it have the children bone or not, is it the latest bone in the branch or not).\n1 or 3 - bones that don't have children bones\n0 or 2 - bones that have children bones\nIf there are a few children bones under the parent bone - all children bones must be 2 or 3, but the last one must be 0 or 1.\nIf there's only one children bone - this children bone must be 0 or 1.\n\nSelect any bone of hierarchy and push this button."
	)
	button btn_CheckHierarchyParams "ANALYSE HIERARCHY PARAMS" height:20 tooltip:"Reads all the SubID/BoneID/BoneId/Tag/BoneIndex/BoneType parameters and shows the analyse result.\nUse this if you're not sure of your SubID/BoneID/BoneId/Tag/BoneIndex/BoneType sets.\n\nSelect any sub-object/bone of hierarchy and push this button."
	group "Clone hierarchy"
	(
		button btn_CloneHierarchy "Whole" width:40 height:16 align:#left across:3 tooltip:"(Whole hierarchy)\nClones the hierarchy.\nAlso automatically calculates BoneIndex parameters for whole bone hierarchy.\n\nSelect any bone of hierarchy and push this button."
		checkbox chkbx_DontReplaceBones "Orig" checked:false tooltip:"(Original)\nIf checked, it will clone the bones with the same type of objects, like it was in the original. Otherwise will replace bones with helpers.\n\nThere're some bugs during cloning some systems like Biped or CAT, that's why it's disabled by default and recommended to activate ONLY if you know what you're doing."
		checkbox chkbx_FullTransformCopy "FullTF" align:#right checked:true tooltip:"(Full Transform)\nIf checked, it will clone the bones' full transformation (positions, rotations and scale), like it was in the original.\nOtherwise will clone positions only."
		button btn_CloneChildren "Partial" width:42 height:16 align:#left across:2 tooltip:"(Partial)\nClones the selected children bone and it's children hierarchy, if needed. Use this, if you want to clone a bodypart, like hand or foot.\nAlso automatically calculates BoneIndex parameters for whole bone hierarchy.\n\nSelect any bone of hierarchy and push this button."
		checkbox chkbx_CloneChildrenAutoSetID "Calculate SubIDs" align:#right checked:true tooltip:"If checked, it recalculate cloned bones' SubID parameters automatically."
		checkbox chkbx_CloneChildrenCalculateSubIDsInSeqOrder "Calc IDs in sequential order" align:#left checked:true enabled:false tooltip:"If checked, it will calculate SubID/BoneID/BoneId/tag just in sequential order (like BoneIndex), nothing fancy."
		checkbox chkbx_CloneChildrenMirror "Mirror cloned" align:#left checked:false across:2 tooltip:"If checked, it will move and rotate (if the checkbox on the right is selected too) cloned bones regarding the selected axis."
		checkbox chkbx_CloneChildrenMirrorRotations "Rots" align:#right checked:true enabled:true tooltip:"If checked, it will Rotate cloned bones regarding the selected axis.\nOtherwise it will move them only."
		radiobuttons rb_CloneChildrenMirror "by parent Axis:" labels:#("X", "Y","Z", "XY", "YZ","ZX", "XYZ") columns:3 align:#left enabled:true tooltip:"You can choose the axis you want to mirror cloned bones."
		checkbox chkbx_CloneChildrenXAxisRotated "Bones X-Axis rotated" align:#left checked:false enabled:false tooltip:"If checked, it will rotate cloned bones the way loax X-Axis will always look at the children bone."
		checkbox chkbx_CloneChildrenRenameMirrored "Rename (L>R and L<R)" align:#left checked:false enabled:false tooltip:"If checked, it will rename cloned Left bones to Right, and vice versa."
	)
	group "Bones' rotations"
	(
		button btn_CalcHierRotations "Calc hier rot" width:70 height:16 align:#left across:2 tooltip:"Calculate all hierarchy rotations.\n\nAutomatically calculates bones' rotations in the whole hierarchy to X axis.\nAlso automatically calculates BoneIndex parameters for whole bone hierarchy.\n\nSelect any bone of hierarchy and push this button."
		button btn_CalcSelectedBonesRotations "Only selected" width:77 height:16 align:#right tooltip:"Calculate selected bones' rotations.\n\nAutomatically calculates selected bones' rotations to X axis.\nIt's possible to set a specific bone orientation (to the needed bone), if one bone selected.\nAlso automatically calculates BoneIndex parameters for whole bone hierarchy.\n\nSelect any bone of hierarchy and push this button."
	)
	group "Skin Weights transfer"
	(
		button btn_SkinWeightsTransfer "Transfer" width:55 height:16 align:#left across:2 tooltip:"Transfer skin weights from the current (old) bone hierarchy to the new one.\nCan transfer animation from the old hierarchy to the new one.\nAlso automatically calculates BoneIndex parameters for bone hierarchy.\n\nSelect any bone of hierarchy and push this button."
		checkbox chkbx_SWTTransferAnimation "with Anim" align:#right checked:true tooltip:"If checked, it will transfer animation from the old bone hierarchy to the new one."
		checkbox chkbx_SWTResetScale "RS" across:4 align:#left checked:false tooltip:"Reset scale.\n\nIf checked, it will reset scale for all the bones (except the main Root bone/controller) to the default while skin weights transfering, if their scale is less than 0,7 or more than 1,3 than the default scale.\nOtherwise you can reset bones' scales manually, if you need.\n\nUse this if you have some scale problems while animation conversions from Maya or other programs."
		checkbox chkbx_SWTTransferObjects "BO" checked:false tooltip:"Bake objects' animation.\n\nIf checked, it will bake linked objects' animation to the world position."
		checkbox chkbx_SWTSaveOriginal "SO" checked:false tooltip:"Save original hierarchy.\n\nIf checked, it will save original bone hierarchy in hidden layer."
		checkbox chkbx_SWTCleanModifiersList "CM" align:#right checked:true tooltip:"Clean modifiers list.\n\nIf checked, it will clean character's modifier list before adaptation.\n\nIt's important in most of the situations, that's why its checked by default. Uncheck ONLY if you KNOW what you're doing!"
	)
	group "Automatic Skeleton Adaptation"--"Extra tools"
	(
		--checkbutton setup "Setup" checked:true tooltip:"Opens setup panels"
		--button theButton iconName:@"PolyTools\TransformTools\PB_CW" iconSize:[20,20]
		--button theBorderlessButton2 "I am a button, too!" border:false
		button btn_BonesAdaptationTool "Skel Adapt" across:2 height:16 align:#left tooltip:"Skeleton adaptation.\n\nCreates a clone of hierarchy, automatically calculates proper rotation values.\nCan transfer animation from the old hierarchy to the new one.\nAlso automatically calculates BoneIndex parameters for bone hierarchy.\n\nSelect any bone of hierarchy and push this button."
		checkbox chkbx_BATransferAnimation "with Anim" align:#right checked:true tooltip:"If checked, it will transfer animation from the old bone hierarchy to the new one."
		checkbox chkbx_BAResetScale "RS" across:4 align:#left checked:true tooltip:"Reset scale.\n\nIf checked, it will reset scale for all the bones (except the main Root bone/controller) to the default while skeleton adaptation, if their scale is less than 0,7 or more than 1,3 than the default scale.\nOtherwise you can reset bones' scales manually, if you need.\n\nUse this if you have some scale problems while animation conversions from Maya or other programs."
		checkbox chkbx_BATransferObjects "BO" checked:true tooltip:"Bake objects' animation.\n\nIf checked, it will bake linked objects' animation to the world position."
		checkbox chkbx_BASaveOriginal "SO" checked:false tooltip:"Save original hierarchy.\n\nIf checked, it will save original bone hierarchy in hidden layer."
		checkbox chkbx_BACleanModifiersList "CM" align:#right checked:true tooltip:"Clean modifiers list.\n\nIf checked, it will clean character's modifier list before adaptation.\n\nIt's important in most of the situations, that's why its checked by default. Uncheck ONLY if you KNOW what you're doing!"
		button btn_SceneBonesAdaptationTool "Scene Adapt" across:2 height:16 align:#left tooltip:"Whole scene adaptation.\n\nDoes the same thing as the ''Skeleton adaptation'' above, but with all the characters in the scene, just in one click.\n\nCreates a clone of hierarchy for each character, automatically calculates proper rotation values.\nCan transfer animation from the old hierarchy to the new one.\nAlso automatically calculates BoneIndex parameters for bone hierarchy."
		button btn_TestHierarchy "Test hier" width:55 height:16 align:#right tooltip:"Test your bone hierarchy to see its dimensions and direction axis.\n\nCreates a boundary box and the direction axis box (you can delete them later, if you don't need them).\nAlso automatically calculates BoneIndex parameters for whole bone hierarchy.\n\nSelect any bone of hierarchy and push this button."
	)
	group "Extra tools"
	(
		button btn_ResetObjectsTFs "Reset objs TF" across:2 height:16 align:#left tooltip:"Resets objects' transforms (Xforms and pivots).\n\nCould be useful in cases of future rigging export problems.\n\nSelect all the needed objects and push this button."
		checkbox chkbx_RPivotToTheSceneCenter "Scn cntr" align:#right checked:true tooltip:"If checked, it will reset pivot of each object to the center of the scene.\nOtherwise, pivots will be centered to the object's center."
		button btn_CreateUniqueLayerForHier "Create Layer for hierarchy" height:16 tooltip:"Creates a unique layer for selected objects/bones.\n\nSelect any bone of hierarchy and push this button."
	)
	
	rollout AutoSubIDSetTool "Automatic SubID Set Tool" width:320 height:200
	(
		radiobuttons rb_ShowInViewportSubIDType "Show in viewport:" labels:#("SubID", "BoneID","BoneId","tag") columns:4 enabled:true tooltip:"You can choose what type of SubID/BoneID/BoneId/Tag parameters you want to see in selected viewport in real time."
		
		button btn_AutoCheckHierarchyParams "ANALYSE HIERARCHY PARAMS" height:20 tooltip:"Reads all the SubID/BoneID/BoneId/Tag/BoneIndex/BoneType parameters and shows the analyse result.\nUse this if you're not sure of your SubID/BoneID/BoneId/Tag/BoneIndex/BoneType sets.\n\nSelect any sub-object/bone of hierarchy and push this button."
		button btn_AutoInfoUpdate "INFO UPDATE" height:20 tooltip:"Press this button to update all the following columns, and see fresh info."
		button btn_UnifyBySubID "Unify by AA's SubID" height:16 align:#left across:3 tooltip:"Automatically sets SubID/BoneID/BoneId/tag parameters for hierarchy, by unifying them from SubID (\"Another Animation\" Scripts ID parameter) to other types.\n\nIt means that SubID parameter will be applied to all the other ones.\n\nSelect any sub-object/bone of hierarchy and push this button."
		checkbutton ib_SubIDCheck "Status:" height:16 width:45 highlightColor:[85,75,65] checked:true enabled:false align:#center offset:[50,0]
		checkbutton cbtn_SubIDCheck "INCORRECT!" height:16 width:70 highlightcolor:[127,0,14] checked:true enabled:false align:#right offset:[0,0] tooltip:"The result of testing AA's SubID parameters.\nIf all the bones has a unique SubID parameter - the test's result will be green \"CORRECT!\".\nOtherwise it will be red \"INCORRECT!\"."
		button btn_UnifyByBoneID "Unify by Kam's BoneID" height:16 align:#left across:3 tooltip:"Automatically sets SubID/BoneID/BoneId/tag parameters for hierarchy, by unifying them from BoneID (\"Kam's scripts\" ID parameter) to other types.\n\nIt means that BoneID parameter will be applied to all the other ones.\n\nSelect any sub-object/bone of hierarchy and push this button."
		checkbutton ib_BoneIDCheck "Status:" height:16 width:45 highlightColor:[85,75,65] checked:true enabled:false align:#center offset:[50,0]
		checkbutton cbtn_BoneIDCheck "INCORRECT!" height:16 width:70 highlightcolor:[127,0,14] checked:true enabled:false align:#right offset:[0,0] tooltip:"The result of testing Kam's BoneID parameters.\nIf all the bones has a unique BoneID parameter - the test's result will be green \"CORRECT!\".\nOtherwise it will be red \"INCORRECT!\"."
		button btn_UnifyByBoneIdSeggaeman "Unify by Seggaeman's BoneId" height:16 align:#left across:3 tooltip:"Automatically sets SubID/BoneID/BoneId/tag parameters for hierarchy, by unifying them from BoneId (\"Seggaeman's DFF plugin\" ID parameter, very rare stuff) to other types.\n\nIt means that BoneId parameter will be applied to all the other ones.\n\nSelect any sub-object/bone of hierarchy and push this button."
		checkbutton ib_BoneIdSeggaemanCheck "Status:" height:16 width:45 highlightColor:[85,75,65] checked:true enabled:false align:#center offset:[50,0]
		checkbutton cbtn_BoneIdSeggaemanCheck "INCORRECT!" height:16 width:70 highlightcolor:[127,0,14] checked:true enabled:false align:#right offset:[0,0] tooltip:"The result of testing Seggaeman's BoneId parameters.\nIf all the bones has a unique BoneId parameter - the test's result will be green \"CORRECT!\".\nOtherwise it will be red \"INCORRECT!\"."
		button btn_UnifyByTag "Unify by aap's tag" height:16 align:#left across:3 tooltip:"Automatically sets SubID/BoneID/BoneId/tag parameters for hierarchy, by unifying them from tag (\"The Hero/aap's DFF plugin\" ID parameter) to other types.\n\nIt means that tag parameter will be applied to all the other ones.\n\nSelect any sub-object/bone of hierarchy and push this button."
		checkbutton ib_TagCheck "Status:" height:16 width:45 highlightColor:[85,75,65] checked:true enabled:false align:#center offset:[50,0]
		checkbutton cbtn_TagCheck "INCORRECT!" height:16 width:70 highlightcolor:[127,0,14] checked:true enabled:false align:#right offset:[0,0] tooltip:"The result of testing The Hero/aap's tag parameters.\nIf all the bones has a unique tag parameter - the test's result will be green \"CORRECT!\".\nOtherwise it will be red \"INCORRECT!\"."
		
		button btn_CalculateSubIDs "Calculate whole new Sub IDs" height:16 align:#left across:2 tooltip:"Automatically calculates SubID/BoneID/BoneId/tag parameters for hierarchy.\n\nUse this tool if you don't need to indicate some bodyparts and you just need all SubID/BoneID parameters to be in order one after the other.\n\nSelect any sub-object/bone of hierarchy and push this button."
		checkbox chkbx_CalculateSubIDsInSeqOrder "in sequential order" align:#right checked:true enabled:false tooltip:"If checked, it will calculate SubID/BoneID/BoneId/tag just in sequential order (like BoneIndex), nothing fancy."
		
		
		fn UpdateSubIDAnalyse =
		(
			if selection[1] != undefined and (selection[1].children.count > 0 OR selection[1].parent != undefined) then
			(
				local finalHierAnalyseInfo = SE_AAH_AnalyseHierarchy selection[1] false -- hierAA, subAA, hierKams, subKams, hierSeggaeman, subSeggaeman, hieraap, subaap
				if finalHierAnalyseInfo.subAA == true then
				(
					cbtn_SubIDCheck.caption = "CORRECT!"
					cbtn_SubIDCheck.highlightcolor = [0,127,14]
					cbtn_SubIDCheck.tooltip = "AA's SubID parameters are just FINE!\nYou can use it to Unify other types to them."
				)
				else
				(
					cbtn_SubIDCheck.caption = "INCORRECT!"
					cbtn_SubIDCheck.highlightcolor = [127,0,14]
					cbtn_SubIDCheck.tooltip = "AA's SubID parameters are WRONG!\nRecalculate them or Unify by OTHER types."
				)
				if finalHierAnalyseInfo.subKams == true then
				(
					cbtn_BoneIDCheck.caption = "CORRECT!"
					cbtn_BoneIDCheck.highlightcolor = [0,127,14]
					cbtn_BoneIDCheck.tooltip = "Kam's BoneID parameters are just FINE!\nYou can use it to Unify other types to them."
				)
				else
				(
					cbtn_BoneIDCheck.caption = "INCORRECT!"
					cbtn_BoneIDCheck.highlightcolor = [127,0,14]
					cbtn_BoneIDCheck.tooltip = "Kam's BoneID parameters are WRONG!\nRecalculate them or Unify by OTHER types."
				)
				if finalHierAnalyseInfo.subSeggaeman == true then
				(
					cbtn_BoneIdSeggaemanCheck.caption = "CORRECT!"
					cbtn_BoneIdSeggaemanCheck.highlightcolor = [0,127,14]
					cbtn_BoneIdSeggaemanCheck.tooltip = "Seggaeman's BoneId parameters are just FINE!\nYou can use it to Unify other types to them."
				)
				else
				(
					cbtn_BoneIdSeggaemanCheck.caption = "INCORRECT!"
					cbtn_BoneIdSeggaemanCheck.highlightcolor = [127,0,14]
					cbtn_BoneIdSeggaemanCheck.tooltip = "Seggaeman's BoneId parameters are WRONG!\nRecalculate them or Unify by OTHER types."
				)
				if finalHierAnalyseInfo.subaap == true then
				(
					cbtn_TagCheck.caption = "CORRECT!"
					cbtn_TagCheck.highlightcolor = [0,127,14]
					cbtn_TagCheck.tooltip = "The Hero/aap's tag parameters are just FINE!\nYou can use it to Unify other types to them."
				)
				else
				(
					cbtn_TagCheck.caption = "INCORRECT!"
					cbtn_TagCheck.highlightcolor = [127,0,14]
					cbtn_TagCheck.tooltip = "The Hero/aap's tag parameters are WRONG!\nRecalculate them or Unify by OTHER types."
				)
			)
			else
			(
				cbtn_SubIDCheck.caption = "-"
				cbtn_SubIDCheck.highlightcolor = [85,75,65]
				cbtn_SubIDCheck.tooltip = "The result of testing AA's SubID parameters.\nIf all the bones has a unique SubID parameter - the test's result will be green \"CORRECT!\".\nOtherwise it will be red \"INCORRECT!\"."
				cbtn_BoneIDCheck.caption = "-"
				cbtn_BoneIDCheck.highlightcolor = [85,75,65]
				cbtn_BoneIDCheck.tooltip = "The result of testing Kam's BoneID parameters.\nIf all the bones has a unique BoneID parameter - the test's result will be green \"CORRECT!\".\nOtherwise it will be red \"INCORRECT!\"."
				cbtn_BoneIdSeggaemanCheck.caption = "-"
				cbtn_BoneIdSeggaemanCheck.highlightcolor = [85,75,65]
				cbtn_BoneIdSeggaemanCheck.tooltip = "The result of testing Seggaeman's BoneId parameters.\nIf all the bones has a unique BoneId parameter - the test's result will be green \"CORRECT!\".\nOtherwise it will be red \"INCORRECT!\"."
				cbtn_TagCheck.caption = "-"
				cbtn_TagCheck.highlightcolor = [85,75,65]
				cbtn_TagCheck.tooltip = "The result of testing aap's tag parameters.\nIf all the bones has a unique tag parameter - the test's result will be green \"CORRECT!\".\nOtherwise it will be red \"INCORRECT!\"."
			)
			
			if SE_AAH_ProcessUpdateFreezeTrigger == false do
			(
				if selection.count > 0 then
				(
					btn_CheckHierarchyParams.enabled = true
					btn_SetBoneIdxsnTypes.enabled = true
					btn_CloneHierarchy.enabled = true
					btn_CloneChildren.enabled = true
					btn_TestHierarchy.enabled = true
					btn_CalcHierRotations.enabled = true
					btn_CalcSelectedBonesRotations.enabled = true
					btn_BonesAdaptationTool.enabled = true
					if selection.count == 1 then
					(
						spn_SubID.value = SE_AAH_GetSubID 0 $
						spn_SubID.enabled = true
						btn_SubIDSet.enabled = true
						btn_CreateChildB.enabled = true
						btn_CreateRollB.enabled = true
					)
					else
					(
						spn_SubID.value = 0
						spn_SubID.enabled = false
						btn_SubIDSet.enabled = false
						btn_CreateChildB.enabled = false
						btn_CreateRollB.enabled = false
					)
					if SE_AAH_DrawSubIDsTrigger then
					(
						registerRedrawViewsCallback SE_AAH_ShowSubIDsInViewport -- thanks aleks926820 for the idea
					)
					else
					(
						unRegisterRedrawViewsCallback SE_AAH_ShowSubIDsInViewport
					)
				)
				else
				(
					spn_SubID.value = 0
					spn_SubID.enabled = false
					btn_SubIDSet.enabled = false
					btn_CreateChildB.enabled = false
					btn_CreateRollB.enabled = false
					
					btn_CheckHierarchyParams.enabled = false
					btn_SetBoneIdxsnTypes.enabled = false
					btn_CloneHierarchy.enabled = false
					btn_CloneChildren.enabled = false
					btn_TestHierarchy.enabled = false
					btn_CalcHierRotations.enabled = false
					btn_CalcSelectedBonesRotations.enabled = false
					btn_BonesAdaptationTool.enabled = false
					
					unRegisterRedrawViewsCallback SE_AAH_ShowSubIDsInViewport
				)
			)
		)
		
		
		
		on AutoSubIDSetTool open do
		(
			--callbacks.addScript #selectionSetChanged "SE_AAH_Rig_Tuner_Rollout.SubIDsAndFrameNames()" id:#se_aah_rigtuner
			--SubIDsAndFrameNames()
			SE_AAH_AutoSubIDSetToolEnabled = true
			SE_AAH_DrawSubIDType = 1
			rb_ShowInViewportSubIDType.state = 1
			if SE_AAH_DrawSubIDsTrigger == false do
			(
				SE_AAH_DrawSubIDsTrigger = true
				registerRedrawViewsCallback SE_AAH_ShowSubIDsInViewport -- thanks aleks926820 for the idea
			)
			UpdateSubIDAnalyse()
		)

		on AutoSubIDSetTool close do
		(
			--callbacks.removeScripts id:#se_aah_rigtuner
			SE_AAH_AutoSubIDSetToolEnabled = false
			if SE_AAH_ManualSubIDSetToolEnabled == false do
			(
				SE_AAH_DrawSubIDsTrigger = false
				unRegisterRedrawViewsCallback SE_AAH_ShowSubIDsInViewport
			)
		)
		
		on rb_ShowInViewportSubIDType changed theState do 
		(
			if rb_ShowInViewportSubIDType.state == 1 then
			(
				SE_AAH_DrawSubIDType = 1
			)
			else if rb_ShowInViewportSubIDType.state == 2 then
			(
				SE_AAH_DrawSubIDType = 2
			)
			else if rb_ShowInViewportSubIDType.state == 3 then
			(
				SE_AAH_DrawSubIDType = 3
			)
			else if rb_ShowInViewportSubIDType.state == 4 do
			(
				SE_AAH_DrawSubIDType = 4
			)
			UpdateSubIDAnalyse()
		)
		
		on btn_AutoCheckHierarchyParams pressed do
		(
			if selection[1] != undefined and (selection[1].children.count > 0 OR selection[1].parent != undefined) then
			(
				--SE_AAH_UpdateOrCreateAAHHelperLayer()
				local finalHierAnalyseInfo = SE_AAH_AnalyseHierarchy selection[1] true -- hierAA, subAA, hierKams, subKams, hierSeggaeman, subSeggaeman, hieraap, subaap
				--if finalHierAnalyseInfo.hierAA == true and finalHierAnalyseInfo.hierKams == true and finalHierAnalyseInfo.hierSeggaeman == true and finalHierAnalyseInfo.hieraap == true then messageBox "Noice!\n" title:"Cool"
				--else messageBox "Looser!\n" title:"Not cool"
			)
			else messageBox "You picked the wrong house, fool!\n(Select any bone of hierarchy and THEN push that button!)\n" title:"ERROR"
		)
		
		on btn_AutoInfoUpdate pressed do
		(
			UpdateSubIDAnalyse()
		)
		
		on btn_UnifyBySubID pressed do
		(
			if (queryBox "Have you selected any bone of hierarchy?" title:"ATTENTION") do
			(
				if selection[1] != undefined and (selection[1].children.count > 0 OR selection[1].parent != undefined) then
				(
					SE_AAH_UnifySubIDParamsFinally 1 "AA's SubID" "SubID" "BoneID" "BoneId" "tag" true
					UpdateSubIDAnalyse()
				)
				else messageBox "You picked the wrong house, fool!\n(Select any bone of hierarchy and THEN push that button!)\n" title:"ERROR"
			)
		)
		
		on btn_UnifyByBoneID pressed do
		(
			if (queryBox "Have you selected any bone of hierarchy?" title:"ATTENTION") do
			(
				if selection[1] != undefined and (selection[1].children.count > 0 OR selection[1].parent != undefined) then
				(
					SE_AAH_UnifySubIDParamsFinally 2 "Kam's BoneID" "BoneID" "SubID" "BoneId" "tag" true
					UpdateSubIDAnalyse()
				)
				else messageBox "You picked the wrong house, fool!\n(Select any bone of hierarchy and THEN push that button!)\n" title:"ERROR"
			)
		)
		
		on btn_UnifyByBoneIdSeggaeman pressed do
		(
			if (queryBox "Have you selected any bone of hierarchy?" title:"ATTENTION") do
			(
				if selection[1] != undefined and (selection[1].children.count > 0 OR selection[1].parent != undefined) then
				(
					SE_AAH_UnifySubIDParamsFinally 3 "Seggaeman's BoneId" "BoneId" "SubID" "BoneID" "tag" true
					UpdateSubIDAnalyse()
				)
				else messageBox "You picked the wrong house, fool!\n(Select any bone of hierarchy and THEN push that button!)\n" title:"ERROR"
			)
		)
		
		on btn_UnifyByTag pressed do
		(
			if (queryBox "Have you selected any bone of hierarchy?" title:"ATTENTION") do
			(
				if selection[1] != undefined and (selection[1].children.count > 0 OR selection[1].parent != undefined) then
				(
					SE_AAH_UnifySubIDParamsFinally 4 "The Hero/aap's tag" "tag" "SubID" "BoneID" "BoneId" true
					UpdateSubIDAnalyse()
				)
				else messageBox "You picked the wrong house, fool!\n(Select any bone of hierarchy and THEN push that button!)\n" title:"ERROR"
			)
		)
		
		on btn_CalculateSubIDs pressed do
		(
			if (queryBox "Have you selected any bone of hierarchy?" title:"ATTENTION") do
			(
				if selection[1] != undefined then
				(
					if selection[1].target != undefined then
					(
						setUserProp selection[1] "SubID" 0
						setUserProp selection[1] "BoneID" 0
						setUserProp selection[1] "BoneId" 0
						setUserProp selection[1] "tag" 0
						setUserProp selection[1].target "SubID" 1
						setUserProp selection[1].target "BoneID" 1
						setUserProp selection[1].target "BoneId" 1
						setUserProp selection[1].target "tag" 1
					)
					else
					(
						if selection[1] != undefined and (selection[1].children.count > 0 OR selection[1].parent != undefined) then
						(
							local sHier = SE_AAH_GetAllHierarchy selection[1] 0
							local newSubID = 0
							for s in sHier do
							(
								setUserProp s "SubID" newSubID
								setUserProp s "BoneID" newSubID
								setUserProp s "BoneId" newSubID
								setUserProp s "tag" newSubID
								newSubID = newSubID + 1
							)
							UpdateSubIDAnalyse()
							--SE_AAH_ShowSubIDsInViewport
							--try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
							messagebox "Now your hierarchy's SubIDs are ready for the game!" title:"Done!"
						)
						else messageBox "You picked the wrong house, fool!\n(Select any bone of hierarchy and THEN push that button!)\n" title:"ERROR"
					)
				)
				else messageBox "You picked the wrong house, fool!\n(Select any bone of hierarchy and THEN push that button!)\n" title:"ERROR"
			)
		)
	)
	
	
	rollout ManualSubIDSetTool "Manual SubID Set Tool (UNDER DEVELOPMENT)" width:300 height:400
	(
		radiobuttons rb_ShowInViewportSubIDTypeMan "Show in viewport:" labels:#("SubID", "BoneID","BoneId","tag") columns:4 enabled:true tooltip:"You can choose what type of SubID/BoneID/BoneId/Tag parameters you want to see in selected viewport in real time."
		button btn_TestHierarchy2 "Test hier2" width:55 height:16 align:#right tooltip:"Test your bone hierarchy.\nAlso automatically calculates BoneIndex parameters for whole bone hierarchy.\n\nSelect any bone of hierarchy and push this button."
		checkbox chkbx_SetSubIDs "Set SubID / BoneID / tag" align:#left checked:true across:2 tooltip:"Set SubID/BoneID/Tag by this tool. Select need bone, then select needed bone type from the list down here."
		checkbox chkbx_SetNamesToo "Set names too" align:#right checked:false tooltip:"If checked, it will clone the bones with the same type of objects, like it was in the original. Otherwise will replace bones with helpers.\n\nThere're some bugs during cloning some systems like Biped or CAT, that's why it's disabled by default and recommended to activate ONLY if you know what you're doing."
		button btn_SetBRoot "Root" height:16 tooltip:"Set the Root bone (main bone in the hierarchy)." --border:false 
		button btn_SetBPelvis "Pelvis" height:16 tooltip:"Set the Pelvis bone (the parent bone of legs and (sometimes) spine bone)."
		button btn_SetBRThigh "R Thigh" height:16 across:2 tooltip:"Set the R Thigh bone (right thigh bone)."
		button btn_SetBLThigh "L Thigh" height:16 tooltip:"Set the L Thigh bone (left thigh bone)."
		button btn_SetBRCalf "R Calf" height:16 across:2 tooltip:"Set the R Calf bone (right calf bone)."
		button btn_SetBLCalf "L Calf" height:16 tooltip:"Set the L Calf bone (left calf bone)."
		button btn_SetBRFoot "R Foot" height:16 across:2 tooltip:"Set the R Foot bone (right foot bone)."
		button btn_SetBLFoot "L Foot" height:16 tooltip:"Set the L Foot bone (left foot bone)."
		button btn_SetBRToe0 "R Toe0" height:16 across:2 tooltip:"Set the R Toe0 bone (right toe bone)."
		button btn_SetBLToe0 "L Toe0" height:16 tooltip:"Set the L Toe0 bone (left toe bone)."
		
		
		
		
		button btn_SetBSpine "Spine" height:16 tooltip:"Set the Spine bone (the first bone of the spine)."
		button btn_SetBSpine1 "Spine1" height:16 tooltip:"Set the Spine1 bone (the second bone of the spine)."
		button btn_SetBSpine2 "Spine2" height:16 across:5 tooltip:"Set the Spine2 bone or analog."
		button btn_SetBSpine3 "Spine3" height:16 tooltip:"Set the Spine3 bone or analog."
		button btn_SetBSpine4 "Spine4" height:16 tooltip:"Set the Spine4 bone or analog."
		button btn_SetBSpine5 "Spine5" height:16 tooltip:"Set the Spine5 bone or analog."
		button btn_SetBSpine6 "Spine6" height:16 tooltip:"Set the Spine6 bone or analog."
		button btn_SetBSpine7 "Spine7" height:16 across:5 tooltip:"Set the Spine7 bone or analog."
		button btn_SetBSpine8 "Spine8" height:16 tooltip:"Set the Spine8 bone or analog."
		button btn_SetBSpine9 "Spine9" height:16 tooltip:"Set the Spine9 bone or analog."
		button btn_SetBSpine10 "Spine10" height:16 tooltip:"Set the Spine10 bone or analog."
		button btn_SetBSpine11 "Spine11" height:16 tooltip:"Set the Spine11 bone or analog."
		button btn_SetBSpine12 "Spine12" height:16 across:5 tooltip:"Set the Spine12 bone or analog."
		button btn_SetBSpine13 "Spine13" height:16 tooltip:"Set the Spine13 bone or analog."
		button btn_SetBSpine14 "Spine14" height:16 tooltip:"Set the Spine14 bone or analog."
		button btn_SetBSpine15 "Spine15" height:16 tooltip:"Set the Spine15 bone or analog."
		button btn_SetBSpine16 "Spine16" height:16 tooltip:"Set the Spine16 bone or analog."
		
		
		on ManualSubIDSetTool open do
		(
			--callbacks.addScript #selectionSetChanged "SE_AAH_Rig_Tuner_Rollout.SubIDsAndFrameNames()" id:#se_aah_rigtuner
			--SubIDsAndFrameNames()
			SE_AAH_ManualSubIDSetToolEnabled = true
			SE_AAH_DrawSubIDType = 1
			if SE_AAH_DrawSubIDsTrigger == false do
			(
				SE_AAH_DrawSubIDsTrigger = true
				registerRedrawViewsCallback SE_AAH_ShowSubIDsInViewport -- thanks aleks926820 for the idea
			)
		)

		on ManualSubIDSetTool close do
		(
			--callbacks.removeScripts id:#se_aah_rigtuner
			SE_AAH_ManualSubIDSetToolEnabled = false
			if SE_AAH_AutoSubIDSetToolEnabled == false do
			(
				SE_AAH_DrawSubIDsTrigger = false
				unRegisterRedrawViewsCallback SE_AAH_ShowSubIDsInViewport
			)
		)
		
		on rb_ShowInViewportSubIDTypeMan changed theState do 
		(
			if rb_ShowInViewportSubIDTypeMan.state == 1 then
			(
				SE_AAH_DrawSubIDType = 1
			)
			else if rb_ShowInViewportSubIDTypeMan.state == 2 then
			(
				SE_AAH_DrawSubIDType = 2
			)
			else if rb_ShowInViewportSubIDTypeMan.state == 3 then
			(
				SE_AAH_DrawSubIDType = 3
			)
			else if rb_ShowInViewportSubIDTypeMan.state == 4 do
			(
				SE_AAH_DrawSubIDType = 4
			)
		)
		
		
		on btn_TestHierarchy2 pressed do
		(
			if (queryBox "Have you selected any bone of hierarchy?" title:"ATTENTION") do
			(
				if selection[1] != undefined and (selection[1].children.count > 0 OR selection[1].parent != undefined) then
				(
					SE_AAH_UpdateOrCreateAAHHelperLayer()
					local sHier = SE_AAH_GetAllHierarchy selection[1] 0
					
					local boundingBox = SE_AAH_GetBoundingBoxOfHierarchy sHier
					
					--AAHHelperLayer.addnode boundingBox
					select boundingBox
				)
				else messageBox "You picked the wrong house, fool!\n(Select any bone of hierarchy and THEN push that button!)\n" title:"ERROR"
			)
		)
		
		on btn_SetBRoot pressed do
		(
			if selection.count == 1 do
			(
				if chkbx_SetSubIDs.state == true do
				(
					setUserProp $ "SubID" "0"
					setUserProp $ "BoneID" "0"
					setUserProp $ "BoneId" "0"
					setUserProp $ "tag" "0"
				)
				if chkbx_SetNamesToo.state == true do $.name = "Root"
				SE_AAH_Rig_Tuner_Rollout.SubIDsAndFrameNames()
			)
		)
		
		on btn_SetBPelvis pressed do
		(
			if selection.count == 1 do
			(
				if chkbx_SetSubIDs.state == true do
				(
					setUserProp $ "SubID" "1"
					setUserProp $ "BoneID" "1"
					setUserProp $ "BoneId" "1"
					setUserProp $ "tag" "1"
				)
				if chkbx_SetNamesToo.state == true do $.name = "Pelvis"
				SE_AAH_Rig_Tuner_Rollout.SubIDsAndFrameNames()
			)
		)
		
		
		
		
		
		
	)
	
	on btn_AutoSetSubIDs pressed do
	(
		try (DestroyDialog AutoSubIDSetTool) catch()
		createDialog AutoSubIDSetTool
	)
	
	on btn_ManualSetSubIDs pressed do
	(
		try (DestroyDialog ManualSubIDSetTool) catch()
		/*rollout AboutDialog "Another Animation Helper v.0.986b" width:275 height:315
		(
			label abd1 "\"Another Animation Helper\" v.0.986b (Open Beta)" align:#left
			label abd2 ""
			label abd3 "Made by Shagg_E, 2017-2022:" align:#left
			HyperLink github "https://github.com/ShaggEw/AnotherAnimationHelper" address:"https://github.com/ShaggEw/AnotherAnimationHelper" color: (color 191 76 0) hovercolor:(color 255 106 0) visitedcolor:(color 127 51 0)
			HyperLink nrsite "http://newrockstar.do.am" address:"http://newrockstar.do.am" color: (color 0 127 0) hovercolor:(color 0 191 0) visitedcolor:(color 0 95 0)
			HyperLink ytchannel "https://youtube.com/@Shagg_E" address:"https://youtube.com/@Shagg_E" color: (color 191 0 0) hovercolor:(color 255 0 0) visitedcolor:(color 127 0 0)
			label abd4 ""
			--label abd5 "" align:#left
			--label abd6 "" align:#left
			--HyperLink lbemail "lbtools2k@gmail.com" address:"mailto:lbtools2k@gmail.com" color: (color 0 0 255) hovercolor:(color 0 0 255) visitedcolor:(color 0 0 191)
			--label abd7 ""
			label abd8 "I want to credit these people:" align:#left
			label abd9 "Kam, Yelmi, Deniska, The Hero, Mr. Jago," align:#left
			label abd10 "Wesser and Lorne Brooks - for their incredible scripts" align:#left
			label abd11 "and researches, which inspired and helped me a lot" align:#left
			--label abd12 "" align:#left
			--label abd13 "" align:#left
			--label abd14 "" align:#left
			label abd15 "to work on all this stuff," align:#left
			label abd16 "and many other guys who made all this possible!" align:#left
			label abd17 ""
			label abd18 "This script is not copyrighted, please feel free" align:#left
			label abd19 "to modify or distribute!" align:#left
		)*/
		createDialog ManualSubIDSetTool
	)
		
		
	
	/*on setup changed state do
	(
		if state == on then
		(
			--openRollout testshit
			--SE_AAH_Process_Rollout.open = true
			--testshit.open = true
			--createDialog testshit
			theButton.visible = true
			theBorderlessButton2.visible = true
		)
		else
		(
			--closeRollout testshit
			--SE_AAH_Process_Rollout.open = false
			--testshit.open = false
			--DestroyDialog testshit
			theButton.visible = false
			theBorderlessButton2.visible = false
		)
	)*/
	
	/*on theBorderlessButton pressed do
	(
		clearselection()
		local nrtbn = dummy boxsize:([0.001,0.001,0.001]) wirecolor:blue --bone pos: [0.0,0.0,0.0] wirecolor:blue
		--nrtbn.box = false
		nrtbn.name = "Root"
		setUserProp nrtbn "SubID" "0"
		setUserProp nrtbn "BoneID" "0"
		setUserProp nrtbn "BoneId" "0"
		--local nrtbnTempDummy = dummy boxsize:([0.001,0.001,0.001])
		--nrtbn.baseobject = nrtbnTempDummy
		--delete nrtbnTempDummy
		
		nrtbn.showLinks = true
		--nrtbn.showLinksOnly = true
		
		select nrtbn
	)*/
	
	/*on theBorderlessButton2 pressed do
	(
		clearselection()
		local nrtbn = dummy boxsize:([0.001,0.001,0.001]) wirecolor:blue --bone pos: [0.0,0.0,0.0] wirecolor:blue
		--nrtbn.box = false
		nrtbn.name = "Root"
		setUserProp nrtbn "SubID" "0"
		setUserProp nrtbn "BoneID" "0"
		setUserProp nrtbn "BoneId" "0"
		--local nrtbnTempDummy = dummy boxsize:([0.001,0.001,0.001])
		--nrtbn.baseobject = nrtbnTempDummy
		--delete nrtbnTempDummy
		
		nrtbn.showLinks = true
		--nrtbn.showLinksOnly = true
		
		select nrtbn
	)*/
	/*---------------------------------------------------------------------------------------------------*/
	/*---------------------------------------------------------------------------------------------------*/
	/*---------------------------------------------------------------------------------------------------*/
	
	fn SubIDsAndFrameNames =
	(
		if SE_AAH_ProcessUpdateFreezeTrigger == false do
		(
			if selection.count > 0 then
			(
				btn_CheckHierarchyParams.enabled = true
				btn_SetBoneIdxsnTypes.enabled = true
				btn_CloneHierarchy.enabled = true
				btn_CloneChildren.enabled = true
				btn_TestHierarchy.enabled = true
				btn_CalcHierRotations.enabled = true
				btn_CalcSelectedBonesRotations.enabled = true
				btn_BonesAdaptationTool.enabled = true
				if selection.count == 1 then
				(
					spn_SubID.value = SE_AAH_GetSubID 0 $
					spn_SubID.enabled = true
					btn_SubIDSet.enabled = true
					btn_CreateChildB.enabled = true
					btn_CreateRollB.enabled = true
				)
				else
				(
					spn_SubID.value = 0
					spn_SubID.enabled = false
					btn_SubIDSet.enabled = false
					btn_CreateChildB.enabled = false
					btn_CreateRollB.enabled = false
				)
				if SE_AAH_DrawSubIDsTrigger then
				(
					registerRedrawViewsCallback SE_AAH_ShowSubIDsInViewport -- thanks aleks926820 for the idea
				)
				else
				(
					unRegisterRedrawViewsCallback SE_AAH_ShowSubIDsInViewport
				)
			)
			else
			(
				spn_SubID.value = 0
				spn_SubID.enabled = false
				btn_SubIDSet.enabled = false
				btn_CreateChildB.enabled = false
				btn_CreateRollB.enabled = false
				
				btn_CheckHierarchyParams.enabled = false
				btn_SetBoneIdxsnTypes.enabled = false
				btn_CloneHierarchy.enabled = false
				btn_CloneChildren.enabled = false
				btn_TestHierarchy.enabled = false
				btn_CalcHierRotations.enabled = false
				btn_CalcSelectedBonesRotations.enabled = false
				btn_BonesAdaptationTool.enabled = false
				
				unRegisterRedrawViewsCallback SE_AAH_ShowSubIDsInViewport
			)
		)
	)
	
	/*---------------------------------------------------------------------------------------------------*/
	/*---------------------------------------------------------------------------------------------------*/
	/*---------------------------------------------------------------------------------------------------*/
	
	on SE_AAH_Rig_Tuner_Rollout open do
	(
		callbacks.addScript #selectionSetChanged "SE_AAH_Rig_Tuner_Rollout.SubIDsAndFrameNames()" id:#se_aah_rigtuner
		SubIDsAndFrameNames()
	)

	on SE_AAH_Rig_Tuner_Rollout close do
	(
		callbacks.removeScripts id:#se_aah_rigtuner
		unRegisterRedrawViewsCallback SE_AAH_ShowSubIDsInViewport
	)
	
	/*---------------------------------------------------------------------------------------------------*/
	/*---------------------------------------------------------------------------------------------------*/
	/*---------------------------------------------------------------------------------------------------*/

	on btn_CreateRootB pressed do
	(
		clearselection()
		local nrtbn = dummy boxsize:([0.001,0.001,0.001]) wirecolor:blue --bone pos: [0.0,0.0,0.0] wirecolor:blue
		--nrtbn.box = false
		nrtbn.name = "Root"
		setUserProp nrtbn "SubID" "0"
		setUserProp nrtbn "BoneID" "0"
		setUserProp nrtbn "BoneId" "0"
		setUserProp nrtbn "tag" "0"
		--local nrtbnTempDummy = dummy boxsize:([0.001,0.001,0.001])
		--nrtbn.baseobject = nrtbnTempDummy
		--delete nrtbnTempDummy
		
		nrtbn.showLinks = true
		--nrtbn.showLinksOnly = true
		
		select nrtbn
	)
	
	on btn_CreateChildB pressed do
	(
		if selection.count == 1 then
		(
			local nrtbnParent = selection[1]
			local nrtbn = dummy boxsize:([0.001,0.001,0.001]) wirecolor:blue --bone wirecolor:blue
			--nrtbn.box = false
			nrtbn.transform = nrtbnParent.transform
			local nrtbnParentChildCountS = (nrtbnParent.children.count + 1) as string
			nrtbn.name = nrtbnParent.name + "Ch" + nrtbnParentChildCountS
			nrtbnParent.layer.addnode nrtbn
			local nrtbnHier = SE_AAH_GetAllHierarchy selection[1] 0
			local nrtbnBoneID = (SE_AAH_GetSubID 0 nrtbnParent) + 1
			nrtbnBoneID = SE_AAH_CheckAndFindFreeSubID nrtbnHier nrtbnBoneID 
			clearselection()
			setUserProp nrtbn "SubID" nrtbnBoneID
			setUserProp nrtbn "BoneID" nrtbnBoneID
			setUserProp nrtbn "BoneId" nrtbnBoneID
			setUserProp nrtbn "tag" nrtbnBoneID
			nrtbn.parent = nrtbnParent
			--local nrtbnTempDummy = dummy boxsize:([0.001,0.001,0.001])
			--nrtbn.baseobject = nrtbnTempDummy
			--delete nrtbnTempDummy
			nrtbn.showLinks = true
			--nrtbn.showLinksOnly = true
			select nrtbn
		)
		else messageBox "Select ONE bone and THEN push that button!" title:"ERROR"
	)
	
	on btn_CreateRollB pressed do
	(
		if selection.count == 1 then
		(
			local rollChild
			local info_str_msg = "Select the target bone for \"" + selection[1].name + "\"'s roll...\n\nDo you want to continue?"
			if (queryBox info_str_msg title:"ATTENTION") do
			(
				info_str_msg = "Select the target bone for \"" + selection[1].name + "\"'s roll"
				local pickedObject = pickObject prompt:info_str_msg rubberBand:[selection[1].pos.x,selection[1].pos.y,selection[1].pos.z]
				if pickedObject != undefined AND pickedObject != #escape do rollChild = pickedObject
			)
			if rollChild == undefined and selection[1].children.count > 0 do
			(
				info_str_msg = "Do you want to use \"" + selection[1].children[1].name + "\" as the \"" + selection[1].name + "\"'s roll target?"
				if (queryBox info_str_msg title:"ATTENTION") do rollChild = selection[1].children[1]
			)
			if rollChild != undefined then
			(
				local rollParent = selection[1]
				local rollBn = dummy boxsize:([0.001,0.001,0.001]) wirecolor:blue --bone wirecolor:blue
				--nrtbn.box = false
				rollBn.wirecolor = rollParent.wirecolor
				rollBn.transform = rollParent.transform
				rollBn.position = (rollParent.position - ((rollParent.position - rollChild.position)/2))
				rollBn.name = rollParent.name + "Roll"
				rollParent.layer.addnode rollBn
				local rollBoneID = (SE_AAH_GetSubID 0 rollParent)
				local nrtbnHier = SE_AAH_GetAllHierarchy selection[1] 0
				if rollBoneID > -1 then rollBoneID = SE_AAH_CheckAndFindFreeSubID nrtbnHier (rollBoneID + 7000)
				else rollBoneID = SE_AAH_CheckAndFindFreeSubID nrtbnHier 7000
				setUserProp rollBn "SubID" rollBoneID
				setUserProp rollBn "BoneID" rollBoneID
				setUserProp rollBn "BoneId" rollBoneID
				setUserProp rollBn "tag" rollBoneID
				rollBn.parent = rollParent
				rollBn.showLinks = true
				--rollBn.showLinksOnly = true
				select rollBn
				--else
				--(
				--	local info_str_msg = "Bone \"" + selection[1].name + "\" have no children bone!\nIt's not possible to calculate the roll/twist bone!"
				--	messagebox info_str_msg title:"ERROR"
				--)
			)
			else messageBox "You canceled the operation!" title:"OKAY"
		)
		else messageBox "Select ONE bone and THEN push that button!" title:"ERROR"
	)
	
	/*---------------------------------------------------------------------------------------------------*/
	/*---------------------------------------------------------------------------------------------------*/
	/*---------------------------------------------------------------------------------------------------*/
	
	on btn_SubIDSet pressed do
	(
		if selection.count == 1 do
		(
			if SE_AAH_GetSubID 0 $ != -1 and spn_SubID.enabled == false do spn_SubID.enabled = true
			setUserProp $ "SubID" spn_SubID.value
			setUserProp $ "BoneID" spn_SubID.value
			setUserProp $ "BoneId" spn_SubID.value
			setUserProp $ "tag" spn_SubID.value
		)
	)
	
	on btn_CheckHierarchyParams pressed do
	(
		if selection[1] != undefined and (selection[1].children.count > 0 OR selection[1].parent != undefined) then
		(
			--SE_AAH_UpdateOrCreateAAHHelperLayer()
			local finalHierAnalyseInfo = SE_AAH_AnalyseHierarchy selection[1] true -- hierAA, subAA, hierKams, subKams, hierSeggaeman, subSeggaeman, hieraap, subaap
			--if finalHierAnalyseInfo.hierAA == true and finalHierAnalyseInfo.hierKams == true and finalHierAnalyseInfo.hierSeggaeman == true and finalHierAnalyseInfo.hieraap == true then messageBox "Noice!\n" title:"Cool"
			--else messageBox "Looser!\n" title:"Not cool"
		)
		else messageBox "You picked the wrong house, fool!\n(Select any bone of hierarchy and THEN push that button!)\n" title:"ERROR"
	)
	
	/*---------------------------------------------------------------------------------------------------*/
	/*---------------------------------------------------------------------------------------------------*/
	/*---------------------------------------------------------------------------------------------------*/	
	
	on btn_SetBoneIdxsnTypes pressed do
	(
		if (queryBox "Have you selected any bone of hierarchy?" title:"ATTENTION") do
		(
			if selection[1] != undefined and (selection[1].children.count > 0 OR selection[1].parent != undefined) then
			(
				local sHier = SE_AAH_GetAllHierarchy selection[1] 0
				/*for s in sHier do
				(
					setUserProp s "BoneIndex" "fuckyouasshole"
				)
				clearselection()
				local sNewHier = #()
				for o in objects where getUserProp o "BoneIndex" == "fuckyouasshole" do append sNewHier o --// New Selection Order(as in the hierarchy)*/
				local sSPunknown = 0
				if (queryBox "SA?" title:"ATTENTION") do sSPunknown = 4				
				setUserProp sHier[1] "SPunknown" sSPunknown
				
				--fakeBiped = True
				--SkinMeshNumber = 1
				setUserProp sHier[1] "fakeBiped" "True"
				SE_AAH_SetBonesIndexesnTypes sHier
				--try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
				messagebox "Now your hierarchy's BoneIndexes and BoneTypes are ready for the game!" title:"Done!"
			)
			else messageBox "You picked the wrong house, fool!\n(Select any bone of hierarchy and THEN push that button!)\n" title:"ERROR"
		)
	)
	
	/*---------------------------------------------------------------------------------------------------*/
	/*---------------------------------------------------------------------------------------------------*/
	/*---------------------------------------------------------------------------------------------------*/
	/*
	checkbox chkbx_CloneChildrenAutoSetID "Calculate SubIDs" align:#right checked:true tooltip:"If checked, it recalculate cloned bones' SubID parameters automatically."
	checkbox chkbx_CloneChildrenCalculateSubIDsInSeqOrder "Calc IDs in sequential order" align:#left checked:true enabled:false tooltip:"If checked, it will calculate SubID/BoneID/BoneId/tag just in sequential order (like BoneIndex), nothing fancy."
	checkbox chkbx_CloneChildrenMirror "Mirror cloned" align:#left checked:false across:2 tooltip:"If checked, it will move and rotate (if the checkbox on the right is selected too) cloned bones regarding the selected axis."
	checkbox chkbx_CloneChildrenMirrorRotations "Rots" align:#right checked:true enabled:false tooltip:"If checked, it will Rotate cloned bones regarding the selected axis.\nOtherwise it will move them only."
	radiobuttons rb_CloneChildrenMirror "by axis:" labels:#("X", "Y","Z", "XY", "YZ","ZX", "XYZ") columns:3 align:#left enabled:false tooltip:"You can choose the axis you want to mirror cloned bones."
	*/
	
	on btn_CloneHierarchy pressed do
	(
		if (queryBox "Have you selected any bone of hierarchy?" title:"ATTENTION") do
		(
			if selection[1] != undefined and (selection[1].children.count > 0 OR selection[1].parent != undefined) then
			(
				local oldAnimKeysState = SE_AAH_GetAndOffAnimKeys()
				local sHier = SE_AAH_GetAllHierarchy selection[1] 0
				SE_AAH_SetBonesIndexesnTypes sHier
				local sHierTempCloneArray = SE_AAH_CloneHierarchy sHier chkbx_DontReplaceBones.state chkbx_FullTransformCopy.state false false false false false 0 -- make a clone of the hierarchy with copypasted rotations
				local cHLayer = LayerManager.newLayer()
				if sHierTempCloneArray[1] != undefined do
				(	
					cHLayer.setname ("Bones " + sHierTempCloneArray[1].name + " clone layer")
					for cHBone in sHierTempCloneArray do
					(
						cHLayer.addnode cHBone
					)
					select sHierTempCloneArray[1]
				)
				SE_AAH_SetBackAnimKeys oldAnimKeysState
			)
			else messageBox "You picked the wrong house, fool!\n(Select any bone of hierarchy and THEN push that button!)\n" title:"ERROR"
		)
	)
	
	on btn_CloneChildren pressed do
	(
		if (queryBox "Have you selected main bone of needed bodypart hierarchy?" title:"ATTENTION") do
		(
			if selection[1] != undefined and (selection[1].children.count > 0 OR selection[1].parent != undefined) then
			(
				local oldAnimKeysState = SE_AAH_GetAndOffAnimKeys()
				local sHier = SE_AAH_GetAllHierarchy selection[1] 0
				SE_AAH_SetBonesIndexesnTypes sHier
				local sHierCh = SE_AAH_GetChildrenHierarchy selection 0
				local sHierTempCloneArray = SE_AAH_CloneHierarchy sHierCh chkbx_DontReplaceBones.state chkbx_FullTransformCopy.state false chkbx_CloneChildrenAutoSetID.state chkbx_CloneChildrenCalculateSubIDsInSeqOrder.state chkbx_CloneChildrenMirror.state chkbx_CloneChildrenMirrorRotations.state rb_CloneChildrenMirror.state -- make a clone of the hierarchy with copypasted rotations
				local cHLayer = LayerManager.newLayer()
				if sHierTempCloneArray[1] != undefined do
				(	
					cHLayer.setname ("Bones " + sHierTempCloneArray[1].name + " clone layer")
					for cHBone in sHierTempCloneArray do
					(
						cHLayer.addnode cHBone
					)
					select sHierTempCloneArray[1]
				)
				SE_AAH_SetBackAnimKeys oldAnimKeysState
			)
			else messageBox "You picked the wrong house, fool!\n(Select any bone of hierarchy and THEN push that button!)\n" title:"ERROR"
		)
	)
	
	on btn_TestHierarchy pressed do 
	(
		if (queryBox "Have you selected any bone of hierarchy?" title:"ATTENTION") do
		(
			if selection[1] != undefined and (selection[1].children.count > 0 OR selection[1].parent != undefined) then
			(
				SE_AAH_UpdateOrCreateAAHHelperLayer()
				local sHier = SE_AAH_GetAllHierarchy selection[1] 0
				
				local boundingBox = SE_AAH_GetBoundingBoxOfHierarchy sHier
				local v3DCharFacing = SE_AAH_GetHierarchyFacingVector sHier boundingBox
				local sBBHier = SE_AAH_GetAllHierarchy boundingBox 0
				--for sBB in sBBHier do delete sBB
				
				
				--v3DCharFacing.x
				
				
				--AAHHelperLayer.addnode boundingBox
				select boundingBox
			)
			else messageBox "You picked the wrong house, fool!\n(Select any bone of hierarchy and THEN push that button!)\n" title:"ERROR"
		)
	)
	
	on btn_CalcHierRotations pressed do
	(
		if (queryBox "Have you selected any bone of hierarchy?" title:"ATTENTION") do
		(
			if selection[1] != undefined and (selection[1].children.count > 0 OR selection[1].parent != undefined) then
			(
				SE_AAH_UpdateOrCreateAAHHelperLayer()
				local sHier = SE_AAH_GetAllHierarchy selection[1] 0
				
				SE_AAH_CalculateBonesRotations sHier
				
				local info_str_msg = "Now your bone hierarchy has proper bones' rotations!"
				messagebox info_str_msg title:"Done!"
			)
			else messageBox "You picked the wrong house, fool!\n(Select any bone of hierarchy and THEN push that button!)\n" title:"ERROR"
		)
	)
	
	on btn_CalcSelectedBonesRotations pressed do
	(
		if (queryBox "Have you selected any bone of hierarchy?" title:"ATTENTION") do
		(
			if selection[1] != undefined and (selection[1].children.count > 0 OR selection[1].parent != undefined) then
			(
				SE_AAH_UpdateOrCreateAAHHelperLayer()
				local CurrentBone = selection[1]
				
				if selection.count == 1 then
				(
					local info_str_msg = "Do you want to select the target bone for \"" + selection[1].name + "\"?"
					if (queryBox info_str_msg title:"ATTENTION") then
					(
						info_str_msg = "Select the target bone for \"" + selection[1].name + "\""
						local pickedObject = pickObject prompt:info_str_msg rubberBand:[selection[1].pos.x,selection[1].pos.y,selection[1].pos.z]
						if pickedObject != undefined AND pickedObject != #escape then
						(
							info_str_msg = "Are you sure you want \"" + selection[1].name + "\" to turn in the \"" + pickedObject.name + "\"'s direction?!"
							if (queryBox info_str_msg title:"ATTENTION") then
							(
								local selOldChildren = #()
					
								if selection[1].children.count > 0 do
								(
									for selHierChild in selection[1].children do
									(
										selHierChild.parent = undefined
										append selOldChildren selHierChild
									)
								)
								
								local localsHier = SE_AAH_GetAllHierarchy selection[1] 0
								local boundingBox = SE_AAH_GetBoundingBoxOfHierarchy localsHier
								local v3DCharFacing = SE_AAH_GetHierarchyFacingVector localsHier boundingBox
								local sBBHier = SE_AAH_GetAllHierarchy boundingBox 0
								for sBB in sBBHier do delete sBB
									
								local bRotHelperY = BoneSys.createBone (in coordsys world selection[1].transform.position) (in coordsys world pickedObject.transform.position) v3DCharFacing -- actually, it's XZ rotation helper, but then we'll rotate it by X-axis and it will be XY rotation helper
				
								in coordsys world selection[1].rotation.x_rotation = in coordsys world bRotHelperY.rotation.x_rotation
								in coordsys world selection[1].rotation.y_rotation = in coordsys world bRotHelperY.rotation.y_rotation
								in coordsys world selection[1].rotation.z_rotation = in coordsys world bRotHelperY.rotation.z_rotation
								
								delete bRotHelperY
								
								in coordsys world selection[1].transform = in coordsys world ( (rotateXmatrix 90) * selection[1].transform) -- now Y-axis is pointing to the actual Y-axis of the character (and X-axis - to the children bone)
								
								if selOldChildren.count > 0 do
								(
									for selOldChildrenChild in selOldChildren do
									(
										selOldChildrenChild.parent = selection[1]
									)
								)
								try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
								
								info_str_msg = "Bone \"" + selection[1].name + "\" now look at the \"" + pickedObject.name + "\" bone's direction!"
								messagebox info_str_msg title:"Done!"
								
								
								info_str_msg = "Do you want to recalculate all the \"" + selection[1].name + "\"' children bones' rotations?!"
								if (queryBox info_str_msg title:"ATTENTION") then
								(
									local selBonesHier = SE_AAH_GetAllHierarchy selection[1] 0
									SE_AAH_SetBonesIndexesnTypes selBonesHier
									local selHier = #()
									append selHier selection[1]
									local sChildrenHier = SE_AAH_GetChildrenHierarchy selHier 1
									
									SE_AAH_CalculateBonesRotations sChildrenHier
									
									try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
									
									local info_str_msg = "Now all the \"" + selection[1].name + "\"'s children bones has proper rotations!"
									messagebox info_str_msg title:"Done!"
								)
							)
							else
							(
								SE_AAH_Process_Rollout.lbl_PrcssAAH.text = "Bones rot calc canceled"
								SE_AAH_Process_Rollout.prgb_AAH.value = 0
								try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
								SE_AAH_ProcessUpdateFreezeTrigger = false
								messageBox "You canceled the operation!" title:"OKAY"
							)
						)
						else
						(
							SE_AAH_Process_Rollout.lbl_PrcssAAH.text = "Bones rot calc canceled"
							SE_AAH_Process_Rollout.prgb_AAH.value = 0
							try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
							SE_AAH_ProcessUpdateFreezeTrigger = false
							messageBox "You canceled the operation!" title:"OKAY"
						)
					)
					else
					(
						if selection[1].parent != undefined then
						(
							info_str_msg = "Do you want set the \"" + selection[1].name + "\" bone its parent \"" + selection[1].parent.name + "\" bone rotation?"
							if (queryBox info_str_msg title:"ATTENTION") then
							(
								local selOldChildren = #()
					
								if selection[1].children.count > 0 do
								(
									for selHierChild in selection[1].children do
									(
										selHierChild.parent = undefined
										append selOldChildren selHierChild
									)
								)
								
								selection[1].rotation.x_rotation = selection[1].parent.rotation.x_rotation
								selection[1].rotation.y_rotation = selection[1].parent.rotation.y_rotation
								selection[1].rotation.z_rotation = selection[1].parent.rotation.z_rotation
								
								if selOldChildren.count > 0 do
								(
									for selOldChildrenChild in selOldChildren do
									(
										selOldChildrenChild.parent = selection[1]
									)
								)
								
								try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
								
								info_str_msg = "Bone \"" + selection[1].name + "\" now have \"" + selection[1].parent.name + "\"'s rotation!"
								messagebox info_str_msg title:"Done!"
									
								info_str_msg = "Do you want to recalculate all the \"" + selection[1].name + "\"' children bones' rotations?!"
								if (queryBox info_str_msg title:"ATTENTION") then
								(
									local selBonesHier = SE_AAH_GetAllHierarchy selection[1] 0
									SE_AAH_SetBonesIndexesnTypes selBonesHier
									local selHier = #()
									append selHier selection[1]
									local sChildrenHier = SE_AAH_GetChildrenHierarchy selHier 1
									
									SE_AAH_CalculateBonesRotations sChildrenHier
									
									try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
									
									local info_str_msg = "Now all the \"" + selection[1].name + "\"'s children bones has proper rotations!"
									messagebox info_str_msg title:"Done!"
								)
							)
							else
							(
								info_str_msg = "Do you want to reset the \"" + selection[1].name + "\" bone's rotation?"
								if (queryBox info_str_msg title:"ATTENTION") then
								(
									local selOldChildren = #()
					
									if selection[1].children.count > 0 do
									(
										for selHierChild in selection[1].children do
										(
											selHierChild.parent = undefined
											append selOldChildren selHierChild
										)
									)
									
									in coordsys world selection[1].rotation.x_rotation = 0.0
									in coordsys world selection[1].rotation.y_rotation = 0.0
									in coordsys world selection[1].rotation.z_rotation = 0.0
										
									if selOldChildren.count > 0 do
									(
										for selOldChildrenChild in selOldChildren do
										(
											selOldChildrenChild.parent = selection[1]
										)
									)
									
									try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
								
									info_str_msg = "Bone \"" + selection[1].name + "\" now have the default rotation!"
									messagebox info_str_msg title:"Done!"
										
									info_str_msg = "Do you want to recalculate all the \"" + selection[1].name + "\"' children bones' rotations?!"
									if (queryBox info_str_msg title:"ATTENTION") then
									(
										local selBonesHier = SE_AAH_GetAllHierarchy selection[1] 0
										SE_AAH_SetBonesIndexesnTypes selBonesHier
										local selHier = #()
										append selHier selection[1]
										local sChildrenHier = SE_AAH_GetChildrenHierarchy selHier 1
										
										SE_AAH_CalculateBonesRotations sChildrenHier
										
										try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
										
										local info_str_msg = "Now all the \"" + selection[1].name + "\"'s children bones has proper rotations!"
										messagebox info_str_msg title:"Done!"
									)
								)
								else
								(
									SE_AAH_Process_Rollout.lbl_PrcssAAH.text = "Bones rot calc canceled"
									SE_AAH_Process_Rollout.prgb_AAH.value = 0
									try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
									SE_AAH_ProcessUpdateFreezeTrigger = false
									messageBox "You canceled the operation!" title:"OKAY"
								)
							)
						)
						else
						(
							SE_AAH_Process_Rollout.lbl_PrcssAAH.text = "Bones rot calc canceled"
							SE_AAH_Process_Rollout.prgb_AAH.value = 0
							try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
							SE_AAH_ProcessUpdateFreezeTrigger = false
							messageBox "You canceled the operation!" title:"OKAY"
						)
					)
				)
				else
				(
					--local sHier = SE_AAH_GetAllHierarchy selection[1] 0
					--SE_AAH_SetBonesIndexesnTypes sHier
					--local sHierCh = SE_AAH_GetChildrenHierarchy selection 0
					local sSortedHier = SE_AAH_GetSortedHierarchy selection
					
					SE_AAH_CalculateBonesRotations sSortedHier
					
					SE_AAH_Process_Rollout.lbl_PrcssAAH.text = "Bones rot calculated"
					SE_AAH_Process_Rollout.prgb_AAH.value = 0
					try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
					SE_AAH_ProcessUpdateFreezeTrigger = false
					local info_str_msg = "Now your bones has proper rotations!"
					messagebox info_str_msg title:"Done!"
				)
			)
			else messageBox "You picked the wrong house, fool!\n(Select any bone of hierarchy and THEN push that button!)\n" title:"ERROR"
		)
	)
	
	on btn_SkinWeightsTransfer pressed do
	(
		if (queryBox "Have you selected any bone of hierarchy or any of the meshes?" title:"ATTENTION") do
		(
			if selection.count > 0 then --if selection[1] != undefined and (selection[1].children.count > 0 OR selection[1].parent != undefined) then
			(
				SE_AAH_ProcessUpdateFreezeTrigger = true
				SE_AAH_Process_Rollout.lbl_PrcssAAH.text = "Prep for skin weights transfer..."
				SE_AAH_Process_Rollout.prgb_AAH.value = 5
				try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
					
				SE_AAH_UpdateOrCreateAAHHelperLayer()
				SE_AAH_MarkAllSkinsAndBonesInScene()
				local currentMeshes = #()
				local currentBones = #()
				local newBones = #()
				local currentSkinMeshNumber
				if getUserProp selection[1] "SkinMeshNumber" != undefined and getUserProp selection[1] "SkinMeshNumber" != -1 do currentSkinMeshNumber = getUserProp selection[1] "SkinMeshNumber"
				if currentSkinMeshNumber != undefined then
				(
					local shitFound = false
					for obj in objects while shitFound == false do
					(
						if (SE_AAH_HasSkinModifier obj) do
						(
							if getUserProp obj "SkinMeshNumber" != undefined and getUserProp obj "SkinMeshNumber" == currentSkinMeshNumber do
							(
								local currentBonesTemp = SE_AAH_GetRelatedSkinBones obj
								currentBones = SE_AAH_GetAllHierarchy currentBonesTemp[1] 0
								currentMeshes = SE_AAH_GetRelatedSkinMeshes obj
								shitFound = true
							)
						)
					)
					if currentMeshes.count > 0 and currentBones.count > 0 do format "%: Found meshes: %, Found bones: %\n" currentMeshes[1].name currentMeshes.count currentBones.count

					if currentMeshes.count > 0 and currentBones.count > 0 then
					(
						
						
						-- Check if original bones has the unique bone names. Offer to rename duplicates automatically
						
						
						
						
						
						local info_str_msg = "Select any bone of the new bone hierarchy"
						if (queryBox info_str_msg title:"ATTENTION") then
						(
							info_str_msg = "Select any bone of the new bone hierarchy"
							local pickedObject = pickObject prompt:info_str_msg rubberBand:[selection[1].pos.x,selection[1].pos.y,selection[1].pos.z]
							if pickedObject != undefined AND pickedObject != #escape then
							(
								
								newBones = SE_AAH_GetAllHierarchy pickedObject 0
								
								if newBones[1] != currentBones[1] then
								(
									if newBones.count > 0 then
									(
										if currentBones.count > newBones.count then
										(
											SE_AAH_Process_Rollout.lbl_PrcssAAH.text = "Wrong hierarchy!"
											SE_AAH_Process_Rollout.prgb_AAH.value = 0
											try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
											SE_AAH_ProcessUpdateFreezeTrigger = false
											messageBox "You picked the wrong house, fool!\n(New hierarchy contains LESS bones than the current one!)\n" title:"ERROR"
										)
										else
										(
											local matchBonesTrigger = true
											
											local matchBonesNamesCount = 0
											local matchBonesBoneIDsCount = 0
											local matchBonesBoneIndexesCount = 0
											local matchBonesTotalCount = 0
											
											
											matchBonesNamesCount = SE_AAH_CheckHierNamesMatch currentBones newBones true -- make similar temp BoneIndexes too, by the way
											
											if currentBones.count > matchBonesNamesCount then matchBonesBoneIDsCount = SE_AAH_CheckHierBoneIDsMatch currentBones newBones true -- make similar temp BoneIndexes too, by the way
											else matchBonesBoneIDsCount = SE_AAH_CheckHierBoneIDsMatch currentBones newBones false -- don't touch BoneIndexes
											
											
											if matchBonesNamesCount > matchBonesTotalCount do matchBonesTotalCount = matchBonesNamesCount
											if matchBonesBoneIDsCount > matchBonesTotalCount do matchBonesTotalCount = matchBonesBoneIDsCount
											
											
											if currentBones.count > matchBonesTotalCount do
											(
												info_str_msg = "There's not enough bones' Names/BoneIDs matches!\n\nDo you want to use BoneIndexes to match the bones?\n\nWARNING: Do this ONLY if you sure you have the IDENTICAL bone hierarchies (just different bones' names/positions/rotations)!\nOtherwise...  prepare for UNFORESEEN CONSEQUENCESsSss.\n(names/BoneIDs may change a LOT)"
												if (queryBox info_str_msg title:"WARNING") do
												(
													SE_AAH_SetBonesIndexesnTypes currentBones
													SE_AAH_SetBonesIndexesnTypes newBones
													matchBonesBoneIndexesCount = SE_AAH_CheckHierIndexesMatch currentBones newBones
													
													if matchBonesBoneIndexesCount > matchBonesTotalCount do matchBonesTotalCount = matchBonesBoneIndexesCount
														
													info_str_msg = "Bone BoneIndex matches: " + matchBonesBoneIndexesCount as string
													messageBox info_str_msg title:"Info"
												)
											)
											
											if currentBones.count > matchBonesTotalCount do matchBonesTrigger = false
											
											if matchBonesTrigger then
											(
												info_str_msg = currentMeshes[1].name + ":\n\nTotal current bones: " + currentBones.count as string + "\nTotal new bones: " + newBones.count as string + "\nBone names matches: " + matchBonesNamesCount as string + "\nBone BoneIDs matches: " + matchBonesBoneIDsCount as string + "\nBone BoneIndexes matches: " + matchBonesBoneIndexesCount as string + "\n\n\nTOTAL bones matches: " + matchBonesTotalCount as string + "\n\nAre you sure you want to continue?"
												if (queryBox info_str_msg title:"ATTENTION") then
												(
													
													
													--local sHier = currentBones
													--local info_str_msg = currentMeshes[1].name + ": Found meshes: " + currentMeshes.count as string + ", Found bones: " + currentBones.count as string
													--messagebox info_str_msg title:"TEST!"
												
													--local adBnsCount = SE_AAH_AdaptBones currentMeshes currentBones chkbx_BATransferAnimation.state chkbx_BAResetScale.state chkbx_BATransferObjects.state chkbx_BASaveOriginal.state chkbx_BACleanModifiersList.state
													
													local adBnsCount = SE_AAH_TransferWeights currentMeshes currentBones newBones chkbx_SWTTransferAnimation.state chkbx_SWTResetScale.state chkbx_SWTTransferObjects.state chkbx_SWTSaveOriginal.state chkbx_SWTCleanModifiersList.state
													
													SE_AAH_Process_Rollout.lbl_PrcssAAH.text = "Skin weights transfer finished!"
													SE_AAH_Process_Rollout.prgb_AAH.value = 0
													try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
											
													SE_AAH_ProcessUpdateFreezeTrigger = false
													local info_str_msg = "Skin weights transfering finished!\n\nAdapted meshes: " + currentMeshes.count as string + "\nAdapted bones: " + adBnsCount as string
													messagebox info_str_msg title:"Done!"
												)
												else
												(
													SE_AAH_Process_Rollout.lbl_PrcssAAH.text = "Weights transfer canceled"
													SE_AAH_Process_Rollout.prgb_AAH.value = 0
													try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
													SE_AAH_ProcessUpdateFreezeTrigger = false
													messageBox "You canceled the operation!" title:"OKAY"
												)
											)
											else
											(
												SE_AAH_Process_Rollout.lbl_PrcssAAH.text = "Weights transfer canceled"
												SE_AAH_Process_Rollout.prgb_AAH.value = 0
												try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
												SE_AAH_ProcessUpdateFreezeTrigger = false
												info_str_msg = currentMeshes[1].name + ":\n\nTotal current bones: " + currentBones.count as string + "\nTotal new bones: " + newBones.count as string + "\nBone names matches: " + matchBonesNamesCount as string + "\nBone BoneIDs matches: " + matchBonesBoneIDsCount as string + "\nBone BoneIndexes matches: " + matchBonesBoneIndexesCount as string + "\n\n\nTOTAL bones matches: " + matchBonesTotalCount as string + "\n\nERROR: There's not enough bones matches!"
												messageBox info_str_msg title:"ERROR"
											)
											
											SE_AAH_SetBonesIndexesnTypes newBones
										)
									)
									else
									(
										SE_AAH_Process_Rollout.lbl_PrcssAAH.text = "Weights transfer canceled"
										SE_AAH_Process_Rollout.prgb_AAH.value = 0
										try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
										SE_AAH_ProcessUpdateFreezeTrigger = false
										info_str_msg = "ERROR: There's not enough new bones!"
										messageBox info_str_msg title:"ERROR"
									)
								)
								else
								(
									SE_AAH_Process_Rollout.lbl_PrcssAAH.text = "Weights transfer canceled"
									SE_AAH_Process_Rollout.prgb_AAH.value = 0
									try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
									SE_AAH_ProcessUpdateFreezeTrigger = false
									info_str_msg = "You picked the wrong house, fool!\n(You choosed the same hierarchy!)\n"
									messageBox info_str_msg title:"ERROR"
								)
							)
							else
							(
								SE_AAH_Process_Rollout.lbl_PrcssAAH.text = "Weights transfer canceled"
								SE_AAH_Process_Rollout.prgb_AAH.value = 0
								try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
								SE_AAH_ProcessUpdateFreezeTrigger = false
								messageBox "You canceled the operation!" title:"OKAY"
							)
						)
						else
						(
							SE_AAH_Process_Rollout.lbl_PrcssAAH.text = "Weights transfer canceled"
							SE_AAH_Process_Rollout.prgb_AAH.value = 0
							try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
							SE_AAH_ProcessUpdateFreezeTrigger = false
							messageBox "You canceled the operation!" title:"OKAY"
						)
					)
					else
					(
						SE_AAH_Process_Rollout.lbl_PrcssAAH.text = "No related skin mesh or bones found!"
						SE_AAH_Process_Rollout.prgb_AAH.value = 0
						try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
						SE_AAH_ProcessUpdateFreezeTrigger = false
					)
				)
				else
				(
					SE_AAH_Process_Rollout.lbl_PrcssAAH.text = "No related skin mesh found!"
					SE_AAH_Process_Rollout.prgb_AAH.value = 0
					try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
					SE_AAH_ProcessUpdateFreezeTrigger = false
					messageBox "No related skin mesh found!\nTry to select another bone" title:"OKAY"
				)
			)
			else messageBox "You picked the wrong house, fool!\n(Select any bone of hierarchy or any mesh and THEN push that button!)\n" title:"ERROR"
		)
	)
	
	
	on btn_BonesAdaptationTool pressed do
	(
		if (queryBox "Have you selected any bone of hierarchy or any of the meshes?" title:"ATTENTION") do
		(
			if selection.count > 0 then --if selection[1] != undefined and (selection[1].children.count > 0 OR selection[1].parent != undefined) then
			(
				SE_AAH_ProcessUpdateFreezeTrigger = true
				SE_AAH_Process_Rollout.lbl_PrcssAAH.text = "Preparing for bones adaptation..."
				SE_AAH_Process_Rollout.prgb_AAH.value = 5
				try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
					
				SE_AAH_UpdateOrCreateAAHHelperLayer()
				SE_AAH_MarkAllSkinsAndBonesInScene()
				local currentMeshes = #()
				local currentBones = #()
				local currentSkinMeshNumber
				if getUserProp selection[1] "SkinMeshNumber" != undefined and getUserProp selection[1] "SkinMeshNumber" != -1 do currentSkinMeshNumber = getUserProp selection[1] "SkinMeshNumber"
				if currentSkinMeshNumber != undefined then
				(
					local shitFound = false
					for obj in objects while shitFound == false do
					(
						if (SE_AAH_HasSkinModifier obj) do
						(
							if getUserProp obj "SkinMeshNumber" != undefined and getUserProp obj "SkinMeshNumber" == currentSkinMeshNumber do
							(
								local currentBonesTemp = SE_AAH_GetRelatedSkinBones obj
								currentBones = SE_AAH_GetAllHierarchy currentBonesTemp[1] 0
								currentMeshes = SE_AAH_GetRelatedSkinMeshes obj
								shitFound = true
							)
						)
					)
					if currentMeshes.count > 0 and currentBones.count > 0 do format "%: Found meshes: %, Found bones: %\n" currentMeshes[1].name currentMeshes.count currentBones.count

					if currentMeshes.count > 0 and currentBones.count > 0 then
					(
						--local sHier = currentBones
						--local info_str_msg = currentMeshes[1].name + ": Found meshes: " + currentMeshes.count as string + ", Found bones: " + currentBones.count as string
						--messagebox info_str_msg title:"TEST!"
						
						local adBnsCount = SE_AAH_AdaptBones currentMeshes currentBones chkbx_BATransferAnimation.state chkbx_BAResetScale.state chkbx_BATransferObjects.state chkbx_BASaveOriginal.state chkbx_BACleanModifiersList.state
							
						SE_AAH_ProcessUpdateFreezeTrigger = false
						local info_str_msg = "Character adaptation finished!\n\nAdapted meshes: " + currentMeshes.count as string + "\nAdapted bones: " + adBnsCount as string
						messagebox info_str_msg title:"Done!"
					)
					else
					(
						SE_AAH_Process_Rollout.lbl_PrcssAAH.text = "No related skin mesh or bones found!"
						SE_AAH_Process_Rollout.prgb_AAH.value = 0
						try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
						SE_AAH_ProcessUpdateFreezeTrigger = false
					)
				)
				else
				(
					SE_AAH_Process_Rollout.lbl_PrcssAAH.text = "No related skin mesh found!"
					SE_AAH_Process_Rollout.prgb_AAH.value = 0
					try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
					SE_AAH_ProcessUpdateFreezeTrigger = false
				)
			)
			else messageBox "You picked the wrong house, fool!\n(Select any bone of hierarchy or any mesh and THEN push that button!)\n" title:"ERROR"
		)
	)
	
	on btn_SceneBonesAdaptationTool pressed do
	(
		if (queryBox "Are you sure you want to adapt the whole scene?" title:"ATTENTION") do
		(
			SE_AAH_ProcessUpdateFreezeTrigger = true
			SE_AAH_MarkAllSkinsAndBonesInScene()
			local currentMeshes = #()
			local currentBones = #()
			local adaptedCharactersCount = 0
			local adaptedMeshesCount = 0
			local adaptedBonesCount = 0
			local currentSkinMeshNumber = 1
			for i=1 to NewSM_Number do
			(
				local shitFound = false
				for obj in objects while shitFound == false do
				(
					if (SE_AAH_HasSkinModifier obj) do
					(
						if getUserProp obj "SkinMeshNumber" != undefined and getUserProp obj "SkinMeshNumber" == i do
						(
							local currentBonesTemp = SE_AAH_GetRelatedSkinBones obj
							currentBones = SE_AAH_GetAllHierarchy currentBonesTemp[1] 0
							currentMeshes = SE_AAH_GetRelatedSkinMeshes obj
							shitFound = true
						)
					)
				)
				if currentMeshes.count > 0 and currentBones.count > 0 do format "%) %: Found meshes: %, Found bones: %\n" i currentMeshes[1].name currentMeshes.count currentBones.count
				
				if currentMeshes.count > 0 and currentBones.count > 0 then
				(
					--adaptedBonesCount += currentBones.count
					adaptedMeshesCount += currentMeshes.count
					--local sHier = currentBones
					--local info_str_msg = currentMeshes[1].name + ": Found meshes: " + currentMeshes.count as string + ", Found bones: " + currentBones.count as string
					--messagebox info_str_msg title:"TEST!"
					--local ShowDialoguesPerChar = false --show no dialogues per character
					local adBnsCount = SE_AAH_AdaptBones currentMeshes currentBones chkbx_BATransferAnimation.state chkbx_BAResetScale.state chkbx_BATransferObjects.state chkbx_BASaveOriginal.state chkbx_BACleanModifiersList.state
					
					adaptedBonesCount += adBnsCount
					adaptedCharactersCount += 1
					
				)
				else
				(
					SE_AAH_Process_Rollout.lbl_PrcssAAH.text = "No related skin mesh or bones found!"
					SE_AAH_Process_Rollout.prgb_AAH.value = 0
					try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
					SE_AAH_ProcessUpdateFreezeTrigger = false
				)
				
				
				free currentMeshes
				free currentBones
			)
			local info_str_msg = "Scene adaptation finished!\n\nAdapted characters: " + adaptedCharactersCount as string + "\nTotal adapted meshes: " + adaptedMeshesCount as string + "\nTotal adapted bones: " + adaptedBonesCount as string
			messagebox info_str_msg title:"Done!"
			SE_AAH_ProcessUpdateFreezeTrigger = false
		)
	)
	
	on btn_ResetObjectsTFs pressed do
	(
		if (queryBox "Are you sure you selected all the needed geometry objects?" title:"ATTENTION") do
		(
			if selection.count > 0 do
			(
				SE_AAH_ProcessUpdateFreezeTrigger = true
				local oldAnimKeysState = SE_AAH_GetAndOffAnimKeys()
				SE_AAH_SetOffAnimKeys()
				wholeAttachBakingTime = timeStamp()
				local processedObjects = 0
				local skippedObjects = 0
				local pgbCount = 0
				local pgbCountTotal = selection.count
				for s in selection do
				(
					if superclassof s == GeometryClass then
					(
						SE_AAH_Process_Rollout.lbl_PrcssAAH.text = "Processing: " + s.name
						ResetXForm s
						collapseStack s
						if chkbx_RPivotToTheSceneCenter.state == true then s.pivot = [0.0, 0.0, 0.0]
						else s.pivot = s.center
						processedObjects = processedObjects + 1
					)
					else skippedObjects = skippedObjects + 1
					pgbCount = pgbCount + 1
					SE_AAH_Process_Rollout.prgb_AAH.value = 100.0*pgbCount/pgbCountTotal
				)
				if processedObjects > 0 do
				(
					wholeAttachBakingTime = (((timeStamp() - wholeAttachBakingTime) / 1000.0) as string)
					SE_AAH_Process_Rollout.lbl_PrcssAAH.text = "Objects processed in " + wholeAttachBakingTime + "s"
						
					local info_str_msg
					if processedObjects == 1 then info_str_msg = processedObjects as string + " object\nwas processed in " + wholeAttachBakingTime + " seconds!"
					else info_str_msg = processedObjects as string + " objects\nwere processed in " + wholeAttachBakingTime + " seconds!"
					if skippedObjects > 0 do
					(
						if skippedObjects == 1 then info_str_msg = info_str_msg + "\n\n" + skippedObjects as string + " object\nwas skipped."
						else info_str_msg = info_str_msg + "\n\n" + skippedObjects as string + " objects\nwere skipped."
					)
					messagebox info_str_msg title:"Done!"
				)
				SE_AAH_Process_Rollout.prgb_AAH.value = 0
				SE_AAH_SetBackAnimKeys oldAnimKeysState
				SE_AAH_ProcessUpdateFreezeTrigger = false
			)
		)
	)
	
	on btn_CreateUniqueLayerForHier pressed do
	(
		if (queryBox "Have you selected any bone of hierarchy?" title:"ATTENTION") do
		(
			if selection[1] != undefined and (selection[1].children.count > 0 OR selection[1].parent != undefined) then
			(
				--SE_AAH_UpdateOrCreateAAHHelperLayer()
				local sHier = SE_AAH_GetAllHierarchy selection[1] 0
				
				local bonesNewLayer = SE_AAH_GetUniqueHierarchyLayer sHier -- -2 means impostor nodes in the same layer; -1 means hierarchy lays between different layers; proper layer means hierarchy has a proper unique layer
				if bonesNewLayer == -1 or bonesNewLayer == -2 do
				(
					bonesNewLayer = SE_AAH_CreateLayerForHierarchy sHier ("Bones " + sHier[1].name + " layer")
				)

			)
			else messageBox "You picked the wrong house, fool!\n(Select any bone of hierarchy and THEN push that button!)\n" title:"ERROR"
		)
	)
)

/*********************************************************************************************************************************************************************/
--// MAIN ANIM ROLLOUT
/*********************************************************************************************************************************************************************/

rollout SE_AAH_Main_Anim_Rollout "Main Anim" width:132 height:170
(
	group "Select hierarchy"
	(
		button SelectAllItems "All" width:25 height:16 pos:[8,25] across:3 tooltip:"Automatically will select all the items of picked hierarchy.\n\nSelect any item and push this button."
		button SelectAllExceptRootItem "Except Root" width:73 height:16 pos:[36,25] tooltip:"Automatically will select all the items of picked hierarchy, except Root one.\n\nSelect any item and push this button."
		button SelectOnlyRootItem "Only Root" width:57 height:16 pos:[112,25] tooltip:"Automatically will select only Root item of picked hierarchy.\n\nSelect any item and push this button."
	)
	group "Transform Helper"
	(
		checkbox chkbx_ThTrnsfrmPos "Pos" align:#left checked:false across:3 tooltip:"Work with object's position."
		checkbox chkbx_ThTrnsfrmRot "Rot" align:#center checked:true across:3 tooltip:"Work with object's rotation."
		checkbox chkbx_ThTrnsfrmScale "Scale" align:#right checked:false across:3 tooltip:"Work with object's scale."
		button CopyPasteObjectsTransform "Copy obj ts" height:16 align:#left across:2 tooltip:"Copies selected object's transform to another one, if checked above."
		button ResetObjectsTransform "Reset obj ts" height:16 align:#right tooltip:"Resets selected objects' transform to default values, if checked above:\npos 0.0\nrot 0.0\nscale 100.0\n\nSometimes scale reset will cause funny values but it should work that way, it's made for the first frame reset."
	)
	button EulerToTCBAVV "Euler<=>TCB" height:16 tooltip:"Enables TCB Rotation Controller for all selected bones/objects if Euler XYZ is the current controller for the first one of the selected bones/objects. Otherwise enables Euler XYZ for all the bones/objects."
	group "Attach Object Controllers"
	(
		button AttachObjTo "Attach to selected" width:97 height:16 align:#left across:2 tooltip:"Attaches object to selected bone/helper/object.\n\nSelect ONE bone/helper/object and push this button.\n\nWARNING!!!\nIf you are trying to attach HI solver to your selected bone/helper/object, MAKE SURE your selected bone/helper/object is NOT inside a container."
		button DetachObj "Detach" width:50 height:16 align:#right tooltip:"Detaches selected attached objects or attached objects for selected bones/helpers/objects.\n\nWorks only for objects that were attached by this script!\n\nSelect all needed bones/helpers/objects and push this button."
		button CreateKeysFAO "Bake for all selected" height:16 tooltip:"Creates anim keys for all selected attached objects or attached objects for selected bones/helpers/objects.\n\nWorks only for objects that were attached by this script!\nUse this before animation export.\n\nSelect all needed bones/helpers/objects and push this button."
		checkbox chkbx_DetailedAOAnim "Detailed" align:#left checked:true across:2 tooltip:"Bakes more detailed animation by adding extra anim keys every few frames. Choose frame interval in the \"Int\" field.\n\nDisable ONLY if you're know what you're doing and you want to get the less detailed baked anim depending on current attached object's animation keys and the keys of its current parent object!"
		spinner spn_DetailedAOAnim "Int:" range:[0.001, 1000.0, 1.0] type:#float align:#right across:2 fieldwidth:45
	)
	group "Animation control"
	(
		checkbox chkbx_ACTrnsfrmKsPos "Pos" align:#left checked:true across:3 tooltip:"Transform type:\nControl the object's Position keys."
		checkbox chkbx_ACTrnsfrmKsRot "Rot" align:#center checked:false tooltip:"Transform type:\nControl the object's Rotation keys."
		checkbox chkbx_ACTrnsfrmKsScale "Scale" align:#right checked:false tooltip:"Transform type:\nControl the object's Scale keys."
		checkbox chkbx_ACTrnsfrmKsRoll "Roll" align:#center checked:false across:2 tooltip:"Transform type:\nControl the target object/camera's Roll keys."
		checkbox chkbx_ACTrnsfrmKsFOV "FOV" align:#center checked:false tooltip:"Transform type:\nControl the target camera's FOV keys."
		spinner spn_ACTrnsfrmRangeStartVal "S:" range:[0.0, 999999.0, 0.0] type:#float align:#left across:2 fieldwidth:45 tooltip:"Animation Keys Range Start"
		spinner spn_ACTrnsfrmRangeEndVal "E:" range:[0.0, 999999.0, 100.0] type:#float align:#right across:2 fieldwidth:45 tooltip:"Animation Keys Range End"
		radiobuttons rb_AnimKeysRange "Anim keyframes range:" labels:#("All", "Set","TimeL") columns:3 tooltip:"You can select the specified keyframes range you want to work with:\n\nAll: Will work with all the keys of the selected object(s).\n\nSet: Will work for the selected keys range you specified above (from Range Start to Range End).\n\nTimeL: Will work for the selected keys range you have selected on the animation timeline (or the range between the selected first and the last key on the timeline)."
		
		checkbutton ib_CASbutton "Change animation speed:" height:15 width:135 highlightColor:[85,75,65] checked:true enabled:false align:#center offset:[0,-3]
		button CASIncrease "Increase..." width:68 height:16 align:#left across:2 tooltip:"Increases selected animation's speed as many times as specified in right field.\n\nIf you want slow down the animation by 2 times, then choose \"0,5\" in that field.\n\nSelect all needed bones/helpers/objects, then select keys range and push this button."
		spinner spn_CASIncBy "...by:" range:[-1000.0, 1000.0, 2.0] type:#float align:#right fieldwidth:45 --[0.001, 1000.0, 2.0]
		checkbox chkbx_CASAccuracy "Accuracy" align:#left checked:true across:2 tooltip:"Round-up the number of frames of the new animation range to the value that was chosen in the right field.\n\nIf you increased your animation's speed that has 25,0 frames by 2,0 times then the new range will be 12,5.\nBut if THIS checkbox was checked and value \"1,0\" was chosen - the new range will be 13,0."
		spinner spn_CASAccuracyVal "upto:" range:[0.001, 1000.0, 1.0] type:#float align:#right across:2 fieldwidth:45
		
		checkbutton ib_BakeAKbutton "Additional control:" height:15 width:100 highlightColor:[85,75,65] checked:true enabled:false align:#center offset:[0,-3]
		button BakeObjectsTransformKeys "Bake Keys" width:68 height:16 align:#left across:2 tooltip:"Bakes selected object's transform animation keys.\n\nSelect all needed bones, choose transform type mode, keys range and frame interval in the right field and push this button."
		spinner spn_BkTrnsfrmAccuracyVal "Int:" range:[0.001, 1000.0, 1.0] type:#float align:#right across:2 fieldwidth:45 tooltip:"Animation Keys Baking Frame Interval"
		checkbox chkbx_BkDeleteOrigkeys "Delete original keysframes" align:#left checked:true tooltip:"While baking, the script will delete all the original keyfames inside the baking animation interval."
		button SmoothObjectsAnimation "Smooth" width:55 height:16 align:#left across:2 tooltip:"Smoothes selected object's transform animation, makes it a bit less snappy.\n\nSelect all needed bones, choose transform type mode and keys range and push this button.\n\nRepeat these steps if you are not yet satisfied the result."
		spinner spn_SmoothTimesVal "Times:" range:[1, 100000, 1] type:#integer align:#right across:2 fieldwidth:45 tooltip:"How many times you want to smooth your animation."
		radiobuttons rb_SmoothingAlgorithm "Smoothing algorithm:" labels:#("Def", "CS","IG") columns:3 enabled:false tooltip:"UNDER DEVELOPMENT.\nYou can choose the animation smoothing algorithm.\n\nDef: The dafault smoothing algorithm, best for solo objects/bones.\n\nCS: More advanced smoothing algorithm, usable for big structures and bone hierarchy. Forcibly creates position keyframes, even when using for rotation only, that's why it's better for Cutscene animations only. May cause \"jelly effect\" when overusing, but looks good for living forms animation, if used smartly.\n\nIG: The most advanced, but slowest smoothing algorithm, doesn't create position keyframes when used for rotation only."
		
		
		button DeleteObjectsTransformKeys "Delete object's transform keys" height:16 tooltip:"Deletes selected object's transform animation keys.\n\nSelect all needed bones, choose transform type mode and keys range and push this button."
	)
	/*group "Before Export: Delete anim keys"
	(
		button DelPosKeys "Del Pos keys(all except Root)" tooltip:"All bones except Root bone must have rotation(green) keys only(for correct animation), so you need to delete position(red) keys for them.\nUse this before animation export.\nSelect all needed bones(except Root) and push this button."
		button DelScaKeys "Del Scale keys(not important)" tooltip:"Bones can have rotation(green, all bones) and position(red, Root bone only) keys but it's also recommended to delete scale(blue) keys for them.\nActually, I don't know how scale keys can damage your animation, because it seems the game doesn't read them.\nBut I made this option for the future purposes and also because I can.\nUse this(or not) before animation export.\nSelect all needed bones and push this button."
	)*/
	
	/*---------------------------------------------------------------------------------------------------*/
	/*---------------------------------------------------------------------------------------------------*/
	/*---------------------------------------------------------------------------------------------------*/
	
	fn CreateAOLink targetNode pickedObject bool_ShowResultDialogue =
	(
		local oldAnimKeysState = SE_AAH_GetAndOffAnimKeys()
		--select pickedObject
		SE_AAH_IncreaseAONumber()
		local newAOAttachHelper
		local pohelper = point size:0.1
		pohelper.name = "AO_" + pickedObject.name + " old anim"
		SE_AAH_UpdateOrCreateAAHHelperLayer()
		SE_AAH_UpdateOrCreateAAHControllerLayer()
		AAHHelperLayer.addnode pohelper
		local isThereAZeroKeyAtAllpos = false
		local isThereAZeroKeyAtAllrot = false
		local isThereAZeroKeyAtAllscl = false
		with Animate on
		(
			if pickedObject.target == undefined then
			(
				if pickedObject.rotation.controller.keys.count > 0 then
				(
					for i = 1 to pickedObject.rotation.controller.keys.count do
					(
						if pickedObject.rotation.controller.keys[i].time == 0.0f do isThereAZeroKeyAtAllrot = true
						at time pickedObject.rotation.controller.keys[i].time
						(
							--pohelper.transform = pickedObject.transform
							----in coordsys world pohelper.rotation.controller.value = in coordsys world pickedObject.rotation.controller.value
							in coordsys world pohelper.rotation.x_rotation = in coordsys world pickedObject.rotation.x_rotation
							in coordsys world pohelper.rotation.y_rotation = in coordsys world pickedObject.rotation.y_rotation
							in coordsys world pohelper.rotation.z_rotation = in coordsys world pickedObject.rotation.z_rotation
							
							--if pickedObject.parent != undefined then
							--	in coordsys parent pohelper.rotation.controller.value = (pickedObject.transform * (inverse pickedObject.parent.transform)) as quat
							--else
							--	in coordsys parent pohelper.rotation.controller.value = pickedObject.transform as quat
							
							--in coordsys world pohelper.rotation.controller.value = pickedObject.transform as quat
						)
					)
				)
				else
				(
					at time sliderTime
					(
						----in coordsys world pohelper.transform = in coordsys world pickedObject.transform
						in coordsys world pohelper.rotation.x_rotation = in coordsys world pickedObject.rotation.x_rotation
						in coordsys world pohelper.rotation.y_rotation = in coordsys world pickedObject.rotation.y_rotation
						in coordsys world pohelper.rotation.z_rotation = in coordsys world pickedObject.rotation.z_rotation
					)
				)
			)
			else
			(
				if pickedObject.controller.roll_angle.controller.keys.count > 0 then
				(
					for i = 1 to pickedObject.controller.roll_angle.controller.keys.count do
					(
						if pickedObject.controller.roll_angle.controller.keys[i].time == 0.0f do isThereAZeroKeyAtAllrot = true
						at time pickedObject.controller.roll_angle.controller.keys[i].time
						(
							--pohelper.transform = pickedObject.transform
							in coordsys world pohelper.transform = in coordsys world pickedObject.transform
						)
					)
				)
				else
				(
					at time sliderTime
					(
						--pohelper.transform = pickedObject.transform
						in coordsys world pohelper.transform = in coordsys world pickedObject.transform
					)
				)
			)
			if pickedObject.position.controller.keys.count > 0 then
			(
				for i = 1 to pickedObject.position.controller.keys.count do
				(
					if pickedObject.position.controller.keys[i].time == 0.0f do isThereAZeroKeyAtAllpos = true
					at time pickedObject.position.controller.keys[i].time
					(
						--pohelper.transform = pickedObject.transform
						in coordsys world pohelper.position.x = in coordsys world pickedObject.position.x
						in coordsys world pohelper.position.y = in coordsys world pickedObject.position.y
						in coordsys world pohelper.position.z = in coordsys world pickedObject.position.z
					)
				)
			)
			else
			(
				at time sliderTime
				(
					--pohelper.transform = pickedObject.transform
					----in coordsys world pohelper.transform = in coordsys world pickedObject.transform
					in coordsys world pohelper.position.x = in coordsys world pickedObject.position.x
					in coordsys world pohelper.position.y = in coordsys world pickedObject.position.y
					in coordsys world pohelper.position.z = in coordsys world pickedObject.position.z
				)
			)
			if pickedObject.scale.controller.keys.count > 0 then
			(
				for i = 1 to pickedObject.scale.controller.keys.count do
				(
					if pickedObject.scale.controller.keys[i].time == 0.0f do isThereAZeroKeyAtAllscl = true
					at time pickedObject.scale.controller.keys[i].time
					(
						--pohelper.transform = pickedObject.transform
						in coordsys world pohelper.scale.x = in coordsys world pickedObject.scale.x
						in coordsys world pohelper.scale.y = in coordsys world pickedObject.scale.y
						in coordsys world pohelper.scale.z = in coordsys world pickedObject.scale.z
					)
				)
			)
			else
			(
				at time sliderTime
				(
					--pohelper.transform = pickedObject.transform
					----in coordsys world pohelper.transform = in coordsys world pickedObject.transform
					in coordsys world pohelper.scale.x = in coordsys world pickedObject.scale.x
					in coordsys world pohelper.scale.y = in coordsys world pickedObject.scale.y
					in coordsys world pohelper.scale.z = in coordsys world pickedObject.scale.z
				)
			)
		)
		if isThereAZeroKeyAtAllpos == false do --we need to prevent the automatic creation of an extra anim key at zero frame
		(
			deselectKeys pohelper.position.controller
			selectKeys pohelper.position.controller 0.0f
			deleteKeys pohelper.position.controller #selection
		)
		if isThereAZeroKeyAtAllrot == false do --we need to prevent the automatic creation of an extra anim key at zero frame
		(
			deselectKeys pohelper.rotation.controller
			selectKeys pohelper.rotation.controller 0.0f
			deleteKeys pohelper.rotation.controller #selection
		)
		if isThereAZeroKeyAtAllscl == false do --we need to prevent the automatic creation of an extra anim key at zero frame
		(
			deselectKeys pohelper.scale.controller
			selectKeys pohelper.scale.controller 0.0f
			deleteKeys pohelper.scale.controller #selection
		)
		setUserProp pohelper "AOHelperNumber" NewAO_Number
		if pickedObject.target == undefined then deleteKeys pickedObject.rotation.controller #allKeys
		else deleteKeys pickedObject.controller.roll_angle.controller #allKeys
		deleteKeys pickedObject.position.controller #allKeys
		deleteKeys pickedObject.scale.controller #allKeys
		----at time sliderTime pickedObject.transform= pohelper.transform   -- bug with pickedObject object teleportation after attach
		pickedObject.transform= pohelper.transform
		if pickedObject.target == undefined then addNewKey pickedObject.rotation.controller sliderTime
		else addNewKey pickedObject.controller.roll_angle.controller sliderTime
		addNewKey pickedObject.position.controller sliderTime
		addNewKey pickedObject.scale.controller sliderTime  
		if pickedObject.parent != undefined then
		(
			local currentAOParent_Number
			if getUserProp pickedObject.parent "AOParentPNumber" != undefined and getUserProp pickedObject.parent "AOParentPNumber" > 0 then
			(
				currentAOParent_Number = getUserProp pickedObject.parent "AOParentPNumber"
			)
			else
			(
				SE_AAH_IncreaseAOParentNumber()
				currentAOParent_Number = NewAOParent_Number
				setUserProp pickedObject.parent "AOParentPNumber" currentAOParent_Number
			)
			setUserProp pickedObject "AOParentCNumber" currentAOParent_Number
		)
		else
		(
			setUserProp pickedObject "AOParentCNumber" -1						
		)
		
		local newAOAttachHelperSize = 0.1
		
		if ClassOf pickedObject != point then
		(
			local newAOAttachHelperSizeBB= nodeLocalBoundingBox pickedObject
			newAOAttachHelperSize = (length(newAOAttachHelperSizeBB[2] - newAOAttachHelperSizeBB[1]))*0.5
		)
		else newAOAttachHelperSize = pickedObject.size*0.5
		if 0.1 > newAOAttachHelperSize do newAOAttachHelperSize = 0.1	
		newAOAttachHelper = point size:newAOAttachHelperSize
		newAOAttachHelper.name = "AO_" + pickedObject.name + " attach controller"
		newAOAttachHelper.cross = true
		newAOAttachHelper.box = true
		newAOAttachHelper.drawontop = true
		newAOAttachHelper.wirecolor = (color 255 106 0)
		newAOAttachHelper.position.x = targetNode.position.x
		newAOAttachHelper.position.y = targetNode.position.y
		newAOAttachHelper.position.z = targetNode.position.z
		if targetNode.target == undefined then
		(
			newAOAttachHelper.rotation.x_rotation = targetNode.rotation.x_rotation
			newAOAttachHelper.rotation.y_rotation = targetNode.rotation.y_rotation
			newAOAttachHelper.rotation.z_rotation = targetNode.rotation.z_rotation
		)
		else newAOAttachHelper.transform = targetNode.transform
		addNewKey newAOAttachHelper.position.controller sliderTime
		addNewKey newAOAttachHelper.rotation.controller sliderTime
		addNewKey newAOAttachHelper.scale.controller sliderTime
		newAOAttachHelper.parent = targetNode
		AAHControllerLayer.addnode newAOAttachHelper
		pickedObject.parent = newAOAttachHelper
		if pickedObject.target != undefined do
		(
			local crollanglehelper = point size:0.1
			crollanglehelper.name = "AO_" + pickedObject.name + " roll angle temp helper"
			AAHHelperLayer.addnode crollanglehelper
			at time sliderTime
			(
				crollanglehelper.transform = pohelper.transform
			)
			crollanglehelper.parent = newAOAttachHelper
			pickedObject.controller.roll_angle.controller = Float_Script()
			pickedObject.controller.roll_angle.controller.addNode "crah" (crollanglehelper)
			--pickedObject.controller.roll_angle.controller.script = "-0.0175*(crah.transform.rotation as eulerangles).y"
			--pickedObject.controller.roll_angle.controller.script = "0.0175*atan2(crah.transform.row1.z)(crah.transform.row3.z)"
			--pickedObject.controller.roll_angle.controller.script = "-0.0175*crah.rotation.y_rotation"
			--pickedObject.controller.roll_angle.controller.script = "-0.0175*(atan2(crah.transform.row3.y)(crah.transform.row3.z)+atan2(crah.transform.row3.x)(crah.transform.row3.z))"
			--pickedObject.controller.roll_angle.controller.script = "-0.0175*crah.rotation.y_rotation"
			pickedObject.controller.roll_angle.controller.script = "if crah.transform.row2.z < 0.0 then
roll_angle = 3.1416+0.0175*(crah.transform.rotation as eulerangles).y
else
roll_angle = -0.0175*(crah.transform.rotation as eulerangles).y"--"0.00875*((ftest.transform.rotation as eulerangles).x+ftest.rotation.x_rotation)"
			setUserProp crollanglehelper "AOCHelperNumber" NewAO_Number
			freeze crollanglehelper
			hide crollanglehelper
			AAHHelperLayer.addnode crollanglehelper
		)
		freeze pohelper
		hide pohelper
		setUserProp newAOAttachHelper "AOControllerNumber" NewAO_Number  -- setUserProp targetNode "AOBoneNumber" NewAO_Number
		setUserProp pickedObject "AObjectNumber" NewAO_Number
		if bool_ShowResultDialogue == 1 do
		(
			local info_str_msg = "Object \"" + pickedObject.name + "\" has been successfully attached to \"" + targetNode.name + "\"."
			messagebox info_str_msg title:"Done!"
		)
		SE_AAH_SetBackAnimKeys oldAnimKeysState
		return newAOAttachHelper
	)
	
	/*---------------------------------------------------------------------------------------------------*/
	
	fn RemoveAOLink bkAOArray BakeAOAnimFlag bool_DetailedAOAnim float_DetailedAOAnim bool_ShowResultDialogue =
	(
		local oldAnimKeysState = SE_AAH_GetAndOffAnimKeys()
		SE_AAH_UpdateOrCreateAAHHelperLayer()
		SE_AAH_UpdateOrCreateAAHControllerLayer()
		local isThereAZeroKeyAtAllpos = false
		local isThereAZeroKeyAtAllrot = false
		local isThereAZeroKeyAtAllscl = false
		--AAHHelperLayer 
		--AAHHelperLayer.nodes &thenodes
		local localbkAOArray = bkAOArray -- to prevent EXCEPTION ACCESS VIOLATION  memory error while deleting array's nodes, we need to create a local array which will be a copy of initial array
		for bkAOATargetObject in localbkAOArray do
		(
			if isValidNode bkAOATargetObject do
			(
				if getUserProp bkAOATargetObject "AObjectNumber" != undefined and getUserProp bkAOATargetObject "AObjectNumber" != -1 do
				(
					local wholeAttachBakingTime = timeStamp()
					SE_AAH_Process_Rollout.lbl_PrcssAAH.text = "Baking attach initialising"
					try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
					local AObject_Number = getUserProp bkAOATargetObject "AObjectNumber"
					local AOController
					local AObjecthelper
					local AObjectRAhelper
					for AOCAll in objects do
					(
						if getUserProp AOCAll "AOControllerNumber" == AObject_Number do AOController = AOCAll
						if getUserProp AOCAll "AOHelperNumber" == AObject_Number do AObjecthelper = AOCAll
						if getUserProp AOCAll "AOCHelperNumber" == AObject_Number do AObjectRAhelper = AOCAll	
					)
					if BakeAOAnimFlag == 1 and AObjecthelper != undefined do
					(
						local AOAnimRangeStart
						local AOAnimRangeEnd
						if bkAOATargetObject.position.controller.keys.count > 0 do
						(
							AOAnimRangeStart = bkAOATargetObject.position.controller.keys[1].time
							--if bkAOATargetObject.position.controller.keys.count > 1 do 
							AOAnimRangeEnd = bkAOATargetObject.position.controller.keys[bkAOATargetObject.position.controller.keys.count].time
						)
						--format "AOController: %\n\n" AOController
						if AOController.position.controller.keys.count > 0 do
						(
							if AOAnimRangeStart != undefined then
							(
								if AOAnimRangeStart > AOController.position.controller.keys[1].time do AOAnimRangeStart = AOController.position.controller.keys[1].time
							)
							else AOAnimRangeStart = AOController.position.controller.keys[1].time
							--if AOController.position.controller.keys.count > 1 do
							--(
								if AOAnimRangeEnd != undefined then
								(
									if AOAnimRangeEnd < AOController.position.controller.keys[AOController.position.controller.keys.count].time do AOAnimRangeEnd = AOController.position.controller.keys[AOController.position.controller.keys.count].time
								)
								else AOAnimRangeEnd = AOController.position.controller.keys[AOController.position.controller.keys.count].time
							--)
						)
						if bkAOATargetObject.target == undefined then
						(
							if bkAOATargetObject.rotation.controller.keys.count > 0 do
							(
								if AOAnimRangeStart != undefined then
								(
									if AOAnimRangeStart > bkAOATargetObject.rotation.controller.keys[1].time do AOAnimRangeStart = bkAOATargetObject.rotation.controller.keys[1].time
								)
								else AOAnimRangeStart = bkAOATargetObject.rotation.controller.keys[1].time
								--if bkAOATargetObject.rotation.controller.keys.count > 1 do
								--(
									if AOAnimRangeEnd != undefined then
									(
										if AOAnimRangeEnd < bkAOATargetObject.rotation.controller.keys[bkAOATargetObject.rotation.controller.keys.count].time do AOAnimRangeEnd = bkAOATargetObject.rotation.controller.keys[bkAOATargetObject.rotation.controller.keys.count].time
									)
									else AOAnimRangeEnd = bkAOATargetObject.rotation.controller.keys[bkAOATargetObject.rotation.controller.keys.count].time
								--)
							)
						)
						else
						(
							if bkAOATargetObject.controller.roll_angle.controller.keys.count > 0 do
							(
								if AOAnimRangeStart != undefined then
								(
									if AOAnimRangeStart > bkAOATargetObject.controller.roll_angle.controller.keys[1].time do AOAnimRangeStart = bkAOATargetObject.controller.roll_angle.controller.keys[1].time
								)
								else AOAnimRangeStart = bkAOATargetObject.controller.roll_angle.controller.keys[1].time
								--if bkAOATargetObject.controller.roll_angle.controller.keys.count > 1 do
								--(
									if AOAnimRangeEnd != undefined then
									(
										if AOAnimRangeEnd < bkAOATargetObject.controller.roll_angle.controller.keys[bkAOATargetObject.controller.roll_angle.controller.keys.count].time do AOAnimRangeEnd = bkAOATargetObject.controller.roll_angle.controller.keys[bkAOATargetObject.controller.roll_angle.controller.keys.count].time
									)
									else AOAnimRangeEnd = bkAOATargetObject.controller.roll_angle.controller.keys[bkAOATargetObject.controller.roll_angle.controller.keys.count].time
								--)
							)
						)
						if AOController.rotation.controller.keys.count > 0 do
						(
							if AOAnimRangeStart != undefined then
							(
								if AOAnimRangeStart > AOController.rotation.controller.keys[1].time do AOAnimRangeStart = AOController.rotation.controller.keys[1].time
							)
							else AOAnimRangeStart = AOController.rotation.controller.keys[1].time
							--if AOController.rotation.controller.keys.count > 1 do
							--(
								if AOAnimRangeEnd != undefined then
								(
									if AOAnimRangeEnd < AOController.rotation.controller.keys[AOController.rotation.controller.keys.count].time do AOAnimRangeEnd = AOController.rotation.controller.keys[AOController.rotation.controller.keys.count].time
								)
								else AOAnimRangeEnd = AOController.rotation.controller.keys[AOController.rotation.controller.keys.count].time
							--)
						)
						if bkAOATargetObject.scale.controller.keys.count > 0 do
						(
							if AOAnimRangeStart != undefined then
							(
								if AOAnimRangeStart > bkAOATargetObject.scale.controller.keys[1].time do AOAnimRangeStart = bkAOATargetObject.scale.controller.keys[1].time
							)
							else AOAnimRangeStart = bkAOATargetObject.scale.controller.keys[1].time
							--if bkAOATargetObject.scale.controller.keys.count > 1 do
							--(
								if AOAnimRangeEnd != undefined then
								(
									if AOAnimRangeEnd < bkAOATargetObject.scale.controller.keys[bkAOATargetObject.scale.controller.keys.count].time do AOAnimRangeEnd = bkAOATargetObject.scale.controller.keys[bkAOATargetObject.scale.controller.keys.count].time
								)
								else AOAnimRangeEnd = bkAOATargetObject.scale.controller.keys[bkAOATargetObject.scale.controller.keys.count].time
							--)
						)
						if AOController.scale.controller.keys.count > 0 do
						(
							if AOAnimRangeStart != undefined then
							(
								if AOAnimRangeStart > AOController.scale.controller.keys[1].time do AOAnimRangeStart = AOController.scale.controller.keys[1].time
							)
							else AOAnimRangeStart = AOController.scale.controller.keys[1].time
							--if AOController.scale.controller.keys.count > 1 do
							--(
								if AOAnimRangeEnd != undefined then
								(
									if AOAnimRangeEnd < AOController.scale.controller.keys[AOController.scale.controller.keys.count].time do AOAnimRangeEnd = AOController.scale.controller.keys[AOController.scale.controller.keys.count].time
								)
								else AOAnimRangeEnd = AOController.scale.controller.keys[AOController.scale.controller.keys.count].time
							--)
						)
						if AOAnimRangeStart != undefined and AOAnimRangeEnd != undefined do
						(
							deselectKeys AObjecthelper.position.controller
							selectKeys AObjecthelper.position.controller AOAnimRangeStart AOAnimRangeEnd
							deleteKeys AObjecthelper.position.controller #selection
							deselectKeys AObjecthelper.rotation.controller
							selectKeys AObjecthelper.rotation.controller AOAnimRangeStart AOAnimRangeEnd
							deleteKeys AObjecthelper.rotation.controller #selection
							deselectKeys AObjecthelper.scale.controller
							selectKeys AObjecthelper.scale.controller AOAnimRangeStart AOAnimRangeEnd
							deleteKeys AObjecthelper.scale.controller #selection
						)
						if AObjecthelper.position.controller.keys.count > 0 do 
						(
							for i = 1 to AObjecthelper.position.controller.keys.count do
							(
								if AObjecthelper.position.controller.keys[i].time == 0.0f do isThereAZeroKeyAtAllpos = true
							)
						)
						
						if AObjecthelper.rotation.controller.keys.count > 0 do 
						(
							for i = 1 to AObjecthelper.rotation.controller.keys.count do
							(
								if AObjecthelper.rotation.controller.keys[i].time == 0.0f do isThereAZeroKeyAtAllrot = true
							)
						)
						
						if AObjecthelper.scale.controller.keys.count > 0 do 
						(
							for i = 1 to AObjecthelper.scale.controller.keys.count do
							(
								if AObjecthelper.scale.controller.keys[i].time == 0.0f do isThereAZeroKeyAtAllscl = true
							)
						)
						
						with Animate on
						(
							if bool_DetailedAOAnim == false do
							(
								--Start of current object animation baking to temp helper
								if bkAOATargetObject.position.controller.keys.count > 0 do 
								(
									local pgbCount = 0
									local pgbCountTotal = bkAOATargetObject.position.controller.keys.count
									SE_AAH_Process_Rollout.lbl_PrcssAAH.text = "Bk attach pos: " + bkAOATargetObject.name
									for i = 1 to bkAOATargetObject.position.controller.keys.count do
									(
										if bkAOATargetObject.position.controller.keys[i].time == 0.0f do isThereAZeroKeyAtAllpos = true
										at time bkAOATargetObject.position.controller.keys[i].time
										(
											--AObjecthelper.transform = bkAOATargetObject.transform
											in coordsys world AObjecthelper.position.x = in coordsys world bkAOATargetObject.position.x
											in coordsys world AObjecthelper.position.y = in coordsys world bkAOATargetObject.position.y
											in coordsys world AObjecthelper.position.z = in coordsys world bkAOATargetObject.position.z
											pgbCount = pgbCount + 1
											SE_AAH_Process_Rollout.prgb_AAH.value = 100.*pgbCount/pgbCountTotal
										)
									)
								)
								SE_AAH_Process_Rollout.lbl_PrcssAAH.text = "Bk attach pos (Ok!): " + bkAOATargetObject.name
								SE_AAH_Process_Rollout.prgb_AAH.value = 0
								try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
								if bkAOATargetObject.target == undefined then
								(
									if bkAOATargetObject.rotation.controller.keys.count > 0 do
									(
										local pgbCount = 0
										local pgbCountTotal = bkAOATargetObject.rotation.controller.keys.count
										SE_AAH_Process_Rollout.lbl_PrcssAAH.text = "Bk attach rot: " + bkAOATargetObject.name
										for i = 1 to bkAOATargetObject.rotation.controller.keys.count do
										(
											if bkAOATargetObject.rotation.controller.keys[i].time == 0.0f do isThereAZeroKeyAtAllrot = true
											at time bkAOATargetObject.rotation.controller.keys[i].time
											(
												--AObjecthelper.transform = bkAOATargetObject.transform
												
												----in coordsys world AObjecthelper.rotation.controller.value = in coordsys world bkAOATargetObject.rotation.controller.value
												in coordsys world AObjecthelper.rotation.x_rotation = in coordsys world bkAOATargetObject.rotation.x_rotation
												in coordsys world AObjecthelper.rotation.y_rotation = in coordsys world bkAOATargetObject.rotation.y_rotation
												in coordsys world AObjecthelper.rotation.z_rotation = in coordsys world bkAOATargetObject.rotation.z_rotation
												
												
												--in coordsys world AObjecthelper.rotation.controller.value = bkAOATargetObject.transform as quat
												--in coordsys world AObjecthelper.rotation.controller.value = in coordsys world bkAOATargetObject.transform as quat
												pgbCount = pgbCount + 1
												SE_AAH_Process_Rollout.prgb_AAH.value = 100.*pgbCount/pgbCountTotal
											)
										)
									)
									SE_AAH_Process_Rollout.lbl_PrcssAAH.text = "Bk attach rot (Ok!): " + bkAOATargetObject.name
									SE_AAH_Process_Rollout.prgb_AAH.value = 0
									try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
								)
								else
								(
									if bkAOATargetObject.controller.roll_angle.controller.keys.count > 0 do
									(
										local pgbCount = 0
										local pgbCountTotal = bkAOATargetObject.controller.roll_angle.controller.keys.count
										SE_AAH_Process_Rollout.lbl_PrcssAAH.text = "Bk attach roll: " + bkAOATargetObject.name
										for i = 1 to bkAOATargetObject.controller.roll_angle.controller.keys.count do
										(
											if bkAOATargetObject.controller.roll_angle.controller.keys[i].time == 0.0f do isThereAZeroKeyAtAllrot = true
											at time bkAOATargetObject.controller.roll_angle.controller.keys[i].time
											(
												--AObjecthelper.transform = bkAOATargetObject.transform
												--in coordsys world AObjecthelper.rotation.controller.value = in coordsys world bkAOATargetObject.rotation.controller.value
												
												in coordsys world AObjecthelper.transform = in coordsys world bkAOATargetObject.transform
												pgbCount = pgbCount + 1
												SE_AAH_Process_Rollout.prgb_AAH.value = 100.*pgbCount/pgbCountTotal
											)
										)
									)
									SE_AAH_Process_Rollout.lbl_PrcssAAH.text = "Bk attach roll (Ok!): " + bkAOATargetObject.name
									SE_AAH_Process_Rollout.prgb_AAH.value = 0
									try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
								)
								if bkAOATargetObject.scale.controller.keys.count > 0 do
								(
									local pgbCount = 0
									local pgbCountTotal = bkAOATargetObject.scale.controller.keys.count
									SE_AAH_Process_Rollout.lbl_PrcssAAH.text = "Bk attach scl: " + bkAOATargetObject.name
									for i = 1 to bkAOATargetObject.scale.controller.keys.count do
									(
										if bkAOATargetObject.scale.controller.keys[i].time == 0.0f do isThereAZeroKeyAtAllscl = true
										at time bkAOATargetObject.scale.controller.keys[i].time
										(
											--AObjecthelper.transform = bkAOATargetObject.transform
											--in coordsys world AObjecthelper.rotation.controller.value = in coordsys world bkAOATargetObject.rotation.controller.value
											
											in coordsys world AObjecthelper.scale.x = in coordsys world bkAOATargetObject.scale.x
											in coordsys world AObjecthelper.scale.y = in coordsys world bkAOATargetObject.scale.y
											in coordsys world AObjecthelper.scale.z = in coordsys world bkAOATargetObject.scale.z
											pgbCount = pgbCount + 1
											SE_AAH_Process_Rollout.prgb_AAH.value = 100.*pgbCount/pgbCountTotal
										)
									)
								)
								SE_AAH_Process_Rollout.lbl_PrcssAAH.text = "Bk attach scl (Ok!): " + bkAOATargetObject.name
								SE_AAH_Process_Rollout.prgb_AAH.value = 0
								try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.

								--Start of current Attach Controller animation baking to temp helper
								if AOController.position.controller.keys.count > 0 do 
								(
									local pgbCount = 0
									local pgbCountTotal = AOController.position.controller.keys.count
									SE_AAH_Process_Rollout.lbl_PrcssAAH.text = "Bk attach pos2: " + bkAOATargetObject.name
									for i = 1 to AOController.position.controller.keys.count do
									(
										if AOController.position.controller.keys[i].time == 0.0f do isThereAZeroKeyAtAllpos = true
										at time AOController.position.controller.keys[i].time
										(
											--AObjecthelper.transform = AOController.transform
											in coordsys world AObjecthelper.position.x = in coordsys world bkAOATargetObject.position.x
											in coordsys world AObjecthelper.position.y = in coordsys world bkAOATargetObject.position.y
											in coordsys world AObjecthelper.position.z = in coordsys world bkAOATargetObject.position.z
											pgbCount = pgbCount + 1
											SE_AAH_Process_Rollout.prgb_AAH.value = 100.*pgbCount/pgbCountTotal
										)
									)
								)
								SE_AAH_Process_Rollout.lbl_PrcssAAH.text = "Bk attach pos2 (Ok!): " + bkAOATargetObject.name
								SE_AAH_Process_Rollout.prgb_AAH.value = 0
								try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
								if AOController.rotation.controller.keys.count > 0 do
								(
									local pgbCount = 0
									local pgbCountTotal = AOController.rotation.controller.keys.count
									SE_AAH_Process_Rollout.lbl_PrcssAAH.text = "Bk attach rot2: " + bkAOATargetObject.name
									for i = 1 to AOController.rotation.controller.keys.count do
									(
										if AOController.rotation.controller.keys[i].time == 0.0f do isThereAZeroKeyAtAllrot = true
										at time AOController.rotation.controller.keys[i].time
										(
											if bkAOATargetObject.target == undefined then
											(
												--AObjecthelper.transform = bkAOATargetObject.transform
												----in coordsys world AObjecthelper.rotation.controller.value = in coordsys world bkAOATargetObject.rotation.controller.value
												in coordsys world AObjecthelper.rotation.x_rotation = in coordsys world bkAOATargetObject.rotation.x_rotation
												in coordsys world AObjecthelper.rotation.y_rotation = in coordsys world bkAOATargetObject.rotation.y_rotation
												in coordsys world AObjecthelper.rotation.z_rotation = in coordsys world bkAOATargetObject.rotation.z_rotation
												
												--in coordsys world AObjecthelper.rotation.controller.value = in coordsys world bkAOATargetObject.transform as quat
											)
											else
											(
												in coordsys world AObjecthelper.transform = in coordsys world bkAOATargetObject.transform
											)
											pgbCount = pgbCount + 1
											SE_AAH_Process_Rollout.prgb_AAH.value = 100.*pgbCount/pgbCountTotal
										)
									)
								)
								SE_AAH_Process_Rollout.lbl_PrcssAAH.text = "Bk attach rot2 (Ok!): " + bkAOATargetObject.name
								SE_AAH_Process_Rollout.prgb_AAH.value = 0
								try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
								if AOController.scale.controller.keys.count > 0 do
								(
									local pgbCount = 0
									local pgbCountTotal = AOController.scale.controller.keys.count
									SE_AAH_Process_Rollout.lbl_PrcssAAH.text = "Bk attach scl2: " + bkAOATargetObject.name
									for i = 1 to AOController.scale.controller.keys.count do
									(
										if AOController.scale.controller.keys[i].time == 0.0f do isThereAZeroKeyAtAllscl = true
										at time AOController.scale.controller.keys[i].time
										(
											--AObjecthelper.transform = AOController.transform
											--in coordsys world AObjecthelper.rotation.controller.value = in coordsys world AOController.rotation.controller.value
											in coordsys world AObjecthelper.scale.x = in coordsys world bkAOATargetObject.scale.x
											in coordsys world AObjecthelper.scale.y = in coordsys world bkAOATargetObject.scale.y
											in coordsys world AObjecthelper.scale.z = in coordsys world bkAOATargetObject.scale.z
											pgbCount = pgbCount + 1
											SE_AAH_Process_Rollout.prgb_AAH.value = 100.*pgbCount/pgbCountTotal
										)
									)
								)
								SE_AAH_Process_Rollout.lbl_PrcssAAH.text = "Bk attach scl2 (Ok!): " + bkAOATargetObject.name
								SE_AAH_Process_Rollout.prgb_AAH.value = 0
								try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
							)
							
							--Start of current object animation baking depending detailed interval
							if bool_DetailedAOAnim and AOAnimRangeStart != undefined and AOAnimRangeEnd != undefined do
							(
								if AOAnimRangeStart < AOAnimRangeEnd and (AOAnimRangeEnd - AOAnimRangeStart) > float_DetailedAOAnim do
								(
									local pgbCount = 0
									local pgbCountTotal = (((AOAnimRangeEnd - AOAnimRangeStart)as float)/TicksPerFrame / float_DetailedAOAnim) as integer
									SE_AAH_Process_Rollout.lbl_PrcssAAH.text = "Bk attach Int: " + bkAOATargetObject.name
									local DetailedAOAnimCurrentTime = AOAnimRangeStart
									while DetailedAOAnimCurrentTime <= AOAnimRangeEnd do
									(
										if DetailedAOAnimCurrentTime == 0.0f do
										(
											isThereAZeroKeyAtAllpos = true
											isThereAZeroKeyAtAllrot = true
											isThereAZeroKeyAtAllscl = true
										)
										at time DetailedAOAnimCurrentTime
										(
											in coordsys world AObjecthelper.transform = in coordsys world bkAOATargetObject.transform
											pgbCount = pgbCount + 1
											SE_AAH_Process_Rollout.prgb_AAH.value = 100.*pgbCount/pgbCountTotal
										)
										DetailedAOAnimCurrentTime += float_DetailedAOAnim
									)
								)
								SE_AAH_Process_Rollout.lbl_PrcssAAH.text = "Bk attach Int (Ok!): " + bkAOATargetObject.name
								SE_AAH_Process_Rollout.prgb_AAH.value = 0
								try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
							)
						)
						if isThereAZeroKeyAtAllpos == false do --we need to prevent the automatic creation of an extra anim key at zero frame
						(
							deselectKeys AObjecthelper.position.controller
							selectKeys AObjecthelper.position.controller 0.0f
							deleteKeys AObjecthelper.position.controller #selection
						)	
						if isThereAZeroKeyAtAllrot == false do --we need to prevent the automatic creation of an extra anim key at zero frame
						(	
							deselectKeys AObjecthelper.rotation.controller
							selectKeys AObjecthelper.rotation.controller 0.0f
							deleteKeys AObjecthelper.rotation.controller #selection
						)	
						if isThereAZeroKeyAtAllscl == false do --we need to prevent the automatic creation of an extra anim key at zero frame
						(	
							deselectKeys AObjecthelper.scale.controller
							selectKeys AObjecthelper.scale.controller 0.0f
							deleteKeys AObjecthelper.scale.controller #selection
						)
					)
					setUserProp bkAOATargetObject "AObjectNumber" -1
					if getUserProp bkAOATargetObject "AOParentCNumber" != undefined and getUserProp bkAOATargetObject "AOParentCNumber" > 0 then
					(
						local currentAOParentNumber = getUserProp bkAOATargetObject "AOParentCNumber"
						local AOOriginalParent
						for AOAllO in objects do
						(
							if getUserProp AOAllO "AOParentPNumber" == currentAOParentNumber do
							(
								AOOriginalParent = AOAllO
							)
						)
						if	AOOriginalParent != undefined then bkAOATargetObject.parent = AOOriginalParent
						else bkAOATargetObject.parent = undefined
						setUserProp bkAOATargetObject "AOParentCNumber" -1
					)
					else bkAOATargetObject.parent = undefined
					if AObjecthelper != undefined do setUserProp AObjecthelper "AOHelperNumber" -1
					--if AOController != undefined do setUserProp AOController "AOControllerNumber" -1
					if AOController != undefined do delete AOController
					deleteKeys bkAOATargetObject.position.controller #allKeys
					if bkAOATargetObject.target == undefined then deleteKeys bkAOATargetObject.rotation.controller #allKeys
					else
					(
						bkAOATargetObject.controller.roll_angle.controller = Bezier_Float()
						deleteKeys bkAOATargetObject.controller.roll_angle.controller #allKeys
					)
					deleteKeys bkAOATargetObject.scale.controller #allKeys
					isThereAZeroKeyAtAllpos = false
					isThereAZeroKeyAtAllrot = false
					isThereAZeroKeyAtAllscl = false
					with Animate on
					(
						if AObjecthelper != undefined do
						(
							
							--Start of final animation baking/restoring
							if AObjecthelper.position.controller.keys.count > 0 do
							(
								local pgbCount = 0
								local pgbCountTotal = AObjecthelper.position.controller.keys.count
								SE_AAH_Process_Rollout.lbl_PrcssAAH.text = "Bk attach pos3: " + bkAOATargetObject.name
								for i = 1 to AObjecthelper.position.controller.keys.count do
								(
									if AObjecthelper.position.controller.keys[i].time == 0.0f do isThereAZeroKeyAtAllpos = true
									at time AObjecthelper.position.controller.keys[i].time
									(
										--bkAOATargetObject.transform = AObjecthelper.transform
										in coordsys world bkAOATargetObject.position.x = in coordsys world AObjecthelper.position.x
										in coordsys world bkAOATargetObject.position.y = in coordsys world AObjecthelper.position.y
										in coordsys world bkAOATargetObject.position.z = in coordsys world AObjecthelper.position.z
										pgbCount = pgbCount + 1
										SE_AAH_Process_Rollout.prgb_AAH.value = 100.*pgbCount/pgbCountTotal
									)
								)
							)
							SE_AAH_Process_Rollout.lbl_PrcssAAH.text = "Bk attach pos3 (Ok!): " + bkAOATargetObject.name
							SE_AAH_Process_Rollout.prgb_AAH.value = 0
							try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
							if AObjecthelper.rotation.controller.keys.count > 0 do
							(
								local pgbCount = 0
								local pgbCountTotal = AObjecthelper.rotation.controller.keys.count
								SE_AAH_Process_Rollout.lbl_PrcssAAH.text = "Bk attach rot3: " + bkAOATargetObject.name
								for i = 1 to AObjecthelper.rotation.controller.keys.count do
								(
									if AObjecthelper.rotation.controller.keys[i].time == 0.0f do isThereAZeroKeyAtAllrot = true
									at time AObjecthelper.rotation.controller.keys[i].time
									(
										--bkAOATargetObject.transform = AObjecthelper.transform
										if bkAOATargetObject.target != undefined then
										(
											if AObjecthelper.transform.row2.z < 0.0 then bkAOATargetObject.controller.roll_angle = 180.0+(AObjecthelper.transform.rotation as eulerangles).y
											else	bkAOATargetObject.controller.roll_angle = -(AObjecthelper.transform.rotation as eulerangles).y
										)
										else
										(
											----in coordsys world bkAOATargetObject.rotation.controller.value = in coordsys world AObjecthelper.rotation.controller.value
											in coordsys world bkAOATargetObject.rotation.x_rotation = in coordsys world AObjecthelper.rotation.x_rotation
											in coordsys world bkAOATargetObject.rotation.y_rotation = in coordsys world AObjecthelper.rotation.y_rotation
											in coordsys world bkAOATargetObject.rotation.z_rotation = in coordsys world AObjecthelper.rotation.z_rotation
										)
										--else in coordsys world bkAOATargetObject.rotation.controller.value = in coordsys world AObjecthelper.transform as quat
										pgbCount = pgbCount + 1
										SE_AAH_Process_Rollout.prgb_AAH.value = 100.*pgbCount/pgbCountTotal
									)
								)
							)
							SE_AAH_Process_Rollout.lbl_PrcssAAH.text = "Bk attach rot3 (Ok!): " + bkAOATargetObject.name
							SE_AAH_Process_Rollout.prgb_AAH.value = 0
							try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
							if AObjecthelper.scale.controller.keys.count > 0 do
							(
								local pgbCount = 0
								local pgbCountTotal = AObjecthelper.scale.controller.keys.count
								SE_AAH_Process_Rollout.lbl_PrcssAAH.text = "Bk attach scl3: " + bkAOATargetObject.name
								for i = 1 to AObjecthelper.scale.controller.keys.count do
								(
									if AObjecthelper.scale.controller.keys[i].time == 0.0f do isThereAZeroKeyAtAllscl = true
									at time AObjecthelper.scale.controller.keys[i].time
									(
										--bkAOATargetObject.transform = AObjecthelper.transform
										in coordsys world bkAOATargetObject.scale.x = in coordsys world AObjecthelper.scale.x
										in coordsys world bkAOATargetObject.scale.y = in coordsys world AObjecthelper.scale.y
										in coordsys world bkAOATargetObject.scale.z = in coordsys world AObjecthelper.scale.z
										pgbCount = pgbCount + 1
										SE_AAH_Process_Rollout.prgb_AAH.value = 100.*pgbCount/pgbCountTotal
									)
								)
							)
							SE_AAH_Process_Rollout.lbl_PrcssAAH.text = "Bk attach scl3 (Ok!): " + bkAOATargetObject.name
							SE_AAH_Process_Rollout.prgb_AAH.value = 0
							try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
						)
					)
					if isThereAZeroKeyAtAllpos == false do --we need to prevent the automatic creation of an extra anim key at zero frame
					(
						deselectKeys bkAOATargetObject.position.controller
						selectKeys bkAOATargetObject.position.controller 0.0f
						deleteKeys bkAOATargetObject.position.controller #selection
					)	
					if isThereAZeroKeyAtAllrot == false do --we need to prevent the automatic creation of an extra anim key at zero frame
					(	
						if bkAOATargetObject.target != undefined then
						(
							deselectKeys bkAOATargetObject.controller.roll_angle.controller
							selectKeys bkAOATargetObject.controller.roll_angle.controller 0.0f
							deleteKeys bkAOATargetObject.controller.roll_angle.controller #selection
							
						)
						else
						(
							deselectKeys bkAOATargetObject.rotation.controller
							selectKeys bkAOATargetObject.rotation.controller 0.0f
							deleteKeys bkAOATargetObject.rotation.controller #selection
						)
					)
					if isThereAZeroKeyAtAllscl == false do --we need to prevent the automatic creation of an extra anim key at zero frame
					(	
						deselectKeys bkAOATargetObject.scale.controller
						selectKeys bkAOATargetObject.scale.controller 0.0f
						deleteKeys bkAOATargetObject.scale.controller #selection
					)
					if AObjecthelper != undefined do delete AObjecthelper
					if AObjectRAhelper != undefined do delete AObjectRAhelper
					wholeAttachBakingTime = (((timeStamp() - wholeAttachBakingTime) / 1000.0) as string)
					SE_AAH_Process_Rollout.lbl_PrcssAAH.text = "Attach baked in " + wholeAttachBakingTime + "s"
					SE_AAH_Process_Rollout.prgb_AAH.value = 0
					try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
					if bool_ShowResultDialogue == 1 do
					(
						local info_str_msg = bkAOATargetObject.name + " attach anim baked in " + wholeAttachBakingTime + " seconds!"
						messageBox info_str_msg title:"Done!"
					)
				)
			)
		)
		clearselection()
		SE_AAH_SetBackAnimKeys oldAnimKeysState
	)
	
	/*---------------------------------------------------------------------------------------------------*/
	 
	fn UpdateAnimRangeStartAndEnd =
	(
		SE_AAH_UpdateAnimRangeStartAndEnd selection rb_AnimKeysRange.state chkbx_ACTrnsfrmKsPos.state chkbx_ACTrnsfrmKsRot.state chkbx_ACTrnsfrmKsScale.state chkbx_ACTrnsfrmKsRoll.state chkbx_ACTrnsfrmKsFOV.state spn_ACTrnsfrmRangeStartVal.value spn_ACTrnsfrmRangeEndVal.value true
	)
	
	/*---------------------------------------------------------------------------------------------------*/
	
	fn BakeTransformKeysForArray bkArray chbPos chbRot chbScl chbRll chbFOV arStart arEnd bkInterval chbDelOrigKeyframes bool_ShowResultDialogue = --arType
	(
		local wholeBakingTransformTime = timeStamp()
		SE_AAH_Process_Rollout.lbl_PrcssAAH.text = "Transform Baking initialising"
		try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
		local BakePointHelper = point size:0.1
		BakePointHelper.scale.controller = ScaleXYZ()
		BakePointHelper.name = "BakeObjectsTransform temp helper"
		BakeCamHelper = freecamera()
		BakeCamHelper.name = "BakeObjectsTransform temp Cam helper"
		SE_AAH_UpdateOrCreateAAHHelperLayer()
		AAHHelperLayer.addnode BakePointHelper
		AAHHelperLayer.addnode BakeCamHelper
		local pgbCount = 0
		local pgbCountTotal = bkArray.count
		local isThereAZeroKeyAtAllpos = false
		local isThereAZeroKeyAtAllrot = false
		local isThereAZeroKeyAtAllscl = false
		local isThereAZeroKeyAtAllfov = false
		with Animate on
		(
			for bkArrayCurrentNode in bkArray do
			(
				isThereAZeroKeyAtAllpos = false
				isThereAZeroKeyAtAllrot = false
				isThereAZeroKeyAtAllscl = false
				isThereAZeroKeyAtAllfov = false
				BakePointHelper.parent = undefined
				--at time 0.0
				--(
					BakePointHelper.position = [0.0,0.0,0.0]
					in coordsys world BakePointHelper.rotation.x_rotation = 0.0
					in coordsys world BakePointHelper.rotation.y_rotation = 0.0
					in coordsys world BakePointHelper.rotation.z_rotation = 0.0
					ResetScale BakePointHelper -- mapped method
					in coordsys parent BakePointHelper.scale = [1,1,1]
					local objTm= in coordsys parent BakePointHelper.transform
					local objTmX=normalize objTm.row1
					local objTmY=normalize objTm.row2
					local objTmZ=normalize (cross objTmX objTmY) --Rebuild the Z to orthogonalize the matrix.
					in coordsys parent BakePointHelper.transform=(matrix3 objTmX objTmY objTmZ objTm.pos)
				--)
				
				deleteKeys BakePointHelper.position.controller
				deleteKeys BakePointHelper.rotation.controller
				deleteKeys BakePointHelper.scale.controller
				if bkArrayCurrentNode.parent != undefined do
				(
					BakePointHelper.parent = bkArrayCurrentNode.parent
				)
				local BakeRangeKeysCount = (arEnd - arStart) / bkInterval
				if BakeRangeKeysCount > 0 do
				(
					SE_AAH_Process_Rollout.lbl_PrcssAAH.text = "Baking: " + bkArrayCurrentNode.name
					if chbPos == true and ((chbRot == false and chbRll == false) or chbScl == false or ClassOf bkArrayCurrentNode == targetcamera or ClassOf bkArrayCurrentNode == VRayPhysicalCamera or ClassOf bkArrayCurrentNode == freecamera) do
					(	
						for i = 0 to BakeRangeKeysCount do
						(
							if (arStart + (i * bkInterval)) == 0.0f do isThereAZeroKeyAtAllpos = true
							at time (arStart + (i * bkInterval))
							(
								in coordsys parent BakePointHelper.position = in coordsys parent bkArrayCurrentNode.position
								in coordsys parent BakePointHelper.position = in coordsys parent bkArrayCurrentNode.position
							)
						)
						if arEnd == 0.0f do isThereAZeroKeyAtAllpos = true
						at time arEnd
						(
							in coordsys parent BakePointHelper.position = in coordsys parent bkArrayCurrentNode.position
							in coordsys parent BakePointHelper.position = in coordsys parent bkArrayCurrentNode.position
						)
						if BakePointHelper.position.controller.keys.count > 0 do
						(
							if BakePointHelper.position.controller.keys.count > 0 do
							(
								if isThereAZeroKeyAtAllpos == false do --we need to prevent the automatic creation of an extra anim key at zero frame
								(
									deselectKeys BakePointHelper.position.controller
									selectKeys BakePointHelper.position.controller 0.0f
									deleteKeys BakePointHelper.position.controller #selection
								)
								if bkArrayCurrentNode.position.controller.keys.count > 0 do 
								(
									for i = 1 to bkArrayCurrentNode.position.controller.keys.count do
									(
										if bkArrayCurrentNode.position.controller.keys[i].time == 0.0f do isThereAZeroKeyAtAllpos = true
									)
								)
								if chbDelOrigKeyframes == true do
								(
									deselectKeys bkArrayCurrentNode.position.controller
									selectKeys bkArrayCurrentNode.position.controller arStart arEnd
									deleteKeys bkArrayCurrentNode.position.controller #selection
								)
							)
							for i = 1 to BakePointHelper.position.controller.keys.count do
							(
								at time BakePointHelper.position.controller.keys[i].time
								(
									in coordsys parent appendKey bkArrayCurrentNode.position.x_position.controller.keys BakePointHelper.position.x_position.controller.keys[i]
									in coordsys parent appendKey bkArrayCurrentNode.position.y_position.controller.keys BakePointHelper.position.y_position.controller.keys[i]
									in coordsys parent appendKey bkArrayCurrentNode.position.z_position.controller.keys BakePointHelper.position.z_position.controller.keys[i]
								)
							)
							if isThereAZeroKeyAtAllpos == false do --we need to prevent the automatic creation of an extra anim key at zero frame
							(
								deselectKeys bkArrayCurrentNode.position.controller
								selectKeys bkArrayCurrentNode.position.controller 0.0f
								deleteKeys bkArrayCurrentNode.position.controller #selection
							)
						)
						deleteKeys BakePointHelper.position.controller
						deleteKeys BakePointHelper.rotation.controller
						deleteKeys BakePointHelper.scale.controller
					)
					if (chbRot == true or chbRll == true) and (chbPos == false or chbScl == false or ClassOf bkArrayCurrentNode == targetcamera or ClassOf bkArrayCurrentNode == VRayPhysicalCamera or ClassOf bkArrayCurrentNode == freecamera) do
					(	
						for i = 0 to BakeRangeKeysCount do
						(
							if (arStart + (i * bkInterval)) == 0.0f do isThereAZeroKeyAtAllrot = true
							at time (arStart + (i * bkInterval))
							(
								in coordsys world BakePointHelper.transform = in coordsys world bkArrayCurrentNode.transform
								in coordsys world BakePointHelper.transform = in coordsys world bkArrayCurrentNode.transform
							)
						)
						if arEnd == 0.0f do isThereAZeroKeyAtAllrot = true
						at time arEnd
						(
							in coordsys world BakePointHelper.transform = in coordsys world bkArrayCurrentNode.transform
							in coordsys world BakePointHelper.transform = in coordsys world bkArrayCurrentNode.transform
						)
						deleteKeys BakePointHelper.position.controller
						--deleteKeys BakePointHelper.rotation.controller
						deleteKeys BakePointHelper.scale.controller
						--format "Rot keys count: %\n\n" BakePointHelper.rotation.controller.keys.count
						if BakePointHelper.rotation.controller.keys.count > 0 do
						(
							if BakePointHelper.rotation.controller.keys.count > 0 do
							(
								if isThereAZeroKeyAtAllrot == false do --we need to prevent the automatic creation of an extra anim key at zero frame
								(
									deselectKeys BakePointHelper.rotation.controller
									selectKeys BakePointHelper.rotation.controller 0.0f
									deleteKeys BakePointHelper.rotation.controller #selection
								)
								if bkArrayCurrentNode.target != undefined and chbRll == true then
								(
									if bkArrayCurrentNode.controller.roll_angle.controller.keys.count > 0 do 
									(
										for i = 1 to bkArrayCurrentNode.controller.roll_angle.controller.keys.count do
										(
											if bkArrayCurrentNode.controller.roll_angle.controller.keys[i].time == 0.0f do isThereAZeroKeyAtAllrot = true
										)
									)
									if chbDelOrigKeyframes == true do
									(
										deselectKeys bkArrayCurrentNode.controller.roll_angle.controller
										selectKeys bkArrayCurrentNode.controller.roll_angle.controller arStart arEnd
										deleteKeys bkArrayCurrentNode.controller.roll_angle.controller #selection
									)
								)
								else if chbRot == true do
								(
									if bkArrayCurrentNode.rotation.controller.keys.count > 0 do 
									(
										for i = 1 to bkArrayCurrentNode.rotation.controller.keys.count do
										(
											if bkArrayCurrentNode.rotation.controller.keys[i].time == 0.0f do isThereAZeroKeyAtAllrot = true
										)
									)
									if chbDelOrigKeyframes == true do
									(
										--format "deleting extra keys...\n\n"
										deselectKeys bkArrayCurrentNode.rotation.controller
										selectKeys bkArrayCurrentNode.rotation.controller arStart arEnd
										deleteKeys bkArrayCurrentNode.rotation.controller #selection
									)
								)
							)
							for i = 1 to BakePointHelper.rotation.controller.keys.count do
							(
								at time BakePointHelper.rotation.controller.keys[i].time
								(
									if bkArrayCurrentNode.target != undefined and chbRll == true then
									(
										if BakePointHelper.transform.row2.z < 0.0 then
										(
											in coordsys parent bkArrayCurrentNode.controller.roll_angle = 180.0+(BakePointHelper.transform.rotation as eulerangles).y
											in coordsys parent bkArrayCurrentNode.controller.roll_angle = 180.0+(BakePointHelper.transform.rotation as eulerangles).y
										)
										else
										(
											in coordsys parent bkArrayCurrentNode.controller.roll_angle = -(BakePointHelper.transform.rotation as eulerangles).y
											in coordsys parent bkArrayCurrentNode.controller.roll_angle = -(BakePointHelper.transform.rotation as eulerangles).y
										)
									)
									else if chbRot == true do
									(
										in coordsys parent appendKey bkArrayCurrentNode.rotation.x_rotation.controller.keys BakePointHelper.rotation.x_rotation.controller.keys[i]
										in coordsys parent appendKey bkArrayCurrentNode.rotation.y_rotation.controller.keys BakePointHelper.rotation.y_rotation.controller.keys[i]
										in coordsys parent appendKey bkArrayCurrentNode.rotation.z_rotation.controller.keys BakePointHelper.rotation.z_rotation.controller.keys[i]
									)
								)
							)
							if isThereAZeroKeyAtAllrot == false do --we need to prevent the automatic creation of an extra anim key at zero frame
							(
								if bkArrayCurrentNode.target != undefined and chbRll == true then
								(
									deselectKeys bkArrayCurrentNode.controller.roll_angle.controller
									selectKeys bkArrayCurrentNode.controller.roll_angle.controller 0.0f
									deleteKeys bkArrayCurrentNode.controller.roll_angle.controller #selection
								)
								else if chbRot == true do
								(
									deselectKeys bkArrayCurrentNode.rotation.controller
									selectKeys bkArrayCurrentNode.rotation.controller 0.0f
									deleteKeys bkArrayCurrentNode.rotation.controller #selection
								)
							)
						)
						deleteKeys BakePointHelper.position.controller
						deleteKeys BakePointHelper.rotation.controller
						deleteKeys BakePointHelper.scale.controller
					)
					isThereAZeroKeyAtAllpos = false
					isThereAZeroKeyAtAllrot = false
					
					if chbScl == true and ClassOf bkArrayCurrentNode != targetcamera and ClassOf bkArrayCurrentNode != VRayPhysicalCamera and ClassOf bkArrayCurrentNode != freecamera do
					(	
						bkArrayCurrentNode.scale.controller = ScaleXYZ()
						for i = 0 to BakeRangeKeysCount do
						(
							if (arStart + (i * bkInterval)) == 0.0f do isThereAZeroKeyAtAllscl = true
							at time (arStart + (i * bkInterval))
							(
								in coordsys world BakePointHelper.transform = in coordsys world bkArrayCurrentNode.transform
								in coordsys world BakePointHelper.transform = in coordsys world bkArrayCurrentNode.transform
								--format "setting baking scl keys...\n\n"
							)
						)
						if arEnd == 0.0f do isThereAZeroKeyAtAllscl = true
						at time arEnd
						(
							in coordsys world BakePointHelper.transform = in coordsys world bkArrayCurrentNode.transform
							in coordsys world BakePointHelper.transform = in coordsys world bkArrayCurrentNode.transform
						)
						--format "Scl keys count: %\n\n" BakePointHelper.scale.controller.keys.count
						if BakePointHelper.scale.controller.keys.count > 0 do
						(
							if isThereAZeroKeyAtAllscl == false do --we need to prevent the automatic creation of an extra anim key at zero frame
							(
								deselectKeys BakePointHelper.scale.controller
								selectKeys BakePointHelper.scale.controller 0.0f
								deleteKeys BakePointHelper.scale.controller #selection
							)
							if chbPos == true and (chbRot == true or chbRll == true) do
							(
								for p_i = 1 to bkArrayCurrentNode.position.controller.keys.count do
								(
									if bkArrayCurrentNode.position.controller.keys[p_i].time == 0.0f do isThereAZeroKeyAtAllpos = true
								)
								if bkArrayCurrentNode.target != undefined and chbRll == true then
								(
									if bkArrayCurrentNode.controller.roll_angle.controller.keys.count > 0 do 
									(
										for r_i = 1 to bkArrayCurrentNode.controller.roll_angle.controller.keys.count do
										(
											if bkArrayCurrentNode.controller.roll_angle.controller.keys[r_i].time == 0.0f do isThereAZeroKeyAtAllrot = true
										)
									)
								)
								else if chbRot == true do
								(
									if bkArrayCurrentNode.rotation.controller.keys.count > 0 do 
									(
										for r_i = 1 to bkArrayCurrentNode.rotation.controller.keys.count do
										(
											if bkArrayCurrentNode.rotation.controller.keys[r_i].time == 0.0f do isThereAZeroKeyAtAllrot = true
										)
									)
								)
							)
							if bkArrayCurrentNode.scale.controller.keys.count > 0 do 
							(
								for i = 1 to bkArrayCurrentNode.scale.controller.keys.count do
								(
									if bkArrayCurrentNode.scale.controller.keys[i].time == 0.0f do isThereAZeroKeyAtAllscl = true
								)
							)
							if chbDelOrigKeyframes == true do
							(
								--format "deleting extra keys...\n\n"
								deselectKeys bkArrayCurrentNode.scale.controller
								selectKeys bkArrayCurrentNode.scale.controller arStart arEnd
								deleteKeys bkArrayCurrentNode.scale.controller #selection
								if chbPos == true and (chbRot == true or chbRll == true) do
								(
									deselectKeys bkArrayCurrentNode.position.controller
									selectKeys bkArrayCurrentNode.position.controller arStart arEnd
									deleteKeys bkArrayCurrentNode.position.controller #selection
									if bkArrayCurrentNode.target != undefined and chbRll == true then
									(
										deselectKeys bkArrayCurrentNode.controller.roll_angle.controller
										selectKeys bkArrayCurrentNode.controller.roll_angle.controller arStart arEnd
										deleteKeys bkArrayCurrentNode.controller.roll_angle.controller #selection
									)
									else if chbRot == true do
									(
										deselectKeys bkArrayCurrentNode.rotation.controller
										selectKeys bkArrayCurrentNode.rotation.controller arStart arEnd
										deleteKeys bkArrayCurrentNode.rotation.controller #selection
									)
								)
							)
							for i = 1 to BakePointHelper.scale.controller.keys.count do
							(
								at time BakePointHelper.scale.controller.keys[i].time
								(
									if chbPos == true and (chbRot == true or chbRll == true) then
									(
										in coordsys world bkArrayCurrentNode.transform = in coordsys world BakePointHelper.transform
										in coordsys world bkArrayCurrentNode.transform = in coordsys world BakePointHelper.transform
									)
									else
									(
										in coordsys parent appendKey bkArrayCurrentNode.scale.x_scale.controller.keys BakePointHelper.scale.x_scale.controller.keys[i]
										in coordsys parent appendKey bkArrayCurrentNode.scale.y_scale.controller.keys BakePointHelper.scale.y_scale.controller.keys[i]
										in coordsys parent appendKey bkArrayCurrentNode.scale.z_scale.controller.keys BakePointHelper.scale.z_scale.controller.keys[i]
									)
								)
							)
							if chbPos == true and (chbRot == true or chbRll == true) do
							(
								if isThereAZeroKeyAtAllpos == false do --we need to prevent the automatic creation of an extra anim key at zero frame
								(
									deselectKeys bkArrayCurrentNode.position.controller
									selectKeys bkArrayCurrentNode.position.controller 0.0f
									deleteKeys bkArrayCurrentNode.position.controller #selection
								)
								if isThereAZeroKeyAtAllrot == false do --we need to prevent the automatic creation of an extra anim key at zero frame
								(
									if bkArrayCurrentNode.target != undefined and chbRll == true then
									(
										deselectKeys bkArrayCurrentNode.controller.roll_angle.controller
										selectKeys bkArrayCurrentNode.controller.roll_angle.controller 0.0f
										deleteKeys bkArrayCurrentNode.controller.roll_angle.controller #selection
									)
									else if chbRot == true do
									(
										deselectKeys bkArrayCurrentNode.rotation.controller
										selectKeys bkArrayCurrentNode.rotation.controller 0.0f
										deleteKeys bkArrayCurrentNode.rotation.controller #selection
									)
								)
							)
							if isThereAZeroKeyAtAllscl == false do --we need to prevent the automatic creation of an extra anim key at zero frame
							(
								deselectKeys bkArrayCurrentNode.scale.controller
								selectKeys bkArrayCurrentNode.scale.controller 0.0f
								deleteKeys bkArrayCurrentNode.scale.controller #selection
							)
						)
					)
					if chbFOV == true do
					(
						if ClassOf bkArrayCurrentNode == targetcamera or ClassOf bkArrayCurrentNode == VRayPhysicalCamera or ClassOf bkArrayCurrentNode == freecamera do
						(
							for i = 0 to BakeRangeKeysCount do
							(
								if (arStart + (i * bkInterval)) == 0.0f do isThereAZeroKeyAtAllfov = true
								at time (arStart + (i * bkInterval))
								(
									BakeCamHelper.FOV = bkArrayCurrentNode.FOV
									BakeCamHelper.FOV = bkArrayCurrentNode.FOV
								)
							)
							if arEnd == 0.0f do isThereAZeroKeyAtAllfov = true
							at time arEnd
							(
								BakeCamHelper.FOV = bkArrayCurrentNode.FOV
								BakeCamHelper.FOV = bkArrayCurrentNode.FOV
							)
							if BakeCamHelper.FOV.controller.keys.count > 0 do
							(
								if BakeCamHelper.FOV.controller.keys.count > 0 do
								(
									if isThereAZeroKeyAtAllfov == false do --we need to prevent the automatic creation of an extra anim key at zero frame
									(
										deselectKeys BakeCamHelper.FOV.controller
										selectKeys BakeCamHelper.FOV.controller 0.0f
										deleteKeys BakeCamHelper.FOV.controller #selection
									)
									if bkArrayCurrentNode.FOV.controller.keys.count > 0 do 
									(
										for i = 1 to bkArrayCurrentNode.FOV.controller.keys.count do
										(
											if bkArrayCurrentNode.FOV.controller.keys[i].time == 0.0f do isThereAZeroKeyAtAllfov = true
										)
									)
									if chbDelOrigKeyframes == true do
									(
										deselectKeys bkArrayCurrentNode.FOV.controller
										selectKeys bkArrayCurrentNode.FOV.controller arStart arEnd
										deleteKeys bkArrayCurrentNode.FOV.controller #selection
									)
								)
								for i = 1 to BakeCamHelper.FOV.controller.keys.count do
								(
									at time BakeCamHelper.FOV.controller.keys[i].time
									(
										appendKey bkArrayCurrentNode.FOV.controller.keys BakeCamHelper.FOV.controller.keys[i]
									)
								)
								if isThereAZeroKeyAtAllfov == false do --we need to prevent the automatic creation of an extra anim key at zero frame
								(
									deselectKeys bkArrayCurrentNode.FOV.controller
									selectKeys bkArrayCurrentNode.FOV.controller 0.0f
									deleteKeys bkArrayCurrentNode.FOV.controller #selection
								)
							)
							deleteKeys BakeCamHelper.FOV.controller
						)
					)
					
					pgbCount = pgbCount + 1
					SE_AAH_Process_Rollout.prgb_AAH.value = 100.*pgbCount/pgbCountTotal
				)
				try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
			)
		)
		delete BakePointHelper
		delete BakeCamHelper
		wholeBakingTransformTime = (((timeStamp() - wholeBakingTransformTime) / 1000.0) as string)
		SE_AAH_Process_Rollout.lbl_PrcssAAH.text = "Tf baked in " + wholeBakingTransformTime + "s"
		SE_AAH_Process_Rollout.prgb_AAH.value = 0
		try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
		if bool_ShowResultDialogue == 1 do
		(
			local info_str_msg = "Transform baked in " + wholeBakingTransformTime + " seconds!"
			messageBox info_str_msg title:"Done!"
		)
	)
	
	/*---------------------------------------------------------------------------------------------------*/
	
	fn DeleteTransformKeysForArray dkArray chbPos chbRot chbScl chbRll chbFov AllAnimation arStart arEnd bool_ShowResultDialogue = --arType
	(
		local wholeDeleteTransformTime = timeStamp()
		SE_AAH_Process_Rollout.lbl_PrcssAAH.text = "Transform anim deleting initialising"
		try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
		local pgbCount = 0
		local pgbCountTotal = selection.count
		for dkArrayCurrentNode in dkArray do
		(
			SE_AAH_Process_Rollout.lbl_PrcssAAH.text = "Del. keys: " + dkArrayCurrentNode.name
			if AllAnimation == 1 then
			(
				if chbPos == true do deleteKeys dkArrayCurrentNode.position.controller
				if chbRot == true do
				(
					if dkArrayCurrentNode.target != undefined then deleteKeys dkArrayCurrentNode.controller.roll_angle.controller
					else deleteKeys dkArrayCurrentNode.rotation.controller
				)
				if chbScl == true do deleteKeys dkArrayCurrentNode.scale.controller
			)
			else
			(
				if chbPos == true and dkArrayCurrentNode.position.controller.keys.count > 0 do
				(
					deselectKeys dkArrayCurrentNode.position.controller
					selectKeys dkArrayCurrentNode.position.controller arStart arEnd
					deleteKeys dkArrayCurrentNode.position.controller #selection
				)
				if chbRot == true or chbRll == true do
				(
					if dkArrayCurrentNode.target != undefined and chbRll == true then
					(
						if dkArrayCurrentNode.controller.roll_angle.controller.keys.count > 0 do
						(
							deselectKeys dkArrayCurrentNode.controller.roll_angle.controller
							selectKeys dkArrayCurrentNode.controller.roll_angle.controller arStart arEnd
							deleteKeys dkArrayCurrentNode.controller.roll_angle.controller #selection
						)
					)
					else if chbRot == true do
					(
						if dkArrayCurrentNode.rotation.controller.keys.count > 0 do
						(
							deselectKeys dkArrayCurrentNode.rotation.controller
							selectKeys dkArrayCurrentNode.rotation.controller arStart arEnd
							deleteKeys dkArrayCurrentNode.rotation.controller #selection
						)
					)
				)
				if chbScl == true and dkArrayCurrentNode.scale.controller.keys.count > 0 do
				(
					deselectKeys dkArrayCurrentNode.scale.controller
					selectKeys dkArrayCurrentNode.scale.controller arStart arEnd
					deleteKeys dkArrayCurrentNode.scale.controller #selection
				)
				if chbFov == true and (ClassOf dkArrayCurrentNode == targetcamera or ClassOf dkArrayCurrentNode == VRayPhysicalCamera or ClassOf dkArrayCurrentNode == freecamera) do
				(
					if dkArrayCurrentNode.FOV.controller.keys.count > 0 do
					(
						deselectKeys dkArrayCurrentNode.FOV.controller
						selectKeys dkArrayCurrentNode.FOV.controller arStart arEnd
						deleteKeys dkArrayCurrentNode.FOV.controller #selection
					)
				)
			)
			pgbCount = pgbCount + 1
			SE_AAH_Process_Rollout.prgb_AAH.value = 100.*pgbCount/pgbCountTotal
		)
		wholeDeleteTransformTime = (((timeStamp() - wholeDeleteTransformTime) / 1000.0) as string)
		SE_AAH_Process_Rollout.lbl_PrcssAAH.text = "Del finished in " + wholeDeleteTransformTime + "s"
		SE_AAH_Process_Rollout.prgb_AAH.value = 0
		try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
		if bool_ShowResultDialogue == 1 do
		(
			local info_str_msg = "Transform anim deleted in " + wholeDeleteTransformTime + " seconds!"
			messageBox info_str_msg title:"Done!"
		)
	)
	
	/*---------------------------------------------------------------------------------------------------*/
	/*---------------------------------------------------------------------------------------------------*/
	/*---------------------------------------------------------------------------------------------------*/
	
	on SelectAllItems pressed do
	(
		if selection[1] != undefined then
		(
			if selection[1].children.count > 0 OR selection[1].parent != undefined then
			(
				local SelAllArray = SE_AAH_GetAllHierarchy selection[1] 0
				clearselection()
				select SelAllArray
			)
		)
	)

	on SelectAllExceptRootItem pressed do
	(
		if selection[1] != undefined then
		(
			if selection[1].children.count > 0 OR selection[1].parent != undefined then
			(
				local SelAllArray = SE_AAH_GetAllHierarchy selection[1] 1
				clearselection()
				select SelAllArray
			)
		)
	)

	on SelectOnlyRootItem pressed do
	(
		if selection[1] != undefined then
		(
			if selection[1].children.count > 0 OR selection[1].parent != undefined then
			(
				local rootItem = SE_AAH_GetRoot selection[1]
				clearselection()
				select rootItem
			)
		)
	)
	
	/*---------------------------------------------------------------------------------------------------*/
	/*---------------------------------------------------------------------------------------------------*/
	/*---------------------------------------------------------------------------------------------------*/

	on CopyPasteObjectsTransform pressed do
	(
		if selection.count == 1 then
		(
			if chkbx_ThTrnsfrmPos.state == true or chkbx_ThTrnsfrmRot.state == true or chkbx_ThTrnsfrmScale.state == true then
			(
				local s = selection[1]
				if (queryBox "Select the object that you want to have selected object's transform...\n\nDo you want to continue?" title:"ATTENTION") do
				(
					clearSelection()
					local pickedObject = pickObject prompt:"Select the object that you want to have selected object's transform..." rubberBand:[s.pos.x,s.pos.y,s.pos.z]
					if pickedObject != undefined AND pickedObject != #escape do
					(
						local info_str_msg = "Are you sure you want \"" + pickedObject.name + "\" to have \"" + s.name + "\"'s transform?!"
						if (queryBox info_str_msg title:"ATTENTION") then
						(
							select pickedObject
							if chkbx_ThTrnsfrmPos.state == true and chkbx_ThTrnsfrmRot.state == true and chkbx_ThTrnsfrmScale.state == true then
							(
								pickedObject.transform = s.transform
								pickedObject.transform = s.transform -- doubling to prevent some 3ds max bugs
							)
							else
							(
								if chkbx_ThTrnsfrmPos.state == true do
								(
									pickedObject.position.x = s.position.x
									pickedObject.position.y = s.position.y
									pickedObject.position.z = s.position.z
									pickedObject.position.x = s.position.x -- doubling to prevent some 3ds max bugs
									pickedObject.position.y = s.position.y
									pickedObject.position.z = s.position.z
								)
								if chkbx_ThTrnsfrmRot.state == true do
								(
									pickedObject.rotation.x_rotation = s.rotation.x_rotation
									pickedObject.rotation.y_rotation = s.rotation.y_rotation
									pickedObject.rotation.z_rotation = s.rotation.z_rotation
									pickedObject.rotation.x_rotation = s.rotation.x_rotation -- doubling to prevent some 3ds max bugs
									pickedObject.rotation.y_rotation = s.rotation.y_rotation
									pickedObject.rotation.z_rotation = s.rotation.z_rotation
								)
								if chkbx_ThTrnsfrmScale.state == true do
								(
									s.scale.controller = ScaleXYZ()
									pickedObject.scale.controller = ScaleXYZ()
									pickedObject.scale.x = s.scale.x
									pickedObject.scale.y = s.scale.y
									pickedObject.scale.z = s.scale.z
									pickedObject.scale.x = s.scale.x -- doubling to prevent some 3ds max bugs
									pickedObject.scale.y = s.scale.y
									pickedObject.scale.z = s.scale.z
								)
							)
							local info_str_msg = "Object \"" + pickedObject.name + "\" now has \"" + s.name + "\"'s transform!"
							messagebox info_str_msg title:"Done!"
						)
						else	messageBox "You canceled the operation!" title:"OKAY"
					)
				)
			)
			else messageBox "Select any Transform type checkbox and THEN push that button!!" title:"ERROR"
		)
		else messageBox "Select ONE bone/helper/object and THEN push that button!" title:"ERROR"
	)
	
	on ResetObjectsTransform pressed do
	(
		if selection.count > 0 then
		(
			if chkbx_ThTrnsfrmPos.state == true or chkbx_ThTrnsfrmRot.state == true or chkbx_ThTrnsfrmScale.state == true then
			(
				for s in selection do
				(
					if chkbx_ThTrnsfrmPos.state == true do
					(
						s.position = [0.0,0.0,0.0]
						s.position = [0.0,0.0,0.0]
					)
					if chkbx_ThTrnsfrmRot.state == true do
					(
						in coordsys world s.rotation.x_rotation = 0.0
						in coordsys world s.rotation.y_rotation = 0.0
						in coordsys world s.rotation.z_rotation = 0.0
						in coordsys world s.rotation.x_rotation = 0.0
						in coordsys world s.rotation.y_rotation = 0.0
						in coordsys world s.rotation.z_rotation = 0.0
						--s.transform = matrix3 1
						--s.rotation = eulerangles 0 0 0
					)
					if chkbx_ThTrnsfrmScale.state == true do
					(
						local rosOldParent = s.parent
						if rosOldParent != undefined do s.parent = undefined
						ResetScale s -- mapped method
						in coordsys parent s.scale = [1,1,1]
						in coordsys parent s.scale = [1,1,1]
						local objTm= in coordsys parent s.transform
						local objTmX=normalize objTm.row1
						local objTmY=normalize objTm.row2
						local objTmZ=normalize (cross objTmX objTmY) --Rebuild the Z to orthogonalize the matrix.
						in coordsys parent s.transform=(matrix3 objTmX objTmY objTmZ objTm.pos)
						if rosOldParent != undefined do s.parent = rosOldParent
					)
				)
			)
			else messageBox "Select any Transform type checkbox and THEN push that button!!" title:"ERROR"
		)
		else messageBox "Select at least ONE bone/helper/object and THEN push that button!" title:"ERROR"
	)
	
	/*---------------------------------------------------------------------------------------------------*/
	/*---------------------------------------------------------------------------------------------------*/
	/*---------------------------------------------------------------------------------------------------*/
	
	on EulerToTCBAVV pressed do
	(
		if selection.count > 0 then
		(
			local EulerToTCBTrigger = false
			if (classof selection[1].rotation.controller) == Euler_XYZ do EulerToTCBTrigger = true
			for s in selection do
			(
				if EulerToTCBTrigger == true then s.rotation.controller = TCB_Rotation()--Linear_Rotation()--TCB_Rotation()
				else s.rotation.controller = Euler_XYZ()
			)
			if EulerToTCBTrigger == true then messageBox "Bones' rotation controllers were set to TCB Controller!" title:"Done!"
			else messageBox "Bones' rotation controllers were set to Euler XYZ!" title:"Done!"
		)
		else messageBox "Select at least ONE bone/helper/object and THEN push that button!" title:"ERROR"
	)
	
	/*---------------------------------------------------------------------------------------------------*/
	/*---------------------------------------------------------------------------------------------------*/
	/*---------------------------------------------------------------------------------------------------*/
	
	on AttachObjTo pressed do
	(
		if selection.count == 1 then
		(
			local s = selection[1]
			if (queryBox "Select the object that you want to attach to this bone/helper/object...\n\nDo you want to continue?" title:"ATTENTION") do
			(
				clearSelection()
				local pO = pickObject prompt:"Select the object that you want to attach to this bone/helper/object..." rubberBand:[s.pos.x,s.pos.y,s.pos.z]
				if pO != undefined AND pO != #escape AND pO != s do
				(
					local attachTargetObjectTrigger = false
					if pO.target != undefined do
						if (queryBox "You have selected Target Object.\n\nDo you want to attach object's target too?" title:"ATTENTION") do attachTargetObjectTrigger = true
					local newAOAttachController = CreateAOLink s pO 1
					if attachTargetObjectTrigger do local newAOAttachController2 = CreateAOLink s pO.target 1
					if newAOAttachController != undefined do
					(
						select newAOAttachController
					)

				)
			)
		)
		else messageBox "Select ONE bone/helper/object and THEN push that button!" title:"ERROR"
	)
	
	on DetachObj pressed do
	(
		if selection.count > 0 then
		(
			local AOAllNeededObjectsArray = #()
			for s in selection do
			(
				if getUserProp s "AObjectNumber" != undefined and getUserProp s "AObjectNumber" != -1 do append AOAllNeededObjectsArray s
				if getUserProp s "AOControllerNumber" != undefined and getUserProp s "AOControllerNumber" != -1 do
				(
					local AOSelectNumber = getUserProp s "AOControllerNumber"
					for obj in objects do
					(
						if getUserProp obj "AObjectNumber" ==  AOSelectNumber do append AOAllNeededObjectsArray obj
					)
				)
			)
			if AOAllNeededObjectsArray.count > 0 do RemoveAOLink AOAllNeededObjectsArray 0 0 0.0 0
		)
		else messageBox "Select at least ONE bone/helper/object and THEN push that button!" title:"ERROR"
	)

	on CreateKeysFAO pressed do
	(
		if selection.count > 0 then
		(
			local AOAllNeededObjectsArray = #()
			for s in selection do
			(
				if getUserProp s "AObjectNumber" != undefined and getUserProp s "AObjectNumber" != -1 do append AOAllNeededObjectsArray s
				if getUserProp s "AOControllerNumber" != undefined and getUserProp s "AOControllerNumber" != -1 do
				(
					local AOSelectNumber = getUserProp s "AOControllerNumber"
					for obj in objects do
					(
						if getUserProp obj "AObjectNumber" ==  AOSelectNumber do append AOAllNeededObjectsArray obj
					)
				)
			)
			if AOAllNeededObjectsArray.count > 0 do RemoveAOLink AOAllNeededObjectsArray 1 chkbx_DetailedAOAnim.state spn_DetailedAOAnim.value 1
		)
		else messageBox "Select at least ONE bone/helper/object and THEN push that button!" title:"ERROR"
	)
	
	/*---------------------------------------------------------------------------------------------------*/
	/*---------------------------------------------------------------------------------------------------*/
	/*---------------------------------------------------------------------------------------------------*/
	
	on CASIncrease pressed do
	(
		if selection.count > 0 then
		(
			if chkbx_ACTrnsfrmKsPos.state == true or chkbx_ACTrnsfrmKsRot.state == true or chkbx_ACTrnsfrmKsScale.state == true then
			(
				if spn_CASIncBy.value != 1.0 do
				(
					local oldAnimKeysState = SE_AAH_GetAndOffAnimKeys()
					UpdateAnimRangeStartAndEnd() 
					if ACAnimRangeStartKeyframe != undefined and ACAnimRangeEndKeyframe != undefined do
					(
						if ACAnimRangeStartKeyframe < ACAnimRangeEndKeyframe do
						(  
							local wholeCASIncreaseTime = timeStamp()
							SE_AAH_Process_Rollout.lbl_PrcssAAH.text = "Changing anim speed initialising"
							try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
							local OldAnimStretch = ACAnimRangeEndKeyframe - ACAnimRangeStartKeyframe
							OldAnimStretch = (OldAnimStretch as float)/TicksPerFrame
							local NewAnimStretchFactor = 1.0 / spn_CASIncBy.value
							local NewAnimStretch = OldAnimStretch * NewAnimStretchFactor
							if chkbx_CASAccuracy.state do
							(
								NewAnimStretch = SE_AAH_RoundUp2 NewAnimStretch spn_CASAccuracyVal.value
								NewAnimStretchFactor = NewAnimStretch / OldAnimStretch
							)
							local NewAnimShift = NewAnimStretch - OldAnimStretch
							/*
							local CASAnimRangeStartS = CASAnimRangeStart as string
							local CASAnimRangeEndS = CASAnimRangeEnd as string
							local NewAnimStretchS = NewAnimStretch as string
							local NewAnimShiftS = NewAnimShift as string
							local NewAnimStretchFactorS = NewAnimStretchFactor as string
							local CASAccuracyValS = (spn_CASAccuracyVal.value * 100.0) as string
							local info_str_msg = "Frames: from " + CASAnimRangeStartS + " to " + CASAnimRangeEndS + " !\nStretch:" + NewAnimStretchS + " !\n" + NewAnimStretchFactorS
							messagebox info_str_msg title:"TEST!"
							*/
							if NewAnimShift != 0.0 do
							(
								local NewAnimRangeShift
								local pgbCount = 0
								local pgbCountTotal = selection.count
								if NewAnimShift > 0.0 then
								(
									for s in selection do
									(
										SE_AAH_Process_Rollout.lbl_PrcssAAH.text = "Dec. speed: " + s.name
										if chkbx_ACTrnsfrmKsPos.state == true and s.position.controller.keys.count > 0 do
										(
											for i = s.position.controller.keys.count to 1 by -1 do
											(
												if s.position.controller.keys[i].time >= ACAnimRangeEndKeyframe then
												( 
													moveKey s.position.x_position.controller i NewAnimShift
													moveKey s.position.y_position.controller i NewAnimShift
													moveKey s.position.z_position.controller i NewAnimShift
												)
												else if s.position.controller.keys[i].time > ACAnimRangeStartKeyframe do
												(
													NewAnimRangeShift = ((s.position.controller.keys[i].time - ACAnimRangeStartKeyframe) * NewAnimStretchFactor) - (s.position.controller.keys[i].time - ACAnimRangeStartKeyframe)
													moveKey s.position.x_position.controller i NewAnimRangeShift
													moveKey s.position.y_position.controller i NewAnimRangeShift
													moveKey s.position.z_position.controller i NewAnimRangeShift
												)
											)
										)
										if chkbx_ACTrnsfrmKsRot.state == true and s.rotation.controller.keys.count > 0 do
										(
											for i = s.rotation.controller.keys.count to 1 by -1 do
											(
												if s.rotation.controller.keys[i].time >= ACAnimRangeEndKeyframe then
												(
													if (classof s.rotation.controller) == TCB_Rotation then
													(														
														moveKey s.rotation.controller i NewAnimShift
													)
													else
													(
														moveKey s.rotation.x_rotation.controller i NewAnimShift
														moveKey s.rotation.y_rotation.controller i NewAnimShift
														moveKey s.rotation.z_rotation.controller i NewAnimShift
													)
												)
												else if s.rotation.controller.keys[i].time > ACAnimRangeStartKeyframe do
												(
													NewAnimRangeShift = ((s.rotation.controller.keys[i].time - ACAnimRangeStartKeyframe) * NewAnimStretchFactor) - (s.rotation.controller.keys[i].time - ACAnimRangeStartKeyframe)
													if (classof s.rotation.controller) == TCB_Rotation then
													(														
														moveKey s.rotation.controller i NewAnimRangeShift
													)
													else
													(
														moveKey s.rotation.x_rotation.controller i NewAnimRangeShift
														moveKey s.rotation.y_rotation.controller i NewAnimRangeShift
														moveKey s.rotation.z_rotation.controller i NewAnimRangeShift
													)
												)
											)
										) 
										/*scaleshit*/
										if chkbx_ACTrnsfrmKsScale.state == true and s.scale.controller.keys.count > 0 do
										(
											s.scale.controller = ScaleXYZ()
											for i = s.scale.controller.keys.count to 1 by -1 do
											(
												if s.scale.controller.keys[i].time >= ACAnimRangeEndKeyframe then
												(
													moveKey s.scale.x_scale.controller i NewAnimShift
													moveKey s.scale.y_scale.controller i NewAnimShift
													moveKey s.scale.z_scale.controller i NewAnimShift
												)
												else if s.scale.controller.keys[i].time > ACAnimRangeStartKeyframe do
												(
													NewAnimRangeShift = ((s.scale.controller.keys[i].time - ACAnimRangeStartKeyframe) * NewAnimStretchFactor) - (s.scale.controller.keys[i].time - ACAnimRangeStartKeyframe)
													moveKey s.scale.x_scale.controller i NewAnimRangeShift
													moveKey s.scale.y_scale.controller i NewAnimRangeShift
													moveKey s.scale.z_scale.controller i NewAnimRangeShift
												)
											)
										)
										/*othershit*/
										if chkbx_ACTrnsfrmKsPos.state == true and chkbx_ACTrnsfrmKsRot.state == true and chkbx_ACTrnsfrmKsScale.state == true do
										(
											if (classof s) == IK_Chain_Object then
											(	
												if s.transform.controller.swivelAngle.controller.keys.count > 0 do
												(
													for i = s.transform.controller.swivelAngle.controller.keys.count to 1 by -1 do
													(
														if s.transform.controller.swivelAngle.controller.keys[i].time >= ACAnimRangeEndKeyframe then
														(
															moveKey s.transform.controller.swivelAngle.controller i NewAnimShift
														)
														else if s.transform.controller.swivelAngle.controller.keys[i].time > ACAnimRangeStartKeyframe do
														(
															NewAnimRangeShift = ((s.transform.controller.swivelAngle.controller.keys[i].time - ACAnimRangeStartKeyframe) * NewAnimStretchFactor) - (s.transform.controller.swivelAngle.controller.keys[i].time - ACAnimRangeStartKeyframe)
															moveKey s.transform.controller.swivelAngle.controller i NewAnimRangeShift
														)
													)
												)
												if s.transform.controller.Enabled.controller.keys.count > 0 do
												(
													for i = s.transform.controller.Enabled.controller.keys.count to 1 by -1 do
													(
														if s.transform.controller.Enabled.controller.keys[i].time >= ACAnimRangeEndKeyframe then
														(
															moveKey s.transform.controller.Enabled.controller i NewAnimShift
														)
														else if s.transform.controller.Enabled.controller.keys[i].time > ACAnimRangeStartKeyframe do
														(
															NewAnimRangeShift = ((s.transform.controller.Enabled.controller.keys[i].time - ACAnimRangeStartKeyframe) * NewAnimStretchFactor) - (s.transform.controller.Enabled.controller.keys[i].time - ACAnimRangeStartKeyframe)
															moveKey s.transform.controller.Enabled.controller i NewAnimRangeShift
														)
													)
												)
											)
											else if (classof s.rotation.controller) == Orientation_Constraint do
											(
												if (classof s.transform.controller) == IKControl do
												(
													if s.Rotation.controller.weight.count > 0 do
													(
														for wc = 1 to s.Rotation.controller.weight.count do
														(
															if s.Rotation.controller.weight[wc].controller.keys.count > 0 do
															(
																for i = s.Rotation.controller.weight[wc].controller.keys.count to 1 by -1 do
																(
																	if s.Rotation.controller.weight[wc].controller.keys[i].time >= ACAnimRangeEndKeyframe then
																	(
																		moveKey s.Rotation.controller.weight[wc].controller i NewAnimShift
																	)
																	else if s.Rotation.controller.weight[wc].controller.keys[i].time > ACAnimRangeStartKeyframe do
																	(
																		NewAnimRangeShift = ((s.Rotation.controller.weight[wc].controller.keys[i].time - ACAnimRangeStartKeyframe) * NewAnimStretchFactor) - (s.Rotation.controller.weight[wc].controller.keys[i].time - ACAnimRangeStartKeyframe)
																		moveKey s.Rotation.controller.weight[wc].controller i NewAnimRangeShift
																	)
																)
															)
														)
													)
												)
											)
										)
										pgbCount = pgbCount + 1
										SE_AAH_Process_Rollout.prgb_AAH.value = 100.*pgbCount/pgbCountTotal
										try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
									)
								)
								else
								( 
									for s in selection do
									(
										SE_AAH_Process_Rollout.lbl_PrcssAAH.text = "Inc. speed: " + s.name
										if chkbx_ACTrnsfrmKsPos.state == true and s.position.controller.keys.count > 0 do
										(
											for i = 1 to s.position.controller.keys.count do
											(
												if s.position.controller.keys[i].time > ACAnimRangeStartKeyframe do
												(
													if s.position.controller.keys[i].time < ACAnimRangeEndKeyframe then
													(
														NewAnimRangeShift = ((s.position.controller.keys[i].time - ACAnimRangeStartKeyframe) * NewAnimStretchFactor) - (s.position.controller.keys[i].time - ACAnimRangeStartKeyframe)
														moveKey s.position.x_position.controller i NewAnimRangeShift
														moveKey s.position.y_position.controller i NewAnimRangeShift
														moveKey s.position.z_position.controller i NewAnimRangeShift
													)
													else
													(
														moveKey s.position.x_position.controller i NewAnimShift
														moveKey s.position.y_position.controller i NewAnimShift
														moveKey s.position.z_position.controller i NewAnimShift
													)
												)
											)
										)
										if chkbx_ACTrnsfrmKsRot.state == true and s.rotation.controller.keys.count > 0 do
										(
											for i = 1 to s.rotation.controller.keys.count do
											(
												if s.rotation.controller.keys[i].time > ACAnimRangeStartKeyframe do
												(
													if s.rotation.controller.keys[i].time < ACAnimRangeEndKeyframe then
													(
														NewAnimRangeShift = ((s.rotation.controller.keys[i].time - ACAnimRangeStartKeyframe) * NewAnimStretchFactor) - (s.rotation.controller.keys[i].time - ACAnimRangeStartKeyframe)
														if (classof s.rotation.controller) == TCB_Rotation then
														(														
															moveKey s.rotation.controller i NewAnimRangeShift
															--moveKey s.rotation.x.controller i NewAnimRangeShift
															--moveKey s.rotation.y.controller i NewAnimRangeShift
															--moveKey s.rotation.z.controller i NewAnimRangeShift
														)
														else
														(
															moveKey s.rotation.x_rotation.controller i NewAnimRangeShift
															moveKey s.rotation.y_rotation.controller i NewAnimRangeShift
															moveKey s.rotation.z_rotation.controller i NewAnimRangeShift
														)
													)
													else
													(
														if (classof s.rotation.controller) == TCB_Rotation then
														(														
															moveKey s.rotation.controller i NewAnimRangeShift
															--moveKey s.rotation.x.controller i NewAnimRangeShift
															--moveKey s.rotation.y.controller i NewAnimRangeShift
															--moveKey s.rotation.z.controller i NewAnimRangeShift
														)
														else
														(
															moveKey s.rotation.x_rotation.controller i NewAnimShift
															moveKey s.rotation.y_rotation.controller i NewAnimShift
															moveKey s.rotation.z_rotation.controller i NewAnimShift
														)
													)
												)
											)
										) 
										if chkbx_ACTrnsfrmKsScale.state == true and s.scale.controller.keys.count > 0 do
										(
											s.scale.controller = ScaleXYZ()
											for i = 1 to s.scale.controller.keys.count do
											(
												if s.scale.controller.keys[i].time > ACAnimRangeStartKeyframe do
												(
													if s.scale.controller.keys[i].time < ACAnimRangeEndKeyframe then
													(
														NewAnimRangeShift = ((s.scale.controller.keys[i].time - ACAnimRangeStartKeyframe) * NewAnimStretchFactor) - (s.scale.controller.keys[i].time - ACAnimRangeStartKeyframe)
														moveKey s.scale.x_scale.controller i NewAnimRangeShift
														moveKey s.scale.y_scale.controller i NewAnimRangeShift
														moveKey s.scale.z_scale.controller i NewAnimRangeShift
													)
													else
													(
														moveKey s.scale.x_scale.controller i NewAnimShift
														moveKey s.scale.y_scale.controller i NewAnimShift
														moveKey s.scale.z_scale.controller i NewAnimShift
													)
												)
											)
										)
										/*othershit*/
										if chkbx_ACTrnsfrmKsPos.state == true and chkbx_ACTrnsfrmKsRot.state == true and chkbx_ACTrnsfrmKsScale.state == true do
										(
											if (classof s) == IK_Chain_Object then
											(	
												if s.transform.controller.swivelAngle.controller.keys.count > 0 do
												(
													for i = 1 to s.transform.controller.swivelAngle.controller.keys.count do
													(
														if s.transform.controller.swivelAngle.controller.keys[i].time > ACAnimRangeStartKeyframe do
														(
															if s.transform.controller.swivelAngle.controller.keys[i].time < ACAnimRangeEndKeyframe then
															(
																NewAnimRangeShift = ((s.transform.controller.swivelAngle.controller.keys[i].time - ACAnimRangeStartKeyframe) * NewAnimStretchFactor) - (s.transform.controller.swivelAngle.controller.keys[i].time - ACAnimRangeStartKeyframe)
																moveKey s.transform.controller.swivelAngle.controller i NewAnimRangeShift
															)
															else
															(
																moveKey s.transform.controller.swivelAngle.controller i NewAnimShift
															)
														)
													)
												)
												if s.transform.controller.Enabled.controller.keys.count > 0 do
												(
													for i = 1 to s.transform.controller.Enabled.controller.keys.count do
													(
														if s.transform.controller.Enabled.controller.keys[i].time > ACAnimRangeStartKeyframe do
														(
															if s.transform.controller.Enabled.controller.keys[i].time < ACAnimRangeEndKeyframe then
															(
																NewAnimRangeShift = ((s.transform.controller.Enabled.controller.keys[i].time - ACAnimRangeStartKeyframe) * NewAnimStretchFactor) - (s.transform.controller.Enabled.controller.keys[i].time - ACAnimRangeStartKeyframe)
																moveKey s.transform.controller.Enabled.controller i NewAnimRangeShift
															)
															else
															(
																moveKey s.transform.controller.Enabled.controller i NewAnimShift
															)
														)
													)
												)
											)
											else if (classof s.rotation.controller) == Orientation_Constraint do
											(
												if (classof s.transform.controller) == IKControl do
												(
													if s.Rotation.controller.weight.count > 0 do
													(
														for wc = 1 to s.Rotation.controller.weight.count do
														(
															if s.Rotation.controller.weight[wc].controller.keys.count > 0 do
															(
																for i = 1 to s.Rotation.controller.weight[wc].controller.keys.count do
																(
																	if s.Rotation.controller.weight[wc].controller.keys[i].time > ACAnimRangeStartKeyframe do
																	(
																		if s.Rotation.controller.weight[wc].controller.keys[i].time < ACAnimRangeEndKeyframe then
																		(
																			NewAnimRangeShift = ((s.Rotation.controller.weight[wc].controller.keys[i].time - ACAnimRangeStartKeyframe) * NewAnimStretchFactor) - (s.Rotation.controller.weight[wc].controller.keys[i].time - ACAnimRangeStartKeyframe)
																			moveKey s.Rotation.controller.weight[wc].controller i NewAnimRangeShift
																		)
																		else
																		(
																			moveKey s.Rotation.controller.weight[wc].controller i NewAnimShift
																		)
																	)
																)
															)
														)
													)
												)
												
											)
										)
										pgbCount = pgbCount + 1
										SE_AAH_Process_Rollout.prgb_AAH.value = 100.*pgbCount/pgbCountTotal
										try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
									)
								)
							)
							wholeCASIncreaseTime = (((timeStamp() - wholeCASIncreaseTime) / 1000.0) as string)
							SE_AAH_Process_Rollout.lbl_PrcssAAH.text = "CAS finished in " + wholeCASIncreaseTime + "s"
							SE_AAH_Process_Rollout.prgb_AAH.value = 0
							try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
							local info_str_msg = "Anim speed changing finished in " + wholeCASIncreaseTime + " seconds!"
							messageBox info_str_msg title:"Done!"
						)
					)
					SE_AAH_SetBackAnimKeys oldAnimKeysState
				)
			)
			else messageBox "Select any Transform type checkbox and THEN push that button!!" title:"ERROR"
		)
		else messageBox "Select at least ONE bone/helper/object and THEN push that button!" title:"ERROR"
	)
		
	on BakeObjectsTransformKeys pressed do
	(
		if selection.count > 0 then
		(
			if chkbx_ACTrnsfrmKsPos.state == true or chkbx_ACTrnsfrmKsRot.state == true or chkbx_ACTrnsfrmKsScale.state == true or chkbx_ACTrnsfrmKsRoll.state or chkbx_ACTrnsfrmKsFOV.state then
			(
				local oldAnimKeysState = SE_AAH_GetAndOffAnimKeys()
				UpdateAnimRangeStartAndEnd()
				if ACAnimRangeStartKeyframe != undefined and ACAnimRangeEndKeyframe != undefined do
				(
					BakeTransformKeysForArray selection chkbx_ACTrnsfrmKsPos.state chkbx_ACTrnsfrmKsRot.state chkbx_ACTrnsfrmKsScale.state chkbx_ACTrnsfrmKsRoll.state chkbx_ACTrnsfrmKsFOV.state ACAnimRangeStartKeyframe ACAnimRangeEndKeyframe spn_BkTrnsfrmAccuracyVal.value chkbx_BkDeleteOrigkeys.state 1
				)
				SE_AAH_SetBackAnimKeys oldAnimKeysState
			)
			else messageBox "Select any Transform type checkbox and THEN push that button!!" title:"ERROR"
		)
		else messageBox "Select at least ONE bone/helper/object and THEN push that button!" title:"ERROR"	
	)
	
	on SmoothObjectsAnimation pressed do
	(
		if selection.count > 0 then
		(
			if chkbx_ACTrnsfrmKsPos.state == true or chkbx_ACTrnsfrmKsRot.state == true or chkbx_ACTrnsfrmKsScale.state == true then
			(
				local oldAnimKeysState = SE_AAH_GetAndOffAnimKeys()
				UpdateAnimRangeStartAndEnd()
				if ACAnimRangeStartKeyframe != undefined and ACAnimRangeEndKeyframe != undefined do
				(
					local wholeSmoothAnimationTime = timeStamp()
					SE_AAH_Process_Rollout.lbl_PrcssAAH.text = "Anim smoothing initialising"
					try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
					local pgbCount = 0
					local pgbCountTotal = selection.count * spn_SmoothTimesVal.value
					with Animate on
					(
						for s in selection do
						(
							--local SmoothRangeKeysCount = (ACAnimRangeEndKeyframe - ACAnimRangeStartKeyframe) as integer
							local SmoothRangeKeysCount = (((ACAnimRangeEndKeyframe - ACAnimRangeStartKeyframe) as float)/TicksPerFrame)as integer
							if SmoothRangeKeysCount > 2 do
							(
								for i = 1 to spn_SmoothTimesVal.value do
								(
									SE_AAH_Process_Rollout.lbl_PrcssAAH.text = "Smoothing: " + s.name
									local currentSOAKeyTime = 0.0f
									if chkbx_ACTrnsfrmKsPos.state == true and s.position.controller.keys.count > 0 do
									(
										for i = 1 to s.position.controller.keys.count do
										(
											currentSOAKeyTime = s.position.controller.keys[i].time
											if currentSOAKeyTime > ACAnimRangeStartKeyframe and ACAnimRangeEndKeyframe > currentSOAKeyTime then
											( 
												deletekey s.position.controller i
												addnewkey s.position.controller currentSOAKeyTime
											)
										)
									)
									
									if chkbx_ACTrnsfrmKsRot.state == true and s.rotation.controller.keys.count > 0 do
									(
										for i = 1 to s.rotation.controller.keys.count do
										(
											currentSOAKeyTime = s.rotation.controller.keys[i].time
											if currentSOAKeyTime > ACAnimRangeStartKeyframe and ACAnimRangeEndKeyframe > currentSOAKeyTime then
											( 
												deletekey s.rotation.controller i
												addnewkey s.rotation.controller currentSOAKeyTime
											)
										)
									)
									
									if chkbx_ACTrnsfrmKsScale.state == true and s.scale.controller.keys.count > 0 do
									(
										s.scale.controller = ScaleXYZ()
										for i = 1 to s.scale.controller.keys.count do
										(
											currentSOAKeyTime = s.scale.controller.keys[i].time
											if currentSOAKeyTime > ACAnimRangeStartKeyframe and ACAnimRangeEndKeyframe > currentSOAKeyTime then
											( 
												deletekey s.scale.controller i
												addnewkey s.scale.controller currentSOAKeyTime
											)
										)
									)
									pgbCount = pgbCount + 1
									SE_AAH_Process_Rollout.prgb_AAH.value = 100.*pgbCount/pgbCountTotal
									try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
								)
							)
						)
					)
					wholeSmoothAnimationTime = (((timeStamp() - wholeSmoothAnimationTime) / 1000.0) as string)
					SE_AAH_Process_Rollout.lbl_PrcssAAH.text = "Smth finished in " + wholeSmoothAnimationTime + "s"
					SE_AAH_Process_Rollout.prgb_AAH.value = 0
					try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
					local info_str_msg = "Anim smooth finished in " + wholeSmoothAnimationTime + " seconds!"
					messageBox info_str_msg title:"Done!"
				)
				SE_AAH_SetBackAnimKeys oldAnimKeysState
			)
			else messageBox "Select any Transform type checkbox and THEN push that button!!" title:"ERROR"
		)
		else messageBox "Select at least ONE bone/helper/object and THEN push that button!" title:"ERROR"	
	)
	
	--if fovKeysTrigger == true and (ClassOf s == targetcamera or ClassOf s == VRayPhysicalCamera or ClassOf s == freecamera) do
	--if s.FOV.controller.keys.count > 0 do
	
	on DeleteObjectsTransformKeys pressed do
	(
		if selection.count > 0 then
		(
			if chkbx_ACTrnsfrmKsPos.state == true or chkbx_ACTrnsfrmKsRot.state == true or chkbx_ACTrnsfrmKsScale.state == true or chkbx_ACTrnsfrmKsRoll.state or chkbx_ACTrnsfrmKsFOV.state then
			(
				local oldAnimKeysState = SE_AAH_GetAndOffAnimKeys()
				UpdateAnimRangeStartAndEnd()
				local allAnimationTrigger = 0
				if rb_AnimKeysRange.state == 1 do allAnimationTrigger = 1
				if ACAnimRangeStartKeyframe != undefined and ACAnimRangeEndKeyframe != undefined do
				(
					DeleteTransformKeysForArray selection chkbx_ACTrnsfrmKsPos.state chkbx_ACTrnsfrmKsRot.state chkbx_ACTrnsfrmKsScale.state chkbx_ACTrnsfrmKsRoll.state chkbx_ACTrnsfrmKsFOV.state allAnimationTrigger ACAnimRangeStartKeyframe ACAnimRangeEndKeyframe 1
				)
				SE_AAH_SetBackAnimKeys oldAnimKeysState
			)
			else messageBox "Select any Transform type checkbox and THEN push that button!!" title:"ERROR"
		)
		else messageBox "Select at least ONE bone/helper/object and THEN push that button!" title:"ERROR"
	)

)

/*********************************************************************************************************************************************************************/
--// BODY ANIM ROLLOUT
/*********************************************************************************************************************************************************************/

rollout SE_AAH_Body_Anim_Rollout "Body Anim" width:132 height:170
(
	group "Skin Mesh Triggers"
	(
		button SMTrigFreeze "Freeze" width:57 height:16 align:#left across:2 tooltip:"Freezes/unfreezes skin mesh.\n\nSelect any bone/helper or skin mesh and push this button.\n\nWARNING!\nFirst time may work slow (because of the scene analysis), but works fast later!"
		button SMTrigXRay "Transparency" width:90 height:16 align:#right tooltip:"Enables/Disables transparency for skin mesh.\n\nSelect any bone/helper or skin mesh and push this button.\n\nWARNING!\nFirst time may work slow (because of the scene analysis), but works fast later!"
	)
	group "Inverse Kinematics Controllers"
	(
		button CreateHISolver1 "One bone" width:67 height:16 align:#left across:2 tooltip:"Creates HI Solver for selected bone.\n\nSelect ONE bone/helper and push this button."
		button CreateHISolver2 "Bone + Joint" width:80 height:16 align:#right tooltip:"Creates HI Solver for selected bone and its parent joint.\n\nSelect ONE bone/helper and push this button."
		button CreateMovementControllers "Movement Ct" height:16 across:2 tooltip:"Creates all needed controllers for the hierarchy that belongs to the selected bone for character's movement.\n\nSelect ONE bone/helper and push this button."
		button AddArmsControllers "Add Arms" height:16 tooltip:"Adds arms controllers to the selected movement controller.\n\nSelect MOVEMENT CONTROLLER and push this button."
		button CreateHISolverEyes "Eyes" width:32 height:16 align:#left across:2 tooltip:"Creates HI Solver for selected eye pupils' bones.\n\nSelect ALL eye pupils' bones/helpers and push this button."
		button DeleteHISolver "Delete for all selected" width:115 height:16 align:#right tooltip:"Deletes selected HI Solvers or HI Solvers for selected bones.\n\nWorks only for HI Solvers that were created by this script!\n\nSelect all needed bones or/and HI solvers and push this button."
		button CreateKeysFAHIB "Bake for all selected" height:16 tooltip:"Creates anim keys for all selected bones that uses HI Solvers or for bones that uses selected HI Solvers.\n\nWorks only for HI Solvers that were created by this script!\nUse this before animation export.\n\nSelect all needed bones or/and HI solvers and push this button."
		checkbox chkbx_DetailedHIAnim "Detailed" align:#left checked:true across:2 tooltip:"Bakes more detailed animation by adding extra anim keys every few frames. Choose frame interval in the \"Int\" field.\n\nDisable ONLY if you're know what you're doing and you want to get the less detailed baked anim depending on current HI controller's animation keys!"
		spinner spn_DetailedHIAnim "Int:" range:[0.001, 1000.0, 1.0] type:#float align:#right across:2 fieldwidth:45
	)
	
	/*---------------------------------------------------------------------------------------------------*/
	/*---------------------------------------------------------------------------------------------------*/
	/*---------------------------------------------------------------------------------------------------*/
	
	fn RemoveIKControllers bkIKArray BakeHIAnimFlag bool_DetailedHIAnim float_DetailedHIAnim bool_ShowResultDialogue =
	(
		local oldAnimKeysState = SE_AAH_GetAndOffAnimKeys()
		local localbkIKArray = bkIKArray -- to prevent EXCEPTION ACCESS VIOLATION  memory error while deleting array's nodes, we need to create a local array which will be a copy of initial array
		for bkIKArrayCurrentLimb in localbkIKArray do
		(
			if isValidNode bkIKArrayCurrentLimb do
			(
				if getUserProp bkIKArrayCurrentLimb "HIBoneNumber" != undefined and getUserProp bkIKArrayCurrentLimb "HIBoneNumber" != -1 do
				(
					local HI_BoneNumber = getUserProp bkIKArrayCurrentLimb "HIBoneNumber"
					local localbkIKArray2 = objects as array -- to prevent EXCEPTION ACCESS VIOLATION  memory error while deleting array's nodes, we need to create a local array which will be a copy of initial array
					for obj in localbkIKArray2 do
					(
						if isValidNode obj do
						(
							if getUserProp obj "HISolverNumber" != undefined do
							(
								local HI_SolverNumber = getUserProp obj "HISolverNumber"
								if HI_SolverNumber == HI_BoneNumber and getUserProp obj "HISolverType" != 3 do
								(
									local HI_SolverType = getUserProp obj "HISolverType"
									local HIBoneChild
									local HIBoneGChild
									if bkIKArrayCurrentLimb.children.count > 0 do
									(
										for HBC in bkIKArrayCurrentLimb.children do
										(
											if getUserProp HBC "HICBoneNumber" == HI_BoneNumber do
											(
												HIBoneChild = HBC
												if HI_SolverType == 2 and HIBoneChild.children.count > 0 then
												(
													for HBGC in HIBoneChild.children do
													(
														if getUserProp HBGC "HICBoneNumber" == HI_BoneNumber do
														(
															HIBoneGChild = HBGC
															continue
														)
													)
												)
												else
												(
													continue
												)
											)
										)
									)
									local snhelper
									local HIBoneChildnhelper
									local HIBoneGChildnhelper
									local HIJointhelper
									if HI_SolverType != 4 then
									(
										for HHAll in helpers do
										(
											if getUserProp HHAll "HIHelperNumber" == HI_BoneNumber do snhelper = HHAll
											if getUserProp HHAll "HICHelperNumber" == HI_BoneNumber do HIBoneChildnhelper = HHAll
											if getUserProp HHAll "HIGCHelperNumber" == HI_BoneNumber do HIBoneGChildnhelper = HHAll
											if getUserProp HHAll "HIJointNumber" == HI_BoneNumber do HIJointhelper = HHAll
										)
									)
									else
									(
										for HHAll in helpers do
										(
											local sHIEyesNumber = getUserProp bkIKArrayCurrentLimb "HIEyesNumber" 
											if getUserProp HHAll "HIHelperNumber" == HI_BoneNumber and getUserProp HHAll "HIEyesNumber" == sHIEyesNumber do snhelper = HHAll
											if getUserProp HHAll "HICHelperNumber" == HI_BoneNumber and getUserProp HHAll "HIEyesNumber" == sHIEyesNumber do HIBoneChildnhelper = HHAll
										)
										
										
										
										with Animate on
										(
											
											
											if obj.position.controller.keys.count > 1 and (obj.position.controller.keys[obj.position.controller.keys.count].time - obj.position.controller.keys[1].time) > 10.0 and bool_DetailedHIAnim and float_DetailedHIAnim == 1.0 do
											(
												local saccadeAnimRangeCurrentTime = obj.position.controller.keys[1].time
												local saccadeSeed = saccadeAnimRangeCurrentTime + timeStamp()
												saccadeAnimRangeCurrentTime += 10.0
												while saccadeAnimRangeCurrentTime < obj.position.controller.keys[obj.position.controller.keys.count].time do
												(
													addNewKey obj.position.controller saccadeAnimRangeCurrentTime
													saccadeAnimRangeCurrentTime += 10.0
												)
												
												local saccadeAnimXYZ = [0.0, 0.0, 0.0]
												local saccadeMultiplier = 1.0
												local saccadePupillaryDistance = getUserProp obj "HIEyesPupDist"
												local saccadePupillaryDistanceVector = [(getUserProp obj "HIEyesPupDistVectorX"),(getUserProp obj "HIEyesPupDistVectorY"),(getUserProp obj "HIEyesPupDistVectorZ")]
												
												
												local saccadeAnimRangeCurrentTime = obj.position.controller.keys[1].time
												saccadeAnimRangeCurrentTime += 10.0
												while saccadeAnimRangeCurrentTime < obj.position.controller.keys[obj.position.controller.keys.count].time do
												(
													--at time saccadeAnimRangeCurrentTime saccadeAnimXYZ = obj.position
													saccadeSeed += saccadeAnimRangeCurrentTime
													seed saccadeSeed
													local saccadeDelay = random 2 8
													local saccadeDelayTime = 0.0
													local saccadeDelayCount = 9
													while saccadeDelayCount > 0 do
													(
														saccadeDelayTime = saccadeAnimRangeCurrentTime - saccadeDelayCount
														--at time (saccadeAnimRangeCurrentTime - 10.0) saccadeAnimXYZ = obj.position
														if obj.position.controller.keys.count != (obj.position.controller.keys[obj.position.controller.keys.count].time - obj.position.controller.keys[1].time - 9.0) do--then
															--1 == 1 do --getKeyIndex obj.pos.controller.x_Position.controller saccadeDelayTime == 0 and obj.pos.controller.y_Position.controller saccadeDelayTime == 0 and obj.pos.controller.z_Position.controller saccadeDelayTime == 0 do
														(
															
															if saccadeDelayCount > saccadeDelay then
															(
																--at time saccadeDelayTime obj.position = saccadeAnimXYZ
																
																addNewKey obj.position.controller saccadeDelayTime
															)
															else if saccadeDelayCount == saccadeDelay then
															(
																at time saccadeDelayTime
																(
																	
																	saccadeMultiplier = (1.0 / ((length (obj.position - bkIKArrayCurrentLimb.position)) * saccadePupillaryDistance - 1.0) ) * 0.002
																	
																	saccadeSeed += obj.position.x
																	seed saccadeSeed
																	saccadeAnimXYZ.x = obj.position.x + (random 0.0 saccadeMultiplier)
																	obj.position.x = (obj.position.x + saccadeAnimXYZ.x) * 0.5
																	saccadeSeed += obj.position.y
																	seed saccadeSeed
																	saccadeAnimXYZ.y = obj.position.y + (random 0.0 saccadeMultiplier)
																	obj.position.y = (obj.position.y + saccadeAnimXYZ.y) * 0.5
																	saccadeSeed += obj.position.z
																	seed saccadeSeed
																	saccadeAnimXYZ.z = obj.position.z + (random 0.0 saccadeMultiplier)
																	obj.position.z = (obj.position.z + saccadeAnimXYZ.z) * 0.5
																	
																	
																	obj.position += (saccadePupillaryDistanceVector * (random -2.0 2.0) * 0.02)
																	saccadeAnimXYZ = obj.position
																)
																
															)
															else if saccadeDelayCount < saccadeDelay do
															(
																if saccadeDelayCount != 1 then
																(
																	at time saccadeDelayTime
																	(
																		obj.position = saccadeAnimXYZ
																	)
																)
																else
																(
																	addNewKey obj.position.controller saccadeDelayTime
																)
															)
														)
														/*else
														(
															local info_str_msg = "keys: " + ((obj.position.controller.keys[obj.position.controller.keys.count].time - obj.position.controller.keys[1].time + 1.0) as string) + " !\n" +
															"count: " + (obj.position.controller.keys.count as string) + " !\n"
															messagebox info_str_msg title:"TEST!"
														)*/
														saccadeDelayCount -= 1
													)
													
													/*addNewKey obj.position.controller (saccadeAnimRangeCurrentTime - 9.0)
													addNewKey obj.position.controller (saccadeAnimRangeCurrentTime - 8.0)
													addNewKey obj.position.controller (saccadeAnimRangeCurrentTime - 7.0)
													at time (saccadeAnimRangeCurrentTime - 6.0)
													(
														
														saccadeMultiplier = ((length (obj.position - bkIKArrayCurrentLimb.position)) * saccadePupillaryDistance) * 0.1
														
														
														seed (obj.position.x * saccadeAnimRangeCurrentTime)
														obj.position.x += (random 0.0 saccadeMultiplier)
														seed (obj.position.y * saccadeAnimRangeCurrentTime)
														obj.position.y += (random 0.0 saccadeMultiplier)
														seed (obj.position.z * saccadeAnimRangeCurrentTime)
														obj.position.z += (random 0.0 saccadeMultiplier)
														saccadeAnimXYZ = obj.position
													)
													at time (saccadeAnimRangeCurrentTime - 5.0)
													(
														obj.position = saccadeAnimXYZ
													)
													at time (saccadeAnimRangeCurrentTime - 4.0)
													(
														obj.position = saccadeAnimXYZ
													)
													at time (saccadeAnimRangeCurrentTime - 3.0)
													(
														obj.position = saccadeAnimXYZ
													)
													at time (saccadeAnimRangeCurrentTime - 2.0)
													(
														obj.position = saccadeAnimXYZ
													)
													at time (saccadeAnimRangeCurrentTime - 1.0)
													(
														obj.position = saccadeAnimXYZ
													)*/
													saccadeAnimRangeCurrentTime += 10.0
												)
												
												
												
												
												
												
												/*
												if HIAnimRangeStart < HIAnimRangeEnd and (HIAnimRangeEnd - HIAnimRangeStart) > float_DetailedHIAnim do
												(
													local DetailedHIAnimCurrentTime = HIAnimRangeStart
													DetailedHIAnimCurrentTime += float_DetailedHIAnim
													while DetailedHIAnimCurrentTime < HIAnimRangeEnd do
													(
														at time DetailedHIAnimCurrentTime
														(
															if snhelper != undefined do snhelper.transform = bkIKArrayCurrentLimb.transform
															if HIBoneChild != undefined and HIBoneChildnhelper != undefined do HIBoneChildnhelper.transform = HIBoneChild.transform
															if HIBoneGChild != undefined and HIBoneGChildnhelper != undefined do HIBoneGChildnhelper.transform = HIBoneGChild.transform
														)
														DetailedHIAnimCurrentTime += float_DetailedHIAnim
													)
												)*/
											)
										)
										
										
										
									)
									
									
									
									if BakeHIAnimFlag == 1 do
									(
										if obj.position.controller.keys.count > 0 or obj.rotation.controller.keys.count > 0 do
										(
											if obj.position.controller.keys.count > 0 do
											(
												if snhelper != undefined do
												(
													deselectKeys snhelper.rotation.controller
													selectKeys snhelper.rotation.controller obj.position.controller.keys[1].time obj.position.controller.keys[obj.position.controller.keys.count].time
													deleteKeys snhelper.rotation.controller #selection
												)
												if HIBoneChildnhelper != undefined do
												(
													deselectKeys HIBoneChildnhelper.rotation.controller
													selectKeys HIBoneChildnhelper.rotation.controller obj.position.controller.keys[1].time obj.position.controller.keys[obj.position.controller.keys.count].time
													deleteKeys HIBoneChildnhelper.rotation.controller #selection
												)
												if HIBoneGChildnhelper != undefined do
												(
													deselectKeys HIBoneGChildnhelper.rotation.controller
													selectKeys HIBoneGChildnhelper.rotation.controller obj.position.controller.keys[1].time obj.position.controller.keys[obj.position.controller.keys.count].time
													deleteKeys HIBoneGChildnhelper.rotation.controller #selection
												)
											)
											if obj.rotation.controller.keys.count > 0 do
											(
												if HIBoneGChildnhelper != undefined do
												(
													deselectKeys HIBoneGChildnhelper.rotation.controller
													selectKeys HIBoneGChildnhelper.rotation.controller obj.rotation.controller.keys[1].time obj.rotation.controller.keys[obj.rotation.controller.keys.count].time
													deleteKeys HIBoneGChildnhelper.rotation.controller #selection
												)
											)
											with Animate on
											(
												local HIAnimRangeStart
												local HIAnimRangeEnd
												-- baking IK controller position
												if obj.position.controller.keys.count > 0 do
												(
													HIAnimRangeStart = obj.position.controller.keys[1].time
													if obj.position.controller.keys.count > 1 do HIAnimRangeEnd = obj.position.controller.keys[obj.position.controller.keys.count].time
													if snhelper != undefined do
													(
														for i = 1 to obj.position.controller.keys.count do
														(
															at time obj.position.controller.keys[i].time
															(
																snhelper.transform = bkIKArrayCurrentLimb.transform
																if HIBoneChild != undefined and HIBoneChildnhelper != undefined do
																(
																	HIBoneChildnhelper.transform = HIBoneChild.transform
																)
																if HIBoneGChild != undefined and HIBoneGChildnhelper != undefined do
																(
																	HIBoneGChildnhelper.transform = HIBoneGChild.transform
																)
															)
														)
														-- for eyes or one bone controller
														if (HI_SolverType == 1 or HI_SolverType == 4) and bkIKArrayCurrentLimb.parent != undefined do
														(
															local sBoneParent = bkIKArrayCurrentLimb.parent
															if sBoneParent.rotation.controller.keys.count > 0 do
															(
																for i = 1 to sBoneParent.rotation.controller.keys.count do
																(
																	if sBoneParent.rotation.controller.keys[i].time >= obj.position.controller.keys[1].time and sBoneParent.rotation.controller.keys[i].time <= obj.position.controller.keys[obj.position.controller.keys.count].time do
																	(
																		at time sBoneParent.rotation.controller.keys[i].time
																		(
																			snhelper.transform = bkIKArrayCurrentLimb.transform
																			if HIBoneChild != undefined and HIBoneChildnhelper != undefined do
																			(
																				HIBoneChildnhelper.transform = HIBoneChild.transform
																			)
																		)
																	)
																)
															)
														)
													)
												)
												-- baking IK controller rotation
												if obj.rotation.controller.keys.count > 0 do
												(
													if HIAnimRangeStart != undefined then
													(
														if HIAnimRangeStart > obj.rotation.controller.keys[1].time do HIAnimRangeStart = obj.rotation.controller.keys[1].time
													)
													else HIAnimRangeStart = obj.rotation.controller.keys[1].time
													if obj.rotation.controller.keys.count > 1 do
													(
														if HIAnimRangeEnd != undefined then
														(
															if HIAnimRangeEnd < obj.rotation.controller.keys[obj.rotation.controller.keys.count].time do HIAnimRangeEnd = obj.rotation.controller.keys[obj.rotation.controller.keys.count].time
														)
														else HIAnimRangeEnd = obj.rotation.controller.keys[obj.rotation.controller.keys.count].time
													)
													for i = 1 to obj.rotation.controller.keys.count do
													(
														at time obj.rotation.controller.keys[i].time
														(
															if HI_SolverType == 1 or HI_SolverType == 4 then
															(
																if HIBoneChild != undefined and HIBoneChildnhelper != undefined do
																(
																	HIBoneChildnhelper.transform = HIBoneChild.transform
																)
															)
															else
															(
																if HIBoneGChild != undefined and HIBoneGChildnhelper != undefined do
																(
																	HIBoneGChildnhelper.transform = HIBoneGChild.transform
																)
															)
														)
													)
													-- for eyes or one bone controller
													if (HI_SolverType == 1 or HI_SolverType == 4) and bkIKArrayCurrentLimb.parent != undefined do
													(
														local sBoneParent = bkIKArrayCurrentLimb.parent
														if sBoneParent.rotation.controller.keys.count > 0 do
														(
															for i = 1 to sBoneParent.rotation.controller.keys.count do
															(
																if sBoneParent.rotation.controller.keys[i].time >= obj.rotation.controller.keys[1].time and sBoneParent.rotation.controller.keys[i].time <= obj.rotation.controller.keys[obj.rotation.controller.keys.count].time do
																(
																	at time sBoneParent.rotation.controller.keys[i].time
																	(
																		if HIBoneChild != undefined and HIBoneChildnhelper != undefined do
																		(
																			HIBoneChildnhelper.transform = HIBoneChild.transform
																		)
																	)
																)
															)
														)
													)
												)
												if bool_DetailedHIAnim and HIAnimRangeStart != undefined and HIAnimRangeEnd != undefined do
												(
													if HIAnimRangeStart < HIAnimRangeEnd and (HIAnimRangeEnd - HIAnimRangeStart) > float_DetailedHIAnim do
													(
														local DetailedHIAnimCurrentTime = HIAnimRangeStart
														DetailedHIAnimCurrentTime += float_DetailedHIAnim
														while DetailedHIAnimCurrentTime < HIAnimRangeEnd do
														(
															at time DetailedHIAnimCurrentTime
															(
																if snhelper != undefined do snhelper.transform = bkIKArrayCurrentLimb.transform
																if HIBoneChild != undefined and HIBoneChildnhelper != undefined do HIBoneChildnhelper.transform = HIBoneChild.transform
																if HIBoneGChild != undefined and HIBoneGChildnhelper != undefined do HIBoneGChildnhelper.transform = HIBoneGChild.transform
															)
															DetailedHIAnimCurrentTime += float_DetailedHIAnim
														)
													)
												)
											)
										)
									)
									setUserProp bkIKArrayCurrentLimb "HIBoneNumber" -1
									if HI_SolverType == 1 or HI_SolverType == 4 then
									(
										if HIBoneChild != undefined do
										(
											HIBoneChild.rotation.controller = Euler_XYZ()
											setUserProp HIBoneChild "HICBoneNumber" -1
										)
									)
									else
									(
										if HIBoneChild != undefined do setUserProp HIBoneChild "HICBoneNumber" -1
										if HIBoneGChild != undefined do
										(
											HIBoneGChild.rotation.controller = Euler_XYZ()
											setUserProp HIBoneGChild "HICBoneNumber" -1
										)
									)
									local localbkIKArray3 = objects as array -- to prevent EXCEPTION ACCESS VIOLATION  memory error while deleting array's nodes, we need to create a local array which will be a copy of initial array
									for obj2 in localbkIKArray3 do
									(
										if isValidNode obj2 do
										(
											if getUserProp obj2 "HISolverNumber" != undefined do
											(
												if getUserProp obj2 "HISolverNumber" == HI_BoneNumber do
												(
													if HI_SolverType == 4 then
													(
														if getUserProp obj2 "HISolverType" != undefined and getUserProp obj2 "HISolverType" != 3 then
														(
															local HIBonesRemaining = 0
															for obj3 in objects do
															(
																if getUserProp obj3 "HIBoneNumber" != undefined do
																(
																	if getUserProp obj3 "HIBoneNumber" == HI_BoneNumber do
																	(
																		HIBonesRemaining = 1
																	)
																)
															)
															if HIBonesRemaining == 0 do delete obj2
														)
														else
														(
															if getUserProp obj2 "HIEyesNumber" == getUserProp bkIKArrayCurrentLimb "HIEyesNumber" do delete obj2
														)
													)
													else delete obj2
												)
											)
										)
									)------------------EXCEPTION ACCESS VIOLATION 
									deleteKeys bkIKArrayCurrentLimb.rotation.controller #allKeys
									if HIBoneChild != undefined do deleteKeys HIBoneChild.rotation.controller #allKeys
									if HIBoneGChild != undefined do deleteKeys HIBoneGChild.rotation.controller #allKeys
									with Animate on
									(
										if snhelper != undefined do
										(
											if snhelper.rotation.controller.keys.count > 0 do
											(
												for i = 1 to snhelper.rotation.controller.keys.count do
												(
													at time snhelper.rotation.controller.keys[i].time
													(
														bkIKArrayCurrentLimb.transform = snhelper.transform
														
														-- OUTDATED??? Cause bugs with old anim
														/*if HIBoneChild != undefined do
														(
															if HI_SolverType == 2 do
															(
																HIBoneChild.transform = HIBoneChildnhelper.transform
															)
														)
														*/
													)
												)-------------------------------------------------
											)
										)
										if HIBoneChild != undefined and HIBoneChildnhelper != undefined do
										(
											if HIBoneChildnhelper.rotation.controller.keys.count > 0 do
											(
												for i = 1 to HIBoneChildnhelper.rotation.controller.keys.count do
												(
													at time HIBoneChildnhelper.rotation.controller.keys[i].time
													(
														HIBoneChild.transform = HIBoneChildnhelper.transform
													)
												)
											)
											if HI_SolverType == 2 and HIBoneGChild != undefined and HIBoneGChildnhelper != undefined do
											(
												if HIBoneGChildnhelper.rotation.controller.keys.count > 0 do
												(
													for i = 1 to HIBoneGChildnhelper.rotation.controller.keys.count do
													(
														at time HIBoneGChildnhelper.rotation.controller.keys[i].time
														(
															HIBoneGChild.transform = HIBoneGChildnhelper.transform
														)
													)
												)
											)
										)
									)
									if snhelper != undefined do delete snhelper
									if HIBoneChildnhelper != undefined do delete HIBoneChildnhelper
									if HIBoneGChildnhelper != undefined do delete HIBoneGChildnhelper
									if HIJointhelper != undefined do delete HIJointhelper
									--deleteKeys bkIKArrayCurrentLimb.position.controller
									--deleteKeys bkIKArrayCurrentLimb.scale.controller
									if HIBoneChild != undefined do
									(
										--deleteKeys HIBoneChild.position.controller
										--deleteKeys HIBoneChild.scale.controller
									)
									if HIBoneGChild != undefined do
									(
										--deleteKeys HIBoneGChild.position.controller
										--deleteKeys HIBoneGChild.scale.controller
									)
								)
							)
						)
					)
				)
			)
		)
		clearselection()
		SE_AAH_SetBackAnimKeys oldAnimKeysState
	)
	
	/*---------------------------------------------------------------------------------------------------*/
	
	fn CreateHISolver s hitype bool_ShowResultDialogue = -- hitype: "One bone", "Bone + Joint", "Chain", "Eyes" and "Joint" (1-5)
	(
		local newhelper
		local p = s.parent
		if p != undefined then
		(
			local p2 = p.parent
			if hitype != 2 or p2 != undefined then
			(
				SE_AAH_UpdateOrCreateAAHHelperLayer()
				SE_AAH_UpdateOrCreateAAHControllerLayer()
				SE_AAH_IncreaseIKBoneNumber()
				addNewKey s.position.controller sliderTime
				addNewKey s.rotation.controller sliderTime
				addNewKey s.scale.controller sliderTime
				addNewKey p.position.controller sliderTime
				addNewKey p.rotation.controller sliderTime
				addNewKey p.scale.controller sliderTime
				local snhelper = point size:0.1
				snhelper.name = "IK_" + s.name + " old anim"
				AAHHelperLayer.addnode snhelper
				local hIBoneParentnhelper = point size:0.1
				hIBoneParentnhelper.name = "IK_" + s.name + " - " + p.name + " old anim"
				AAHHelperLayer.addnode hIBoneParentnhelper
				if hitype == 2 do
				(
					addNewKey p2.position.controller sliderTime
					addNewKey p2.rotation.controller sliderTime
					addNewKey p2.scale.controller sliderTime
					local hIBoneGParentnhelper = point size:0.1
					hIBoneGParentnhelper.name = "IK_" + s.name + " - " + p2.name + " old anim"
					AAHHelperLayer.addnode hIBoneGParentnhelper
				)
				with Animate on
				(
					if s.rotation.controller.keys.count > 0 then
					(
						for i = 1 to s.rotation.controller.keys.count do
						(
							at time s.rotation.controller.keys[i].time
							(
								snhelper.transform = s.transform
							)
						)
					)
					else
					(
						at time sliderTime
						(
							snhelper.transform = s.transform
						)
					)
					if p.rotation.controller.keys.count > 0 then
					(
						for i = 1 to p.rotation.controller.keys.count do
						(
							at time p.rotation.controller.keys[i].time
							(
								hIBoneParentnhelper.transform = p.transform
							)
						)
					)
					else
					(
						at time sliderTime
						(
							hIBoneParentnhelper.transform = p.transform
						)
					)
					if hitype == 2 do
					(
						if p2.rotation.controller.keys.count > 0 then
						(
							for i = 1 to p2.rotation.controller.keys.count do
							(
								at time p2.rotation.controller.keys[i].time
								(
									hIBoneGParentnhelper.transform = p2.transform
								)
							)
						)
						else
						(
							at time sliderTime
							(
								hIBoneGParentnhelper.transform = p2.transform
							)
						)
					)
				)
				if hitype == 2 then
				(
					setUserProp snhelper "HIGCHelperNumber" NewHI_Number
					setUserProp hIBoneParentnhelper "HICHelperNumber" NewHI_Number
					setUserProp hIBoneGParentnhelper "HIHelperNumber" NewHI_Number
				)
				else
				(
					setUserProp snhelper "HICHelperNumber" NewHI_Number
					setUserProp hIBoneParentnhelper "HIHelperNumber" NewHI_Number
				)				
				addNewKey s.rotation.controller sliderTime
				selectKeys s.rotation.controller
				deselectKeys s.rotation.controller sliderTime
				deleteKeys s.rotation.controller #selection
				
				addNewKey p.rotation.controller sliderTime
				selectKeys p.rotation.controller
				deselectKeys p.rotation.controller sliderTime
				deleteKeys p.rotation.controller #selection
				
				if hitype == 2 do
				(
					addNewKey p2.rotation.controller sliderTime
					selectKeys p2.rotation.controller
					deselectKeys p2.rotation.controller sliderTime
					deleteKeys p2.rotation.controller #selection
				)
				maxOps.setKeyMode = true
				at time sliderTime
				(
					s.transform= snhelper.transform
					p.transform = hIBoneParentnhelper.transform
					if hitype == 2 do p2.transform = hIBoneGParentnhelper.transform
					addNewKey s.rotation.controller sliderTime
					addNewKey p.rotation.controller sliderTime
					if hitype == 2 do addNewKey p2.rotation.controller sliderTime
				)
				maxOps.setKeyMode = false
				freeze snhelper
				hide snhelper
				freeze hIBoneParentnhelper
				hide hIBoneParentnhelper
				if hitype == 2 do
				(
					freeze hIBoneGParentnhelper
					hide hIBoneGParentnhelper
				)
				if hitype == 2 then local ikChain01 = IKSys.ikChain p2 s "IKHISolver"
				else local ikChain01 = IKSys.ikChain p s "IKHISolver"
				ikChain01.transform.controller.posThresh = 0.0--01
				ikChain01.transform.controller.rotThresh = 0.0--01
				ikChain01.transform.controller.iterations = 1000
				ikChain01.transform.controller.goalsize = 0.1
				ikChain01.name = "IK_" +s.name + " Chain"
				ikChain01.wirecolor = (color 255 0 0)
				AAHHelperLayer.addnode ikChain01
				if hitype == 2 then
				(
					setUserProp p2 "HIBoneNumber" NewHI_Number
					setUserProp p "HICBoneNumber" NewHI_Number
					setUserProp s "HICBoneNumber" NewHI_Number
				)
				else
				(
					setUserProp p "HIBoneNumber" NewHI_Number
					setUserProp s "HICBoneNumber" NewHI_Number
				)
				newhelper = point size:(length (p.position - s.position)) 
				newhelper.size = (length (p.position - s.position))
				newhelper.name = "IK_" + s.name + " controller"
				newhelper.position = s.position
				newhelper.cross = false
				newhelper.box = true
				--newhelper.drawontop = true
				newhelper.wirecolor = (color 255 0 0)
				AAHControllerLayer.addnode newhelper
				ikChain01.parent = newhelper
				setUserProp newhelper "HISolverNumber" NewHI_Number
				setUserProp newhelper "HISolverType" hitype
				setUserProp ikChain01 "HISolverNumber" NewHI_Number
				setUserProp ikChain01 "HISolverType" 3 -- "Chain" type
				freeze ikChain01
				ikChain01.showFrozenInGray = false
				s.rotation.controller = Orientation_Constraint()
				s.rotation.controller.appendTarget newhelper 50.0
				
				local newjointhelper = point size:((length (p.position - s.position)) * 0.5)
				newjointhelper.size = ((length (p.position - s.position)) * 0.5)
				newjointhelper.name = "IK_" + s.name + " Joint"
				newjointhelper.position = p.position
				newjointhelper.cross = false
				newjointhelper.box = true
				--newjointhelper.drawontop = true
				newjointhelper.wirecolor = (color 255 0 255)
				AAHControllerLayer.addnode newjointhelper
				newjointhelper.parent = newhelper
				setUserProp newjointhelper "HIJointNumber" NewHI_Number

				--select newhelper
				maxOps.setKeyMode = true
				newhelper.transform = snhelper.transform
				addNewKey newhelper.rotation.controller sliderTime
				addNewKey newhelper.position.controller sliderTime
				
				if hitype == 2 then
				(
					local p2length = length (p2.position - p.position)
					local newjointhelperVector = p2.position - (p2.position - s.position) / (length (p2.position - s.position)) * p2length
					newjointhelper.position = newjointhelperVector - (newjointhelperVector - p.position) / (length (newjointhelperVector - p.position)) * p2length
				)				
				else newjointhelper.position = p.position
				ikChain01.controller.VHTarget = newjointhelper
				ikChain01.controller.useVHTarget = true
				addNewKey newjointhelper.rotation.controller sliderTime
				addNewKey newjointhelper.position.controller sliderTime
				maxOps.setKeyMode = false
			)
			else
			(
				if bool_ShowResultDialogue == 1 do
				(
					local error_str_msg = "Bone " + (s.name) + " hasn't parent joint!"
					messagebox error_str_msg title:"ERROR"
				)
			)
		)
		else
		(
			if bool_ShowResultDialogue == 1 do
			(
				local error_str_msg = "Bone " + (s.name) + " hasn't parent bone!"
				messagebox error_str_msg title:"ERROR"
			)
		)
		return newhelper
	)
	
	/*---------------------------------------------------------------------------------------------------*/
	/*---------------------------------------------------------------------------------------------------*/
	/*---------------------------------------------------------------------------------------------------*/
	
	on SMTrigFreeze pressed do
	(
		if selection.count > 0 then
		(
			local s = selection[1]
			if ClassOf s != point and ClassOf s != bone and ClassOf s != dummy then
			(
				if getUserProp s "SkinMeshNumber" == undefined do
				(
					SE_AAH_MarkAllSkinsAndBonesInScene()
					--if (SE_AAH_HasSkinModifier s) do SE_AAH_MarkRelatedSkinBones s
				)
				if s.isFrozen == true then
				(
					unfreeze s
				)
				else
				(
					s.showFrozenInGray = false
					freeze s
				)
			)
			else --ObjectSet geometry    -- if getUserProp s "FrameName" != undefined then
			(
				local s_Hierarchy = #()
				if getUserProp s "SkinMeshNumber" != undefined and getUserProp s "SkinMeshNumber" != -1 then append s_Hierarchy s
				else s_Hierarchy = SE_AAH_GetAllHierarchy s 0
				local s2 = SE_AAH_GetSkinMeshes s_Hierarchy --// Returns any skin meshes (if any) associated with the picked hierarchy
				if s2.count > 0 then
				(
					for obj in s2 do
					(
						if obj.isFrozen == true then
						(
							unfreeze obj
						)
						else
						(
							obj.showFrozenInGray = false
							freeze obj
						)
					)
				)
				else if getUserProp s "SkinMeshName" != undefined then -- add later SkinMeshName property for extra situations when SE_AAH_GetSkinMeshes is not working properly
				(
					local SkinMeshName = getUserProp s "SkinMeshName"
					local MeshFound = false
					for obj in geometry do
					(
						if SE_AAH_HasSkinModifier s and obj.name == SkinMeshName then
						(
							if obj.isFrozen == true then
							(
								unfreeze obj
							)
							else
							(
								obj.showFrozenInGray = false
								freeze obj
							)
							MeshFound = true
						)
					)
					if MeshFound == false then
					(
						local info_str_msg = "SkinMesh \"" + SkinMeshName + "\" didn't found!"
						messageBox info_str_msg title:"ERROR"
					)
				)
			)
		)
		else messageBox "Select ONE bone/helper/skin and THEN push that button!" title:"ERROR"
	)

	on SMTrigXRay pressed do
	(
		if selection.count > 0 then
		(
			local oldAnimKeysState = SE_AAH_GetAndOffAnimKeys()
			local s = selection[1]
			if ClassOf s != point and ClassOf s != bone and ClassOf s != dummy then
			(
				if getUserProp s "SkinMeshNumber" == undefined do
				(
					SE_AAH_MarkAllSkinsAndBonesInScene()
					--if (SE_AAH_HasSkinModifier s) do SE_AAH_MarkRelatedSkinBones s
				)
				if ((getVisController s) == undefined) do
				(
					s.visibility = bezier_float()
				)
				if s.visibility.controller.value != 0.6 then
				(
					s.visibility.controller.value = 0.6
					s.backfaceCull = true
				)
				else
				(
					s.visibility.controller.value = 1.0
					s.backfaceCull = false
				)
			)
			else --ObjectSet geometry    -- if getUserProp s "FrameName" != undefined then
			(
				local s_Hierarchy = #()
				if getUserProp s "SkinMeshNumber" != undefined and getUserProp s "SkinMeshNumber" != -1 then append s_Hierarchy s
				else s_Hierarchy = SE_AAH_GetAllHierarchy s 0
				local s2 = SE_AAH_GetSkinMeshes s_Hierarchy --// Returns any skin meshes (if any) associated with the picked hierarchy
				if s2.count > 0 then
				(
					for obj in s2 do
					(
						if ((getVisController obj) == undefined) do
						(
							obj.visibility = bezier_float()
						)
						if obj.visibility.controller.value != 0.6 then
						(
							obj.visibility.controller.value = 0.6
							obj.backfaceCull = true
						)
						else
						(
							obj.visibility.controller.value = 1.0
							obj.backfaceCull = false
						)
					)
				)
				else if getUserProp s "SkinMeshName" != undefined then -- add later SkinMeshName property for extra situations when SE_AAH_GetSkinMeshes is not working properly
				(
					local SkinMeshName = getUserProp s "SkinMeshName"
					local MeshFound = false
					for obj in geometry do
					(
						if SE_AAH_HasSkinModifier s and obj.name == SkinMeshName then
						(
							if ((getVisController obj) == undefined) do
							(
								obj.visibility = bezier_float()
							)
							if obj.visibility.controller.value != 0.6 then
							(
								obj.visibility.controller.value = 0.6
								obj.backfaceCull = true
							)
							else
							(
								obj.visibility.controller.value = 1.0
								obj.backfaceCull = false
							)
							MeshFound = true
						)
					)
					if MeshFound == false then
					(
						local error_str_msg = "SkinMesh \"" + SkinMeshName + "\" didn't found!"
						messageBox error_str_msg title:"ERROR"
					)
				)
			)
			SE_AAH_SetBackAnimKeys oldAnimKeysState
			redrawViews()
		)
		else messageBox "Select ONE bone/helper/skin and THEN push that button!" title:"ERROR"
	)
	
	/*---------------------------------------------------------------------------------------------------*/
	/*---------------------------------------------------------------------------------------------------*/
	/*---------------------------------------------------------------------------------------------------*/
	
	on CreateHISolver1 pressed do
	(
		local oldAnimKeysState = SE_AAH_GetAndOffAnimKeys()
		if selection.count == 1 then
		(
			local newIKController = CreateHISolver selection[1] 1 1 -- "One bone" type
			if newIKController != undefined do
			(
				clearselection()
				select newIKController
			)
		)
		else messageBox "Select ONE bone/helper and THEN push that button!" title:"ERROR"
		SE_AAH_SetBackAnimKeys oldAnimKeysState
	)

	on CreateHISolver2 pressed do
	(
		local oldAnimKeysState = SE_AAH_GetAndOffAnimKeys()
		if selection.count == 1 then
		(
			local newIKController = CreateHISolver selection[1] 2 1 -- "Bone + Joint" type
			if newIKController != undefined do
			(
				clearselection()
				select newIKController
			)
		)
		else messageBox "Select ONE bone/helper and THEN push that button!" title:"ERROR"
		SE_AAH_SetBackAnimKeys oldAnimKeysState
	)
	
	on CreateMovementControllers pressed do
	(
		if selection.count > 0 then
		(
			SE_AAH_UpdateOrCreateAAHHelperLayer()
			SE_AAH_UpdateOrCreateAAHControllerLayer()
			local oldAnimKeysState = SE_AAH_GetAndOffAnimKeys() 
			local ccBonesArr = SE_AAH_GetAllHierarchy selection[1] 0
			--local ccCH = SE_AAH_GetCharacterHierarchy selection[1]
			local bool_isItHumanoud
			local bool_isItHasAnyLegs
			local newMovementControllerSize = 0.5
			local aMCIKLegs = #()
			/*
			local info_str_msg = "spineLinks: " + (ccCH.spinelinks as string) + " !\n" +
			"legLinks: " + (ccCH.leglinks as string) + " !\n" +
			"tailLinks: " + (ccCH.taillinks as string) + " !\n" +
			"fingers: " + (ccCH.fingersnumber as string) + " !\n" +
			"fingerLinks: " + (ccCH.fingerlinks as string) + " !\n" +
			"toes: " + (ccCH.toesnumber as string) + " !\n" +
			"toeLinks: " + (ccCH.toelinks as string) + " !\n" +
			"headId: " + (ccCH.headid as string) + " !"
			messagebox info_str_msg title:"TEST!"
			*/
			if (queryBox "Humanoid?" title:"ATTENTION") do bool_isItHumanoud = 1
			for ccbone in ccBonesArr do
			(
				local ccBoneId = SE_AAH_GetSubID 0 ccbone
				if ccBoneId != -1 do
				(
					if ccBoneId == 43 or ccBoneId == 53 or ccBoneId == 24 or ccBoneId == 34 do
					(
						if (ccBoneId == 24 or ccBoneId == 34) and bool_isItHumanoud != 1 do
						(
							newMovementControllerSize = ((length (ccBonesArr[1].position - ccbone.position)) * 0.8)
							local newIKLegController = CreateHISolver ccbone 2 0
							if newIKLegController != undefined do
							(
								append aMCIKLegs newIKLegController
								bool_isItHasAnyLegs = true
							)
						)
						if ccBoneId == 43 or ccBoneId == 53 do
						(
							newMovementControllerSize = ((length (ccBonesArr[1].position - ccbone.position)) * 0.8)
							local newIKLegController = CreateHISolver ccbone 2 0
							if newIKLegController != undefined do
							(
								append aMCIKLegs newIKLegController
								bool_isItHasAnyLegs = true
							)
						)
					)
				)		
			)
			if bool_isItHasAnyLegs == true then
			(
				local newMovementController = point size:newMovementControllerSize
				newMovementController.name = "MC_" + ccBonesArr[1].name + " movement controller"
				newMovementController.cross = true
				newMovementController.box = true
				newMovementController.drawontop = true
				newMovementController.wirecolor = (color 255 48 0)
				newMovementController.position.x = ccBonesArr[1].position.x
				newMovementController.position.y = ccBonesArr[1].position.y
				newMovementController.position.z = ccBonesArr[1].position.z
				newMovementController.rotation.x_rotation = ccBonesArr[1].rotation.x_rotation
				newMovementController.rotation.y_rotation = ccBonesArr[1].rotation.y_rotation
				newMovementController.rotation.z_rotation = ccBonesArr[1].rotation.z_rotation
				addNewKey newMovementController.position.controller sliderTime
				addNewKey newMovementController.rotation.controller sliderTime
				addNewKey newMovementController.scale.controller sliderTime
				setUserProp newMovementController "IKMovementController" 1
				AAHControllerLayer.addnode newMovementController
				local newMCRootAttachController = SE_AAH_Main_Anim_Rollout.CreateAOLink newMovementController ccBonesArr[1] 0				
				
				
				if aMCIKLegs.count > 0 do
				(
					for aMCIKLegsController in aMCIKLegs do
					(
						local aMCIKLegsCAttachController = SE_AAH_Main_Anim_Rollout.CreateAOLink newMovementController aMCIKLegsController 0
					)
				)
				clearselection()
				select newMovementController
			)
				
			else	messageBox "Character is not tuned properly!\n(can't find any legs' BoneID's)" title:"ERROR"
			SE_AAH_SetBackAnimKeys oldAnimKeysState
		)
		else messageBox "Select at least ONE bone/helper and THEN push that button!" title:"ERROR"	
	)
	
	on AddArmsControllers pressed do
	(
		if selection.count > 0 then
		(
			if (getUserProp selection[1] "IKMovementController" != undefined) and (getUserProp selection[1] "IKMovementController" == 1) then
			(
				local OurMovementController = selection[1]
				SE_AAH_UpdateOrCreateAAHHelperLayer()
				SE_AAH_UpdateOrCreateAAHControllerLayer()
				local oldAnimKeysState = SE_AAH_GetAndOffAnimKeys() 
				local ccBonesArr = SE_AAH_GetAllHierarchy selection[1] 0
				--local ccCH = SE_AAH_GetCharacterHierarchy selection[1]
				--local bool_isItHumanoud
				local bool_isItHasAnyArms
				local newMovementControllerSize = 0.5
				local aMCIKArms = #()
			
				for ccbone in ccBonesArr do
				(
					local ccBoneId = SE_AAH_GetSubID 0 ccbone
					if ccBoneId != -1 do
					(
						if ccBoneId == 24 or ccBoneId == 34 do
						(
							newMovementControllerSize = ((length (ccBonesArr[1].position - ccbone.position)) * 0.8)
							local newIKArmController = CreateHISolver ccbone 2 0
							if newIKArmController != undefined do
							(
								append aMCIKArms newIKArmController
								bool_isItHasAnyArms = true
							)
						)
					)		
				)
				if bool_isItHasAnyArms == true then
				(
					if aMCIKArms.count > 0 do
					(
						for aMCIKArmsController in aMCIKArms do
						(
							local aMCIKArmsCAttachController = SE_AAH_Main_Anim_Rollout.CreateAOLink OurMovementController aMCIKArmsController 0
						)
					)
					clearselection()
					select OurMovementController
				)
				SE_AAH_SetBackAnimKeys oldAnimKeysState
			)
			else messageBox "Select MOVEMENT CONTROLLER and THEN push that button!" title:"ERROR"
		)
		else messageBox "Select MOVEMENT CONTROLLER and THEN push that button!" title:"ERROR"	
	)
	
	on CreateHISolverEyes pressed do
	(
		local oldAnimKeysState = SE_AAH_GetAndOffAnimKeys()
		if selection.count > 0 then
		(
			if selection[1].parent != undefined then
			(
				--SE_AAH_IncreaseHIEyesNumber()
				local NewHIE_Number = 0
				SE_AAH_IncreaseIKBoneNumber()
				local newhelper = point size:0.1
				newhelper.size = 0.1
				newhelper.name = "HI_Eyes" + (NewHI_Number as string)
				newhelper.cross = false
				newhelper.box = true
				--newhelper.drawontop = true
				newhelper.wirecolor = (color 255 0 0)
				setUserProp newhelper "HISolverNumber" NewHI_Number
				setUserProp newhelper "HISolverType" 4 -- "Eyes" type
				local eyesPupillaryDistance = 0.0
				local firstEyePosition = [0.0,0.0,0.0]
				local eyesPupillaryDistanceVector = [0.0,0.0,0.0]
				selectionArr = selection as array
				for s in selectionArr do
				(
					if firstEyePosition == [0.0,0.0,0.0] then
					(
						if s.position == [0.0,0.0,0.0] then
						(
							firstEyePosition = [0.00001, 0.00001, 0.00001]
						)
						else firstEyePosition = copy s.position
					)
					else
					(
						eyesPupillaryDistanceVector = s.position - firstEyePosition
						eyesPupillaryDistance = length eyesPupillaryDistanceVector						
					)
					local p = s.parent
					if p != undefined then
					(
						NewHIE_Number = NewHIE_Number + 1
						local snhelper = point size:0.1
						local hIBoneParentnhelper = point size:0.1
						with Animate on
						(
							if s.rotation.controller.keys.count > 0 then
							(
								for i = 1 to s.rotation.controller.keys.count do
								(
									at time s.rotation.controller.keys[i].time
									(
										snhelper.transform = s.transform
									)
								)
							)
							else
							(
								at time sliderTime
								(
									snhelper.transform = s.transform
								)
							)
							if p.rotation.controller.keys.count > 0 then
							(
								for i = 1 to p.rotation.controller.keys.count do
								(
									at time p.rotation.controller.keys[i].time
									(
										hIBoneParentnhelper.transform = p.transform
									)
								)
							)
							else
							(
								at time sliderTime
								(
									hIBoneParentnhelper.transform = p.transform
								)
							)
						)
						setUserProp snhelper "HICHelperNumber" NewHI_Number
						setUserProp hIBoneParentnhelper "HIHelperNumber" NewHI_Number
						setUserProp snhelper "HIEyesNumber" NewHIE_Number
						setUserProp hIBoneParentnhelper "HIEyesNumber" NewHIE_Number

						maxOps.setKeyMode = true
						deleteKeys s.rotation.controller #allKeys
						deleteKeys p.rotation.controller #allKeys
						s.transform= snhelper.transform
						p.transform = hIBoneParentnhelper.transform
						addNewKey s.rotation.controller sliderTime
						addNewKey p.rotation.controller sliderTime
						maxOps.setKeyMode = false
						freeze snhelper
						hide snhelper
						freeze hIBoneParentnhelper
						hide hIBoneParentnhelper
						local ikChain01 = IKSys.ikChain p s "IKHISolver"
						ikChain01.transform.controller.posThresh = 0.001
						ikChain01.transform.controller.rotThresh = 0.001
						ikChain01.transform.controller.iterations = 1000
						ikChain01.transform.controller.goalsize = 0.1
						ikChain01.name = (s.name + " Chain")
						setUserProp p "HIBoneNumber" NewHI_Number
						setUserProp s "HICBoneNumber" NewHI_Number
						
						setUserProp p "HIEyesNumber" NewHIE_Number
						setUserProp s "HIEyesNumber" NewHIE_Number
						
						newhelper.position = s.position
						
						ikChain01.wirecolor = (color 255 0 0)
						ikChain01.parent = newhelper
						
						setUserProp ikChain01 "HISolverNumber" NewHI_Number
						setUserProp ikChain01 "HISolverType" 3 -- "Chain" type
						setUserProp ikChain01 "HIEyesNumber" NewHIE_Number
						
						freeze ikChain01
						ikChain01.showFrozenInGray = false
						--s.rotation.controller = Orientation_Constraint()
						--s.rotation.controller.appendTarget newhelper 50.0
					)
					else messageBox "One of selected bones hasn't parent bone!" title:"ERROR"
				)
				setUserProp newhelper "HIEyesPupDist" eyesPupillaryDistance
				setUserProp newhelper "HIEyesPupDistVectorX" eyesPupillaryDistanceVector.x
				setUserProp newhelper "HIEyesPupDistVectorY" eyesPupillaryDistanceVector.y
				setUserProp newhelper "HIEyesPupDistVectorZ" eyesPupillaryDistanceVector.z
				select newhelper
				maxOps.setKeyMode = true
				--newhelper.transform = snhelper.transform
				addNewKey newhelper.rotation.controller sliderTime
				addNewKey newhelper.position.controller sliderTime
				maxOps.setKeyMode = false
			)
			else messageBox "One of selected bones hasn't parent bone!" title:"ERROR"
		)
		else messageBox "Select ALL eye pupils' bones/helpers and THEN push that button!" title:"ERROR"
		SE_AAH_SetBackAnimKeys oldAnimKeysState
	)
	
	on DeleteHISolver pressed do
	(
		if selection.count > 0 then
		(
			local IKAllNeededObjectsArray = #()
			local IKMovementControllerBase
			for s in selection while IKMCFound == false do
			(
				if getUserProp s "IKMovementController" != undefined and getUserProp s "IKMovementController" != -1 do
				(
					IKMovementControllerBase = s
					clearselection()
					for IKMovementControllerChildren in IKMovementControllerBase.children do selectmore IKMovementControllerChildren
					IKMCFound = true
				)
			)
			for s in selection do
			(
				if getUserProp s "HIBoneNumber" != undefined and getUserProp s "HIBoneNumber" != -1 do append IKAllNeededObjectsArray s
				if getUserProp s "HISolverNumber" != undefined or getUserProp s "HIJointNumber" != undefined or getUserProp s "HICBoneNumber" != undefined do
				(
					local HISelectNumber
					if getUserProp s "HISolverNumber" != undefined then HISelectNumber = getUserProp s "HISolverNumber"
					else if getUserProp s "HIJointNumber" != undefined then HISelectNumber = getUserProp s "HIJointNumber"
					else HISelectNumber = getUserProp s "HICBoneNumber"
					if HISelectNumber != -1 do
					(
						for obj in objects do
						(
							if getUserProp obj "HIBoneNumber" ==  HISelectNumber do append IKAllNeededObjectsArray obj
						)
					)
				)
			)
			if IKAllNeededObjectsArray.count > 0 do RemoveIKControllers IKAllNeededObjectsArray 0 0 0.0 1
			if IKMovementControllerBase != undefined do delete IKMovementControllerBase
		)
		else messageBox "Select at least ONE bone/helper/object and THEN push that button!" title:"ERROR"
	)

	on CreateKeysFAHIB pressed do
	(
		if selection.count > 0 then
		(
			local IKAllNeededObjectsArray = #()
			local IKMovementControllerBase
			for s in selection while IKMCFound == false do
			(
				if getUserProp s "IKMovementController" != undefined and getUserProp s "IKMovementController" != -1 do
				(
					IKMovementControllerBase = s
					clearselection()
					
					
					
					for IKMovementControllerChildren in IKMovementControllerBase.children do
					(
						
						
						
						selectmore IKMovementControllerChildren
					)
					IKMCFound = true
				)
			)
			for s in selection do
			(
				if getUserProp s "HIBoneNumber" != undefined and getUserProp s "HIBoneNumber" != -1 do append IKAllNeededObjectsArray s
				if getUserProp s "HISolverNumber" != undefined or getUserProp s "HIJointNumber" != undefined or getUserProp s "HICBoneNumber" != undefined do
				(
					local HISelectNumber
					if getUserProp s "HISolverNumber" != undefined then HISelectNumber = getUserProp s "HISolverNumber"
					else if getUserProp s "HIJointNumber" != undefined then HISelectNumber = getUserProp s "HIJointNumber"
					else HISelectNumber = getUserProp s "HICBoneNumber"
					if HISelectNumber != -1 do
					(
						for bkIKController in objects do
						(
							if getUserProp bkIKController "HIBoneNumber" ==  HISelectNumber do append IKAllNeededObjectsArray bkIKController
						)
					)
				)
			)
			if IKAllNeededObjectsArray.count > 0 do	RemoveIKControllers IKAllNeededObjectsArray 1 chkbx_DetailedHIAnim.state spn_DetailedHIAnim.value 1
			if IKMovementControllerBase != undefined do delete IKMovementControllerBase
		)
		else messageBox "Select at least ONE bone/helper/object and THEN push that button!" title:"ERROR"
	)
	
	
)

/*********************************************************************************************************************************************************************/
--// FACE ANIM ROLLOUT
/*********************************************************************************************************************************************************************/

rollout SE_AAH_Face_Anim_Rollout "Face Anim" width:132 height:170
(
	group "Face Camera"
	(
		button btn_CreateFaceCamera "Create Face Camera" tooltip:"Creates Face Camera for bone hierarchy"
		button btn_FaceAnimFile "Load Face Animation file" width:150 tooltip:"Loads Face animation from .amf file." highlightcolor:orange
		--label lbl_LFaceAF1 "File:" align:#left tooltip:"Advanced Animation File name"
		--label lbl_LFaceAF2 "Name:" align:#left tooltip:"Internal animation name"
		--label lbl_LFaceAF3 "Total Sub-animations:" align:#left tooltip:"Total count of sub-animations"
		listBox lst_SubAnimList selection:1  height:10
	)
	
	on btn_CreateFaceCamera pressed do
	(
		if selection[1] != undefined and (selection[1].children.count > 0 OR selection[1].parent != undefined) then
		(
			local cfcBonesArr = SE_AAH_GetAllHierarchy selection[1] 0
			local cfcCH = SE_AAH_GetCharacterHierarchy selection[1]
			local HeadBone
			for b in cfcBonesArr do
			(
				if SE_AAH_GetSubID 0 b == cfcCH.headid do HeadBone = b
			)
			if HeadBone != undefined then
			(
				Cam = freecamera()
				Cam.type = #target
				Cam.position = [HeadBone.position.x+0.5, HeadBone.position.y, HeadBone.position.z]
				Cam.target.position = HeadBone.position
				Cam.fovType = 2 --(1 - Horizontal, 2 - Vertical, 3 - Diagonal)
				Cam.nearclip = 0.01
				Cam.farclip = 1000.0
				select HeadBone
				Cam.parent = HeadBone
				Cam.target.parent = HeadBone
				Cam.name = ("Face Camera")
				freeze Cam
				hide Cam
				messagebox "Face Camera successfully created!" title:"Done!"
			)
			else
			(
				messageBox "This hierarchy does not adapted for this script!" title:"ERROR"
			)
		)
		else
		(
			messageBox "Something has gone wrong!\n(Select any bone of hierarchy and THEN push that button!)\n" title:"ERROR"
		)
	)
	
)

/*********************************************************************************************************************************************************************/
--// ANIMATION ADAPTATION ROLLOUT
/*********************************************************************************************************************************************************************/

/*
	group "Animation control"
	(
		checkbox chkbx_ACTrnsfrmKsPos "Pos" align:#left checked:true across:3 tooltip:"Transform type:\nControl the object's position keys."
		checkbox chkbx_ACTrnsfrmKsRot "Rot" align:#center checked:false across:3 tooltip:"Transform type:\nControl the object's rotation keys."
		checkbox chkbx_ACTrnsfrmKsScale "Scale" align:#right checked:false across:3 tooltip:"Transform type:\nControl the object's scale keys."
		spinner spn_ACTrnsfrmRangeStartVal "S:" range:[0.0, 999999.0, 0.0] type:#float align:#left across:2 fieldwidth:45 tooltip:"Animation Keys Range Start"
		spinner spn_ACTrnsfrmRangeEndVal "E:" range:[0.0, 999999.0, 100.0] type:#float align:#right across:2 fieldwidth:45 tooltip:"Animation Keys Range End"
		radiobuttons rb_AnimKeysRange "Anim keyframes range:" labels:#("All", "Set","TimeL") columns:3 tooltip:"You can select the specified keyframes range you want to work with:\n\nAll: Will work with all the keys of the selected object(s).\n\nSet: Will work for the selected keys range you specified above (from Range Start to Range End).\n\nTimeL: Will work for the selected keys range you have selected on the animation timeline (or the range between the selected first and the last key on the timeline)."
		
		checkbutton ib_CASbutton "Change animation speed:" height:15 width:135 highlightColor:[85,75,65] checked:true enabled:false align:#center offset:[0,-3]
		button CASIncrease "Increase..." width:68 height:16 align:#left across:2 tooltip:"Increases selected animation's speed as many times as specified in right field.\nIf you want slow down the animation by 2 times, then choose \"0,5\" in that field.\nSelect all needed bones/helpers/objects, then select keys range and push this button."
		spinner spn_CASIncBy "...by:" range:[0.001, 1000.0, 2.0] type:#float align:#right fieldwidth:45
		checkbox chkbx_CASAccuracy "Accuracy" align:#left checked:true across:2 tooltip:"Round-up the number of frames of the new animation range to the value that was chosen in the right field.\nIf you increased your animation's speed that has 25,0 frames by 2,0 times then the new range will be 12,5.\nBut if THIS checkbox was checked and value \"1,0\" was chosen - the new range will be 13,0."
		spinner spn_CASAccuracyVal "upto:" range:[0.001, 1000.0, 1.0] type:#float align:#right across:2 fieldwidth:45
		
		checkbutton ib_BakeAKbutton "Additional control:" height:15 width:100 highlightColor:[85,75,65] checked:true enabled:false align:#center offset:[0,-3]
		button BakeObjectsTransformKeys "Bake Keys" width:68 height:16 align:#left across:2 tooltip:"Bakes selected object's transform animation keys.\nSelect all needed bones, choose transform type mode, keys range and frame interval in the right field and push this button."
		spinner spn_BkTrnsfrmAccuracyVal "Int:" range:[0.001, 1000.0, 1.0] type:#float align:#right across:2 fieldwidth:45 tooltip:"Animation Keys Baking Frame Interval"
		button SmoothObjectsAnimation "Smooth" width:55 height:16 align:#left across:2 tooltip:"Smoothes selected object's transform animation, makes it a bit less snappy.\nSelect all needed bones, choose transform type mode and keys range and push this button.\nRepeat these steps if you are not yet satisfied the result."
		spinner spn_SmoothTimesVal "Times:" range:[1, 100000, 1] type:#integer align:#right across:2 fieldwidth:45 tooltip:"How many times you want to smooth your animation."
		button DeleteObjectsTransformKeys "Delete object's transform keys" height:16 tooltip:"Deletes selected object's transform animation keys.\nSelect all needed bones, choose transform type mode and keys range and push this button."
	)
*/

rollout SE_AAH_Anim_Adapt_Rollout "Anim Adaptation" width:132 height:170
(
	group "Animation Transform"
	(
		button AACreateSetController "Create set controller" width:110 height:16 align:#left across:2 tooltip:"Creates special Animation Transform controller"
		button AADeleteSetController "Undo" width:37 height:16 align:#right enabled:false tooltip:"Undo"
		--checkbutton ib_AAAnimOffsets "Animation offsets:" height:15 width:110 highlightColor:[85,75,65] checked:true enabled:false align:#center offset:[0,-3]
		checkbutton ib_AAAnimOffsetsPos "Offset Pos:" height:15 width:70 highlightColor:[85,75,65] checked:true enabled:false align:#left across:2 offset:[0,-3]
		checkbutton ib_AAAnimOffsetsRot "Offset Rot:" height:15 width:70 highlightColor:[85,75,65] checked:true enabled:false align:#right across:2 offset:[0,-3]
		spinner spn_AAPosX "X:" range:[-999999.0, 999999.0, 0.0] type:#float align:#left across:2 fieldwidth:45 tooltip:"Animation Position offset X"
		spinner spn_AARotX "X:" range:[-999999.0, 999999.0, 0.0] type:#float align:#right across:2 fieldwidth:45 tooltip:"Animation Rotation offset X"
		spinner spn_AAPosY "Y:" range:[-999999.0, 999999.0, 0.0] type:#float align:#left across:2 fieldwidth:45 tooltip:"Animation Position offset Y"
		spinner spn_AARotY "Y:" range:[-999999.0, 999999.0, 0.0] type:#float align:#right across:2 fieldwidth:45 tooltip:"Animation Rotation offset Y"
		spinner spn_AAPosZ "Z:" range:[-999999.0, 999999.0, -0.945] type:#float align:#left across:2 fieldwidth:45 tooltip:"Animation Position offset Z"
		spinner spn_AARotZ "Z:" range:[-999999.0, 999999.0, 180.0] type:#float align:#right across:2 fieldwidth:45 tooltip:"Animation Rotation offset Z"
		button AAMixamoConversion "Mixamo magic converter" width:130 height:16 tooltip:"Automatically converts mixamo animation from Y-up to Z-up"
	)
	group "Animation Conversion"
	(
		button AASoVConversion "SoV magic converter" width:130 height:16 tooltip:"Does some Blender animation conversion things"
	)
	
	/*---------------------------------------------------------------------------------------------------*/
	/*---------------------------------------------------------------------------------------------------*/
	/*---------------------------------------------------------------------------------------------------*/
	
	--SE_AAH_Process_Rollout.lbl_PrcssAAH.text = "Attch baked in " + wholeAttachBakingTime + "s"
	--SE_AAH_Process_Rollout.prgb_AAH.value = 0
	
	-- status_AAUndoOffset
	
	/*
	AAControllerNumber -- base controller
	V
	AAControllerNumber2 -- copy of target
	V
	AOControllerNumber --attach controller
	V
	AObjectNumber -- original (target) root
	*/
	
	
	fn AnimationAdaptationUpdate =   
	(
		if selection.count > 0 then
		(
			if selection.count == 1 then
			(
				if status_AAUndoOffset == 0 or status_PreviousNode != $ do
				if (getUserProp $ "AAControllerNumber" != undefined and getUserProp $ "AAControllerNumber" != -1) or (getUserProp $ "AAControllerNumber2" != undefined and getUserProp $ "AAControllerNumber2" != -1) or (getUserProp $ "AOControllerNumber" != undefined and getUserProp $ "AOControllerNumber" != -1) or (getUserProp $ "AObjectNumber" != undefined and getUserProp $ "AObjectNumber" != -1) do
				(
					--if getUserProp $ "AAControllerNumber" != -1 do
					
					AADeleteSetController.enabled = true
				)
			)
			else
			(
				AADeleteSetController.enabled = false
			)
		)
		else
		(
			AADeleteSetController.enabled = false
		)
	)
	
	/*---------------------------------------------------------------------------------------------------*/
	/*---------------------------------------------------------------------------------------------------*/
	/*---------------------------------------------------------------------------------------------------*/

	on SE_AAH_Anim_Adapt_Rollout  open do
	(
		callbacks.addScript #selectionSetChanged "SE_AAH_Anim_Adapt_Rollout.AnimationAdaptationUpdate()" id:#se_aah_aahaaupdate
		AnimationAdaptationUpdate()
	)

	on SE_AAH_Anim_Adapt_Rollout  close do
	(
		callbacks.removeScripts id:#se_aah_aahaaupdate
	)
	
	/*---------------------------------------------------------------------------------------------------*/
	/*---------------------------------------------------------------------------------------------------*/
	/*---------------------------------------------------------------------------------------------------*/
	
	on AACreateSetController pressed do
	(
		if selection.count > 0 then
		(
			SE_AAH_UpdateOrCreateAAHHelperLayer()
			SE_AAH_UpdateOrCreateAAHControllerLayer()
			local oldAnimKeysState = SE_AAH_GetAndOffAnimKeys() 
			local cAACBonesArr = SE_AAH_GetAllHierarchy selection[1] 0
			--local cAACSCH = SE_AAH_GetCharacterHierarchy selection[1]
			--local bool_isItHasAnyLegs
			local newAAControllerSize = 0.5
			--local aMCIKLegs = #()
			for cAACbone in cAACBonesArr do
			(
				local cAACBoneId = SE_AAH_GetSubID 0 cAACbone
				if cAACBoneId != -1 do
				(
					if cAACBoneId == 43 or cAACBoneId == 53 do
					(
						newAAControllerSize = ((length (cAACBonesArr[1].position - cAACbone.position)) * 0.8)
						--local newIKLegController = CreateHISolver cAACbone 2 0
						--if newIKLegController != undefined do
						--(
						--	append aMCIKLegs newIKLegController
						--	bool_isItHasAnyLegs = true
						--)
					)
				)		
			)
			--if bool_isItHasAnyLegs == true then
			
			local newAACAnimationStart = 0.0f
			local newAACAnimationEnd = 100.0f
			

			if cAACBonesArr[1].position.controller.keys.count > 0 do
			(
				newAACAnimationStart = cAACBonesArr[1].position.controller.keys[1].time
				if cAACBonesArr[1].position.controller.keys.count > 1 do newAACAnimationEnd = cAACBonesArr[1].position.controller.keys[cAACBonesArr[1].position.controller.keys.count].time
			)
			if cAACBonesArr[1].target == undefined then
			(
				if cAACBonesArr[1].rotation.controller.keys.count > 0 do
				(
					if newAACAnimationStart != undefined then
					(
						if newAACAnimationStart > cAACBonesArr[1].rotation.controller.keys[1].time do newAACAnimationStart = cAACBonesArr[1].rotation.controller.keys[1].time
					)
					else newAACAnimationStart = cAACBonesArr[1].rotation.controller.keys[1].time
					if cAACBonesArr[1].rotation.controller.keys.count > 1 do
					(
						if newAACAnimationEnd != undefined then
						(
							if newAACAnimationEnd < cAACBonesArr[1].rotation.controller.keys[cAACBonesArr[1].rotation.controller.keys.count].time do newAACAnimationEnd = cAACBonesArr[1].rotation.controller.keys[cAACBonesArr[1].rotation.controller.keys.count].time
						)
						else newAACAnimationEnd = cAACBonesArr[1].rotation.controller.keys[cAACBonesArr[1].rotation.controller.keys.count].time
					)
				)
			)
			else
			(
				if cAACBonesArr[1].controller.roll_angle.controller.keys.count > 0 do
				(
					if newAACAnimationStart != undefined then
					(
						if newAACAnimationStart > cAACBonesArr[1].controller.roll_angle.controller.keys[1].time do newAACAnimationStart = cAACBonesArr[1].controller.roll_angle.controller.keys[1].time
					)
					else newAACAnimationStart = cAACBonesArr[1].controller.roll_angle.controller.keys[1].time
					if cAACBonesArr[1].controller.roll_angle.controller.keys.count > 1 do
					(
						if newAACAnimationEnd != undefined then
						(
							if newAACAnimationEnd < cAACBonesArr[1].controller.roll_angle.controller.keys[cAACBonesArr[1].controller.roll_angle.controller.keys.count].time do newAACAnimationEnd = cAACBonesArr[1].controller.roll_angle.controller.keys[cAACBonesArr[1].controller.roll_angle.controller.keys.count].time
						)
						else newAACAnimationEnd = cAACBonesArr[1].controller.roll_angle.controller.keys[cAACBonesArr[1].controller.roll_angle.controller.keys.count].time
					)
				)
			)
			
			
			
			
			
			
			
			
			--if cAACBonesArr[1].position.controller.keys.count
			
			
			--pickedObject.rotation.controller.keys[i].time == 0.0f
			
			local newAAController = point size:newAAControllerSize
			newAAController.name = "AA_" + cAACBonesArr[1].name + " set controller"
			newAAController.cross = true
			newAAController.box = true
			newAAController.drawontop = true
			newAAController.wirecolor = (color 47 159 151)
			/*
			newAAController.position.x = cAACBonesArr[1].position.x
			newAAController.position.y = cAACBonesArr[1].position.y
			newAAController.position.z = cAACBonesArr[1].position.z
			if cAACBonesArr[1].target == undefined then
			(
				newAAController.rotation.x_rotation = cAACBonesArr[1].rotation.x_rotation
				newAAController.rotation.y_rotation = cAACBonesArr[1].rotation.y_rotation
				newAAController.rotation.z_rotation = cAACBonesArr[1].rotation.z_rotation
			)			
			else
			(
				--add shit later
				
			)
			*/
			addNewKey newAAController.position.controller sliderTime
			addNewKey newAAController.rotation.controller sliderTime
			addNewKey newAAController.scale.controller sliderTime
			setUserProp newAAController "AASetController" 1
			AAHControllerLayer.addnode newAAController
			local newAASCRootAttachCloneController = copy cAACBonesArr[1]
			newAASCRootAttachCloneController.parent = newAAController
			newAASCRootAttachCloneController.showFrozenInGray = false
			freeze newAASCRootAttachCloneController
			hide newAASCRootAttachCloneController
			local newAASCRootAttachController = SE_AAH_Main_Anim_Rollout.CreateAOLink newAASCRootAttachCloneController cAACBonesArr[1] 0				

			addNewKey newAASCRootAttachController.position.controller newAACAnimationEnd
			addNewKey newAASCRootAttachController.rotation.controller newAACAnimationEnd
			addNewKey newAASCRootAttachController.scale.controller newAACAnimationEnd


			clearselection()
			select newAAController
			
				
			--else	messageBox "Character is not tuned properly!\n(can't find any legs' BoneID's)" title:"ERROR"
			SE_AAH_SetBackAnimKeys oldAnimKeysState
		)
		else messageBox "Select at least ONE bone/helper and THEN push that button!" title:"ERROR"	
	)
	
	
	
	
	
	
	
	on AAMixamoConversion pressed do
	(
		if selection.count > 0 then
		(
			SE_AAH_UpdateOrCreateAAHHelperLayer()
			SE_AAH_UpdateOrCreateAAHControllerLayer()
			local oldAnimKeysState = SE_AAH_GetAndOffAnimKeys() 
			local cAACBonesArr = SE_AAH_GetAllHierarchy selection[1] 0
			local newAAControllerSize = 0.5
			for cAACbone in cAACBonesArr do
			(
				local cAACBoneId = SE_AAH_GetSubID 0 cAACbone
				if cAACBoneId != -1 do
				(
					if cAACBoneId == 43 or cAACBoneId == 53 do
					(
						newAAControllerSize = ((length (cAACBonesArr[1].position - cAACbone.position)) * 0.8)
					)
				)		
			)
			local newAACAnimationStart = 0.0f
			local newAACAnimationEnd = 100.0f
			if cAACBonesArr[1].position.controller.keys.count > 0 do
			(
				newAACAnimationStart = cAACBonesArr[1].position.controller.keys[1].time
				if cAACBonesArr[1].position.controller.keys.count > 1 do newAACAnimationEnd = cAACBonesArr[1].position.controller.keys[cAACBonesArr[1].position.controller.keys.count].time
			)
			if cAACBonesArr[1].target == undefined then
			(
				if cAACBonesArr[1].rotation.controller.keys.count > 0 do
				(
					if newAACAnimationStart != undefined then
					(
						if newAACAnimationStart > cAACBonesArr[1].rotation.controller.keys[1].time do newAACAnimationStart = cAACBonesArr[1].rotation.controller.keys[1].time
					)
					else newAACAnimationStart = cAACBonesArr[1].rotation.controller.keys[1].time
					if cAACBonesArr[1].rotation.controller.keys.count > 1 do
					(
						if newAACAnimationEnd != undefined then
						(
							if newAACAnimationEnd < cAACBonesArr[1].rotation.controller.keys[cAACBonesArr[1].rotation.controller.keys.count].time do newAACAnimationEnd = cAACBonesArr[1].rotation.controller.keys[cAACBonesArr[1].rotation.controller.keys.count].time
						)
						else newAACAnimationEnd = cAACBonesArr[1].rotation.controller.keys[cAACBonesArr[1].rotation.controller.keys.count].time
					)
				)
			)
			else
			(
				if cAACBonesArr[1].controller.roll_angle.controller.keys.count > 0 do
				(
					if newAACAnimationStart != undefined then
					(
						if newAACAnimationStart > cAACBonesArr[1].controller.roll_angle.controller.keys[1].time do newAACAnimationStart = cAACBonesArr[1].controller.roll_angle.controller.keys[1].time
					)
					else newAACAnimationStart = cAACBonesArr[1].controller.roll_angle.controller.keys[1].time
					if cAACBonesArr[1].controller.roll_angle.controller.keys.count > 1 do
					(
						if newAACAnimationEnd != undefined then
						(
							if newAACAnimationEnd < cAACBonesArr[1].controller.roll_angle.controller.keys[cAACBonesArr[1].controller.roll_angle.controller.keys.count].time do newAACAnimationEnd = cAACBonesArr[1].controller.roll_angle.controller.keys[cAACBonesArr[1].controller.roll_angle.controller.keys.count].time
						)
						else newAACAnimationEnd = cAACBonesArr[1].controller.roll_angle.controller.keys[cAACBonesArr[1].controller.roll_angle.controller.keys.count].time
					)
				)
			)
			local newAAController = point size:newAAControllerSize
			newAAController.name = "AA_" + cAACBonesArr[1].name + " set controller"
			newAAController.cross = true
			newAAController.box = true
			newAAController.drawontop = true
			newAAController.wirecolor = (color 47 159 151)
			addNewKey newAAController.position.controller 0.0f
			addNewKey newAAController.rotation.controller 0.0f
			addNewKey newAAController.scale.controller 0.0f
			setUserProp newAAController "AASetController" 1
			AAHControllerLayer.addnode newAAController
			local newAASCRootAttachCloneController = copy cAACBonesArr[1]
			newAASCRootAttachCloneController.parent = newAAController
			newAASCRootAttachCloneController.showFrozenInGray = false
			freeze newAASCRootAttachCloneController
			hide newAASCRootAttachCloneController
			local newAASCRootAttachController = SE_AAH_Main_Anim_Rollout.CreateAOLink newAASCRootAttachCloneController cAACBonesArr[1] 0				
			addNewKey newAASCRootAttachController.position.controller newAACAnimationEnd
			addNewKey newAASCRootAttachController.rotation.controller newAACAnimationEnd
			addNewKey newAASCRootAttachController.scale.controller newAACAnimationEnd
			clearselection()
			--select newAAController
			
			at time 0.0f
			(
				newAAController.position.x = spn_AAPosX.value
				newAAController.position.y = spn_AAPosY.value
				newAAController.position.z = spn_AAPosZ.value
				newAAController.rotation.x_rotation = spn_AARotX.value
				newAAController.rotation.y_rotation = spn_AARotY.value
				newAAController.rotation.z_rotation = spn_AARotZ.value
			)	
			
			SE_AAH_Main_Anim_Rollout.RemoveAOLink newAASCRootAttachController.children[1] 1 true 1.0 0
			
			delete newAASCRootAttachCloneController
			delete newAAController
			
			animationRange = interval newAACAnimationStart newAACAnimationEnd
			--else	messageBox "Character is not tuned properly!\n(can't find any legs' BoneID's)" title:"ERROR"
			
			SE_AAH_Main_Anim_Rollout.BakeTransformKeysForArray cAACBonesArr true true true newAACAnimationStart newAACAnimationEnd 1.0 0
			
			local cAACAllExceptRoot = SE_AAH_GetAllHierarchy cAACBonesArr[1] 1
			for cAACAllExceptRootEach in cAACAllExceptRoot do
			(
				deleteKeys cAACAllExceptRootEach.position.controller
				deleteKeys cAACAllExceptRootEach.scale.controller
			)
			deleteKeys cAACBonesArr[1].scale.controller

			select cAACBonesArr[1]
			SE_AAH_SetBackAnimKeys oldAnimKeysState
		)
		else messageBox "Select at least ONE bone/helper and THEN push that button!" title:"ERROR"	
	)
	
	
	on AASoVConversion pressed do
	(
		if selection.count > 0 then
		(
			local cAASoVCBonesArr = SE_AAH_GetAllHierarchy selection[1] 0
			if cAASoVCBonesArr.count > 3 then
			(
				SE_AAH_UpdateOrCreateAAHHelperLayer()
				SE_AAH_UpdateOrCreateAAHControllerLayer()
				local oldAnimKeysState = SE_AAH_GetAndOffAnimKeys()
			
				animButtonState = false
				maxOps.setKeyMode = false
				
				in coordsys world cAASoVCBonesArr[1].scale = [1,1,1]
				
				SE_AAH_UpdateAnimRangeStartAndEnd cAASoVCBonesArr 1 true true true false false 0.0 100.0 false --get max anim range for the all hierarchy
				if ACAnimRangeEndKeyframe > ACAnimRangeStartKeyframe then
				(
					animationRange = interval ACAnimRangeStartKeyframe ACAnimRangeEndKeyframe
					for everyNode in cAASoVCBonesArr do
					(
						addNewKey everyNode.position.controller ACAnimRangeStartKeyframe
						addNewKey everyNode.rotation.controller ACAnimRangeStartKeyframe
						addNewKey everyNode.scale.controller ACAnimRangeStartKeyframe
						addNewKey everyNode.position.controller ACAnimRangeEndKeyframe
						addNewKey everyNode.rotation.controller ACAnimRangeEndKeyframe
						addNewKey everyNode.scale.controller ACAnimRangeEndKeyframe
					)
				)
				else animationRange = interval 0.0 100.0
				
				cAASoVCBonesArr[3].parent = undefined
				delete cAASoVCBonesArr[2]
				
				clearselection
				--select cAACBonesArr
			
				SE_AAH_SetBackAnimKeys oldAnimKeysState
			)
			else messageBox "You picked the wrong house, fool!\n(Select any bone/helper/mesh of HIERARCHY and then push that button!)\n" title:"ERROR"
		)
		else messageBox "Select at least ONE bone/helper/mesh and THEN push that button!" title:"ERROR"	
	)
)

/*********************************************************************************************************************************************************************/
--// HIERARHIES ROLLOUT
/*********************************************************************************************************************************************************************/

rollout SE_AAH_Hierarchies_Rollout "Bones Conversion" width:132 height:170
(
	group "Biped settings"
	(
		button CreateBiped "Create Biped for selected" width:160 height:22 align:#center tooltip:"Creates Biped for picked bones' hierarchy.\n\nWARNING!!! Not finished yet."
	)

	/*---------------------------------------------------------------------------------------------------*/
	/*---------------------------------------------------------------------------------------------------*/
	/*---------------------------------------------------------------------------------------------------*/

	on CreateBiped pressed do
	(
		local warning_str_msg = "Private function, invitation only!\nI'm joking...\n\n" +
		"WARNING! This shit is not finished yet!!!\n\n" +
		"WARNING! You're going to create Biped for your bones' hierarchy.\n\n" +
		"Have you selected any bone of hierarchy?"
		if (queryBox warning_str_msg title:"ATTENTION") do
		(
			if selection[1] != undefined and (selection[1].children.count > 0 OR selection[1].parent != undefined) then
			(
				
				local oldAnimKeysState = SE_AAH_GetAndOffAnimKeys()
				SE_AAH_IncreaseBipedNumber()
				local OrigBonesArr = SE_AAH_GetAllHierarchy selection[1] 0
				
				/*local newBipedSpineLinks = 2
				local newBipedLegLinks = 3
				local newBipedTailLinks = 0
				local newBipedFingersNumber = 1
				local newBipedFingerLinks = 1
				local newBipedToesNumber = 1
				local newBipedToeLinks = 1*/
				local origCH = SE_AAH_GetCharacterHierarchy selection[1]
				
				local info_str_msg = "spineLinks: " + (origCH.spinelinks as string) + " !\n" +
				"legLinks: " + (origCH.leglinks as string) + " !\n" +
				"tailLinks: " + (origCH.taillinks as string) + " !\n" +
				"fingers: " + (origCH.fingersnumber as string) + " !\n" +
				"fingerLinks: " + (origCH.fingerlinks as string) + " !\n" +
				"toes: " + (origCH.toesnumber as string) + " !\n" +
				"toeLinks: " + (origCH.toelinks as string) + " !\n" +
				"headId: " + (origCH.headid as string) + " !"
				messagebox info_str_msg title:"TEST!"
				
				--struct CharacterHierarchy (spinelinks, leglinks, taillinks, fingersnumber, fingerlinks, toesnumber, toelinks, headid)
				
				
				
				clearselection()
				
				local newBiped = biped.createNew 1.8 0.0 [0.0,0.0,1.8] neckLinks:1 spineLinks:origCH.spinelinks legLinks:origCH.leglinks tailLinks:origCH.taillinks fingers:origCH.fingersnumber fingerLinks:origCH.fingerlinks toes:origCH.toesnumber toeLinks:origCH.toelinks forearmTwistLinks: 1 trianglePelvis:false triangleNeck:true
				newBiped.transform.controller.figureMode = true
				--newBiped.controller.knuckles = true
				local newBipedRootName = newBiped.name
				local newBipedRootNameLength = newBipedRootName.count
				local newBipedName = "Bpd" + substring (NewBiped_Number as string) 2 -1
				local newBipedBonesArr = SE_AAH_GetAllHierarchy newBiped 0
				newBiped.name = newBipedName
				local newBipedBoneNumber = 0
				local BipedBonesMatches = 0
				local BipedRootBone
				local BipedPelvisBone
				local BipedSpineBone
				local BipedSpine1Bone
				local BipedLeftThighBone
				local BipedRightThighBone
				local OrigRootBone
				local OrigPelvisBone
				local OrigSpineBone
				local OrigSpine1Bone
				local OrigLeftThighBone
				local OrigRightThighBone
				
				local BipedBonesHelper0 = point size:0.1
				BipedBonesHelper0.box = true
				BipedBonesHelper0.wirecolor = (color 255 0 0)
				local BipedBonesHelper1 = point size:0.1
				BipedBonesHelper1.box = true
				BipedBonesHelper1.wirecolor = (color 0 255 0)
				local BipedBonesHelper2 = point size:0.1
				BipedBonesHelper2.box = true
				BipedBonesHelper2.wirecolor = (color 0 0 255)
				local BipedBonesHelper3 = point size:0.1
				BipedBonesHelper3.box = true
				BipedBonesHelper3.wirecolor = (color 255 255 0)
				BipedBonesHelper3.parent = BipedBonesHelper2
				BipedBonesHelper2.parent = BipedBonesHelper1
				BipedBonesHelper1.parent = BipedBonesHelper0
				
				for b in newBipedBonesArr do
				(
					setUserProp b "BipedNumber" NewBiped_Number
					newBipedBoneNumber = newBipedBoneNumber + 1
					setUserProp b "BipedBoneNumber" newBipedBoneNumber
					if b != newBipedBonesArr[1] then
					(
						local newBipedBoneName = substring b.name (newBipedRootNameLength + 2) -1
						--messagebox newBipedBoneName title:"TEST!"
						b.name = newBipedName + " " + newBipedBoneName
						if newBipedBoneName == "Pelvis" do BipedPelvisBone = b
						if newBipedBoneName == "Spine" do BipedSpineBone = b
						if newBipedBoneName == "Spine1" do BipedSpine1Bone = b
						if newBipedBoneName == "L Thigh" do BipedLeftThighBone = b
						if newBipedBoneName == "R Thigh" do BipedRightThighBone = b
						for ob in OrigBonesArr do
						(
							if ob.name == newBipedBoneName or ob.name == ("Bip01 " + newBipedBoneName) or ob.name == (" " + newBipedBoneName) or ob.name == (" " + substituteString newBipedBoneName "Forearm" "ForeArm") do
							(
								setUserProp ob "BipedNumberB" NewBiped_Number
								setUserProp ob "BipedBoneNumberB" newBipedBoneNumber
								setUserProp b "BipedBoneName" newBipedBoneName
								setUserProp ob "BipedBoneNameB" newBipedBoneName
								BipedBonesMatches = BipedBonesMatches + 1
								--Scale Biped bones
								if ob.children.count > 0 and ob.name != "Head" and ob.name != " Head" do
								(
									if ob.name != "L Foot" and ob.name != "R Foot" and ob.name != " L Foot" and ob.name != " R Foot" then
									(
										local OrigBoneLength = length (ob.children[1].pos - ob.pos)
										setUserProp ob "BipedBoneL" OrigBoneLength
										biped.setTransform b #scale [OrigBoneLength,OrigBoneLength,OrigBoneLength] false
										
										ob.rotation.controller = Orientation_Constraint()
										ob.rotation.controller.appendTarget b 50.0
										--ob.position.controller = Position_Constraint()
										--ob.position.controller.appendTarget b 50.0
									)
									else
									(
										BipedBonesHelper0.transform = ob.parent.parent.transform
										BipedBonesHelper1.transform = ob.parent.transform
										BipedBonesHelper2.transform = ob.transform
										BipedBonesHelper3.transform = ob.children[1].transform
										BipedBonesHelper0.rotation.x_rotation = 0.0
										BipedBonesHelper0.rotation.y_rotation = 0.0
										BipedBonesHelper0.rotation.z_rotation = 0.0
										BipedBonesHelper1.rotation.x_rotation = 0.0
										BipedBonesHelper1.rotation.y_rotation = 0.0
										BipedBonesHelper1.rotation.z_rotation = 0.0
										BipedBonesHelper2.rotation.x_rotation = 0.0
										BipedBonesHelper2.rotation.y_rotation = 0.0
										BipedBonesHelper2.rotation.z_rotation = 0.0
										BipedBonesHelper3.rotation.x_rotation = 0.0
										BipedBonesHelper3.rotation.y_rotation = 0.0
										BipedBonesHelper3.rotation.z_rotation = 0.0
										
										local FootHeightDirectionVector = BipedBonesHelper0.pos - BipedBonesHelper2.pos
										
										local FootXLength = BipedBonesHelper2.pos.x - BipedBonesHelper3.pos.x
										local FootYLength = BipedBonesHelper2.pos.y - BipedBonesHelper3.pos.y
										local FootZLength = BipedBonesHelper2.pos.z - BipedBonesHelper3.pos.z
										
										local FootHeightDirectionVectorNormal = sqrt(FootHeightDirectionVector.x * FootHeightDirectionVector.x + FootHeightDirectionVector.y * FootHeightDirectionVector.y + FootHeightDirectionVector.z * FootHeightDirectionVector.z)
										
										local FootXVectorCosine = FootHeightDirectionVector.x * FootXLength / (FootHeightDirectionVectorNormal * sqrt(FootXLength * FootXLength))
										local FootYVectorCosine = FootHeightDirectionVector.y * FootYLength / (FootHeightDirectionVectorNormal * sqrt(FootYLength * FootYLength))
										local FootZVectorCosine = FootHeightDirectionVector.z * FootZLength / (FootHeightDirectionVectorNormal * sqrt(FootZLength * FootZLength))
										
										local BiggerCosine = -1.0
										local FootHeight = 0.0
										if FootXVectorCosine > BiggerCosine do
										(
											BiggerCosine = FootXVectorCosine
											FootHeight = FootXLength
										)
										if FootYVectorCosine > BiggerCosine do
										(
											BiggerCosine = FootYVectorCosine
											FootHeight = FootYLength
										)
										if FootZVectorCosine > BiggerCosine do
										(
											BiggerCosine = FootZVectorCosine
											FootHeight = FootZLength
										)
										FootHeight = sqrt(FootHeight*FootHeight)
										
										local FootHypotenuse = length (ob.children[1].pos - ob.pos)--(BipedBonesHelper2.pos - BipedBonesHelper3.pos)
										local FootLength = sqrt(FootHypotenuse*FootHypotenuse - FootHeight*FootHeight)
										
										biped.setTransform b #scale [FootHeight,FootLength*1.25,FootLength*0.5] false
										biped.setTransform b.children[1] #scale [FootLength*0.25,FootHeight*0.1,FootLength*0.5] false
										
										--BipedBonesHelper0.transform.rotation = quat 0.0 0.0 0.0 1.0
										--BipedBonesHelper0.pos = ob.parent.parent.pos
										--BipedBonesHelper1.transform.rotation = quat 0.0 0.0 0.0 1.0
										--BipedBonesHelper2.transform.rotation = quat 0.0 0.0 0.0 1.0
										--BipedBonesHelper3.transform.rotation = quat 0.0 0.0 0.0 1.0
										
										
										
										
										/*
										ob.transform.rotation = quat 0.0 0.0 0.0 1.0
										BipedBonesHelper0.parent = ob.parent
										BipedBonesHelper0.transform = ob.transform
										BipedBonesHelper1.transform = ob.children[1].transform
										BipedBonesHelper1.parent = BipedBonesHelper0
										BipedBonesHelper0.rotation = quat 0.0 0.0 0.0 1.0
										BipedBonesHelper0.pos = ob.pos
										--BipedBonesHelper1.parent = undefined
										*/
										
										
										/*BipedBonesHelper0.pos = ob.pos
										BipedBonesHelper0.transform.rotation = ob.transform.rotation
										BipedBonesHelper1.pos = ob.children[1].pos
										BipedBonesHelper1.transform.rotation = ob.children[1].transform.rotation
										
										BipedBonesHelper1.parent = BipedBonesHelper0
										BipedBonesHelper0.rotation = quat 0.0 0.0 0.0 1.0
										BipedBonesHelper0.pos = ob.pos
										
										BipedBonesHelper1.parent = undefined
										*/
										
										
										
										/*
										BipedBonesHelper0.pos = ob.parent.parent.pos
										--BipedBonesHelper0.transform.rotation = ob.parent.transform.rotation
										BipedBonesHelper1.pos = ob.children[1].pos
										--BipedBonesHelper1.transform.rotation = ob.children[1].transform.rotation
										
										--BipedBonesHelper0.parent = ob.parent
										BipedBonesHelper1.parent = BipedBonesHelper0
										
										--BipedBonesHelper0.pos = biped.getTransform b #pos
										--BipedBonesHelper0.transform.rotation = biped.getTransform b #rotation
										
										local ikChain01 = IKSys.ikChain BipedBonesHelper0 BipedBonesHelper1 "IKHISolver"
										ikChain01.transform.controller.posThresh = 0.001
										ikChain01.transform.controller.rotThresh = 0.001
										ikChain01.transform.controller.iterations = 1000
										ikChain01.transform.controller.goalsize = 0.1
										--ikChain01.name = (s.name + " Chain")
										
										ikChain01.pos = ob.pos
										delete ikChain01
										
										local OrigFootHeight = length (BipedBonesHelper1.pos - ob.pos)
										local OrigFootLength = length (BipedBonesHelper1.pos - ob.children[1].pos)
										
										--local OrigFootVector = ob.pos - ob.children[1].pos
										
										
										biped.setTransform b #scale [OrigFootHeight,OrigFootLength,OrigFootLength*0.5] false
										
										--biped.setTransform b #scale [abs (BipedBonesHelper0.pos.z - BipedBonesHelper1.pos.z), abs OrigFootVector.y / 0.8, abs (OrigFootVector.y + OrigFootVector.z) * 0.5] false
										*/
										
										
									)
								)
								if newBipedBoneName == "Pelvis" do OrigPelvisBone = ob
								if newBipedBoneName == "Spine" do OrigSpineBone = ob
								if newBipedBoneName == "Spine1" do OrigSpine1Bone = ob
								if newBipedBoneName == "L Thigh" do OrigLeftThighBone = ob
								if newBipedBoneName == "R Thigh" do OrigRightThighBone = ob
							)
						)
					)
					else
					(
						for ob in OrigBonesArr do
						(
							if ob.name == "Root" do
							(
								setUserProp ob "BipedNumberB" NewBiped_Number
								setUserProp ob "BipedBoneNumberB" newBipedBoneNumber
								setUserProp b "BipedBoneName" "Root"
								setUserProp ob "BipedBoneName" "Root"
								BipedRootBone = b
								OrigRootBone = ob
								BipedBonesMatches = BipedBonesMatches + 1
							)
						)
					)
				)
				delete BipedBonesHelper0
				delete BipedBonesHelper1
				delete BipedBonesHelper2
				delete BipedBonesHelper3
				------------------------------------------------------------------------------------------------------------------------
				--local info_str_msg = "Bones matches: " + (BipedBonesMatches as string) + " !\n" + "LOL"
				--messagebox info_str_msg title:"TEST!"
				------------------------------------------------------------------------------------------------------------------------
				--Scale Biped Pelvis
				if BipedPelvisBone != undefined and OrigLeftThighBone != undefined and OrigRightThighBone != undefined do
				(
					local OrigBoneLength = length (OrigLeftThighBone.pos - OrigRightThighBone.pos)
					biped.setTransform BipedPelvisBone #scale [OrigBoneLength,OrigBoneLength,OrigBoneLength] false
				)
				biped.setTransform BipedPelvisBone #rotation (biped.getTransform BipedSpineBone #rotation)  false
				
				--newBiped.transform.controller.trianglePelvis = false
				--newBiped.transform.controller.trianglePelvis = true
				--newBiped.transform.controller.trianglePelvis = false
				--newBiped.transform.controller.trianglePelvis = true
				
				--newBiped.transform.controller.sepSpineTracks = true
				--newBiped.transform.controller.sepSpineTracks = false
				--newBiped.transform.controller.sepSpineTracks = true
				--newBiped.transform.controller.sepSpineTracks = false
				--newBiped.transform.controller.sepLegsTracks = true
				--if BipedPelvisBone != undefined and BipedSpineBone != undefined do
				--(
					
					--BipedSpineBone.rotation.controller = undefined
					--BipedSpineBone.rotation.controller.appendTarget BipedPelvisBone 50.0
				--)
				
				
				local BipedBonesHelpersArr = #()
				BipedBonesHelpersArr.count = OrigBonesArr.count
				
				------------------------------------------------------------------------------------------------------------------------
				--local info_str_msg = "Bones array: " + (BipedBonesHelpersArr.count as string) + " !\n" + "LOL"
				--messagebox info_str_msg title:"TEST!"
				------------------------------------------------------------------------------------------------------------------------
				--Move Biped Bones' Helpers
				for i = 1 to BipedBonesHelpersArr.count do
				(
					BipedBonesHelpersArr[i] = point size:0.1
					BipedBonesHelpersArr[i].pos = OrigBonesArr[i].pos
				
				
				
				)
				
				local BipedBonesHelper0 = point size:0.1
				BipedBonesHelper0.box = true
				BipedBonesHelper0.wirecolor = (color 255 0 0)
				local BipedBonesHelper1 = point size:0.1
				BipedBonesHelper1.box = true
				BipedBonesHelper1.wirecolor = (color 0 255 0)
				local BipedBonesHelper2 = point size:0.1
				BipedBonesHelper2.box = true
				BipedBonesHelper2.wirecolor = (color 0 0 255)
				
				BipedBonesHelper0.pos = biped.getTransform BipedRootBone #pos
				BipedBonesHelper0.transform.rotation = biped.getTransform BipedRootBone #rotation
				BipedBonesHelper0.parent = BipedRootBone
				BipedBonesHelper1.pos = biped.getTransform BipedSpineBone #pos
				BipedBonesHelper1.transform.rotation = biped.getTransform BipedSpineBone #rotation
				BipedBonesHelper1.parent = BipedBonesHelper0
				BipedBonesHelper2.pos = biped.getTransform BipedLeftThighBone #pos
				BipedBonesHelper2.transform.rotation = biped.getTransform BipedLeftThighBone #rotation
				BipedBonesHelper2.parent = BipedBonesHelper0
				
				--Move Biped Bones
				for b in newBipedBonesArr do
				(
					newBipedBoneNumber = -1
					if getUserProp b "BipedBoneNumber" != undefined do
					(
						if b != BipedRootBone and b != BipedPelvisBone do--then
						(
							newBipedBoneNumber = getUserProp b "BipedBoneNumber"
						)
						--else
						--(
							--if b == BipedRootBone do	newBipedBoneNumber = getUserProp BipedPelvisBone "BipedBoneNumber"
							--if b == BipedPelvisBone do newBipedBoneNumber = getUserProp BipedPelvisBone "BipedBoneNumber"
						--)
					)
					if newBipedBoneNumber != -1 then
					(
						for ob in OrigBonesArr do
						(
							if getUserProp ob "BipedBoneNumberB" != undefined and getUserProp ob "BipedBoneNumberB" == newBipedBoneNumber do
							(
								biped.setTransform b #pos ob.pos false
								--biped.setTransform b #rotation ob.rotation false -- (quat 0 0 0 1) false --ob.rotation false
								
								biped.setTransform b #rotation (eulerToQuat (ob.transform.rotation as eulerangles) order:1) false
								
								if b.children.count > 0 do--then
								(
									if getUserProp b.children[1] "BipedBoneNumber" != undefined do
									(
										local newBipedChildBoneNumber = getUserProp b.children[1] "BipedBoneNumber"
										for ob2 in OrigBonesArr do
										(
											if getUserProp ob2 "BipedBoneNumberB" != undefined and getUserProp ob2 "BipedBoneNumberB" == newBipedChildBoneNumber do
											(
												if ob.name != "L Foot" and ob.name != "R Foot" and ob.name != " L Foot" and ob.name != " R Foot" then
												(
													--BipedBonesHelper0.pos = ob.pos --biped.getTransform b #pos
													--BipedBonesHelper0.rotation = ob.rotation --biped.getTransform b #rotation
													BipedBonesHelper0.transform = ob.transform
													BipedBonesHelper0.parent = b
													
													--BipedBonesHelper1.pos = biped.getTransform b.children[1] #pos
													BipedBonesHelper1.transform = b.children[1].transform
													--BipedBonesHelper1.parent = BipedBonesHelper0
													
													local ikChain01 = IKSys.ikChain BipedBonesHelper0 BipedBonesHelper1 "IKHISolver"
													ikChain01.transform.controller.posThresh = 0.001
													ikChain01.transform.controller.rotThresh = 0.001
													ikChain01.transform.controller.iterations = 1000
													ikChain01.transform.controller.goalsize = 0.1
													--ikChain01.name = (s.name + " Chain")
													ikChain01.pos = ob2.pos
													delete ikChain01
													
													biped.setTransform b #rotation (eulerToQuat (BipedBonesHelper0.transform.rotation as eulerangles) order:1) false
												)
												else
												(
													BipedBonesHelper0.parent = undefined
													BipedBonesHelper0.transform = ob.transform
													BipedBonesHelper1.transform = ob2.transform
													BipedBonesHelper0.transform = b.transform
													
													local ikChain01 = IKSys.ikChain BipedBonesHelper0 BipedBonesHelper1 "IKHISolver"
													ikChain01.transform.controller.posThresh = 0.001
													ikChain01.transform.controller.rotThresh = 0.001
													ikChain01.transform.controller.iterations = 1000
													ikChain01.transform.controller.goalsize = 0.1
													--ikChain01.name = (s.name + " Chain")
													ikChain01.pos = ob2.pos
													delete ikChain01
													
													biped.setTransform b #rotation (eulerToQuat (BipedBonesHelper0.transform.rotation as eulerangles) order:1) false
													
													
													
													
													
													
													
													
													
													
													
												)
											)
										)
									)
								)
								
								
								
								--else
								--(
								--	biped.setTransform b #rotation (eulerToQuat (ob.transform.rotation as eulerangles) order:1) false
								--)
							)
						)
					)
					else
					(
						if b == BipedRootBone do
						(
							biped.setTransform b #pos OrigSpineBone.pos false
							local ikChain01 = IKSys.ikChain BipedBonesHelper0 BipedBonesHelper1 "IKHISolver"
							ikChain01.transform.controller.posThresh = 0.001
							ikChain01.transform.controller.rotThresh = 0.001
							ikChain01.transform.controller.iterations = 1000
							ikChain01.transform.controller.goalsize = 0.1
							--ikChain01.name = (s.name + " Chain")
							ikChain01.pos = OrigSpine1Bone.pos
							delete ikChain01
							
							--biped.setTransform b #pos (OrigPelvisBone.pos) false
							biped.setTransform b #pos (OrigLeftThighBone.pos - (OrigLeftThighBone.pos - OrigRightThighBone.pos)*0.5) false
							
							local ikChain01 = IKSys.ikChain BipedBonesHelper0 BipedBonesHelper2 "IKHISolver"
							ikChain01.transform.controller.posThresh = 0.001
							ikChain01.transform.controller.rotThresh = 0.001
							ikChain01.transform.controller.iterations = 1000
							ikChain01.transform.controller.goalsize = 0.1
							--ikChain01.name = (s.name + " Chain")
							ikChain01.pos = OrigLeftThighBone.pos
							delete ikChain01
							biped.setTransform b #rotation (eulerToQuat (BipedBonesHelper0.transform.rotation as eulerangles) order:1) false
							
							
						)						
					)
				)
				
				
				--biped.setTransform BipedPelvisBone #rotation (biped.getTransform BipedSpineBone #rotation)  false
				
				
				
				
				
				
				
				
				
				
				
				
				--newBiped.transform.controller.figureMode = false
				
				/*
				for b in newBipedBonesArr do
				(
					newBipedBoneNumber = -1
					if getUserProp b "BipedBoneNumber" != undefined do
					(
						if b != BipedRootBone and b != BipedPelvisBone then
						(
							newBipedBoneNumber = getUserProp b "BipedBoneNumber"
						)
						else
						(
							if b == BipedRootBone do	newBipedBoneNumber = getUserProp BipedPelvisBone "BipedBoneNumber"
							if b == BipedPelvisBone do newBipedBoneNumber = getUserProp BipedPelvisBone "BipedBoneNumber"
						)
					)
					
					for ob in OrigBonesArr do
					(
						if getUserProp ob "BipedBoneNumberB" != undefined and getUserProp ob "BipedBoneNumberB" == newBipedBoneNumber do
						(
							
							biped.setTransform b #pos ob.pos false
							--biped.setTransform b #rotation ob.rotation false -- (quat 0 0 0 1) false --ob.rotation false
							
							biped.setTransform b #rotation (eulerToQuat (ob.transform.rotation as eulerangles) order:1) false
							
						)
					)
				)
				*/
				
				
				
				
				
				
				
								
				--for s in selectionArr do
				--(
				
				
				
				
				
				--local newBipedRootNumber = substring newBipedRootName 4 -1
				--local info_str_msg = "Biped number: " + newBipedRootNumber + " !\n" + "Chars: " + (newBipedRootNameLength as string) + " !\n" + "LOL"
				--messagebox info_str_msg title:"TEST!"
				
				
				
				
				
				
				--clearselection()
				
				SE_AAH_SetBackAnimKeys oldAnimKeysState
			)
			else
			(
				messageBox "Something has gone wrong!\n(Select any bone of hierarchy and THEN push that button!)\n" title:"ERROR"
			)
		)
	)

)

/*********************************************************************************************************************************************************************/
--// INFO ROLLOUT
/*********************************************************************************************************************************************************************/

rollout SE_AAH_Info_Rollout "Extra Info" width:132 height:30
(
	group "Some Info"
	(
		button HelpButton "Help/How-to" across:2 width:90 height:16 pos:[13,25] tooltip:"Push this button to see some help info"
		button AboutButton "About" width:58 height:16 pos:[106,25] tooltip:"Push this button to see some extra info"
	)
	
	rollout AboutDialog "Another Animation Helper v.0.994b" width:275 height:410
	(
		label abd1 "\"Another Animation Helper\" v.0.994b (Open Beta)" align:#left
		label abd2 ""
		label abd3 "Made by Shagg_E, 2017-2026:" align:#left
		HyperLink githubpage "https://github.com/ShaggEw/AnotherAnimationHelper" address:"https://github.com/ShaggEw/AnotherAnimationHelper" color: (color 0 0 0) hovercolor:(color 128 128 128) visitedcolor:(color 127 51 0)
		HyperLink nrsite "http://newrockstar.do.am" address:"http://newrockstar.do.am" color: (color 0 127 0) hovercolor:(color 0 191 0) visitedcolor:(color 0 95 0)
		HyperLink ytchannel "https://youtube.com/@Shagg_E" address:"https://youtube.com/@Shagg_E" color: (color 191 0 0) hovercolor:(color 255 0 0) visitedcolor:(color 127 0 0)
		HyperLink boostypage "https://boosty.to/shagge" address:"https://boosty.to/shagge" color: (color 191 76 0) hovercolor:(color 255 106 0) visitedcolor:(color 127 51 0)
		label abd4 ""
		--label abd5 "" align:#left
		--label abd6 "" align:#left
		--HyperLink lbemail "lbtools2k@gmail.com" address:"mailto:lbtools2k@gmail.com" color: (color 0 0 255) hovercolor:(color 0 0 255) visitedcolor:(color 0 0 191)
		--label abd7 ""
		label abd8 "I want to credit these people:" align:#left
		label abd9 "Kam, Yelmi, Deniska, The Hero, Mr. Jago," align:#left
		label abd10 "Wesser, DK22Pac, aleks926820 and Lorne Brooks" align:#left
		label abd11 "- for their incredible scripts and researches," align:#left
		label abd12 "which inspired and helped me a lot" align:#left
		--label abd13 "" align:#left
		--label abd14 "" align:#left
		label abd15 "to work on all this stuff," align:#left
		label abd16 "deltaCJ and Benjamin Strutui" align:#left
		label abd17 "- for their great help and support," align:#left
		label abd18 "Cleoude, Braindawg and Speccy" align:#left
		label abd19 "- for testing and feedback," align:#left
		label abd20 "and many other guys who made all this possible!" align:#left
		label abd21 ""
		label abd22 "This script is not copyrighted, please feel free" align:#left
		label abd23 "to modify or distribute!" align:#left
	)

	on HelpButton pressed do
	(
		local my_str_msg = "\"Another Animation Helper\" gives you\nthe ability to skip some boring moments\nof rigging and animation process.\n\n" +
		"Point on any button with the mouse cursor\nto see some extra info.\n\nThat's all, dudes."
		messageBox my_str_msg title:"Help for AA Helper...nice title, genius!"
	)

	on AboutButton pressed do
	(
		try (DestroyDialog AboutDialog) catch()
		createDialog AboutDialog
	)
) --// end rollout


/*********************************************************************************************************************************************************************/
--// MACRO CALLS FOR UI
/*********************************************************************************************************************************************************************/

try (closeRolloutFloater SE_AAHWindow) catch ()
SE_AAHWindow = NewRolloutFloater "AA Helper" 190 775 50 100
addRollout SE_AAH_Process_Rollout SE_AAHWindow --rolledUp:true
addRollout SE_AAH_Rig_Tuner_Rollout SE_AAHWindow rolledUp:true
addRollout SE_AAH_Main_Anim_Rollout SE_AAHWindow --rolledUp:true
addRollout SE_AAH_Body_Anim_Rollout SE_AAHWindow rolledUp:true
addRollout SE_AAH_Face_Anim_Rollout SE_AAHWindow rolledUp:true
addRollout SE_AAH_Anim_Adapt_Rollout SE_AAHWindow rolledUp:true
addRollout SE_AAH_Hierarchies_Rollout SE_AAHWindow rolledUp:true
addRollout SE_AAH_Info_Rollout SE_AAHWindow rolledUp:true

/*********************************************************************************************************************************************************************/