/**************************************************************************************************************************
// Another Animation Helper v0.987b
// This script was made by Shagg_E, 2017-2022
**************************************************************************************************************************/

global NewBH_Number = 1000
global NewHI_Number = 0
--global NewHIE_Number = 0
global NewAO_Number = 0
global NewAOParent_Number = 0
global NewBiped_Number = 1000
global NewSM_Number = 0
global AAHHelperLayer
global AAHControllerLayer
global Process_Rollout
callbacks.removeScripts id:#se_processinfo
global Rig_Tuner_Rollout
callbacks.removeScripts id:#se_rigtuner
global Anim_Adapt_Rollout
callbacks.removeScripts id:#se_aahaaupdate

global ProcessUpdateFreezeTrigger = false

try (DestroyDialog ManualSubIDSetTool) catch()
try (DestroyDialog AboutDialog) catch()

global ACAnimRangeStartKeyframe = undefined
global ACAnimRangeEndKeyframe = undefined

struct CharacterHierarchy (spinelinks, leglinks, taillinks, fingersnumber, fingerlinks, toesnumber, toelinks, headid)

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

fn UpdateOrCreateAAHHelperLayer =
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

fn UpdateOrCreateAAHControllerLayer =
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

fn SE_AAH_UpdateAnimRangeStartAndEnd sHier animKeysRangeType posKeysTrigger rotKeysTrigger sclKeysTrigger prefAnimRangeStart prefAnimRangeEnd showUpdateTextInfoTrigger =
(
	if showUpdateTextInfoTrigger do
	(
		Process_Rollout.lbl_PrcssAAH.text = "Updating Anim Range info"
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
			if rotKeysTrigger == true do
			(
				if s.target != undefined then --ClassOf s == targetcamera or ClassOf s == VRayPhysicalCamera
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
				else if s.rotation.controller.keys.count > 0 do
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
			if showUpdateTextInfoTrigger do Process_Rollout.lbl_PrcssAAH.text = "Anim Range not found"
		)
		else if showUpdateTextInfoTrigger do
		(
			Process_Rollout.lbl_PrcssAAH.text = "Anim Range found"
		)
		if showUpdateTextInfoTrigger do
		(
			pgbCount = pgbCount + 1
			Process_Rollout.prgb_AAH.value = 100.*pgbCount/pgbCountTotal
		)
	)
	if showUpdateTextInfoTrigger do
	(
		if ACAnimRangeStartKeyframe != undefined and ACAnimRangeEndKeyframe != undefined do
		(
			Process_Rollout.lbl_PrcssAAH.text = "Anim Range found"
			formattedPrint ACAnimRangeStartKeyframe
			formattedPrint ACAnimRangeEndKeyframe
			--local info_str_msg = "Anim Range Start: " + (ACAnimRangeStartKeyframe as string) + "\nAnim Range End: " + (ACAnimRangeEndKeyframe as string)
			--messagebox info_str_msg title:"Done!"
		)
		Process_Rollout.prgb_AAH.value = 0
		try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
	)
)

fn IncreaseBHNumber =
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

fn IncreaseHIBoneNumber =
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
fn IncreaseHIEyesNumber =
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

fn IncreaseAONumber =
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

fn IncreaseAOParentNumber =
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

fn IncreaseBipedNumber =
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

fn IncreaseSkinMeshNumber =
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

fn GetAndOffAnimKeys =
(
	local aKStateG = 0
	if animButtonState == true do aKStateG = aKStateG + 1
	if maxOps.setKeyMode == true do aKStateG = aKStateG + 2
	animButtonState = false
	maxOps.setKeyMode = false
	return aKStateG
)

fn SetBackAnimKeys aKStateS =
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

fn GetRoot obj =
(
	if obj.parent != undefined then
	(
		GetRoot obj.parent
	)
	else
	(
		return obj
	)	
)

fn AppendAllChildren obj aH = --&aH:#() =
(
	if obj.children.count > 0 do
	(
		for child in obj.children do
		(
			append aH child
			AppendAllChildren child aH --:aH
		)
	)
)

fn GetAllHierarchy obj exceptRoot =
(
	local aH = #()
	local rootObj = GetRoot obj
	if rootObj != undefined do 
	(
		if exceptRoot == 0 do append aH rootObj
		AppendAllChildren rootObj aH --:aH
	)
	return aH
)

fn GetSelectionRoot objRHier =
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

fn GetChildrenHierarchy objHier exceptRoot =
(
	local acH = #()
	local selRootObj
	if objHier.count > 1 then	selRootObj = GetSelectionRoot objHier
	else selRootObj = objHier[1]
	append acH selRootObj
	AppendAllChildren selRootObj acH
	return acH
)

