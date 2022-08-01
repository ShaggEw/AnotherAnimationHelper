/**************************************************************************************************************************
// This script was made by Shagg_E, 2017-2022
**************************************************************************************************************************/

global NewBH_Number = 1000
global NewHI_Number = 0
--global NewHIE_Number = 0
global NewAO_Number = 0
global NewBiped_Number = 1000
global NewSM_Number = 0
global Rig_Tuner_Rollout
callbacks.removeScripts id:#rigtuner

global ACAnimRangeStartKeyframe = undefined
global ACAnimRangeEndKeyframe = undefined

struct CharacterHierarchy (spinelinks, leglinks, taillinks, fingersnumber, fingerlinks, toesnumber, toelinks, headid)

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

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
		if getUserProp obj "AOBoneNumber" != undefined then
		(
			OldAO_Number = getUserProp obj "AOBoneNumber"
			if OldAO_Number > NewAO_Number then NewAO_Number = OldAO_Number
			OldAO_Number = -1
		)
		if getUserProp obj "AOHelperNumber" != undefined then
		(
			OldAO_Number = getUserProp obj "AOHelperNumber"
			if OldAO_Number > NewAO_Number then NewAO_Number = OldAO_Number
			OldAO_Number = -1
		)
	)
	NewAO_Number = NewAO_Number + 1
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

fn GetAllHierarchy obj =
(
	local aH = #()
	local rootObj = GetRoot obj
	if rootObj != undefined do 
	(
		append aH rootObj
		AppendAllChildren rootObj aH --:aH
	)
	return aH
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
			if getUserProp aHChild "BoneID" != undefined or getUserProp aHChild "BoneId" != undefined do
			(
				local aHBoneId
				if getUserProp aHChild "BoneID" != undefined  then aHBoneId = getUserProp aHChild "BoneID"
				else aHBoneId = getUserProp aHChild "BoneId"
				
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

/*fn SelectHierarchyRootOnly obj =
(
	local rootObj = GetRoot obj
	select rootObj
)

fn SelectAllChildren obj =
(
	if obj.children.count > 0 do
	(
		for child in obj.children do
		(
			selectmore child
			SelectAllChildren child
		)
	)
)*/

fn SelectAllHierarchy obj =
(
	--SelectHierarchyRootOnly obj
	--if selection[1] != undefined do SelectAllChildren selection[1]
	local aH = #()
	local rootObj = GetRoot obj
	if rootObj != undefined do 
	(
		append aH rootObj
		AppendAllChildren rootObj aH --:aH
	)
	clearselection()
	select aH
)

fn HasSkinModifier obj =
(
	local skinModifierFound = false
	for i = 1 to obj.modifiers.count do
	(
		if classof obj.modifiers[i] == Skin do
		(
			skinModifierFound = true
			exit
		)
	)
	return skinModifierFound
)

fn GetSkinMeshes selectedBones =
(
	local relatedSkins = #()
	for obj in geometry do
	(
		if (HasSkinModifier obj) do
		(
			if getUserProp obj "SkinMeshNumber" != undefined then
			(
				for i = 1 to selectedBones.count do
				(
					if getUserProp selectedBones[i] "SkinMeshNumber" != undefined do
					(
						if getUserProp obj "SkinMeshNumber" == getUserProp selectedBones[i] "SkinMeshNumber" do
						(
							append relatedSkins obj
							exit
						)
					)
				)
			)	
			else
			(
				select obj
				setCommandPanelTaskMode #modify
				modPanel.setCurrentObject obj.modifiers[#Skin]
				local boneListCount = skinOps.GetNumberBones obj.skin
				if boneListCount > 0 do
				(
					local boneName = skinOps.getBoneName obj.skin 1 1
					for i = 1 to selectedBones.count do
					(
						if boneName == selectedBones[i].name do
						(
							append relatedSkins obj
							IncreaseSkinMeshNumber()
							setUserProp obj "SkinMeshNumber" NewSM_Number
							local sBoneHier = GetAllHierarchy selectedBones[i]
							for i = 1 to sBoneHier.count do
							(
								setUserProp sBoneHier[i] "SkinMeshNumber" NewSM_Number
							)
							exit
						)
					)
				)
			)
		)
	)
	clearSelection()
	return relatedSkins
)

fn RoundUp2 RValue RAccValue =
(
	return ((ceil (RValue / RAccValue)) * RAccValue)
)

/*********************************************************************************************************************************************************************/
--// RIG TUNER ROLLOUT
/*********************************************************************************************************************************************************************/

rollout Rig_Tuner_Rollout "Rig Tuner" width:132 height:170
(
	group "Create bones"
	(
		button btn_CreateRootB "Create Root" width:71 align:#left across:2 tooltip:"Creates a Root bone at the center of scene."
		button btn_CreateChildB "Add Children" width:76 align:#right tooltip:"Adds children bone for selected one.\nSelect ONE bone and push this button."
	)
	group "Set SubID / BoneID"
	(
		spinner spn_SubID "Set ID: " range:[-1, 100000, 0] type:#integer align:#left offset:[2,0] fieldwidth:45 across:2
		button btn_SubIDSet "Set!" width:27 height:18 pos:[112,75] tooltip:"Applies SubID/BoneID for selected sub-object/bone."
		--checkbutton btn_SubIDSet "Set!" width:27 height:18 pos:[112,75] highlightcolor:orange enabled:false tooltip:"Applies SubID/BoneID for selected sub-object/bone."
		--checkbutton cbtn_ReplaceAnim "Replace" width:52 align:#left highlightcolor:orange checked:true tooltip:"Completely replaces object's animation with the selected one since frame 0.\nOtherwise applies selected animation after selected frame." across:2 enabled:false
		
		button btn_SetSubIDs "Calculate for all hierarchy" width:150 tooltip:"Automatically calculates SubID/BoneID parameters for hierarchy.\nSelect any sub-object/bone of hierarchy and push this button."
	)
	group "Indexes and Types of bones"
	(
		button btn_SetBoneIdxsnTypes "Calculate for all hierarchy" width:150 tooltip:"Automatically calculates BoneType and BoneIndex parameters for custom bone hierarchy.\nSelect any bone of hierarchy and push this button."
	)
	
	/*---------------------------------------------------------------------------------------------------*/
	/*---------------------------------------------------------------------------------------------------*/
	/*---------------------------------------------------------------------------------------------------*/
	
	on btn_CreateRootB pressed do
	(
		clearselection()
		local nrtbn = bone pos: [0.0,0.0,0.0] wirecolor:blue
		nrtbn.name = "Root"
		setUserProp nrtbn "SubID" "0"
		setUserProp nrtbn "BoneID" "0"
		setUserProp nrtbn "BoneId" "0"
		local nrtbnTempDummy = dummy boxsize:([0.001,0.001,0.001])
		nrtbn.baseobject = nrtbnTempDummy
		delete nrtbnTempDummy
		select nrtbn
	)	
	
	on btn_CreateChildB pressed do
	(
		if selection.count == 1 then
		(
			local nrtbnParent = selection[1]
			local nrtbn = bone wirecolor:blue
			nrtbn.transform = nrtbnParent.transform
			local nrtbnParentChildCountS = (nrtbnParent.children.count + 1) as string
			local nrtbnName = nrtbnParent.name + "Ch" + nrtbnParentChildCountS
			nrtbn.name = nrtbnName
			local nrtbnHier = GetAllHierarchy selection[1]
			local nrtbnBoneID = nrtbnHier.count as string
			clearselection()
			setUserProp nrtbn "SubID" nrtbnBoneID
			setUserProp nrtbn "BoneID" nrtbnBoneID
			setUserProp nrtbn "BoneId" nrtbnBoneID
			nrtbn.parent = nrtbnParent
			local nrtbnTempDummy = dummy boxsize:([0.001,0.001,0.001])
			nrtbn.baseobject = nrtbnTempDummy
			delete nrtbnTempDummy
			select nrtbn
		)
		else messageBox "Select ONE bone and THEN push that button!" title:"ERROR"
	)
	
	/*---------------------------------------------------------------------------------------------------*/
	/*---------------------------------------------------------------------------------------------------*/
	/*---------------------------------------------------------------------------------------------------*/
	
	fn SubIDsAndFrameNames =
	(
		if selection.count == 1 then
		(
			if getUserProp $ "SubID" != undefined or getUserProp $ "BoneID" != undefined or getUserProp $ "BoneId" != undefined then
			(
				spn_SubID.enabled = true
				btn_SubIDSet.enabled = true
				if getUserProp $ "SubID" != undefined  then spn_SubID.value = getUserProp $ "SubID"
				else if getUserProp $ "BoneID" != undefined  then spn_SubID.value = getUserProp $ "BoneID"
				else spn_SubID.value = getUserProp $ "BoneId"
			)
			else
			(
				spn_SubID.value = -1
				spn_SubID.enabled = true
				btn_SubIDSet.enabled = true
				--btn_SubIDSet.backcolor = orange
			)
		)
		else
		(
			spn_SubID.value = 0
			spn_SubID.enabled = false
			btn_SubIDSet.enabled = false
		)
	)
	
	/*---------------------------------------------------------------------------------------------------*/
	/*---------------------------------------------------------------------------------------------------*/
	/*---------------------------------------------------------------------------------------------------*/

	on Rig_Tuner_Rollout open do
	(
		callbacks.addScript #selectionSetChanged "Rig_Tuner_Rollout.SubIDsAndFrameNames()" id:#rigtuner
		SubIDsAndFrameNames()
	)

	on Rig_Tuner_Rollout close do
	(
		callbacks.removeScripts id:#rigtuner
	)

	on btn_SubIDSet pressed do
	(
		if selection.count == 1 do
		(
			if getUserProp $ "SubID" == undefined and getUserProp $ "BoneID" == undefined and getUserProp $ "BoneId" == undefined and spn_SubID.enabled == false do spn_SubID.enabled = true
			setUserProp $ "SubID" spn_SubID.value
			setUserProp $ "BoneID" spn_SubID.value
			setUserProp $ "BoneId" spn_SubID.value
		)
	)
	
	/*---------------------------------------------------------------------------------------------------*/
	/*---------------------------------------------------------------------------------------------------*/
	/*---------------------------------------------------------------------------------------------------*/
	
	on btn_SetSubIDs pressed do
	(
		if (queryBox "Have you selected any bone of hierarchy?" title:"WARNING") do
		(
			if (classOf selection[1]) ==  VRayPhysicalCamera or (classOf selection[1]) == Targetcamera then
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
					local sHier = GetAllHierarchy selection[1]
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
				local sHier = GetAllHierarchy selection[1]
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
				local newBoneIndex = 0
				for s in sHier do
				(
					setUserProp s "BoneIndex" newBoneIndex
					newBoneIndex = newBoneIndex + 1
				)
				local a = #()
				local childrenLevel = 0
				local previousBoneIndex = 0
				for s in sHier do
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
				messagebox "Now your custom bone hierarchy is ready for use in game!" title:"Done!"
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
		button SelectAllItems "All" width:25 pos:[8,25] across:3 tooltip:"Automatically will select all the items of picked hierarchy.\nSelect any item and push this button."
		button SelectAllExceptRootItem "Except Root" width:73 pos:[36,25] tooltip:"Automatically will select all the items of picked hierarchy, except Root one.\nSelect any item and push this button."
		button SelectOnlyRootItem "Only Root" width:57 pos:[112,25] tooltip:"Automatically will select only Root item of picked hierarchy.\nSelect any item and push this button."
	)
	group "Transform Helper"
	(
		checkbox chkbx_ThTrnsfrmPos "Pos" align:#left checked:false across:3 tooltip:"Work with object's position."
		checkbox chkbx_ThTrnsfrmRot "Rot" align:#center checked:true across:3 tooltip:"Work with object's rotation."
		checkbox chkbx_ThTrnsfrmScale "Scale" align:#right checked:false across:3 tooltip:"Work with object's scale."
		button CopyPasteObjectsTransform "Copy object's transform" tooltip:"Copies selected object's transform to another one, if checked above."
		button ResetObjectsTransform "Reset object's transform" tooltip:"Resets selected objects' transform to default values, if checked above:\npos 0.0\nrot 0.0\nscale 100.0\nSometimes scale reset will cause funny values but it should work that way, it's made for the first frame reset."
	)	
	group "Attach/Detach/Bake object"
	(
		button AttachObjTo "Attach to selected" width:97 align:#left across:2 tooltip:"Attaches object to selected bone/helper/object.\nSelect ONE bone/helper/object and push this button.\nWARNING!!!\nIf you are trying to attach HI solver to your selected bone/helper/object, MAKE SURE your selected bone/helper/object is NOT inside a container."
		button DetachObj "Detach" width:50 align:#right tooltip:"Detaches selected attached objects or attached objects for selected bones/helpers/objects.\nWorks only for objects that were attached by this script!\nSelect all needed bones/helpers/objects and push this button."
		button CreateKeysFAO "Bake for all selected" tooltip:"Creates anim keys for all selected attached objects or attached objects for selected bones/helpers/objects.\nWorks only for objects that were attached by this script!\nUse this before animation export.\nSelect all needed bones/helpers/objects and push this button."
		checkbox chkbx_DetailedAOAnim "Detailed" align:#left checked:true across:2 tooltip:"Bakes more detailed animation by adding extra anim keys every few frames. Choose frame interval in the \"Int\" field."
		spinner spn_DetailedAOAnim "Int:" range:[0.001, 1000.0, 1.0] type:#float align:#right across:2 fieldwidth:45
	)
	group "Animation control"
	(
		checkbox chkbx_ACTrnsfrmKsPos "Pos" align:#left checked:true across:3 tooltip:"Transform type:\nControl the object's position keys."
		checkbox chkbx_ACTrnsfrmKsRot "Rot" align:#center checked:false across:3 tooltip:"Transform type:\nControl the object's rotation keys."
		checkbox chkbx_ACTrnsfrmKsScale "Scale" align:#right checked:false across:3 tooltip:"Transform type:\nControl the object's scale keys."
		spinner spn_ACTrnsfrmRangeStartVal "S:" range:[0.0, 999999.0, 0.0] type:#float align:#left across:2 fieldwidth:45 tooltip:"Animation Keys Range Start"
		spinner spn_ACTrnsfrmRangeEndVal "E:" range:[0.0, 999999.0, 100.0] type:#float align:#right across:2 fieldwidth:45 tooltip:"Animation Keys Range End"
		radiobuttons rb_AnimKeysRange "Anim keyframes range:" labels:#("All", "Set","TimeL") columns:3 tooltip:"You can select the specified keyframes range you want to work with:\n\nAll: Will work with all the keys of the selected object(s).\n\nSet: Will work for the selected keys range you specified above.\n\nTimeL: Will work for the selected keys range you have selected on the animation timeline (or the range between the selected first and the last key on the timeline)."
		
		checkbutton ib_CASbutton "Change animation speed:" height:15 width:135 highlightColor:[85,75,65] checked:true enabled:false align:#center offset:[0,-3]
		button CASIncrease "Increase..." width:68 height:16 align:#left across:2 tooltip:"Increases selected animation as many times as specified in right field.\nIf you want slow down the animation by 2 times, then choose \"0,5\" in that field.\nSelect all needed bones/helpers/objects, then select keys range and push this button."
		spinner spn_CASIncBy "...by:" range:[0.001, 1000.0, 2.0] type:#float align:#right fieldwidth:45
		checkbox chkbx_CASAccuracy "Accuracy" align:#left checked:true across:2 tooltip:"Round-up the number of frames of the new animation range to the value that was chosen in the right field.\nIf you increased your animation that has 25,0 frames by 2,0 times then the new range will be 12,5.\nBut if THIS checkbox was checked and value \"1,0\" was chosen - the new range will be 13,0."
		spinner spn_CASAccuracyVal "upto:" range:[0.001, 1000.0, 1.0] type:#float align:#right across:2 fieldwidth:45
		
		checkbutton ib_BakeAKbutton "Additional control:" height:15 width:100 highlightColor:[85,75,65] checked:true enabled:false align:#center offset:[0,-3]
		button BakeObjectsTransformKeys "Bake Keys" width:68 height:16 align:#left across:2 tooltip:"Bakes selected object's transform animation keys.\nSelect all needed bones, choose transform type mode, keys range and frame interval in the right field and push this button."
		spinner spn_BkTrnsfrmAccuracyVal "Int:" range:[0.001, 1000.0, 1.0] type:#float align:#right across:2 fieldwidth:45 tooltip:"Animation Keys Baking Frame Interval"
		button SmoothObjectsAnimation "Smooth object's animation" tooltip:"Smoothes selected object's transform animation, makes it a bit less snappy.\nSelect all needed bones, choose transform type mode and keys range and push this button.\nRepeat these steps if you are not yet satisfied the result."
		button DeleteObjectsTransformKeys "Delete object's transform keys" tooltip:"Deletes selected object's transform animation keys.\nSelect all needed bones, choose transform type mode and keys range and push this button."
	)
	/*group "Before Export: Delete anim keys"
	(
		button DelPosKeys "Del Pos keys(all except Root)" tooltip:"All bones except Root bone must have rotation(green) keys only(for correct animation), so you need to delete position(red) keys for them.\nUse this before animation export.\nSelect all needed bones(except Root) and push this button."
		button DelScaKeys "Del Scale keys(not important)" tooltip:"Bones can have rotation(green, all bones) and position(red, Root bone only) keys but it's also recommended to delete scale(blue) keys for them.\nActually, I don't know how scale keys can damage your animation, because it seems the game doesn't read them.\nBut I made this option for the future purposes and also because I can.\nUse this(or not) before animation export.\nSelect all needed bones and push this button."
	)*/
	
	/*---------------------------------------------------------------------------------------------------*/
	/*---------------------------------------------------------------------------------------------------*/
	/*---------------------------------------------------------------------------------------------------*/
	
	fn RemoveAOLink BakeAOAnimFlag bool_DetailedAOAnim float_DetailedAOAnim =
	(
		local oldAnimKeysState = GetAndOffAnimKeys()
		local selectionArr = selection as array
		for s in selectionArr do
		(
			if getUserProp s "AOBoneNumber" != undefined do
			(
				local AOSelectNumber = getUserProp s "AOBoneNumber"
				for obj in objects do
				(
					if getUserProp obj "AObjectNumber" ==  AOSelectNumber do selectmore obj
				)
			)
		)
		selectionArr = selection as array
		for s in selectionArr do
		(
			if isValidNode s do
			(
				if getUserProp s "AObjectNumber" != undefined and getUserProp s "AObjectNumber" != -1 do
				(
					local AObject_Number = getUserProp s "AObjectNumber"
					local AOBone
					local AObjecthelper
					for AOBAll in objects do
					(
						if getUserProp AOBAll "AOBoneNumber" == AObject_Number do AOBone = AOBAll
					)
					for AOHAll in helpers do
					(
						if getUserProp AOHAll "AOHelperNumber" == AObject_Number do AObjecthelper = AOHAll
					)
					if BakeAOAnimFlag == 1 and AObjecthelper != undefined do
					(
						if s.position.controller.keys.count > 0 or s.rotation.controller.keys.count > 0 do
						(
							if s.position.controller.keys.count > 0 do
							(
								deselectKeys AObjecthelper.position.controller
								selectKeys AObjecthelper.position.controller s.position.controller.keys[1].time s.position.controller.keys[s.position.controller.keys.count].time
								deleteKeys AObjecthelper.position.controller #selection
								deselectKeys AObjecthelper.rotation.controller
								selectKeys AObjecthelper.rotation.controller s.position.controller.keys[1].time s.position.controller.keys[s.position.controller.keys.count].time
								deleteKeys AObjecthelper.rotation.controller #selection
							)
							if ClassOf s != targetcamera and ClassOf s != VRayPhysicalCamera then
							(
								if s.rotation.controller.keys.count > 0 do
								(
									deselectKeys AObjecthelper.position.controller
									selectKeys AObjecthelper.position.controller s.rotation.controller.keys[1].time s.rotation.controller.keys[s.rotation.controller.keys.count].time
									deleteKeys AObjecthelper.position.controller #selection
									deselectKeys AObjecthelper.rotation.controller
									selectKeys AObjecthelper.rotation.controller s.rotation.controller.keys[1].time s.rotation.controller.keys[s.rotation.controller.keys.count].time
									deleteKeys AObjecthelper.rotation.controller #selection
								)
							)
							else
							(
								/*if s.controller.roll_angle.keys.count > 0 do
								(
									deselectKeys AObjecthelper.position.controller
									selectKeys AObjecthelper.position.controller s.controller.roll_angle.keys[1].time s.controller.roll_angle.keys[s.controller.roll_angle.keys.count].time
									deleteKeys AObjecthelper.position.controller #selection
									deselectKeys AObjecthelper.rotation.controller
									selectKeys AObjecthelper.rotation.controller s.controller.roll_angle.keys[1].time s.controller.roll_angle.keys[s.controller.roll_angle.keys.count].time
									deleteKeys AObjecthelper.rotation.controller #selection
								)*/
							)
							with Animate on
							(
								local AOAnimRangeStart
								local AOAnimRangeEnd
								if s.position.controller.keys.count > 0 do
								(
									AOAnimRangeStart = s.position.controller.keys[1].time
									if s.position.controller.keys.count > 1 do AOAnimRangeEnd = s.position.controller.keys[s.position.controller.keys.count].time
									for i = 1 to s.position.controller.keys.count do
									(
										at time s.position.controller.keys[i].time
										(
											AObjecthelper.transform = s.transform
										)
									)
								)
								if ClassOf s != targetcamera and ClassOf s != VRayPhysicalCamera then
								(
									if s.rotation.controller.keys.count > 0 do
									(
										if AOAnimRangeStart != undefined then
										(
											if AOAnimRangeStart > s.rotation.controller.keys[1].time do AOAnimRangeStart = s.rotation.controller.keys[1].time
										)
										else AOAnimRangeStart = s.rotation.controller.keys[1].time
										if s.rotation.controller.keys.count > 1 do
										(
											if AOAnimRangeEnd != undefined then
											(
												if AOAnimRangeEnd < s.rotation.controller.keys[s.rotation.controller.keys.count].time do AOAnimRangeEnd = s.rotation.controller.keys[s.rotation.controller.keys.count].time
											)
											else AOAnimRangeEnd = s.rotation.controller.keys[s.rotation.controller.keys.count].time
										)
										for i = 1 to s.rotation.controller.keys.count do
										(
											at time s.rotation.controller.keys[i].time
											(
												AObjecthelper.transform = s.transform
											)
										)
									)
								)
								else
								(
									/*if s.controller.roll_angle.keys.count > 0 do
									(
										if AOAnimRangeStart != undefined then
										(
											if AOAnimRangeStart > s.controller.roll_angle.keys[1].time do AOAnimRangeStart = s.controller.roll_angle.keys[1].time
										)
										else AOAnimRangeStart = s.controller.roll_angle.keys[1].time
										if s.controller.roll_angle.keys.count > 1 do
										(
											if AOAnimRangeEnd != undefined then
											(
												if AOAnimRangeEnd < s.controller.roll_angle.keys[s.controller.roll_angle.keys.count].time do AOAnimRangeEnd = s.controller.roll_angle.keys[s.controller.roll_angle.keys.count].time
											)
											else AOAnimRangeEnd = s.controller.roll_angle.keys[s.controller.roll_angle.keys.count].time
										)
										for i = 1 to s.controller.roll_angle.keys.count do
										(
											at time s.controller.roll_angle.keys[i].time
											(
												AObjecthelper.transform = s.transform
											)
										)
									)*/
								)
								if AOBone != undefined and AOAnimRangeStart != undefined and AOAnimRangeEnd != undefined do
								(
									if AOAnimRangeStart < AOAnimRangeEnd do
									(
										if AOBone.position.controller.keys.count > 0 do
										(
											for i = 1 to AOBone.position.controller.keys.count do
											(
												if AOBone.position.controller.keys[i].time > AOAnimRangeStart and AOBone.position.controller.keys[i].time < AOAnimRangeEnd do
												(
													at time AOBone.position.controller.keys[i].time
													(
														AObjecthelper.transform = s.transform
													)
												)
											)
										)
										if AOBone.rotation.controller.keys.count > 0 do
										(
											for i = 1 to AOBone.rotation.controller.keys.count do
											(
												if AOBone.rotation.controller.keys[i].time > AOAnimRangeStart and AOBone.rotation.controller.keys[i].time < AOAnimRangeEnd do
												(
													at time AOBone.rotation.controller.keys[i].time
													(
														AObjecthelper.transform = s.transform
													)
												)
											)
										)
									)
								)
								if bool_DetailedAOAnim and AOAnimRangeStart != undefined and AOAnimRangeEnd != undefined do
								(
									if AOAnimRangeStart < AOAnimRangeEnd and (AOAnimRangeEnd - AOAnimRangeStart) > float_DetailedAOAnim do
									(
										local DetailedAOAnimCurrentTime = AOAnimRangeStart
										DetailedAOAnimCurrentTime += float_DetailedAOAnim
										while DetailedAOAnimCurrentTime < AOAnimRangeEnd do
										(
											at time DetailedAOAnimCurrentTime
											(
												AObjecthelper.transform = s.transform
											)
											DetailedAOAnimCurrentTime += float_DetailedAOAnim
										)
									)
								)
							)
						)
					)
					setUserProp s "AObjectNumber" -1
					if getUserProp s "AOHadParent" != undefined and getUserProp s "AOHadParent" == 1 then
					(
						local AOOriginalParent
						for AOAllO in objects do
						(
							if getUserProp AOAllO "AOParentNumber" == AObject_Number do
							(
								AOOriginalParent = AOAllO
								setUserProp AOAllO "AOParentNumber" -1
							)
						)
						if	AOOriginalParent != undefined then s.parent = AOOriginalParent
						else s.parent = undefined
						setUserProp s "AOHadParent" -1
					)
					else s.parent = undefined
					if AObjecthelper != undefined do setUserProp AObjecthelper "AOHelperNumber" -1
					if AOBone != undefined do setUserProp AOBone "AOBoneNumber" -1
					deleteKeys s.position.controller #allKeys
					if ClassOf s != targetcamera and ClassOf s != VRayPhysicalCamera then deleteKeys s.rotation.controller #allKeys
					else
					(
						--deleteKeys s.controller.roll_angle.controller #allKeys
						s.controller.roll_angle.controller = bezier_float()
						for AOAllO in objects do
						(
							if isValidNode AOAllO do
							(
								if getUserProp AOAllO "AOCHelperNumber" == AObject_Number do
								(
									setUserProp AOAllO "AOCHelperNumber" -1
									--delete AOAllO
								)
							)
						)
					)
					with Animate on
					(
						if AObjecthelper != undefined do
						(
							if AObjecthelper.position.controller.keys.count > 0 do
							(
								for i = 1 to AObjecthelper.position.controller.keys.count do
								(
									at time AObjecthelper.position.controller.keys[i].time
									(
										s.transform = AObjecthelper.transform
										if ClassOf s == targetcamera or ClassOf s == VRayPhysicalCamera do
										(
											if AObjecthelper.transform.row2.z < 0.0 then s.controller.roll_angle = 180.0+(AObjecthelper.transform.rotation as eulerangles).y
											else	s.controller.roll_angle = -(AObjecthelper.transform.rotation as eulerangles).y
										)
									)
								)
							)
							if AObjecthelper.rotation.controller.keys.count > 0 do
							(
								for i = 1 to AObjecthelper.rotation.controller.keys.count do
								(
									at time AObjecthelper.rotation.controller.keys[i].time
									(
										s.transform = AObjecthelper.transform
										if ClassOf s == targetcamera or ClassOf s == VRayPhysicalCamera do
										(
											if AObjecthelper.transform.row2.z < 0.0 then s.controller.roll_angle = 180.0+(AObjecthelper.transform.rotation as eulerangles).y
											else	s.controller.roll_angle = -(AObjecthelper.transform.rotation as eulerangles).y
										)
									)
								)
							)											
						)
					)
					if AObjecthelper != undefined do delete AObjecthelper
					deleteKeys s.scale.controller
				)
			)
		)
		clearselection()
		SetBackAnimKeys oldAnimKeysState
	)
	
	/*---------------------------------------------------------------------------------------------------*/
	 
	fn UpdateAnimRangeStartAndEnd =
	(
		ACAnimRangeStartKeyframe = undefined
		ACAnimRangeEndKeyframe = undefined
		for s in selection do
		(
			if rb_AnimKeysRange.state == 1 or rb_AnimKeysRange.state == 3 then
			(
				if chkbx_ACTrnsfrmKsPos.state == true and s.position.controller.keys.count > 0 do
				(
					for i = 1 to s.position.controller.keys.count do
					(
						if rb_AnimKeysRange.state == 1 or (rb_AnimKeysRange.state == 3 and isKeySelected s.position.controller i) do
						(
							if ACAnimRangeStartKeyframe != undefined then
							(
								if ACAnimRangeStartKeyframe > s.position.controller.keys[i].time then
								(
									if ACAnimRangeEndKeyframe == undefined do ACAnimRangeEndKeyframe = ACAnimRangeStartKeyframe
									ACAnimRangeStartKeyframe = s.position.controller.keys[i].time
								)
								else
								(
									if ACAnimRangeEndKeyframe != undefined then
									(
										if ACAnimRangeEndKeyframe < s.position.controller.keys[i].time do ACAnimRangeEndKeyframe = s.position.controller.keys[i].time
									)
									else ACAnimRangeEndKeyframe = s.position.controller.keys[i].time
								)
							)
							else ACAnimRangeStartKeyframe = s.position.controller.keys[i].time
						)
					)
				)
				if chkbx_ACTrnsfrmKsRot.state == true and s.rotation.controller.keys.count > 0 do
				(
					for i = 1 to s.rotation.controller.keys.count do
					(
						if rb_AnimKeysRange.state == 1 or (rb_AnimKeysRange.state == 3 and isKeySelected s.rotation.controller i) do
						(
							if ACAnimRangeStartKeyframe != undefined then
							(
								if ACAnimRangeStartKeyframe > s.rotation.controller.keys[i].time then
								(
									if ACAnimRangeEndKeyframe == undefined do ACAnimRangeEndKeyframe = ACAnimRangeStartKeyframe
									ACAnimRangeStartKeyframe = s.rotation.controller.keys[i].time
								)
								else
								(
									if ACAnimRangeEndKeyframe != undefined then
									(
										if ACAnimRangeEndKeyframe < s.rotation.controller.keys[i].time do ACAnimRangeEndKeyframe = s.rotation.controller.keys[i].time
									)
									else ACAnimRangeEndKeyframe = s.rotation.controller.keys[i].time
								)
							)
							else ACAnimRangeStartKeyframe = s.rotation.controller.keys[i].time
						)
					)
				)
				if chkbx_ACTrnsfrmKsScale.state == true and s.scale.controller.keys.count > 0 do
				(
					s.scale.controller = ScaleXYZ()
					for i = 1 to s.scale.controller.keys.count do
					(
						if rb_AnimKeysRange.state == 1 or (rb_AnimKeysRange.state == 3 and isKeySelected s.scale.controller i) do
						(
							if ACAnimRangeStartKeyframe != undefined then
							(
								if ACAnimRangeStartKeyframe > s.scale.controller.keys[i].time then
								(
									if ACAnimRangeEndKeyframe == undefined do ACAnimRangeEndKeyframe = ACAnimRangeStartKeyframe
									ACAnimRangeStartKeyframe = s.scale.controller.keys[i].time
								)
								else
								(
									if ACAnimRangeEndKeyframe != undefined then
									(
										if ACAnimRangeEndKeyframe < s.scale.controller.keys[i].time do ACAnimRangeEndKeyframe = s.scale.controller.keys[i].time
									)
									else ACAnimRangeEndKeyframe = s.scale.controller.keys[i].time
								)
							)
							else ACAnimRangeStartKeyframe = s.scale.controller.keys[i].time
						)
					)
				)
			)
			else
			(
				ACAnimRangeStartKeyframe = 1.0f * spn_ACTrnsfrmRangeStartVal.value
				ACAnimRangeEndKeyframe = 1.0f * spn_ACTrnsfrmRangeEndVal.value
			)
			if ACAnimRangeStartKeyframe == undefined or ACAnimRangeEndKeyframe == undefined or ACAnimRangeStartKeyframe >= ACAnimRangeEndKeyframe do
			(
				ACAnimRangeStartKeyframe = undefined
				ACAnimRangeEndKeyframe = undefined
			)	
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
				SelectAllHierarchy selection[1]
			)
		)
	)

	on SelectAllExceptRootItem pressed do
	(
		if selection[1] != undefined then
		(
			if selection[1].children.count > 0 OR selection[1].parent != undefined then
			(
				SelectAllHierarchy selection[1]
				deselectnode selection[1]
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
						s.rotation.x_rotation = 0.0
						s.rotation.y_rotation = 0.0
						s.rotation.z_rotation = 0.0
					)
					if chkbx_ThTrnsfrmScale.state == true do
					(
						local rosOldParent = s.parent
						if rosOldParent != undefined do s.parent = undefined
						s.scale = [1,1,1]
						local objTm=s.transform
						local objTmX=normalize objTm.row1
						local objTmY=normalize objTm.row2
						local objTmZ=normalize (cross objTmX objTmY) --Rebuild the Z to orthogonalize the matrix.
						s.transform=(matrix3 objTmX objTmY objTmZ objTm.pos)
						if rosOldParent != undefined do s.parent = rosOldParent
					)
				)
			)
			else messageBox "Select any Transform type checkbox and THEN push that button!!" title:"ERROR"
		)
		else messageBox "Select at least ONE bone/helper/object and THEN push that button!" title:"ERROR"
	)
	
	on AttachObjTo pressed do
	(
		local oldAnimKeysState = GetAndOffAnimKeys()
		if selection.count == 1 then
		(
			local s = selection[1]
			if (queryBox "Select the object that you want to attach to this bone/helper/object...\n\nDo you want to continue?" title:"Attention!") do
			(
				clearSelection()
				local pickedObject = pickObject prompt:"Select the object that you want to attach to this bone/helper/object..." rubberBand:[s.pos.x,s.pos.y,s.pos.z]
				if pickedObject != undefined AND pickedObject != #escape AND pickedObject != s do
				(
					select pickedObject
					IncreaseAONumber()
					local pohelper = point size:0.1
					with Animate on
					(
						if ClassOf pickedObject != targetcamera and ClassOf pickedObject != VRayPhysicalCamera then
						(
							if pickedObject.rotation.controller.keys.count > 0 then
							(
								for i = 1 to pickedObject.rotation.controller.keys.count do
								(
									at time pickedObject.rotation.controller.keys[i].time
									(
										pohelper.transform = pickedObject.transform
									)
								)
							)
							else
							(
								at time sliderTime
								(
									pohelper.transform = pickedObject.transform
								)
							)
						)
						else
						(
							if pickedObject.controller.roll_angle.controller.keys.count > 0 then
							(
								for i = 1 to pickedObject.controller.roll_angle.controller.keys.count do
								(
									at time pickedObject.controller.roll_angle.controller.keys[i].time
									(
										pohelper.transform = pickedObject.transform
									)
								)
							)
							else
							(
								at time sliderTime
								(
									pohelper.transform = pickedObject.transform
								)
							)
						)
						if pickedObject.position.controller.keys.count > 0 then
						(
							for i = 1 to pickedObject.position.controller.keys.count do
							(
								at time pickedObject.position.controller.keys[i].time
								(
									pohelper.transform = pickedObject.transform
								)
							)
						)
						else
						(
							at time sliderTime
							(
								pohelper.transform = pickedObject.transform
							)
						)
					)
					setUserProp pohelper "AOHelperNumber" NewAO_Number
					maxOps.setKeyMode = true
					if ClassOf pickedObject != targetcamera and ClassOf pickedObject != VRayPhysicalCamera then deleteKeys pickedObject.rotation.controller #allKeys
					else deleteKeys pickedObject.controller.roll_angle.controller #allKeys
					deleteKeys pickedObject.position.controller #allKeys
					at time sliderTime pickedObject.transform= pohelper.transform
					if ClassOf pickedObject != targetcamera and ClassOf pickedObject != VRayPhysicalCamera do addNewKey pickedObject.rotation.controller sliderTime
					--else addNewKey pohelper.rotation.controller sliderTime
					addNewKey pickedObject.position.controller sliderTime
					maxOps.setKeyMode = false
					if pickedObject.parent != undefined do
					(
						setUserProp pickedObject "AOHadParent" 1
						setUserProp pickedObject.parent "AOParentNumber" NewAO_Number
					)
					pickedObject.parent = s
					if ClassOf pickedObject == targetcamera or ClassOf pickedObject == VRayPhysicalCamera do
					(
						local crollanglehelper = point size:0.1
						at time sliderTime
						(
							crollanglehelper.transform = pohelper.transform
						)
						crollanglehelper.parent = s
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
					)
					freeze pohelper
					hide pohelper
					setUserProp s "AOBoneNumber" NewAO_Number
					setUserProp pickedObject "AObjectNumber" NewAO_Number
					if ClassOf pickedObject != targetcamera and ClassOf pickedObject != VRayPhysicalCamera do pickedObject.parent = s
					local info_str_msg = "Object \"" + pickedObject.name + "\" has been successfully attached to \"" + s.name + "\"."
					messagebox info_str_msg title:"Done!"
				)
			)
		)
		else messageBox "Select ONE bone/helper/object and THEN push that button!" title:"ERROR"
		SetBackAnimKeys oldAnimKeysState
	)
	
	on DetachObj pressed do
	(
		RemoveAOLink 0 0 0.0
	)

	on CreateKeysFAO pressed do
	(
		RemoveAOLink 1 chkbx_DetailedAOAnim.state spn_DetailedAOAnim.value
	)
	
	on CASIncrease pressed do
	(
		if selection.count > 0 then
		(
			if chkbx_ACTrnsfrmKsPos.state == true or chkbx_ACTrnsfrmKsRot.state == true or chkbx_ACTrnsfrmKsScale.state == true then
			(
				local oldAnimKeysState = GetAndOffAnimKeys()
				if spn_CASIncBy.value != 1.0 do
				(
					UpdateAnimRangeStartAndEnd() 
					
					if ACAnimRangeStartKeyframe != undefined and ACAnimRangeEndKeyframe != undefined do
					(
						if ACAnimRangeStartKeyframe < ACAnimRangeEndKeyframe do
						(  
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
								if NewAnimShift > 0.0 then
								(
									for s in selection do
									(
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
									)
								)
								else
								( 
									for s in selection do
									(
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
									)
								)
							)
						)
					)
				)
				SetBackAnimKeys oldAnimKeysState
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
					local BakePointHelper = point size:0.1
					BakePointHelper.scale.controller = ScaleXYZ()
					for s in selection do
					(
						deleteKeys BakePointHelper.position.controller
						deleteKeys BakePointHelper.rotation.controller
						deleteKeys BakePointHelper.scale.controller
						with Animate on
						(
							local BakeRangeKeysCount = (ACAnimRangeEndKeyframe - ACAnimRangeStartKeyframe) / spn_BkTrnsfrmAccuracyVal.value
							if BakeRangeKeysCount > 0 do
							(
							
								if chkbx_ACTrnsfrmKsPos.state == true do
								(	
									for i = 0 to BakeRangeKeysCount do
									(
										at time (ACAnimRangeStartKeyframe + (i * spn_BkTrnsfrmAccuracyVal.value))
										(
											BakePointHelper.position.x = s.position.x
											BakePointHelper.position.y = s.position.y
											BakePointHelper.position.z = s.position.z
										)
									)
									at time ACAnimRangeEndKeyframe
									(
										BakePointHelper.position.x = s.position.x
										BakePointHelper.position.y = s.position.y
										BakePointHelper.position.z = s.position.z
									)
									if BakePointHelper.position.controller.keys.count > 0 do
									(
										if BakePointHelper.position.controller.keys.count > 0 do
										(
											deselectKeys s.position.controller
											selectKeys s.position.controller ACAnimRangeStartKeyframe ACAnimRangeEndKeyframe
											deleteKeys s.position.controller #selection
										)
										for i = 1 to BakePointHelper.position.controller.keys.count do
										(
											at time BakePointHelper.position.controller.keys[i].time
											(
												s.position.x = BakePointHelper.position.x
												s.position.y = BakePointHelper.position.y
												s.position.z = BakePointHelper.position.z
											)
										)
									)
								)
								
								if chkbx_ACTrnsfrmKsRot.state == true do
								(	
									for i = 0 to BakeRangeKeysCount do
									(
										at time (ACAnimRangeStartKeyframe + (i * spn_BkTrnsfrmAccuracyVal.value))
										(
											BakePointHelper.rotation.x_rotation = s.rotation.x_rotation
											BakePointHelper.rotation.y_rotation = s.rotation.y_rotation
											BakePointHelper.rotation.z_rotation = s.rotation.z_rotation
										)
									)
									at time ACAnimRangeEndKeyframe
									(
										BakePointHelper.rotation.x_rotation = s.rotation.x_rotation
										BakePointHelper.rotation.y_rotation = s.rotation.y_rotation
										BakePointHelper.rotation.z_rotation = s.rotation.z_rotation
									)
									if BakePointHelper.rotation.controller.keys.count > 0 do
									(
										if BakePointHelper.rotation.controller.keys.count > 0 do
										(
											deselectKeys s.rotation.controller
											selectKeys s.rotation.controller ACAnimRangeStartKeyframe ACAnimRangeEndKeyframe
											deleteKeys s.rotation.controller #selection
										)
										for i = 1 to BakePointHelper.rotation.controller.keys.count do
										(
											at time BakePointHelper.rotation.controller.keys[i].time
											(
												s.rotation.x_rotation = BakePointHelper.rotation.x_rotation
												s.rotation.y_rotation = BakePointHelper.rotation.y_rotation
												s.rotation.z_rotation = BakePointHelper.rotation.z_rotation
											)
										)
									)
								)
								
								if chkbx_ACTrnsfrmKsScale.state == true do
								(	
									s.scale.controller = ScaleXYZ()
									for i = 0 to BakeRangeKeysCount do
									(
										at time (ACAnimRangeStartKeyframe + (i * spn_BkTrnsfrmAccuracyVal.value))
										(
											BakePointHelper.scale.x = s.scale.x
											BakePointHelper.scale.y = s.scale.y
											BakePointHelper.scale.z = s.scale.z
										)
									)
									at time ACAnimRangeEndKeyframe
									(
										BakePointHelper.scale.x = s.scale.x
										BakePointHelper.scale.y = s.scale.y
										BakePointHelper.scale.z = s.scale.z
									)
									if BakePointHelper.scale.controller.keys.count > 0 do
									(
										if BakePointHelper.scale.controller.keys.count > 0 do
										(
											deselectKeys s.scale.controller
											selectKeys s.scale.controller ACAnimRangeStartKeyframe ACAnimRangeEndKeyframe
											deleteKeys s.scale.controller #selection
										)
										for i = 1 to BakePointHelper.scale.controller.keys.count do
										(
											at time BakePointHelper.scale.controller.keys[i].time
											(
												s.scale.x = BakePointHelper.scale.x
												s.scale.y = BakePointHelper.scale.y
												s.scale.z = BakePointHelper.scale.z
											)
										)
									)
								)
							)
						)
					)
					delete BakePointHelper
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
					for s in selection do
					(
						with Animate on
						(
							local BakeRangeKeysCount = (ACAnimRangeEndKeyframe - ACAnimRangeStartKeyframe) as integer
							if BakeRangeKeysCount > 2 do
							(
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
							)
						)
					)
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
				if ACAnimRangeStartKeyframe != undefined and ACAnimRangeEndKeyframe != undefined do
				(
					for s in selection do
					(
						if rb_AnimKeysRange.state == 1 then
						(
							if chkbx_ACTrnsfrmKsPos.state == true do deleteKeys s.position.controller
							if chkbx_ACTrnsfrmKsRot.state == true do deleteKeys s.rotation.controller
							if chkbx_ACTrnsfrmKsScale.state == true do deleteKeys s.scale.controller
						)
						else
						(
							if chkbx_ACTrnsfrmKsPos.state == true and s.position.controller.keys.count > 0 do
							(
								deselectKeys s.position.controller
								selectKeys s.position.controller ACAnimRangeStartKeyframe ACAnimRangeEndKeyframe
								deleteKeys s.position.controller #selection
							)
							if chkbx_ACTrnsfrmKsRot.state == true and s.rotation.controller.keys.count > 0 do
							(
								deselectKeys s.rotation.controller
								selectKeys s.rotation.controller ACAnimRangeStartKeyframe ACAnimRangeEndKeyframe
								deleteKeys s.rotation.controller #selection
							)
							if chkbx_ACTrnsfrmKsScale.state == true and s.scale.controller.keys.count > 0 do
							(
								deselectKeys s.scale.controller
								selectKeys s.scale.controller ACAnimRangeStartKeyframe ACAnimRangeEndKeyframe
								deleteKeys s.scale.controller #selection
							)
						)
					)
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
		button SMTrigFreeze "Freeze" width:57 align:#left across:2 tooltip:"Freezes/unfreezes skin mesh.\nSelect any bone/helper or skin mesh and push this button."
		button SMTrigXRay "Transparency" width:90 align:#right tooltip:"Enables/Disables transparency for skin mesh.\nSelect any bone/helper or skin mesh and push this button."
	)
	group "Create/Delete/Bake Controllers"
	(
		button CreateHISolver1 "One bone" width:67 align:#left across:2 tooltip:"Creates HI Solver for selected bone.\nSelect ONE bone/helper and push this button."
		button CreateHISolver2 "Bone + Joint" width:80 align:#right tooltip:"Creates HI Solver for selected bone and its parent joint.\nSelect ONE bone/helper and push this button."
		button CreateControllers "Create all Controllers" tooltip:"Creates all needed controllers for the hierarchy that belongs to the selected bone.\nSelect ONE bone/helper and push this button."
		button CreateHISolverEyes "Eyes" width:32 align:#left across:2 tooltip:"Creates HI Solver for selected eye pupils' bones.\nSelect ALL eye pupils' bones/helpers and push this button."
		button DeleteHISolver "Delete for all selected" width:115 align:#right tooltip:"Deletes selected HI Solvers or HI Solvers for selected bones.\nWorks only for HI Solvers that were created by this script!\nSelect all needed bones or/and HI solvers and push this button."
		button CreateKeysFAHIB "Bake for all selected" tooltip:"Creates anim keys for all selected bones that uses HI Solvers or for bones that uses selected HI Solvers.\nWorks only for HI Solvers that were created by this script!\nUse this before animation export.\nSelect all needed bones or/and HI solvers and push this button."
		checkbox chkbx_DetailedHIAnim "Detailed" align:#left checked:true across:2 tooltip:"Bakes more detailed animation by adding extra anim keys every few frames. Choose frame interval in the \"Int\" field."
		spinner spn_DetailedHIAnim "Int:" range:[0.001, 1000.0, 1.0] type:#float align:#right across:2 fieldwidth:45
	)
	
	/*---------------------------------------------------------------------------------------------------*/
	/*---------------------------------------------------------------------------------------------------*/
	/*---------------------------------------------------------------------------------------------------*/
	
	fn RemoveHISolver BakeHIAnimFlag bool_DetailedHIAnim float_DetailedHIAnim =
	(
		local oldAnimKeysState = GetAndOffAnimKeys()
		local selectionArr = selection as array
		for s in selectionArr do
		(
			if getUserProp s "HISolverNumber" != undefined or getUserProp s "HIJointNumber" != undefined or getUserProp s "HICBoneNumber" != undefined do
			(
				local HISelectNumber
				if getUserProp s "HISolverNumber" != undefined then HISelectNumber = getUserProp s "HISolverNumber"
				else if getUserProp s "HIJointNumber" != undefined then HISelectNumber = getUserProp s "HIJointNumber"
				else HISelectNumber = getUserProp s "HICBoneNumber"
				for obj in objects do
				(
					if getUserProp obj "HIBoneNumber" ==  HISelectNumber do selectmore obj
				)
			)
		)
		selectionArr = selection as array
		for s in selectionArr do
		(
			if isValidNode s do
			(
				if getUserProp s "HIBoneNumber" != undefined and getUserProp s "HIBoneNumber" != -1 do
				(
					local HI_BoneNumber = getUserProp s "HIBoneNumber"
					local helpersArr = helpers as array
					for obj in helpersArr do
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
									if s.children.count > 0 do
									(
										for HBC in s.children do
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
											local sHIEyesNumber = getUserProp s "HIEyesNumber" 
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
																	
																	saccadeMultiplier = (1.0 / ((length (obj.position - s.position)) * saccadePupillaryDistance - 1.0) ) * 0.002
																	
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
														
														saccadeMultiplier = ((length (obj.position - s.position)) * saccadePupillaryDistance) * 0.1
														
														
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
															if snhelper != undefined do snhelper.transform = s.transform
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
																snhelper.transform = s.transform
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
														if (HI_SolverType == 1 or HI_SolverType == 4) and s.parent != undefined do
														(
															local sBoneParent = s.parent
															if sBoneParent.rotation.controller.keys.count > 0 do
															(
																for i = 1 to sBoneParent.rotation.controller.keys.count do
																(
																	if sBoneParent.rotation.controller.keys[i].time >= obj.position.controller.keys[1].time and sBoneParent.rotation.controller.keys[i].time <= obj.position.controller.keys[obj.position.controller.keys.count].time do
																	(
																		at time sBoneParent.rotation.controller.keys[i].time
																		(
																			snhelper.transform = s.transform
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
													if (HI_SolverType == 1 or HI_SolverType == 4) and s.parent != undefined do
													(
														local sBoneParent = s.parent
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
																if snhelper != undefined do snhelper.transform = s.transform
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
									setUserProp s "HIBoneNumber" -1
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
									for obj2 in helpersArr do
									(
										if isValidNode obj2 do
										(
											if getUserProp obj2 "HISolverNumber" != undefined do
											(
												if getUserProp obj2 "HISolverNumber" == HI_BoneNumber do
												(
													if HI_SolverType == 4 then
													(
														if getUserProp obj2 "HISolverType" != 3 then
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
															if getUserProp obj2 "HIEyesNumber" == getUserProp s "HIEyesNumber" do delete obj2
														)
													)
													else delete obj2
												)
											)
										)
									)
									deleteKeys s.rotation.controller #allKeys
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
														s.transform = snhelper.transform
														if HIBoneChild != undefined do
														(
															if HI_SolverType == 2 do
															(
																HIBoneChild.transform = HIBoneChildnhelper.transform
															)
														)
													)
												)
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
									--deleteKeys s.position.controller
									--deleteKeys s.scale.controller
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
	
	fn CreateHISolver s hitype = -- hitype: "One bone", "Bone + Joint", "Chain", "Eyes" and "Joint" (1-5)
	(
		local p = s.parent
		if p != undefined then
		(
			local p2 = p.parent
			if hitype != 2 or p2 != undefined then
			(
				IncreaseHIBoneNumber()
				local snhelper = point size:0.1
				local hIBoneParentnhelper = point size:0.1
				if hitype == 2 do local hIBoneGParentnhelper = point size:0.1
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
				ikChain01.name = (s.name + " Chain")
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
				local newhelper = point size:(length (p.position - s.position)) 
				newhelper.size = (length (p.position - s.position))
				newhelper.name = "HI_" + s.name
				newhelper.position = s.position
				newhelper.cross = false
				newhelper.box = true
				--newhelper.drawontop = true
				newhelper.wirecolor = (color 255 0 0)
				ikChain01.wirecolor = (color 255 0 0)
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
				newjointhelper.name = "HI_" + s.name + " Joint"
				newjointhelper.position = p.position
				newjointhelper.cross = false
				newjointhelper.box = true
				--newjointhelper.drawontop = true
				newjointhelper.wirecolor = (color 255 0 255)
				newjointhelper.parent = newhelper
				setUserProp newjointhelper "HIJointNumber" NewHI_Number

				select newhelper
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
				local error_str_msg = "Bone " + (s.name) + " hasn't parent joint!"
				messagebox error_str_msg title:"ERROR"
			)
		)
		else
		(
			local error_str_msg = "Bone " + (s.name) + " hasn't parent bone!"
			messagebox error_str_msg title:"ERROR"
		)
	)
	
	/*---------------------------------------------------------------------------------------------------*/
	/*---------------------------------------------------------------------------------------------------*/
	/*---------------------------------------------------------------------------------------------------*/
	
	on SMTrigFreeze pressed do
	(
		if selection[1] != undefined then
		(
			local s_Array = selection as array
			local s = selection[1]
			clearselection()
			select s
			if SuperclassOf s == GeometryClass and (classof s) == Editable_Mesh and (HasSkinModifier s) then
			(
				for obj in s do
				(
					if obj.isFrozen == true then
					(
						unfreeze obj
					)
					else
					(
						freeze obj
						obj.showFrozenInGray = false
					)
				)
			)
			else-- if getUserProp s "FrameName" != undefined then
			(
				local s_Hierarchy = GetAllHierarchy s
				--SelectAllHierarchy s
				--local s_Hierarchy = selection as array
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
							freeze obj
							obj.showFrozenInGray = false
						)
					)
				)
				else if getUserProp s "SkinMeshName" != undefined then
				(
					local SkinMeshName = getUserProp s "SkinMeshName"
					local MeshFound = false
					for obj in geometry do
					(
						if (classof obj) == Editable_Mesh and obj.name == SkinMeshName then
						(
							if obj.isFrozen == true then
							(
								unfreeze obj
							)
							else
							(
								freeze obj
								obj.showFrozenInGray = false
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
			clearselection()
			for obj in s_Array do
			(
				selectmore obj
			)
		)
	)

	on SMTrigXRay pressed do
	(
		if selection[1] != undefined then
		(
			local oldAnimKeysState = GetAndOffAnimKeys()
			local s_Array = selection as array
			local s = selection[1]
			clearselection()
			select s
			if SuperclassOf s == GeometryClass and (classof s) == Editable_Mesh and (HasSkinModifier s) then
			(
				for obj in s do
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
			else-- if getUserProp s "FrameName" != undefined then
			(
				local s_Hierarchy = GetAllHierarchy s
				--SelectAllHierarchy s
				--local s_Hierarchy = selection as array
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
				else if getUserProp s "SkinMeshName" != undefined then
				(
					local SkinMeshName = getUserProp s "SkinMeshName"
					local MeshFound = false
					for obj in geometry do
					(
						if (classof obj) == Editable_Mesh and obj.name == SkinMeshName then
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
			clearselection()
			for obj in s_Array do
			(
				selectmore obj
			)
			SetBackAnimKeys oldAnimKeysState
			redrawViews()
		)
	)
	
	on CreateHISolver1 pressed do
	(
		local oldAnimKeysState = GetAndOffAnimKeys()
		if selection.count == 1 then
		(
			CreateHISolver selection[1] 1 -- "One bone" type
		)
		else messageBox "Select ONE bone/helper and THEN push that button!" title:"ERROR"
		SetBackAnimKeys oldAnimKeysState
	)

	on CreateHISolver2 pressed do
	(
		local oldAnimKeysState = GetAndOffAnimKeys()
		if selection.count == 1 then
		(
			CreateHISolver selection[1] 2 -- "Bone + Joint" type
		)
		else messageBox "Select ONE bone/helper and THEN push that button!" title:"ERROR"
		SetBackAnimKeys oldAnimKeysState
	)
	
	on CreateControllers pressed do
	(
		local oldAnimKeysState = GetAndOffAnimKeys()
		if selection.count == 1 then
		(
			local ccBonesArr = GetAllHierarchy selection[1]
			local ccCH = GetCharacterHierarchy selection[1]
			local info_str_msg = "spineLinks: " + (ccCH.spinelinks as string) + " !\n" +
			"legLinks: " + (ccCH.leglinks as string) + " !\n" +
			"tailLinks: " + (ccCH.taillinks as string) + " !\n" +
			"fingers: " + (ccCH.fingersnumber as string) + " !\n" +
			"fingerLinks: " + (ccCH.fingerlinks as string) + " !\n" +
			"toes: " + (ccCH.toesnumber as string) + " !\n" +
			"toeLinks: " + (ccCH.toelinks as string) + " !\n" +
			"headId: " + (ccCH.headid as string) + " !"
			messagebox info_str_msg title:"TEST!"
			
			for ccbone in ccBonesArr do
			(
				if getUserProp ccbone "BoneID" != undefined or getUserProp ccbone "BoneId" != undefined do
				(
					local ccBoneId
					if getUserProp ccbone "BoneID" != undefined  then ccBoneId = getUserProp ccbone "BoneID"
					else ccBoneId = getUserProp ccbone "BoneId"
					if ccBoneId == 43 or ccBoneId == 53 or ccBoneId == 24 or ccBoneId == 34 then CreateHISolver ccbone 2
				)		
			)
			clearselection()
			select ccBonesArr[1]
		) 
		SetBackAnimKeys oldAnimKeysState	
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
		RemoveHISolver 0 0 0.0
	)

	on CreateKeysFAHIB pressed do
	(
		RemoveHISolver 1 chkbx_DetailedHIAnim.state spn_DetailedHIAnim.value
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
			local cfcBonesArr = GetAllHierarchy selection[1]
			local cfcCH = GetCharacterHierarchy selection[1]
			local HeadBone
			for b in cfcBonesArr do
			(
				if getUserProp b "BoneID" == cfcCH.headid or getUserProp b "BoneIId" == cfcCH.headid do HeadBone = b
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
				local OrigBonesArr = GetAllHierarchy selection[1]
				
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
				local newBipedBonesArr = GetAllHierarchy newBiped
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

rollout Info_Rollout "Info" width:132 height:30
(
	group "Some Info"
	(
		button HelpButton "Help/How-to" across:2 width:90 pos:[13,25] tooltip:"Push this button to see some help info"
		button AboutButton "About" width:58 pos:[106,25] tooltip:"Push this button to see some extra info"
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
		rollout AboutDialog "Another Animation Helper v.0.98b" width:275 height:315
		(
			label abd1 "\"Another Animation Helper\" v.0.98b (Open Beta)" align:#left
			label abd2 ""
			label abd3 "Made by Shagg_E, 2017-2022:" align:#left
			HyperLink nrsite "http://newrockstar.do.am" address:"http://newrockstar.do.am" color: (color 0 127 0) hovercolor:(color 0 191 0) visitedcolor:(color 0 95 0)
			HyperLink ytchannel "https://youtube.com/user/NewrockstarGames" address:"https://youtube.com/user/NewrockstarGames" color: (color 191 0 0) hovercolor:(color 255 0 0) visitedcolor:(color 127 0 0)
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
		createDialog AboutDialog
	)
) --// end rollout


/*********************************************************************************************************************************************************************/
--// MACRO CALLS FOR UI
/*********************************************************************************************************************************************************************/

try (closeRolloutFloater AAHWindow) catch ()
AAHWindow = NewRolloutFloater "AA Helper" 190 805 50 100
addRollout Rig_Tuner_Rollout AAHWindow rolledUp:true
addRollout Main_Anim_Rollout AAHWindow --rolledUp:true
addRollout Body_Anim_Rollout AAHWindow --rolledUp:true
--addRollout Face_Anim_Rollout AAHWindow rolledUp:true
--addRollout Hierarchies_Rollout AAHWindow rolledUp:true
addRollout Info_Rollout AAHWindow rolledUp:true

/*********************************************************************************************************************************************************************/