fn SE_AAH_GetSubID gSINode =
(
	local nodeSubID = -1
	if getUserProp gSINode "BoneID" != undefined or getUserProp gSINode "BoneId" != undefined or getUserProp gSINode "SubID" != undefined do
	(
		if getUserProp gSINode "BoneID" != undefined  then nodeSubID = getUserProp gSINode "BoneID"
		else if getUserProp gSINode "BoneId" != undefined  then nodeSubID = getUserProp gSINode "BoneId"
		else nodeSubID = getUserProp gSINode "SubID"
	)
	return nodeSubID
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

fn SE_AAH_GetBoundingBoxOfHierarchy sHier =
(
	--UpdateOrCreateAAHHelperLayer()
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

fn SE_AAH_GetHierarchyFacingVector sHier fullBB =
(
	local realCharRoot
	for sHierBone in sHier do
	(
		if sHierBone.children.count > 2 and realCharRoot == undefined do realCharRoot = sHierBone
	)
	local realRootFacingHelper = point size:0.1
	local realRootFacingHelperXMin = point size:0.1
	local realRootFacingHelperXMax = point size:0.1
	local realRootFacingHelperYMin = point size:0.1
	local realRootFacingHelperYMax = point size:0.1
	local realRootFacingHelperZMin = point size:0.1
	local realRootFacingHelperZMax = point size:0.1
	
	in coordsys world realRootFacingHelper.position = in coordsys world realCharRoot.position
	
	in coordsys world realRootFacingHelperXMin.position.x = in coordsys world realCharRoot.position.x-1
	in coordsys world realRootFacingHelperXMin.position.y = in coordsys world realCharRoot.position.y
	in coordsys world realRootFacingHelperXMin.position.z = in coordsys world realCharRoot.position.z
	realRootFacingHelperXMin.parent = realRootFacingHelper
	in coordsys world realRootFacingHelperXMax.position.x = in coordsys world realCharRoot.position.x+1
	in coordsys world realRootFacingHelperXMax.position.y = in coordsys world realCharRoot.position.y
	in coordsys world realRootFacingHelperXMax.position.z = in coordsys world realCharRoot.position.z
	realRootFacingHelperXMax.parent = realRootFacingHelper
	
	in coordsys world realRootFacingHelperYMin.position.x = in coordsys world realCharRoot.position.x
	in coordsys world realRootFacingHelperYMin.position.y = in coordsys world realCharRoot.position.y-1
	in coordsys world realRootFacingHelperYMin.position.z = in coordsys world realCharRoot.position.z
	realRootFacingHelperYMin.parent = realRootFacingHelper
	in coordsys world realRootFacingHelperYMax.position.x = in coordsys world realCharRoot.position.x
	in coordsys world realRootFacingHelperYMax.position.y = in coordsys world realCharRoot.position.y+1
	in coordsys world realRootFacingHelperYMax.position.z = in coordsys world realCharRoot.position.z
	realRootFacingHelperYMax.parent = realRootFacingHelper
	
	in coordsys world realRootFacingHelperZMin.position.x = in coordsys world realCharRoot.position.x
	in coordsys world realRootFacingHelperZMin.position.y = in coordsys world realCharRoot.position.y
	in coordsys world realRootFacingHelperZMin.position.z = in coordsys world realCharRoot.position.z-1
	realRootFacingHelperZMin.parent = realRootFacingHelper
	in coordsys world realRootFacingHelperZMax.position.x = in coordsys world realCharRoot.position.x
	in coordsys world realRootFacingHelperZMax.position.y = in coordsys world realCharRoot.position.y
	in coordsys world realRootFacingHelperZMax.position.z = in coordsys world realCharRoot.position.z+1
	realRootFacingHelperZMax.parent = realRootFacingHelper
	
	in coordsys world realRootFacingHelper.rotation.x_rotation = in coordsys world realCharRoot.rotation.x_rotation
	in coordsys world realRootFacingHelper.rotation.y_rotation = in coordsys world realCharRoot.rotation.y_rotation
	in coordsys world realRootFacingHelper.rotation.z_rotation = in coordsys world realCharRoot.rotation.z_rotation
	
	
	
	
	/*
	--UpdateOrCreateAAHHelperLayer()
	local boundingBox = box()
	boundingBox.wirecolor = sHier[1].wirecolor
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
	
	
	*/
	

	local v3DCharFacingFinal = (in coordsys world realRootFacingHelperYMin.position) - (in coordsys world realRootFacingHelper.position)
	
	local newBBofBB= nodeLocalBoundingBox fullBB
	local facingVectorLength = (length(newBBofBB[2] - newBBofBB[1]))*0.5
	
	v3DCharFacingFinal = (v3DCharFacingFinal / (length v3DCharFacingFinal)) * facingVectorLength
	
	local facingBoundingBox = copy fullBB
	facingBoundingBox.name =  sHier[1].name + " Hierarchy Facing Vector"
	in coordsys world facingBoundingBox.scale = [0.05,0.05,0.05]
	in coordsys world facingBoundingBox.position = realRootFacingHelper.position + v3DCharFacingFinal
	facingBoundingBox.parent = fullBB
	
	--local v3DCharFacingFinal = Vector3D FacialVectorX FacialVectorY FacialVectorZ
	
	delete realRootFacingHelper
	delete realRootFacingHelperXMin
	delete realRootFacingHelperXMax
	delete realRootFacingHelperYMin
	delete realRootFacingHelperYMax
	delete realRootFacingHelperZMin
	delete realRootFacingHelperZMax
	--delete facingBoundingBox
	
	
	return v3DCharFacingFinal
)

fn SE_AAH_CloneHierarchy sHierCurrentOne sHierDontReplaceBones cloneTransformTrigger = -- works only when BoneIndexes are calculated properly!
(
	local clonedH = #()
	if sHierDontReplaceBones == true then sHierTempCloneRoot = copy sHierCurrentOne[1]
	else
	(
		sHierTempCloneRoot = dummy boxsize:([0.001,0.001,0.001]) wirecolor:blue --bone pos: [0.0,0.0,0.0] wirecolor:blue
		if cloneTransformTrigger then sHierTempCloneRoot.transform = sHierCurrentOne[1].transform
		else sHierTempCloneRoot.position = sHierCurrentOne[1].position
		--in coordsys world sHierTempCloneRoot.position.x = in coordsys world sHierCurrentOne[1].position.x
		--in coordsys world sHierTempCloneRoot.position.y = in coordsys world sHierCurrentOne[1].position.y
		--in coordsys world sHierTempCloneRoot.position.z = in coordsys world sHierCurrentOne[1].position.z
		--if cloneTransformTrigger do in coordsys world sHierTempCloneRoot.rotation = in coordsys world sHierCurrentOne[1].rotation
		
		/*		
		ResetScale sHierTempCloneRoot -- mapped method
		in coordsys world sHierTempCloneRoot.scale = [1,1,1]
		local objTm= in coordsys parent sHierTempCloneRoot.transform
		local objTmX=normalize objTm.row1
		local objTmY=normalize objTm.row2
		local objTmZ=normalize (cross objTmX objTmY) --Rebuild the Z to orthogonalize the matrix.
		in coordsys parent sHierTempCloneRoot.transform=(matrix3 objTmX objTmY objTmZ objTm.pos)
		*/
	)
	sHierTempCloneRoot.name = sHierCurrentOne[1].name
	setUserPropBuffer sHierTempCloneRoot (getUserPropBuffer sHierCurrentOne[1])
	sHierTempCloneRoot.wirecolor = sHierCurrentOne[1].wirecolor
	--local nrtbnTempDummy = dummy boxsize:([0.001,0.001,0.001])
	--sHierTempCloneRoot.baseobject = nrtbnTempDummy
	if sHierDontReplaceBones == false do sHierTempCloneRoot.showLinks = true
	--sHierTempCloneRoot.showLinksOnly = true
	append clonedH sHierTempCloneRoot
	if sHierCurrentOne[1].parent != undefined do sHierTempCloneRoot.parent = sHierCurrentOne[1].parent
	local sHierCurrentID
	local sHierParentID
	local sHierTempCloneMember
	for sHierMember in sHierCurrentOne do
	(
		if sHierMember != sHierCurrentOne[1] do
		(
			sHierCurrentID = getUserProp sHierMember "BoneIndex"
			if sHierCurrentID > 0 do
			(
				sHierParentID = getUserProp sHierMember.parent "BoneIndex"
				if sHierDontReplaceBones == true then sHierTempCloneMember = copy sHierMember
				else
				(
					sHierTempCloneMember = dummy boxsize:([0.001,0.001,0.001]) wirecolor:blue --bone pos: [0.0,0.0,0.0] wirecolor:blue
					if cloneTransformTrigger then sHierTempCloneMember.transform = sHierMember.transform
					else sHierTempCloneMember.position = sHierMember.position
					--in coordsys world sHierTempCloneMember.position.x = in coordsys world sHierMember.position.x
					--in coordsys world sHierTempCloneMember.position.y = in coordsys world sHierMember.position.y
					--in coordsys world sHierTempCloneMember.position.z = in coordsys world sHierMember.position.z
					--if cloneTransformTrigger do in coordsys world sHierTempCloneMember.rotation = in coordsys world sHierMember.rotation
					/*
					ResetScale sHierTempCloneMember -- mapped method
					in coordsys world sHierTempCloneMember.scale = [1,1,1]
					local objTm= in coordsys parent sHierTempCloneMember.transform
					local objTmX=normalize objTm.row1
					local objTmY=normalize objTm.row2
					local objTmZ=normalize (cross objTmX objTmY) --Rebuild the Z to orthogonalize the matrix.
					in coordsys parent sHierTempCloneMember.transform=(matrix3 objTmX objTmY objTmZ objTm.pos)
					*/
					
					
				)
				sHierTempCloneMember.name = sHierMember.name
				setUserPropBuffer sHierTempCloneMember (getUserPropBuffer sHierMember)
				sHierTempCloneMember.wirecolor = sHierMember.wirecolor
				--sHierTempCloneMember.baseobject = nrtbnTempDummy
				if sHierDontReplaceBones == false do sHierTempCloneMember.showLinks = true
				--sHierTempCloneMember.showLinksOnly = true
				for sHierTempCloneMemberParent in clonedH do
				(
					if getUserProp sHierTempCloneMemberParent "BoneIndex" == sHierParentID do sHierTempCloneMember.parent = sHierTempCloneMemberParent
				)
				append clonedH sHierTempCloneMember
			)
		)
	)
	--delete nrtbnTempDummy
	return clonedH
)

fn SE_AAH_CalculateBonesRotations sHierCurrentOne =
(
	local boundingBox = SE_AAH_GetBoundingBoxOfHierarchy sHierCurrentOne
	local v3DCharFacing = SE_AAH_GetHierarchyFacingVector sHierCurrentOne boundingBox
	local sBBHier = GetAllHierarchy boundingBox 0
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
					if firstChild == undefined do firstChild = sHierChild
					sHierChild.parent = undefined
					append sHierChildren sHierChild
				)
			)
			--sHierBone
			if firstChild != undefined then
			(
				in coordsys world sHierBone.rotation.x_rotation = 0.0
				in coordsys world sHierBone.rotation.y_rotation = 0.0
				in coordsys world sHierBone.rotation.z_rotation = 0.0
				local ikRotHelperX = point size:0.1
				--ikRotHelperX.box = true
				--ikRotHelperX.wirecolor = (color 0 0 255)
				in coordsys world ikRotHelperX.position.x = in coordsys world sHierBone.position.x+1
				in coordsys world ikRotHelperX.position.y = in coordsys world sHierBone.position.y
				in coordsys world ikRotHelperX.position.z = in coordsys world sHierBone.position.z
				ikRotHelperX.parent = sHierBone
				local ikRotHelperY = point size:0.1
				--ikRotHelperY.box = true
				--ikRotHelperY.wirecolor = (color 0 0 255)
				in coordsys world ikRotHelperY.position.x = in coordsys world sHierBone.position.x
				in coordsys world ikRotHelperY.position.y = in coordsys world sHierBone.position.y+1
				in coordsys world ikRotHelperY.position.z = in coordsys world sHierBone.position.z
				ikRotHelperY.parent = sHierBone
				local ikRotation = IKSys.ikChain sHierBone ikRotHelperX "IKHISolver"
				ikRotation.transform.controller.posThresh = 0.0--01
				ikRotation.transform.controller.rotThresh = 0.0--01
				ikRotation.transform.controller.iterations = 1000
				--ikRotation.transform.controller.goalsize = 0.1
				--ikRotation.name = "IK_" +s.name + " Chain"
				--ikRotation.wirecolor = (color 255 0 0)
				--AAHHelperLayer.addnode ikRotation
				
				
				--local p2length = length (p2.position - p.position)
				--local newjointhelperVector = p2.position - (p2.position - s.position) / (length (p2.position - s.position)) * p2length
				--newjointhelper.position = newjointhelperVector - (newjointhelperVector - p.position) / (length (newjointhelperVector - p.position)) * p2length
				--
				--else newjointhelper.position = p.position
				
				
				
				--+v3DCharFacing.x
				
				--ikRotation.transform.controller.VHTarget = ikRotHelperY
				
				
				in coordsys world ikRotation.position.x = in coordsys world firstChild.position.x
				in coordsys world ikRotation.position.y = in coordsys world firstChild.position.y
				in coordsys world ikRotation.position.z = in coordsys world firstChild.position.z
				
				/*
				ikRotation.transform.controller.endJoint = ikRotHelperY
				
				in coordsys world ikRotation.position.x = in coordsys world sHierBone.position.x + v3DCharFacing.x
				in coordsys world ikRotation.position.y = in coordsys world sHierBone.position.y + v3DCharFacing.y
				in coordsys world ikRotation.position.z = in coordsys world sHierBone.position.z + v3DCharFacing.z
				
				ikRotation.transform.controller.endJoint = ikRotHelperX
				
				in coordsys world ikRotation.position.x = in coordsys world firstChild.position.x
				in coordsys world ikRotation.position.y = in coordsys world firstChild.position.y
				in coordsys world ikRotation.position.z = in coordsys world firstChild.position.z
				*/ 
				
				delete ikRotation
				delete ikRotHelperX
				delete ikRotHelperY
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

fn SE_AAH_CreateLayerForHierarchy sHier sHierLayerName = 
(
	local cHNewLayer = LayerManager.newLayer()
	cHNewLayer.setname sHierLayerName
	for cHBone in sHier do
	(
		cHNewLayer.addnode cHBone
	)
	return cHNewLayer
)

fn SE_AAH_TransferAnimation sHier sHierCloneArray =
(
	SE_AAH_UpdateAnimRangeStartAndEnd sHier 1 true true true 0.0 100.0 false --get max anim range for the all hierarchy
	local tsAnimBkInterval = 1.0
	if ACAnimRangeStartKeyframe != undefined and ACAnimRangeEndKeyframe != undefined do
	(
		local AdoptRangeKeysCount = (((ACAnimRangeEndKeyframe - ACAnimRangeStartKeyframe) as float)/TicksPerFrame) as integer
		local sHierCloneTempArray = SE_AAH_CloneHierarchy sHierCloneArray false true -- make a clone of the hierarchy with array of new helpers and copypasted rotations
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
						
						for i = 0 to AdoptRangeKeysCount do
						(
							--if (ACAnimRangeStartKeyframe + (i * tsAnimBkInterval)) == 0.0f do isThereAZeroKeyAtAllpos = true
							at time (ACAnimRangeStartKeyframe + (i * tsAnimBkInterval))
							(
								in coordsys world sHCANode.transform = in coordsys world currentTempNode.transform
							)
						)
						
						
						/*
						--Start of current object animation baking to temp helper
						if sHNode.position.controller.keys.count > 0 do 
						(
							local pgbCount = 0
							local pgbCountTotal = sHNode.position.controller.keys.count
							Process_Rollout.lbl_PrcssAAH.text = "Bk adopt pos: " + sHNode.name
							for i = 1 to sHNode.position.controller.keys.count do
							(
								--if sHNode.position.controller.keys[i].time == 0.0f do isThereAZeroKeyAtAllpos = true
								at time sHNode.position.controller.keys[i].time
								(
									sHCANode.transform = currentTempNode.transform
									--in coordsys world sHCANode.position.x = in coordsys world currentTempNode.position.x
									--in coordsys world sHCANode.position.y = in coordsys world currentTempNode.position.y
									--in coordsys world sHCANode.position.z = in coordsys world currentTempNode.position.z
									pgbCount = pgbCount + 1
									Process_Rollout.prgb_AAH.value = 100.*pgbCount/pgbCountTotal
								)
							)
						)
						Process_Rollout.lbl_PrcssAAH.text = "Bk adopt pos (Ok!): " + sHNode.name
						Process_Rollout.prgb_AAH.value = 0
						try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
						if sHNode.target == undefined then
						(
							if sHNode.rotation.controller.keys.count > 0 do
							(
								local pgbCount = 0
								local pgbCountTotal = sHNode.rotation.controller.keys.count
								Process_Rollout.lbl_PrcssAAH.text = "Bk adopt rot: " + sHNode.name
								for i = 1 to sHNode.rotation.controller.keys.count do
								(
									--if sHNode.rotation.controller.keys[i].time == 0.0f do isThereAZeroKeyAtAllrot = true
									at time sHNode.rotation.controller.keys[i].time
									(
										--sHCANode.transform = currentTempNode.transform
										
										--in coordsys world sHCANode.rotation.controller.value = in coordsys world currentTempNode.rotation.controller.value
										in coordsys world sHCANode.rotation = in coordsys world currentTempNode.rotation
										
										--in coordsys world sHCANode.rotation.controller.value = currentTempNode.transform as quat
										--in coordsys world sHCANode.rotation.controller.value = in coordsys world currentTempNode.transform as quat
										pgbCount = pgbCount + 1
										Process_Rollout.prgb_AAH.value = 100.*pgbCount/pgbCountTotal
									)
								)
							)
							Process_Rollout.lbl_PrcssAAH.text = "Bk adopt rot (Ok!): " + sHNode.name
							Process_Rollout.prgb_AAH.value = 0
							try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
						)
						else
						(
							if sHNode.controller.roll_angle.controller.keys.count > 0 do
							(
								local pgbCount = 0
								local pgbCountTotal = sHNode.controller.roll_angle.controller.keys.count
								Process_Rollout.lbl_PrcssAAH.text = "Bk adopt roll: " + sHNode.name
								for i = 1 to sHNode.controller.roll_angle.controller.keys.count do
								(
									--if sHNode.controller.roll_angle.controller.keys[i].time == 0.0f do isThereAZeroKeyAtAllrot = true
									at time sHNode.controller.roll_angle.controller.keys[i].time
									(
										--sHCANode.transform = currentTempNode.transform
										--in coordsys world sHCANode.rotation.controller.value = in coordsys world currentTempNode.rotation.controller.value
										
										in coordsys world sHCANode.transform = in coordsys world currentTempNode.transform
										pgbCount = pgbCount + 1
										Process_Rollout.prgb_AAH.value = 100.*pgbCount/pgbCountTotal
									)
								)
							)
							Process_Rollout.lbl_PrcssAAH.text = "Bk adopt roll (Ok!): " + sHNode.name
							Process_Rollout.prgb_AAH.value = 0
							try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
						)
						if sHNode.scale.controller.keys.count > 0 do
						(
							local pgbCount = 0
							local pgbCountTotal = sHNode.scale.controller.keys.count
							Process_Rollout.lbl_PrcssAAH.text = "Bk adopt scl: " + sHNode.name
							for i = 1 to sHNode.scale.controller.keys.count do
							(
								--if sHNode.scale.controller.keys[i].time == 0.0f do isThereAZeroKeyAtAllscl = true
								at time sHNode.scale.controller.keys[i].time
								(
									--sHCANode.transform = currentTempNode.transform
									--in coordsys world sHCANode.rotation.controller.value = in coordsys world currentTempNode.rotation.controller.value
									
									in coordsys world sHCANode.scale.x = in coordsys world currentTempNode.scale.x
									in coordsys world sHCANode.scale.y = in coordsys world currentTempNode.scale.y
									in coordsys world sHCANode.scale.z = in coordsys world currentTempNode.scale.z
									pgbCount = pgbCount + 1
									Process_Rollout.prgb_AAH.value = 100.*pgbCount/pgbCountTotal
								)
							)
						)
						Process_Rollout.lbl_PrcssAAH.text = "Bk adopt scl (Ok!): " + sHNode.name
						Process_Rollout.prgb_AAH.value = 0
						try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
						*/
						
						
						
						
						
					)
					
				)
			)
		)
			

		for sHCTANode in sHierCloneTempArray do delete sHCTANode
		
		
		--AAHHelperLayer.addnode ikRotation
	
	
	
	
	
	)
)
	
fn GetCharacterHierarchy obj =
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
	local rootObj = GetRoot obj
	if rootObj != undefined do 
	(
		append aH rootObj
		AppendAllChildren rootObj aH
		for aHChild in aH do
		(
			local aHBoneId = SE_AAH_GetSubID aHChild
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

fn HasSkinModifier obj =
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

fn GetSkinMeshes selectedBones =
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
			if (HasSkinModifier obj) do
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
			if (HasSkinModifier obj) do
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
													IncreaseSkinMeshNumber()
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
													IncreaseSkinMeshNumber()
													setUserProp obj "SkinMeshNumber" NewSM_Number
													local rsHierarchy = GetAllHierarchy obj2 0
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

fn MarkRelatedSkinBones selectedMesh =
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
										IncreaseSkinMeshNumber()
										setUserProp selectedMesh "SkinMeshNumber" NewSM_Number
										local rsHierarchy = GetAllHierarchy obj 0
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

fn RoundUp2 RValue RAccValue =
(
	return ((ceil (RValue / RAccValue)) * RAccValue)
)

fn copyPasteTransform pickedTm TargetTm pos rot scl =
(
	if pos do pickedTm.row4 = TargetTm.row4
	if rot then
	(
		if scl then
		(
			pickedTm.row1 = TargetTm.row1
			pickedTm.row2 = TargetTm.row2
			pickedTm.row3 = TargetTm.row3
		)
		else
		(
			pickedTm.row1 = (length pickedTm.row1) * normalize TargetTm.row1
			pickedTm.row2 = (length pickedTm.row2) * normalize TargetTm.row2
			pickedTm.row3 = (length pickedTm.row3) * normalize TargetTm.row3
		)
	)
	else if scl do
	(
		pickedTm.row1 = (normalize pickedTm.row1) * length TargetTm.row1
		pickedTm.row2 = (normalize pickedTm.row2) * length TargetTm.row2
		pickedTm.row3 = (normalize pickedTm.row3) * length TargetTm.row3
	)
	return pickedTm
)

/*********************************************************************************************************************************************************************/
--// PROCESS ROLLOUT
/*********************************************************************************************************************************************************************/

rollout Process_Rollout "Process Info" width:132 height:30
(
	progressbar prgb_AAH color:orange tooltip:"Current process progress bar"
	label lbl_PrcssAAH "AAH is ready for use" align:#left tooltip:"Current process info"
	
	/*---------------------------------------------------------------------------------------------------*/
	/*---------------------------------------------------------------------------------------------------*/
	/*---------------------------------------------------------------------------------------------------*/
	
	fn ProgressInfoStatusUpdate =
	(
		if ProcessUpdateFreezeTrigger == false do
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

	on Process_Rollout open do
	(
		callbacks.addScript #selectionSetChanged "Process_Rollout.ProgressInfoStatusUpdate()" id:#se_processinfo
		ProgressInfoStatusUpdate()
	)

	on Process_Rollout close do
	(
		callbacks.removeScripts id:#se_processinfo
	)
	
) --// end rollout

/*********************************************************************************************************************************************************************/
--// RIG TUNER ROLLOUT
/*********************************************************************************************************************************************************************/

rollout Rig_Tuner_Rollout "Rig Tuner" width:132 height:170
(
	group "Create bones"
	(
		button btn_CreateRootB "Create Root" width:71 height:16 align:#left across:2 tooltip:"Creates a Root bone at the center of scene."
		button btn_CreateChildB "Add Children" width:76 height:16 align:#right tooltip:"Adds children bone for selected one.\n\nSelect ONE bone and push this button."
	)
	group "Set SubID / BoneID"
	(
		spinner spn_SubID "Set ID: " range:[-1, 100000, 0] type:#integer align:#left offset:[2,0] fieldwidth:45 across:2
		button btn_SubIDSet "Set!" width:27 height:16 pos:[112,72] tooltip:"Applies SubID/BoneID for selected sub-object/bone."
		--checkbutton btn_SubIDSet "Set!" width:27 height:18 pos:[112,75] highlightcolor:orange enabled:false tooltip:"Applies SubID/BoneID for selected sub-object/bone."
		--checkbutton cbtn_ReplaceAnim "Replace" width:52 align:#left highlightcolor:orange checked:true tooltip:"Completely replaces object's animation with the selected one since frame 0.\nOtherwise applies selected animation after selected frame." across:2 enabled:false
		
		button btn_CalculateSubIDs "Calculate" height:16 across:2 tooltip:"Automatically calculates SubID/BoneID parameters for hierarchy.\n\nUse this tool if you don't need to indicate some bodyparts and you just need all SubID/BoneID parameters to be in order one after the other.\n\nSelect any sub-object/bone of hierarchy and push this button."
		button btn_ManualSetSubIDs "Manual Set" height:16 across:2 tooltip:"Use this tool to manually set SubID/BoneID parameters for hierarchy.\n\nSelect any sub-object/bone of hierarchy and push this button."
	)
	group "Indexes and Types of bones"
	(
		button btn_SetBoneIdxsnTypes "Calculate for all hierarchy" width:150 height:16 tooltip:"Automatically calculates BoneType and BoneIndex parameters for custom bone hierarchy.\n\nQuick tip: it's better to calculate these values automatically.\n\nBoneIndex:\nJust the index of the bone. It need to be in order one after the other.\n\nBoneType:\nSpecial additional value that indicates the bone's type for the engine (does it have the children bone or not, is it the latest bone in the branch or not).\n1 or 3 - bones that don't have children bones\n0 or 2 - bones that have children bones\nIf there are a few children bones under the parent bone - all children bones must be 2 or 3, but the last one must be 0 or 1.\nIf there's only one children bone - this children bone must be 0 or 1.\n\nSelect any bone of hierarchy and push this button."
	)
	group "Clone hierarchy"
	(
		button btn_CloneHierarchy "Whole" width:40 height:16 align:#left across:4 tooltip:"(Whole hierarchy)\nClones the hierarchy.\nAlso automatically calculates BoneIndex parameters for whole bone hierarchy.\n\nSelect any bone of hierarchy and push this button."
		button btn_CloneChildren "Pt" width:22 height:16 tooltip:"(Partial)\nClones the selected children bone and it's children hierarchy, if needed. Use this, if you want to clone a bodypart, like hand or foot.\nAlso automatically calculates BoneIndex parameters for whole bone hierarchy.\n\nSelect any bone of hierarchy and push this button."
		checkbox chkbx_DontReplaceBones "Og" checked:false tooltip:"(Original)\nIf checked, it will clone the bones with the same type of objects, like it was in the original. Otherwise will replace bones with helpers.\n\nThere're some bugs during cloning some systems like Biped or CAT, that's why it's disabled by default and recommended to activate ONLY if you know what you're doing."
		checkbox chkbx_FullTransformCopy "FT" align:#right checked:true tooltip:"(Full Transform)\nIf checked, it will clone the bones' full transformation (positions, rotations and scale), like it was in the original. Otherwise will clone positions only.\n\nThere're some bugs during cloning some systems like Biped or CAT, that's why it's disabled by default and recommended to activate ONLY if you know what you're doing."
	)
	group "Bones' rotations"
	(
		button btn_CalcBonesRotations "Calc bones' rot" width:85 height:16 align:#left across:2 tooltip:"Automatically calculates bones' rotations in the whole hierarchy.\nAlso automatically calculates BoneIndex parameters for whole bone hierarchy.\n\nSelect any bone of hierarchy and push this button."
		button btn_CalcOneBoneRotations "One bone" width:60 height:16 align:#right tooltip:"Automatically calculates bone rotation in the selected bone.\nAlso automatically calculates BoneIndex parameters for whole bone hierarchy.\n\nSelect any bone of hierarchy and push this button."
	)
	group "Skeleton Adaptation"--"Extra tools"
	(
		--checkbutton setup "Setup" checked:true tooltip:"Opens setup panels"
		--button theButton iconName:@"PolyTools\TransformTools\PB_CW" iconSize:[20,20]
		--button theBorderlessButton2 "I am a button, too!" border:false
		button btn_BonesAdaptationTool "Skel Adapt" across:2 height:16 align:#left tooltip:"Creates a clone of hierarchy, automatically calculates proper rotation values.\nCan transfer animation from the old hierarchy to the new one.\nAlso automatically calculates BoneIndex parameters for bone hierarchy.\n\nSelect any bone of hierarchy and push this button."
		checkbox chkbx_BATransferAnimation "with Anim" align:#right checked:false tooltip:"If checked, it will transfer animation from the old bone hierarchy to the new one."
		button btn_TestHierarchy "Test hier" width:55 height:16 align:#right tooltip:"Test your bone hierarchy.\nAlso automatically calculates BoneIndex parameters for whole bone hierarchy.\n\nSelect any bone of hierarchy and push this button."
	)
	
	rollout ManualSubIDSetTool "Manual SubID Set Tool" width:300 height:400
	(
		button btn_TestHierarchy2 "Test hier2" width:55 height:16 align:#right tooltip:"Test your bone hierarchy.\nAlso automatically calculates BoneIndex parameters for whole bone hierarchy.\n\nSelect any bone of hierarchy and push this button."
		checkbox chkbx_SetSubIDs "Set SubID / BoneID" align:#left checked:true across:2 tooltip:"Set SubID / BoneID by this tool. Select need bone, then select needed bone type from the list down here."
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
		
		
		
		on btn_TestHierarchy2 pressed do
		(
			if (queryBox "Have you selected any bone of hierarchy?" title:"WARNING") do
			(
				if selection[1] != undefined and (selection[1].children.count > 0 OR selection[1].parent != undefined) then
				(
					UpdateOrCreateAAHHelperLayer()
					local sHier = GetAllHierarchy selection[1] 0
					
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
				)
				if chkbx_SetNamesToo.state == true do $.name = "Root"
				Rig_Tuner_Rollout.SubIDsAndFrameNames()
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
				)
				if chkbx_SetNamesToo.state == true do $.name = "Pelvis"
				Rig_Tuner_Rollout.SubIDsAndFrameNames()
			)
		)
		
		
		
		
		
		
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
		
		
	
	on setup changed state do
	(
		if state == on then
		(
			--openRollout testshit
			--Process_Rollout.open = true
			--testshit.open = true
			--createDialog testshit
			theButton.visible = true
			theBorderlessButton2.visible = true
		)
		else
		(
			--closeRollout testshit
			--Process_Rollout.open = false
			--testshit.open = false
			--DestroyDialog testshit
			theButton.visible = false
			theBorderlessButton2.visible = false
		)
	)
	
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
	
	on theBorderlessButton2 pressed do
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
	)
	/*---------------------------------------------------------------------------------------------------*/
	/*---------------------------------------------------------------------------------------------------*/
	/*---------------------------------------------------------------------------------------------------*/
	
	fn SubIDsAndFrameNames =
	(
		if ProcessUpdateFreezeTrigger == false do
		(
			if selection.count > 0 then
			(
				btn_CalculateSubIDs.enabled = true
				btn_SetBoneIdxsnTypes.enabled = true
				btn_CloneHierarchy.enabled = true
				btn_CloneChildren.enabled = true
				btn_TestHierarchy.enabled = true
				btn_CalcBonesRotations.enabled = true
				btn_CalcOneBoneRotations.enabled = true
				if selection.count == 1 then
				(
					spn_SubID.value = SE_AAH_GetSubID $
					spn_SubID.enabled = true
					btn_SubIDSet.enabled = true
					btn_CreateChildB.enabled = true
					
				)
				else
				(
					spn_SubID.value = 0
					spn_SubID.enabled = false
					btn_SubIDSet.enabled = false
					btn_CreateChildB.enabled = false
				)
			)
			else
			(
				spn_SubID.value = 0
				spn_SubID.enabled = false
				btn_SubIDSet.enabled = false
				btn_CreateChildB.enabled = false
				
				btn_CalculateSubIDs.enabled = false
				btn_SetBoneIdxsnTypes.enabled = false
				btn_CloneHierarchy.enabled = false
				btn_CloneChildren.enabled = false
				btn_TestHierarchy.enabled = false
				btn_CalcBonesRotations.enabled = false
				btn_CalcOneBoneRotations.enabled = false
				
			)
		)
	)
	
	/*---------------------------------------------------------------------------------------------------*/
	/*---------------------------------------------------------------------------------------------------*/
	/*---------------------------------------------------------------------------------------------------*/
	
	on Rig_Tuner_Rollout open do
	(
		callbacks.addScript #selectionSetChanged "Rig_Tuner_Rollout.SubIDsAndFrameNames()" id:#se_rigtuner
		SubIDsAndFrameNames()
	)

	on Rig_Tuner_Rollout close do
	(
		callbacks.removeScripts id:#se_rigtuner
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
			local nrtbnName = nrtbnParent.name + "Ch" + nrtbnParentChildCountS
			nrtbn.name = nrtbnName
			local nrtbnHier = GetAllHierarchy selection[1] 0
			local nrtbnBoneID = (SE_AAH_GetSubID nrtbnParent) + 1
			local freeBoneIDTrigger = true
			do -- trying to predict optimal SubID value depending on the free SubIDs in the hierarchy
			(
				freeBoneIDTrigger = true
				for nrtbnHierNode in nrtbnHier while freeBoneIDTrigger == true do
				(
					if nrtbnBoneID == SE_AAH_GetSubID nrtbnHierNode do
					(
						nrtbnBoneID = nrtbnBoneID + 1
						freeBoneIDTrigger = false
					)
				)
			)
			while freeBoneIDTrigger == false
			clearselection()
			setUserProp nrtbn "SubID" nrtbnBoneID
			setUserProp nrtbn "BoneID" nrtbnBoneID
			setUserProp nrtbn "BoneId" nrtbnBoneID
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
	
	/*---------------------------------------------------------------------------------------------------*/
	/*---------------------------------------------------------------------------------------------------*/
	/*---------------------------------------------------------------------------------------------------*/
	
	on btn_SubIDSet pressed do
	(
		if selection.count == 1 do
		(
			if SE_AAH_GetSubID $ != -1 and spn_SubID.enabled == false do spn_SubID.enabled = true
			setUserProp $ "SubID" spn_SubID.value
			setUserProp $ "BoneID" spn_SubID.value
			setUserProp $ "BoneId" spn_SubID.value
		)
	)
	
	on btn_CalculateSubIDs pressed do
	(
		if (queryBox "Have you selected any bone of hierarchy?" title:"WARNING") do
		(
			if selection[1].target != undefined then
			(
				setUserProp selection[1] "SubID" 0
				setUserProp selection[1] "BoneID" 0
				setUserProp selection[1] "BoneId" 0
				setUserProp selection[1].target "SubID" 1
				setUserProp selection[1].target "BoneID" 1
				setUserProp selection[1].target "BoneId" 1
			)
			else
			(
				if selection[1] != undefined and (selection[1].children.count > 0 OR selection[1].parent != undefined) then
				(
					local sHier = GetAllHierarchy selection[1] 0
					local newSubID = 0
					for s in sHier do
					(
						setUserProp s "SubID" newSubID
						setUserProp s "BoneID" newSubID
						setUserProp s "BoneId" newSubID
						newSubID = newSubID + 1
					)
				)
				else messageBox "You picked the wrong house, fool!\n(Select any bone of hierarchy and THEN push that button!)\n" title:"ERROR"
			)
		)
	)
	
	/*---------------------------------------------------------------------------------------------------*/
	/*---------------------------------------------------------------------------------------------------*/
	/*---------------------------------------------------------------------------------------------------*/	
	
	on btn_SetBoneIdxsnTypes pressed do
	(
		if (queryBox "Have you selected any bone of hierarchy?" title:"WARNING") do
		(
			if selection[1] != undefined and (selection[1].children.count > 0 OR selection[1].parent != undefined) then
			(
				local sHier = GetAllHierarchy selection[1] 0
				/*for s in sHier do
				(
					setUserProp s "BoneIndex" "fuckyouasshole"
				)
				clearselection()
				local sNewHier = #()
				for o in objects where getUserProp o "BoneIndex" == "fuckyouasshole" do append sNewHier o --// New Selection Order(as in the hierarchy)*/
				local sSPunknown = 0
				if (queryBox "SA?" title:"WARNING") do sSPunknown = 4				
				setUserProp sHier[1] "SPunknown" sSPunknown
				SE_AAH_SetBonesIndexesnTypes sHier
				messagebox "Now your custom bone hierarchy is ready for use in game!" title:"Done!"
			)
			else messageBox "You picked the wrong house, fool!\n(Select any bone of hierarchy and THEN push that button!)\n" title:"ERROR"
		)
	)
	
	/*---------------------------------------------------------------------------------------------------*/
	/*---------------------------------------------------------------------------------------------------*/
	/*---------------------------------------------------------------------------------------------------*/
	
	on btn_CloneHierarchy pressed do
	(
		if (queryBox "Have you selected any bone of hierarchy?" title:"WARNING") do
		(
			if selection[1] != undefined and (selection[1].children.count > 0 OR selection[1].parent != undefined) then
			(
				local sHier = GetAllHierarchy selection[1] 0
				SE_AAH_SetBonesIndexesnTypes sHier
				local sHierTempCloneArray = SE_AAH_CloneHierarchy sHier chkbx_DontReplaceBones.state chkbx_FullTransformCopy.state -- make a clone of the hierarchy with copypasted rotations
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
			)
			else messageBox "You picked the wrong house, fool!\n(Select any bone of hierarchy and THEN push that button!)\n" title:"ERROR"
		)
	)
	
	on btn_CloneChildren pressed do
	(
		if (queryBox "Have you selected main bone of needed bodypart hierarchy?" title:"WARNING") do
		(
			if selection[1] != undefined and (selection[1].children.count > 0 OR selection[1].parent != undefined) then
			(
				local sHier = GetAllHierarchy selection[1] 0
				SE_AAH_SetBonesIndexesnTypes sHier
				local sHierCh = GetChildrenHierarchy selection 0
				local sHierTempCloneArray = SE_AAH_CloneHierarchy sHierCh chkbx_DontReplaceBones.state chkbx_FullTransformCopy.state -- make a clone of the hierarchy with copypasted rotations
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
			)
			else messageBox "You picked the wrong house, fool!\n(Select any bone of hierarchy and THEN push that button!)\n" title:"ERROR"
		)
	)
	
	on btn_TestHierarchy pressed do 
	(
		if (queryBox "Have you selected any bone of hierarchy?" title:"WARNING") do
		(
			if selection[1] != undefined and (selection[1].children.count > 0 OR selection[1].parent != undefined) then
			(
				UpdateOrCreateAAHHelperLayer()
				local sHier = GetAllHierarchy selection[1] 0
				
				local boundingBox = SE_AAH_GetBoundingBoxOfHierarchy sHier
				local v3DCharFacing = SE_AAH_GetHierarchyFacingVector sHier boundingBox
				local sBBHier = GetAllHierarchy boundingBox 0
				--for sBB in sBBHier do delete sBB
				
				
				--v3DCharFacing.x
				
				
				--AAHHelperLayer.addnode boundingBox
				--select boundingBox
			)
			else messageBox "You picked the wrong house, fool!\n(Select any bone of hierarchy and THEN push that button!)\n" title:"ERROR"
		)
	)
	
	on btn_CalcBonesRotations pressed do
	(
		if (queryBox "Have you selected any bone of hierarchy?" title:"WARNING") do
		(
			if selection[1] != undefined and (selection[1].children.count > 0 OR selection[1].parent != undefined) then
			(
				UpdateOrCreateAAHHelperLayer()
				local sHier = GetAllHierarchy selection[1] 0
				
				
				--local sHierTempCloneArray = SE_AAH_CloneHierarchy sHier
				--for sHTCANode in sHierTempCloneArray do
				--(
				--	AAHHelperLayer.addnode sHTCANode
				--)
				
				SE_AAH_CalculateBonesRotations sHier
			)
			else messageBox "You picked the wrong house, fool!\n(Select any bone of hierarchy and THEN push that button!)\n" title:"ERROR"
		)
	)

	on btn_BonesAdaptationTool pressed do
	(
		if (queryBox "Have you selected any bone of hierarchy?" title:"WARNING") do
		(
			if selection[1] != undefined and (selection[1].children.count > 0 OR selection[1].parent != undefined) then
			(
				ProcessUpdateFreezeTrigger = true
				Process_Rollout.lbl_PrcssAAH.text = "Preparing for bones adaptation..."
				Process_Rollout.prgb_AAH.value = 0
				try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
				
				UpdateOrCreateAAHHelperLayer()
				local sHier = GetAllHierarchy selection[1] 0
				SE_AAH_SetBonesIndexesnTypes sHier
				local sHierCloneArray = SE_AAH_CloneHierarchy sHier false false -- make a clone of the hierarchy with array of new helpers and new rotations
				Process_Rollout.lbl_PrcssAAH.text = "Hierarchy clone: success!"
				Process_Rollout.prgb_AAH.value = 30
				try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
				
				local newLayerName
				local oldBonesLayer = SE_AAH_GetUniqueHierarchyLayer sHier -- -2 means impostor nodes in the same layer; -1 means hierarchy lays between different layers; proper layer means hierarchy has a proper unique layer
				if oldBonesLayer == -1 or oldBonesLayer == -2 then
				(
					oldBonesLayer = SE_AAH_CreateLayerForHierarchy sHier ("Bones " + sHier[1].name + " old layer")
					newLayerName = ("Bones " + sHier[1].name + " clone layer")
				)
				else newLayerName = (oldBonesLayer.name + " clone layer")
				oldBonesLayer.isHidden = true
				local cHLayer = SE_AAH_CreateLayerForHierarchy sHierCloneArray newLayerName
				Process_Rollout.lbl_PrcssAAH.text = "Layers preparation: success!"
				Process_Rollout.prgb_AAH.value = 60
				try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
				
				SE_AAH_CalculateBonesRotations sHierCloneArray  
				Process_Rollout.lbl_PrcssAAH.text = "New bone rotations: success!"
				Process_Rollout.prgb_AAH.value = 90
				try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
				select sHierCloneArray[1]
				
				if chkbx_BATransferAnimation.state == true do SE_AAH_TransferAnimation sHier sHierCloneArray

				
				Process_Rollout.lbl_PrcssAAH.text = "Bone adaptation finished!"
				Process_Rollout.prgb_AAH.value = 0
				try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
				ProcessUpdateFreezeTrigger = false
			)
			else messageBox "You picked the wrong house, fool!\n(Select any bone of hierarchy and THEN push that button!)\n" title:"ERROR"
		)
	)
)

/*********************************************************************************************************************************************************************/
--// MAIN ANIM ROLLOUT
/*********************************************************************************************************************************************************************/

rollout Main_Anim_Rollout "Main Anim" width:132 height:170
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
	group "Attach/Detach/Bake object"
	(
		button AttachObjTo "Attach to selected" width:97 height:16 align:#left across:2 tooltip:"Attaches object to selected bone/helper/object.\n\nSelect ONE bone/helper/object and push this button.\n\nWARNING!!!\nIf you are trying to attach HI solver to your selected bone/helper/object, MAKE SURE your selected bone/helper/object is NOT inside a container."
		button DetachObj "Detach" width:50 height:16 align:#right tooltip:"Detaches selected attached objects or attached objects for selected bones/helpers/objects.\n\nWorks only for objects that were attached by this script!\n\nSelect all needed bones/helpers/objects and push this button."
		button CreateKeysFAO "Bake for all selected" height:16 tooltip:"Creates anim keys for all selected attached objects or attached objects for selected bones/helpers/objects.\n\nWorks only for objects that were attached by this script!\nUse this before animation export.\n\nSelect all needed bones/helpers/objects and push this button."
		checkbox chkbx_DetailedAOAnim "Detailed" align:#left checked:true across:2 tooltip:"Bakes more detailed animation by adding extra anim keys every few frames. Choose frame interval in the \"Int\" field.\n\nDisable ONLY if you're know what you're doing and you want to get the less detailed baked anim depending on current attached object's animation keys and the keys of its current parent object!"
		spinner spn_DetailedAOAnim "Int:" range:[0.001, 1000.0, 1.0] type:#float align:#right across:2 fieldwidth:45
	)
	group "Animation control"
	(
		checkbox chkbx_ACTrnsfrmKsPos "Pos" align:#left checked:true across:3 tooltip:"Transform type:\nControl the object's position keys."
		checkbox chkbx_ACTrnsfrmKsRot "Rot" align:#center checked:false across:3 tooltip:"Transform type:\nControl the object's rotation keys."
		checkbox chkbx_ACTrnsfrmKsScale "Scale" align:#right checked:false across:3 tooltip:"Transform type:\nControl the object's scale keys."
		spinner spn_ACTrnsfrmRangeStartVal "S:" range:[0.0, 999999.0, 0.0] type:#float align:#left across:2 fieldwidth:45 tooltip:"Animation Keys Range Start"
		spinner spn_ACTrnsfrmRangeEndVal "E:" range:[0.0, 999999.0, 100.0] type:#float align:#right across:2 fieldwidth:45 tooltip:"Animation Keys Range End"
		radiobuttons rb_AnimKeysRange "Anim keyframes range:" labels:#("All", "Set","TimeL") columns:3 tooltip:"You can select the specified keyframes range you want to work with:\n\nAll: Will work with all the keys of the selected object(s).\n\nSet: Will work for the selected keys range you specified above (from Range Start to Range End).\n\nTimeL: Will work for the selected keys range you have selected on the animation timeline (or the range between the selected first and the last key on the timeline)."
		
		checkbutton ib_CASbutton "Change animation speed:" height:15 width:135 highlightColor:[85,75,65] checked:true enabled:false align:#center offset:[0,-3]
		button CASIncrease "Increase..." width:68 height:16 align:#left across:2 tooltip:"Increases selected animation's speed as many times as specified in right field.\n\nIf you want slow down the animation by 2 times, then choose \"0,5\" in that field.\n\nSelect all needed bones/helpers/objects, then select keys range and push this button."
		spinner spn_CASIncBy "...by:" range:[0.001, 1000.0, 2.0] type:#float align:#right fieldwidth:45
		checkbox chkbx_CASAccuracy "Accuracy" align:#left checked:true across:2 tooltip:"Round-up the number of frames of the new animation range to the value that was chosen in the right field.\n\nIf you increased your animation's speed that has 25,0 frames by 2,0 times then the new range will be 12,5.\nBut if THIS checkbox was checked and value \"1,0\" was chosen - the new range will be 13,0."
		spinner spn_CASAccuracyVal "upto:" range:[0.001, 1000.0, 1.0] type:#float align:#right across:2 fieldwidth:45
		
		checkbutton ib_BakeAKbutton "Additional control:" height:15 width:100 highlightColor:[85,75,65] checked:true enabled:false align:#center offset:[0,-3]
		button BakeObjectsTransformKeys "Bake Keys" width:68 height:16 align:#left across:2 tooltip:"Bakes selected object's transform animation keys.\n\nSelect all needed bones, choose transform type mode, keys range and frame interval in the right field and push this button."
		spinner spn_BkTrnsfrmAccuracyVal "Int:" range:[0.001, 1000.0, 1.0] type:#float align:#right across:2 fieldwidth:45 tooltip:"Animation Keys Baking Frame Interval"
		button SmoothObjectsAnimation "Smooth" width:55 height:16 align:#left across:2 tooltip:"Smoothes selected object's transform animation, makes it a bit less snappy.\n\nSelect all needed bones, choose transform type mode and keys range and push this button.\n\nRepeat these steps if you are not yet satisfied the result."
		spinner spn_SmoothTimesVal "Times:" range:[1, 100000, 1] type:#integer align:#right across:2 fieldwidth:45 tooltip:"How many times you want to smooth your animation."
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
		local oldAnimKeysState = GetAndOffAnimKeys()
		--select pickedObject
		IncreaseAONumber()
		local newAOAttachHelper
		local pohelper = point size:0.1
		pohelper.name = "AO_" + pickedObject.name + " old anim"
		UpdateOrCreateAAHHelperLayer()
		UpdateOrCreateAAHControllerLayer()
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
							in coordsys world pohelper.rotation.controller.value = in coordsys world pickedObject.rotation.controller.value
							
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
						in coordsys world pohelper.transform = in coordsys world pickedObject.transform
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
					in coordsys world pohelper.transform = in coordsys world pickedObject.transform
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
					in coordsys world pohelper.transform = in coordsys world pickedObject.transform
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
		at time sliderTime pickedObject.transform= pohelper.transform
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
				IncreaseAOParentNumber()
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
		SetBackAnimKeys oldAnimKeysState
		return newAOAttachHelper
	)
	
	/*---------------------------------------------------------------------------------------------------*/
	
	fn RemoveAOLink bkAOArray BakeAOAnimFlag bool_DetailedAOAnim float_DetailedAOAnim bool_ShowResultDialogue =
	(
		local oldAnimKeysState = GetAndOffAnimKeys()
		UpdateOrCreateAAHHelperLayer()
		UpdateOrCreateAAHControllerLayer()
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
					Process_Rollout.lbl_PrcssAAH.text = "Baking attach initialising"
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
							--Start of current object animation baking to temp helper
							if bkAOATargetObject.position.controller.keys.count > 0 do 
							(
								local pgbCount = 0
								local pgbCountTotal = bkAOATargetObject.position.controller.keys.count
								Process_Rollout.lbl_PrcssAAH.text = "Bk attach pos: " + bkAOATargetObject.name
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
										Process_Rollout.prgb_AAH.value = 100.*pgbCount/pgbCountTotal
									)
								)
							)
							Process_Rollout.lbl_PrcssAAH.text = "Bk attach pos (Ok!): " + bkAOATargetObject.name
							Process_Rollout.prgb_AAH.value = 0
							try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
							if bkAOATargetObject.target == undefined then
							(
								if bkAOATargetObject.rotation.controller.keys.count > 0 do
								(
									local pgbCount = 0
									local pgbCountTotal = bkAOATargetObject.rotation.controller.keys.count
									Process_Rollout.lbl_PrcssAAH.text = "Bk attach rot: " + bkAOATargetObject.name
									for i = 1 to bkAOATargetObject.rotation.controller.keys.count do
									(
										if bkAOATargetObject.rotation.controller.keys[i].time == 0.0f do isThereAZeroKeyAtAllrot = true
										at time bkAOATargetObject.rotation.controller.keys[i].time
										(
											--AObjecthelper.transform = bkAOATargetObject.transform
											
											in coordsys world AObjecthelper.rotation.controller.value = in coordsys world bkAOATargetObject.rotation.controller.value
											
											
											--in coordsys world AObjecthelper.rotation.controller.value = bkAOATargetObject.transform as quat
											--in coordsys world AObjecthelper.rotation.controller.value = in coordsys world bkAOATargetObject.transform as quat
											pgbCount = pgbCount + 1
											Process_Rollout.prgb_AAH.value = 100.*pgbCount/pgbCountTotal
										)
									)
								)
								Process_Rollout.lbl_PrcssAAH.text = "Bk attach rot (Ok!): " + bkAOATargetObject.name
								Process_Rollout.prgb_AAH.value = 0
								try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
							)
							else
							(
								if bkAOATargetObject.controller.roll_angle.controller.keys.count > 0 do
								(
									local pgbCount = 0
									local pgbCountTotal = bkAOATargetObject.controller.roll_angle.controller.keys.count
									Process_Rollout.lbl_PrcssAAH.text = "Bk attach roll: " + bkAOATargetObject.name
									for i = 1 to bkAOATargetObject.controller.roll_angle.controller.keys.count do
									(
										if bkAOATargetObject.controller.roll_angle.controller.keys[i].time == 0.0f do isThereAZeroKeyAtAllrot = true
										at time bkAOATargetObject.controller.roll_angle.controller.keys[i].time
										(
											--AObjecthelper.transform = bkAOATargetObject.transform
											--in coordsys world AObjecthelper.rotation.controller.value = in coordsys world bkAOATargetObject.rotation.controller.value
											
											in coordsys world AObjecthelper.transform = in coordsys world bkAOATargetObject.transform
											pgbCount = pgbCount + 1
											Process_Rollout.prgb_AAH.value = 100.*pgbCount/pgbCountTotal
										)
									)
								)
								Process_Rollout.lbl_PrcssAAH.text = "Bk attach roll (Ok!): " + bkAOATargetObject.name
								Process_Rollout.prgb_AAH.value = 0
								try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
							)
							if bkAOATargetObject.scale.controller.keys.count > 0 do
							(
								local pgbCount = 0
								local pgbCountTotal = bkAOATargetObject.scale.controller.keys.count
								Process_Rollout.lbl_PrcssAAH.text = "Bk attach scl: " + bkAOATargetObject.name
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
										Process_Rollout.prgb_AAH.value = 100.*pgbCount/pgbCountTotal
									)
								)
							)
							Process_Rollout.lbl_PrcssAAH.text = "Bk attach scl (Ok!): " + bkAOATargetObject.name
							Process_Rollout.prgb_AAH.value = 0
							try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.

							--Start of current Attach Controller animation baking to temp helper
							if AOController.position.controller.keys.count > 0 do 
							(
								local pgbCount = 0
								local pgbCountTotal = AOController.position.controller.keys.count
								Process_Rollout.lbl_PrcssAAH.text = "Bk attach pos2: " + bkAOATargetObject.name
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
										Process_Rollout.prgb_AAH.value = 100.*pgbCount/pgbCountTotal
									)
								)
							)
							Process_Rollout.lbl_PrcssAAH.text = "Bk attach pos2 (Ok!): " + bkAOATargetObject.name
							Process_Rollout.prgb_AAH.value = 0
							try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
							if AOController.rotation.controller.keys.count > 0 do
							(
								local pgbCount = 0
								local pgbCountTotal = AOController.rotation.controller.keys.count
								Process_Rollout.lbl_PrcssAAH.text = "Bk attach rot2: " + bkAOATargetObject.name
								for i = 1 to AOController.rotation.controller.keys.count do
								(
									if AOController.rotation.controller.keys[i].time == 0.0f do isThereAZeroKeyAtAllrot = true
									at time AOController.rotation.controller.keys[i].time
									(
										if bkAOATargetObject.target == undefined then
										(
											--AObjecthelper.transform = bkAOATargetObject.transform
											in coordsys world AObjecthelper.rotation.controller.value = in coordsys world bkAOATargetObject.rotation.controller.value
											--in coordsys world AObjecthelper.rotation.controller.value = in coordsys world bkAOATargetObject.transform as quat
										)
										else
										(
											in coordsys world AObjecthelper.transform = in coordsys world bkAOATargetObject.transform
										)
										pgbCount = pgbCount + 1
										Process_Rollout.prgb_AAH.value = 100.*pgbCount/pgbCountTotal
									)
								)
							)
							Process_Rollout.lbl_PrcssAAH.text = "Bk attach rot2 (Ok!): " + bkAOATargetObject.name
							Process_Rollout.prgb_AAH.value = 0
							try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
							if AOController.scale.controller.keys.count > 0 do
							(
								local pgbCount = 0
								local pgbCountTotal = AOController.scale.controller.keys.count
								Process_Rollout.lbl_PrcssAAH.text = "Bk attach scl2: " + bkAOATargetObject.name
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
										Process_Rollout.prgb_AAH.value = 100.*pgbCount/pgbCountTotal
									)
								)
							)
							Process_Rollout.lbl_PrcssAAH.text = "Bk attach scl2 (Ok!): " + bkAOATargetObject.name
							Process_Rollout.prgb_AAH.value = 0
							try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
							
							
							--Start of current object animation baking depending detailed interval
							if bool_DetailedAOAnim and AOAnimRangeStart != undefined and AOAnimRangeEnd != undefined do
							(
								if AOAnimRangeStart < AOAnimRangeEnd and (AOAnimRangeEnd - AOAnimRangeStart) > float_DetailedAOAnim do
								(
									local pgbCount = 0
									local pgbCountTotal = (((AOAnimRangeEnd - AOAnimRangeStart)as float)/TicksPerFrame / float_DetailedAOAnim) as integer
									Process_Rollout.lbl_PrcssAAH.text = "Bk attach Int: " + bkAOATargetObject.name
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
											Process_Rollout.prgb_AAH.value = 100.*pgbCount/pgbCountTotal
										)
										DetailedAOAnimCurrentTime += float_DetailedAOAnim
									)
								)
								Process_Rollout.lbl_PrcssAAH.text = "Bk attach Int (Ok!): " + bkAOATargetObject.name
								Process_Rollout.prgb_AAH.value = 0
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
								Process_Rollout.lbl_PrcssAAH.text = "Bk attach pos3: " + bkAOATargetObject.name
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
										Process_Rollout.prgb_AAH.value = 100.*pgbCount/pgbCountTotal
									)
								)
							)
							Process_Rollout.lbl_PrcssAAH.text = "Bk attach pos3 (Ok!): " + bkAOATargetObject.name
							Process_Rollout.prgb_AAH.value = 0
							try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
							if AObjecthelper.rotation.controller.keys.count > 0 do
							(
								local pgbCount = 0
								local pgbCountTotal = AObjecthelper.rotation.controller.keys.count
								Process_Rollout.lbl_PrcssAAH.text = "Bk attach rot3: " + bkAOATargetObject.name
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
										else in coordsys world bkAOATargetObject.rotation.controller.value = in coordsys world AObjecthelper.rotation.controller.value
										--else in coordsys world bkAOATargetObject.rotation.controller.value = in coordsys world AObjecthelper.transform as quat
										pgbCount = pgbCount + 1
										Process_Rollout.prgb_AAH.value = 100.*pgbCount/pgbCountTotal
									)
								)
							)
							Process_Rollout.lbl_PrcssAAH.text = "Bk attach rot3 (Ok!): " + bkAOATargetObject.name
							Process_Rollout.prgb_AAH.value = 0
							try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
							if AObjecthelper.scale.controller.keys.count > 0 do
							(
								local pgbCount = 0
								local pgbCountTotal = AObjecthelper.scale.controller.keys.count
								Process_Rollout.lbl_PrcssAAH.text = "Bk attach scl3: " + bkAOATargetObject.name
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
										Process_Rollout.prgb_AAH.value = 100.*pgbCount/pgbCountTotal
									)
								)
							)
							Process_Rollout.lbl_PrcssAAH.text = "Bk attach scl3 (Ok!): " + bkAOATargetObject.name
							Process_Rollout.prgb_AAH.value = 0
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
					Process_Rollout.lbl_PrcssAAH.text = "Attach baked in " + wholeAttachBakingTime + "s"
					Process_Rollout.prgb_AAH.value = 0
					try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
					if bool_ShowResultDialogue == 1 do
					(
						local info_str_msg = bkAOATargetObject.name + " attach anim baked in " + wholeAttachBakingTime + " seconds!"
						messageBox info_str_msg title:"SUCCESS!"
					)
				)
			)
		)
		clearselection()
		SetBackAnimKeys oldAnimKeysState
	)
	
	/*---------------------------------------------------------------------------------------------------*/
	 
	fn UpdateAnimRangeStartAndEnd =
	(
		SE_AAH_UpdateAnimRangeStartAndEnd selection rb_AnimKeysRange.state chkbx_ACTrnsfrmKsPos.state chkbx_ACTrnsfrmKsRot.state chkbx_ACTrnsfrmKsScale.state spn_ACTrnsfrmRangeStartVal.value spn_ACTrnsfrmRangeEndVal.value true
	)
	
	/*---------------------------------------------------------------------------------------------------*/
	
	fn BakeTransformKeysForArray bkArray chbPos chbRot chbScl arStart arEnd bkInterval bool_ShowResultDialogue = --arType
	(
		local wholeBakingTransformTime = timeStamp()
		Process_Rollout.lbl_PrcssAAH.text = "Transform Baking initialising"
		try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
		local BakePointHelper = point size:0.1
		BakePointHelper.scale.controller = ScaleXYZ()
		BakePointHelper.name = "BakeObjectsTransform temp helper"
		UpdateOrCreateAAHHelperLayer()
		AAHHelperLayer.addnode BakePointHelper
		local pgbCount = 0
		local pgbCountTotal = bkArray.count
		local isThereAZeroKeyAtAllpos = false
		local isThereAZeroKeyAtAllrot = false
		local isThereAZeroKeyAtAllscl = false
		with Animate on
		(
			for bkArrayCurrentNode in bkArray do
			(
				deleteKeys BakePointHelper.position.controller
				deleteKeys BakePointHelper.rotation.controller
				deleteKeys BakePointHelper.scale.controller
				local BakeRangeKeysCount = (arEnd - arStart) / bkInterval
				if BakeRangeKeysCount > 0 do
				(
					Process_Rollout.lbl_PrcssAAH.text = "Baking: " + bkArrayCurrentNode.name
					if chbPos == true do
					(	
						for i = 0 to BakeRangeKeysCount do
						(
							if (arStart + (i * bkInterval)) == 0.0f do isThereAZeroKeyAtAllpos = true
							at time (arStart + (i * bkInterval))
							(
								in coordsys parent BakePointHelper.position = in coordsys parent bkArrayCurrentNode.position
							)
						)
						if arEnd == 0.0f do isThereAZeroKeyAtAllpos = true
						at time arEnd
						(
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
								deselectKeys bkArrayCurrentNode.position.controller
								selectKeys bkArrayCurrentNode.position.controller arStart arEnd
								deleteKeys bkArrayCurrentNode.position.controller #selection
							)
							for i = 1 to BakePointHelper.position.controller.keys.count do
							(
								at time BakePointHelper.position.controller.keys[i].time
								(
									in coordsys parent bkArrayCurrentNode.position = in coordsys parent BakePointHelper.position
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
					
					if chbRot == true do
					(	
						for i = 0 to BakeRangeKeysCount do
						(
							if (arStart + (i * bkInterval)) == 0.0f do isThereAZeroKeyAtAllrot = true
							at time (arStart + (i * bkInterval))
							(
								/*
								if bkArrayCurrentNode.parent != undefined then
									--in coordsys parent BakePointHelper.rotation.controller.value = (bkArrayCurrentNode.transform * (inverse bkArrayCurrentNode.parent.transform)) as quat
									in coordsys parent BakePointHelper.rotation.controller.value = normalize ((bkArrayCurrentNode.transform * (inverse bkArrayCurrentNode.parent.transform)) as quat)
									--in coordsys parent BakePointHelper.rotation.controller.value = pickedObject.rotation.controller.value
								else
									in coordsys parent BakePointHelper.rotation.controller.value = bkArrayCurrentNode.transform as quat
								*/
								local oldTM
								if bkArrayCurrentNode.parent != undefined then oldTM = bkArrayCurrentNode.transform * (inverse bkArrayCurrentNode.parent.transform)
								else oldTM = bkArrayCurrentNode.transform
								in coordsys parent BakePointHelper.transform = copyPasteTransform (in coordsys parent BakePointHelper.transform) oldTM false true false
							)
						)
						if arEnd == 0.0f do isThereAZeroKeyAtAllrot = true
						at time arEnd
						(
							/*
							if bkArrayCurrentNode.parent != undefined then
								--in coordsys parent BakePointHelper.rotation.controller.value = (bkArrayCurrentNode.transform * (inverse bkArrayCurrentNode.parent.transform)) as quat
								in coordsys parent BakePointHelper.rotation.controller.value = normalize((bkArrayCurrentNode.transform * (inverse bkArrayCurrentNode.parent.transform)) as quat)
							else
								in coordsys parent BakePointHelper.rotation.controller.value = bkArrayCurrentNode.transform as quat
							*/
							local oldTM
							if bkArrayCurrentNode.parent != undefined then oldTM = bkArrayCurrentNode.transform * (inverse bkArrayCurrentNode.parent.transform)
							else oldTM = bkArrayCurrentNode.transform
							in coordsys parent BakePointHelper.transform = copyPasteTransform (in coordsys parent BakePointHelper.transform) oldTM false true false
						)
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
								if bkArrayCurrentNode.target != undefined then
								(
									if bkArrayCurrentNode.controller.roll_angle.controller.keys.count > 0 do 
									(
										for i = 1 to bkArrayCurrentNode.controller.roll_angle.controller.keys.count do
										(
											if bkArrayCurrentNode.controller.roll_angle.controller.keys[i].time == 0.0f do isThereAZeroKeyAtAllrot = true
										)
									)
									deselectKeys bkArrayCurrentNode.controller.roll_angle.controller
									selectKeys bkArrayCurrentNode.controller.roll_angle.controller arStart arEnd
									deleteKeys bkArrayCurrentNode.controller.roll_angle.controller #selection
								)
								else
								(
									if bkArrayCurrentNode.rotation.controller.keys.count > 0 do 
									(
										for i = 1 to bkArrayCurrentNode.rotation.controller.keys.count do
										(
											if bkArrayCurrentNode.rotation.controller.keys[i].time == 0.0f do isThereAZeroKeyAtAllrot = true
										)
									)
									deselectKeys bkArrayCurrentNode.rotation.controller
									selectKeys bkArrayCurrentNode.rotation.controller arStart arEnd
									deleteKeys bkArrayCurrentNode.rotation.controller #selection
								)
							)
							for i = 1 to BakePointHelper.rotation.controller.keys.count do
							(
								at time BakePointHelper.rotation.controller.keys[i].time
								(
									if bkArrayCurrentNode.target != undefined then
									(
										if BakePointHelper.transform.row2.z < 0.0 then in coordsys parent bkArrayCurrentNode.controller.roll_angle = 180.0+(BakePointHelper.transform.rotation as eulerangles).y
										else	in coordsys parent bkArrayCurrentNode.controller.roll_angle = -(BakePointHelper.transform.rotation as eulerangles).y
									)
									else in coordsys parent bkArrayCurrentNode.rotation.controller.value = normalize (BakePointHelper.transform as quat)
								)
							)
							if isThereAZeroKeyAtAllrot == false do --we need to prevent the automatic creation of an extra anim key at zero frame
							(
								if bkArrayCurrentNode.target != undefined then
								(
									deselectKeys bkArrayCurrentNode.controller.roll_angle.controller
									selectKeys bkArrayCurrentNode.controller.roll_angle.controller 0.0f
									deleteKeys bkArrayCurrentNode.controller.roll_angle.controller #selection
								)
								else
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
					
					if chbScl == true do
					(	
						bkArrayCurrentNode.scale.controller = ScaleXYZ()
						for i = 0 to BakeRangeKeysCount do
						(
							if (arStart + (i * bkInterval)) == 0.0f do isThereAZeroKeyAtAllscl = true
							at time (arStart + (i * bkInterval))
							(
								--in coordsys world BakePointHelper.scale.x = in coordsys world bkArrayCurrentNode.scale.x
								--in coordsys world BakePointHelper.scale.y = in coordsys world bkArrayCurrentNode.scale.y
								--in coordsys world BakePointHelper.scale.z = in coordsys world bkArrayCurrentNode.scale.z
								if chbRot == true then BakePointHelper.transform = copyPasteTransform BakePointHelper.transform bkArrayCurrentNode.transform false true true
								else in coordsys parent BakePointHelper.transform = in coordsys parent bkArrayCurrentNode.transform
							)
						)
						if arEnd == 0.0f do isThereAZeroKeyAtAllscl = true
						at time arEnd
						(
							--in coordsys world BakePointHelper.scale.x = in coordsys world bkArrayCurrentNode.scale.x
							--in coordsys world BakePointHelper.scale.y = in coordsys world bkArrayCurrentNode.scale.y
							--in coordsys world BakePointHelper.scale.z = in coordsys world bkArrayCurrentNode.scale.z
							if chbRot == true then BakePointHelper.transform = copyPasteTransform BakePointHelper.transform bkArrayCurrentNode.transform false true true
							else in coordsys parent BakePointHelper.transform = in coordsys parent bkArrayCurrentNode.transform
						)
						if BakePointHelper.scale.controller.keys.count > 0 do
						(
							if BakePointHelper.scale.controller.keys.count > 0 do
							(
								if isThereAZeroKeyAtAllscl == false do --we need to prevent the automatic creation of an extra anim key at zero frame
								(
									deselectKeys BakePointHelper.scale.controller
									selectKeys BakePointHelper.scale.controller 0.0f
									deleteKeys BakePointHelper.scale.controller #selection
								)
								if bkArrayCurrentNode.scale.controller.keys.count > 0 do 
								(
									for i = 1 to bkArrayCurrentNode.scale.controller.keys.count do
									(
										if bkArrayCurrentNode.scale.controller.keys[i].time == 0.0f do isThereAZeroKeyAtAllscl = true
									)
								)
								deselectKeys bkArrayCurrentNode.scale.controller
								selectKeys bkArrayCurrentNode.scale.controller arStart arEnd
								deleteKeys bkArrayCurrentNode.scale.controller #selection
							)
							for i = 1 to BakePointHelper.scale.controller.keys.count do
							(
								at time BakePointHelper.scale.controller.keys[i].time
								(
									--in coordsys world bkArrayCurrentNode.scale.x = in coordsys world BakePointHelper.scale.x
									--in coordsys world bkArrayCurrentNode.scale.y = in coordsys world BakePointHelper.scale.y
									--in coordsys world bkArrayCurrentNode.scale.z = in coordsys world BakePointHelper.scale.z
									if chbRot == true then bkArrayCurrentNode.transform = copyPasteTransform bkArrayCurrentNode.transform BakePointHelper.transform false true true
									else in coordsys parent bkArrayCurrentNode.scale.controller.value = in coordsys parent BakePointHelper.scale.controller.value
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
					pgbCount = pgbCount + 1
					Process_Rollout.prgb_AAH.value = 100.*pgbCount/pgbCountTotal
				)
				try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
			)
		)
		delete BakePointHelper
		wholeBakingTransformTime = (((timeStamp() - wholeBakingTransformTime) / 1000.0) as string)
		Process_Rollout.lbl_PrcssAAH.text = "Tf baked in " + wholeBakingTransformTime + "s"
		Process_Rollout.prgb_AAH.value = 0
		try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
		if bool_ShowResultDialogue == 1 do
		(
			local info_str_msg = "Transform baked in " + wholeBakingTransformTime + " seconds!"
			messageBox info_str_msg title:"SUCCESS!"
		)
	)
	
	/*---------------------------------------------------------------------------------------------------*/
	
	fn DeleteTransformKeysForArray dkArray chbPos chbRot chbScl AllAnimation arStart arEnd bool_ShowResultDialogue = --arType
	(
		local wholeDeleteTransformTime = timeStamp()
		Process_Rollout.lbl_PrcssAAH.text = "Transform anim deleting initialising"
		try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
		local pgbCount = 0
		local pgbCountTotal = selection.count
		for dkArrayCurrentNode in dkArray do
		(
			Process_Rollout.lbl_PrcssAAH.text = "Del. keys: " + dkArrayCurrentNode.name
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
				if chbRot == true do
				(
					if dkArrayCurrentNode.target != undefined then
					(
						if dkArrayCurrentNode.controller.roll_angle.controller.keys.count > 0 do
						(
							deselectKeys dkArrayCurrentNode.controller.roll_angle.controller
							selectKeys dkArrayCurrentNode.controller.roll_angle.controller arStart arEnd
							deleteKeys dkArrayCurrentNode.controller.roll_angle.controller #selection
						)
					)
					else
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
			)
			pgbCount = pgbCount + 1
			Process_Rollout.prgb_AAH.value = 100.*pgbCount/pgbCountTotal
		)
		wholeDeleteTransformTime = (((timeStamp() - wholeDeleteTransformTime) / 1000.0) as string)
		Process_Rollout.lbl_PrcssAAH.text = "Del finished in " + wholeDeleteTransformTime + "s"
		Process_Rollout.prgb_AAH.value = 0
		try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
		if bool_ShowResultDialogue == 1 do
		(
			local info_str_msg = "Transform anim deleted in " + wholeDeleteTransformTime + " seconds!"
			messageBox info_str_msg title:"SUCCESS!"
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
				local SelAllArray = GetAllHierarchy selection[1] 0
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
				local SelAllArray = GetAllHierarchy selection[1] 1
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
				local rootItem = GetRoot selection[1]
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
				if (queryBox "Select the object that you want to have selected object's transform...\n\nDo you want to continue?" title:"Attention!") do
				(
					clearSelection()
					local pickedObject = pickObject prompt:"Select the object that you want to have selected object's transform..." rubberBand:[s.pos.x,s.pos.y,s.pos.z]
					if pickedObject != undefined AND pickedObject != #escape do
					(
						local info_str_msg = "Are you sure you want \"" + pickedObject.name + "\" to have \"" + s.name + "\"'s transform?!"
						if (queryBox info_str_msg title:"Attention!") then
						(
							select pickedObject
							if chkbx_ThTrnsfrmPos.state == true do
							(
								pickedObject.position.x = s.position.x
								pickedObject.position.y = s.position.y
								pickedObject.position.z = s.position.z
							)
							if chkbx_ThTrnsfrmRot.state == true do
							(
								pickedObject.rotation.x_rotation = s.rotation.x_rotation
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
					if chkbx_ThTrnsfrmPos.state == true do	s.position = [0.0,0.0,0.0]
					if chkbx_ThTrnsfrmRot.state == true do
					(
						in coordsys parent s.rotation.x_rotation = 0.0
						in coordsys parent s.rotation.y_rotation = 0.0
						in coordsys parent s.rotation.z_rotation = 0.0
					)
					if chkbx_ThTrnsfrmScale.state == true do
					(
						local rosOldParent = s.parent
						if rosOldParent != undefined do s.parent = undefined
						ResetScale s -- mapped method
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
			if EulerToTCBTrigger == true then messageBox "Bones' rotation controllers were set to TCB Controller!" title:"SUCCESS!"
			else messageBox "Bones' rotation controllers were set to Euler XYZ!" title:"SUCCESS!"
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
			if (queryBox "Select the object that you want to attach to this bone/helper/object...\n\nDo you want to continue?" title:"Attention!") do
			(
				clearSelection()
				local pO = pickObject prompt:"Select the object that you want to attach to this bone/helper/object..." rubberBand:[s.pos.x,s.pos.y,s.pos.z]
				if pO != undefined AND pO != #escape AND pO != s do
				(
					local attachTargetObjectTrigger = false
					if pO.target != undefined do
						if (queryBox "You have selected Target Object.\n\nDo you want to attach object's target too?" title:"Attention!") do attachTargetObjectTrigger = true
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
					local oldAnimKeysState = GetAndOffAnimKeys()
					UpdateAnimRangeStartAndEnd() 
					if ACAnimRangeStartKeyframe != undefined and ACAnimRangeEndKeyframe != undefined do
					(
						if ACAnimRangeStartKeyframe < ACAnimRangeEndKeyframe do
						(  
							local wholeCASIncreaseTime = timeStamp()
							Process_Rollout.lbl_PrcssAAH.text = "Changing anim speed initialising"
							try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
							local OldAnimStretch = ACAnimRangeEndKeyframe - ACAnimRangeStartKeyframe
							OldAnimStretch = (OldAnimStretch as float)/TicksPerFrame
							local NewAnimStretchFactor = 1.0 / spn_CASIncBy.value
							local NewAnimStretch = OldAnimStretch * NewAnimStretchFactor
							if chkbx_CASAccuracy.state do
							(
								NewAnimStretch = RoundUp2 NewAnimStretch spn_CASAccuracyVal.value
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
										Process_Rollout.lbl_PrcssAAH.text = "Dec. speed: " + s.name
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
													moveKey s.rotation.x_rotation.controller i NewAnimShift
													moveKey s.rotation.y_rotation.controller i NewAnimShift
													moveKey s.rotation.z_rotation.controller i NewAnimShift
												)
												else if s.rotation.controller.keys[i].time > ACAnimRangeStartKeyframe do
												(
													NewAnimRangeShift = ((s.rotation.controller.keys[i].time - ACAnimRangeStartKeyframe) * NewAnimStretchFactor) - (s.rotation.controller.keys[i].time - ACAnimRangeStartKeyframe)
													moveKey s.rotation.x_rotation.controller i NewAnimRangeShift
													moveKey s.rotation.y_rotation.controller i NewAnimRangeShift
													moveKey s.rotation.z_rotation.controller i NewAnimRangeShift
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
										pgbCount = pgbCount + 1
										Process_Rollout.prgb_AAH.value = 100.*pgbCount/pgbCountTotal
										try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
									)
								)
								else
								( 
									for s in selection do
									(
										Process_Rollout.lbl_PrcssAAH.text = "Inc. speed: " + s.name
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
														moveKey s.rotation.x_rotation.controller i NewAnimRangeShift
														moveKey s.rotation.y_rotation.controller i NewAnimRangeShift
														moveKey s.rotation.z_rotation.controller i NewAnimRangeShift
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
										pgbCount = pgbCount + 1
										Process_Rollout.prgb_AAH.value = 100.*pgbCount/pgbCountTotal
										try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
									)
								)
							)
							wholeCASIncreaseTime = (((timeStamp() - wholeCASIncreaseTime) / 1000.0) as string)
							Process_Rollout.lbl_PrcssAAH.text = "CAS finished in " + wholeCASIncreaseTime + "s"
							Process_Rollout.prgb_AAH.value = 0
							try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
							local info_str_msg = "Anim speed changing finished in " + wholeCASIncreaseTime + " seconds!"
							messageBox info_str_msg title:"SUCCESS!"
						)
					)
					SetBackAnimKeys oldAnimKeysState
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
			if chkbx_ACTrnsfrmKsPos.state == true or chkbx_ACTrnsfrmKsRot.state == true or chkbx_ACTrnsfrmKsScale.state == true then
			(
				local oldAnimKeysState = GetAndOffAnimKeys()
				UpdateAnimRangeStartAndEnd()
				if ACAnimRangeStartKeyframe != undefined and ACAnimRangeEndKeyframe != undefined do
				(
					BakeTransformKeysForArray selection chkbx_ACTrnsfrmKsPos.state chkbx_ACTrnsfrmKsRot.state chkbx_ACTrnsfrmKsScale.state ACAnimRangeStartKeyframe ACAnimRangeEndKeyframe spn_BkTrnsfrmAccuracyVal.value 1
				)
				SetBackAnimKeys oldAnimKeysState
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
				local oldAnimKeysState = GetAndOffAnimKeys()
				UpdateAnimRangeStartAndEnd()
				if ACAnimRangeStartKeyframe != undefined and ACAnimRangeEndKeyframe != undefined do
				(
					local wholeSmoothAnimationTime = timeStamp()
					Process_Rollout.lbl_PrcssAAH.text = "Anim smoothing initialising"
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
									Process_Rollout.lbl_PrcssAAH.text = "Smoothing: " + s.name
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
									Process_Rollout.prgb_AAH.value = 100.*pgbCount/pgbCountTotal
									try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
								)
							)
						)
					)
					wholeSmoothAnimationTime = (((timeStamp() - wholeSmoothAnimationTime) / 1000.0) as string)
					Process_Rollout.lbl_PrcssAAH.text = "Smth finished in " + wholeSmoothAnimationTime + "s"
					Process_Rollout.prgb_AAH.value = 0
					try (windows.processPostedMessages()) catch() --Max is telling Windows “I am still alive and kicking!” and not freezing while big loop (thanks, Bobo from forums.cgsociety.org!). Warning! Don't put this INSIDE big loop, it works VERY SLOW! Try/Catch cause Max 2011+ support only.
					local info_str_msg = "Anim smooth finished in " + wholeSmoothAnimationTime + " seconds!"
					messageBox info_str_msg title:"SUCCESS!"
				)
				SetBackAnimKeys oldAnimKeysState
			)
			else messageBox "Select any Transform type checkbox and THEN push that button!!" title:"ERROR"
		)
		else messageBox "Select at least ONE bone/helper/object and THEN push that button!" title:"ERROR"	
	)
	
	on DeleteObjectsTransformKeys pressed do
	(
		if selection.count > 0 then
		(
			if chkbx_ACTrnsfrmKsPos.state == true or chkbx_ACTrnsfrmKsRot.state == true or chkbx_ACTrnsfrmKsScale.state == true then
			(
				local oldAnimKeysState = GetAndOffAnimKeys()
				UpdateAnimRangeStartAndEnd()
				local allAnimationTrigger = 0
				if rb_AnimKeysRange.state == 1 do allAnimationTrigger = 1
				if ACAnimRangeStartKeyframe != undefined and ACAnimRangeEndKeyframe != undefined do
				(
					DeleteTransformKeysForArray selection chkbx_ACTrnsfrmKsPos.state chkbx_ACTrnsfrmKsRot.state chkbx_ACTrnsfrmKsScale.state allAnimationTrigger ACAnimRangeStartKeyframe ACAnimRangeEndKeyframe 1
				)
				SetBackAnimKeys oldAnimKeysState
			)
			else messageBox "Select any Transform type checkbox and THEN push that button!!" title:"ERROR"
		)
		else messageBox "Select at least ONE bone/helper/object and THEN push that button!" title:"ERROR"
	)

)

/*********************************************************************************************************************************************************************/
--// BODY ANIM ROLLOUT
/*********************************************************************************************************************************************************************/

rollout Body_Anim_Rollout "Body Anim" width:132 height:170
(
	group "Skin Mesh Triggers"
	(
		button SMTrigFreeze "Freeze" width:57 height:16 align:#left across:2 tooltip:"Freezes/unfreezes skin mesh.\n\nSelect any bone/helper or skin mesh and push this button.\n\nWARNING!\nFirst time may work slow, but works fast later!"
		button SMTrigXRay "Transparency" width:90 height:16 align:#right tooltip:"Enables/Disables transparency for skin mesh.\n\nSelect any bone/helper or skin mesh and push this button.\n\nWARNING!\nFirst time may work slow, but works fast later!"
	)
	group "Create/Delete/Bake Controllers"
	(
		button CreateHISolver1 "One bone" width:67 height:16 align:#left across:2 tooltip:"Creates HI Solver for selected bone.\n\nSelect ONE bone/helper and push this button."
		button CreateHISolver2 "Bone + Joint" width:80 height:16 align:#right tooltip:"Creates HI Solver for selected bone and its parent joint.\n\nSelect ONE bone/helper and push this button."
		button CreateMovementControllers "All Movement Controllers" height:16 tooltip:"Creates all needed controllers for the hierarchy that belongs to the selected bone.\n\nSelect ONE bone/helper and push this button."
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
		local oldAnimKeysState = GetAndOffAnimKeys()
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
		SetBackAnimKeys oldAnimKeysState
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
				UpdateOrCreateAAHHelperLayer()
				UpdateOrCreateAAHControllerLayer()
				IncreaseHIBoneNumber()
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
				if (HasSkinModifier s) do MarkRelatedSkinBones s
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
				else s_Hierarchy = GetAllHierarchy s 0
				local s2 = GetSkinMeshes s_Hierarchy --// Returns any skin meshes (if any) associated with the picked hierarchy
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
				else if getUserProp s "SkinMeshName" != undefined then -- add later SkinMeshName property for extra situations when GetSkinMeshes is not working properly
				(
					local SkinMeshName = getUserProp s "SkinMeshName"
					local MeshFound = false
					for obj in geometry do
					(
						if HasSkinModifier s and obj.name == SkinMeshName then
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
			local oldAnimKeysState = GetAndOffAnimKeys()
			local s = selection[1]
			if ClassOf s != point and ClassOf s != bone and ClassOf s != dummy then
			(
				if (HasSkinModifier s) do MarkRelatedSkinBones s
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
				else s_Hierarchy = GetAllHierarchy s 0
				local s2 = GetSkinMeshes s_Hierarchy --// Returns any skin meshes (if any) associated with the picked hierarchy
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
				else if getUserProp s "SkinMeshName" != undefined then -- add later SkinMeshName property for extra situations when GetSkinMeshes is not working properly
				(
					local SkinMeshName = getUserProp s "SkinMeshName"
					local MeshFound = false
					for obj in geometry do
					(
						if HasSkinModifier s and obj.name == SkinMeshName then
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
			SetBackAnimKeys oldAnimKeysState
			redrawViews()
		)
		else messageBox "Select ONE bone/helper/skin and THEN push that button!" title:"ERROR"
	)
	
	/*---------------------------------------------------------------------------------------------------*/
	/*---------------------------------------------------------------------------------------------------*/
	/*---------------------------------------------------------------------------------------------------*/
	
	on CreateHISolver1 pressed do
	(
		local oldAnimKeysState = GetAndOffAnimKeys()
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
		SetBackAnimKeys oldAnimKeysState
	)

	on CreateHISolver2 pressed do
	(
		local oldAnimKeysState = GetAndOffAnimKeys()
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
		SetBackAnimKeys oldAnimKeysState
	)
	
	on CreateMovementControllers pressed do
	(
		if selection.count > 0 then
		(
			UpdateOrCreateAAHHelperLayer()
			UpdateOrCreateAAHControllerLayer()
			local oldAnimKeysState = GetAndOffAnimKeys() 
			local ccBonesArr = GetAllHierarchy selection[1] 0
			--local ccCH = GetCharacterHierarchy selection[1]
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
			if (queryBox "Humanoid?" title:"WARNING") do bool_isItHumanoud = 1
			for ccbone in ccBonesArr do
			(
				local ccBoneId = SE_AAH_GetSubID ccbone
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
								bool_isItHasAnyLegs = 1
							)
						)
						if ccBoneId == 43 or ccBoneId == 53 do
						(
							newMovementControllerSize = ((length (ccBonesArr[1].position - ccbone.position)) * 0.8)
							local newIKLegController = CreateHISolver ccbone 2 0
							if newIKLegController != undefined do
							(
								append aMCIKLegs newIKLegController
								bool_isItHasAnyLegs = 1
							)
						)
					)
				)		
			)
			if bool_isItHasAnyLegs == 1 then
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
				local newMCRootAttachController = Main_Anim_Rollout.CreateAOLink newMovementController ccBonesArr[1] 0				
				
				
				if aMCIKLegs.count > 0 do
				(
					for aMCIKLegsController in aMCIKLegs do
					(
						local aMCIKLegsCAttachController = Main_Anim_Rollout.CreateAOLink newMovementController aMCIKLegsController 0
					)
				)
				clearselection()
				select newMovementController
			)
				
			else	messageBox "Character is not tuned properly!\n(can't find any legs' BoneID's)" title:"ERROR"
			SetBackAnimKeys oldAnimKeysState
		)
		else messageBox "Select at least ONE bone/helper and THEN push that button!" title:"ERROR"	
	)
	
	on CreateHISolverEyes pressed do
	(
		local oldAnimKeysState = GetAndOffAnimKeys()
		if selection.count > 0 then
		(
			if selection[1].parent != undefined then
			(
				--IncreaseHIEyesNumber()
				local NewHIE_Number = 0
				IncreaseHIBoneNumber()
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
		SetBackAnimKeys oldAnimKeysState
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

rollout Face_Anim_Rollout "Face Anim" width:132 height:170
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
			local cfcBonesArr = GetAllHierarchy selection[1] 0
			local cfcCH = GetCharacterHierarchy selection[1]
			local HeadBone
			for b in cfcBonesArr do
			(
				if SE_AAH_GetSubID b == cfcCH.headid do HeadBone = b
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

rollout Anim_Adapt_Rollout "Anim Adaptation" width:132 height:170
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
	
	/*---------------------------------------------------------------------------------------------------*/
	/*---------------------------------------------------------------------------------------------------*/
	/*---------------------------------------------------------------------------------------------------*/
	
	--Process_Rollout.lbl_PrcssAAH.text = "Attch baked in " + wholeAttachBakingTime + "s"
	--Process_Rollout.prgb_AAH.value = 0
	
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

	on Anim_Adapt_Rollout  open do
	(
		callbacks.addScript #selectionSetChanged "Anim_Adapt_Rollout.AnimationAdaptationUpdate()" id:#se_aahaaupdate
		AnimationAdaptationUpdate()
	)

	on Anim_Adapt_Rollout  close do
	(
		callbacks.removeScripts id:#se_aahaaupdate
	)
	
	/*---------------------------------------------------------------------------------------------------*/
	/*---------------------------------------------------------------------------------------------------*/
	/*---------------------------------------------------------------------------------------------------*/
	
	on AACreateSetController pressed do
	(
		if selection.count > 0 then
		(
			UpdateOrCreateAAHHelperLayer()
			UpdateOrCreateAAHControllerLayer()
			local oldAnimKeysState = GetAndOffAnimKeys() 
			local cAACBonesArr = GetAllHierarchy selection[1] 0
			--local cAACSCH = GetCharacterHierarchy selection[1]
			--local bool_isItHasAnyLegs
			local newAAControllerSize = 0.5
			--local aMCIKLegs = #()
			for cAACbone in cAACBonesArr do
			(
				local cAACBoneId = SE_AAH_GetSubID cAACbone
				if cAACBoneId != -1 do
				(
					if cAACBoneId == 43 or cAACBoneId == 53 do
					(
						newAAControllerSize = ((length (cAACBonesArr[1].position - cAACbone.position)) * 0.8)
						--local newIKLegController = CreateHISolver cAACbone 2 0
						--if newIKLegController != undefined do
						--(
						--	append aMCIKLegs newIKLegController
						--	bool_isItHasAnyLegs = 1
						--)
					)
				)		
			)
			--if bool_isItHasAnyLegs == 1 then
			
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
			local newAASCRootAttachController = Main_Anim_Rollout.CreateAOLink newAASCRootAttachCloneController cAACBonesArr[1] 0				

			addNewKey newAASCRootAttachController.position.controller newAACAnimationEnd
			addNewKey newAASCRootAttachController.rotation.controller newAACAnimationEnd
			addNewKey newAASCRootAttachController.scale.controller newAACAnimationEnd


			clearselection()
			select newAAController
			
				
			--else	messageBox "Character is not tuned properly!\n(can't find any legs' BoneID's)" title:"ERROR"
			SetBackAnimKeys oldAnimKeysState
		)
		else messageBox "Select at least ONE bone/helper and THEN push that button!" title:"ERROR"	
	)
	
	
	
	
	
	
	
	on AAMixamoConversion pressed do
	(
		if selection.count > 0 then
		(
			UpdateOrCreateAAHHelperLayer()
			UpdateOrCreateAAHControllerLayer()
			local oldAnimKeysState = GetAndOffAnimKeys() 
			local cAACBonesArr = GetAllHierarchy selection[1] 0
			local newAAControllerSize = 0.5
			for cAACbone in cAACBonesArr do
			(
				local cAACBoneId = SE_AAH_GetSubID cAACbone
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
			local newAASCRootAttachController = Main_Anim_Rollout.CreateAOLink newAASCRootAttachCloneController cAACBonesArr[1] 0				
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
			
			Main_Anim_Rollout.RemoveAOLink newAASCRootAttachController.children[1] 1 true 1.0 0
			
			delete newAASCRootAttachCloneController
			delete newAAController
			
			animationRange = interval newAACAnimationStart newAACAnimationEnd
			--else	messageBox "Character is not tuned properly!\n(can't find any legs' BoneID's)" title:"ERROR"
			
			Main_Anim_Rollout.BakeTransformKeysForArray cAACBonesArr true true true newAACAnimationStart newAACAnimationEnd 1.0 0
			
			local cAACAllExceptRoot = GetAllHierarchy cAACBonesArr[1] 1
			for cAACAllExceptRootEach in cAACAllExceptRoot do
			(
				deleteKeys cAACAllExceptRootEach.position.controller
				deleteKeys cAACAllExceptRootEach.scale.controller
			)
			deleteKeys cAACBonesArr[1].scale.controller

			select cAACBonesArr[1]
			SetBackAnimKeys oldAnimKeysState
		)
		else messageBox "Select at least ONE bone/helper and THEN push that button!" title:"ERROR"	
	)
	
	
	
)

/*********************************************************************************************************************************************************************/
--// HIERARHIES ROLLOUT
/*********************************************************************************************************************************************************************/

rollout Hierarchies_Rollout "Bones Conversion" width:132 height:170
(
	group "Biped settings"
	(
		button CreateBiped "Create Biped for selected" width:160 height:22 align:#center tooltip:"Creates Biped for picked bones' hierarchy."
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
		if (queryBox warning_str_msg title:"WARNING") do
		(
			if selection[1] != undefined and (selection[1].children.count > 0 OR selection[1].parent != undefined) then
			(
				
				local oldAnimKeysState = GetAndOffAnimKeys()
				IncreaseBipedNumber()
				local OrigBonesArr = GetAllHierarchy selection[1] 0
				
				/*local newBipedSpineLinks = 2
				local newBipedLegLinks = 3
				local newBipedTailLinks = 0
				local newBipedFingersNumber = 1
				local newBipedFingerLinks = 1
				local newBipedToesNumber = 1
				local newBipedToeLinks = 1*/
				local origCH = GetCharacterHierarchy selection[1]
				
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
				local newBipedBonesArr = GetAllHierarchy newBiped 0
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
				
				SetBackAnimKeys oldAnimKeysState
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

rollout Info_Rollout "Extra Info" width:132 height:30
(
	group "Some Info"
	(
		button HelpButton "Help/How-to" across:2 width:90 height:16 pos:[13,25] tooltip:"Push this button to see some help info"
		button AboutButton "About" width:58 height:16 pos:[106,25] tooltip:"Push this button to see some extra info"
	)
	
	rollout AboutDialog "Another Animation Helper v.0.987b" width:275 height:315
	(
		label abd1 "\"Another Animation Helper\" v.0.987b (Open Beta)" align:#left
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
	)

	on HelpButton pressed do
	(
		local my_str_msg = "\"Another Animation Helper\" gives you\nthe ability to skip some boring moments\nof skinning and animation of the characters\nor something else.\n\n" +
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
SE_AAHWindow = NewRolloutFloater "AA Helper" 190 835 50 100
addRollout Process_Rollout SE_AAHWindow --rolledUp:true
addRollout Rig_Tuner_Rollout SE_AAHWindow rolledUp:true
addRollout Main_Anim_Rollout SE_AAHWindow --rolledUp:true
addRollout Body_Anim_Rollout SE_AAHWindow rolledUp:true
--addRollout Face_Anim_Rollout SE_AAHWindow rolledUp:true
addRollout Anim_Adapt_Rollout SE_AAHWindow --rolledUp:true
--addRollout Hierarchies_Rollout SE_AAHWindow rolledUp:true
addRollout Info_Rollout SE_AAHWindow rolledUp:true

/*********************************************************************************************************************************************************************/