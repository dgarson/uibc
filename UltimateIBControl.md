# Ultimate IBControl

Ultimate IBControl is an enhanced version of Unlimited IBControl, leapfrogging off the work by ImmortalBob and Pappy. It provides extensive support for additional, more sophisticated operations that may be tedious to otherwise perform with an army, despite the availability of things like `#echo` or `/ub bc` (UtilityBelt broadcasts).


### Prerequisites

#### You must have the latest UtilityBelt beta which can be downloaded from https://ubstaging.surge.sh/master/releases/ -- PLEASE MAKE SURE TO CLOSE ALL AC CLIENTS PRIOR TO INSTALLING!!
#### You should already have ChaosHelper installed per Unlimited IBControl instructions, if you want to use it
#### Group Config Meta must be setup and run: 
Only two things really need to be edited, in the UltimateIBControl.met (the tiny one) -- the big one never gets touched
* #1 is the charlist just like regular Unlimited IBControl
* #2 is the FellowPassword and optionally the fellowname
IF you decide to rename the tiny config meta (right now named UltimateIBControl.met) then you MUST update the variable in that met file to match the filename it's in, e.g. setpvar[IBControlMetaName,MyIBControl] if you renamed to MyIBControl.met

## Significant Feature Improvements

### Restore Options after Actions
A lot of IBControl actions have to change your character's nav distance or approach range. This is necessary because your character may not behave as expected when following embedded navs, etc. Unfortunately, this leaves army controllers with an
unfortunate situation where after performing an action like a `#quest Graveyard Killtasks`, they find themselves with characters all using very low ranges. If you want different ranges and options for melee vs ranged, this becomes a nightmare to
restore. In Ultimate IBControl, your character's current options are captured whenever you run such an action and then, upon completion or failure, those options are restored to the values they had before. Right now, this supports the following
options:
* AttackDistance
* ApproachDistance
* NavCloseStopRange (nav/follow distance)
* EnableNav
* EnableCombat
* EnableLooting
* EnableBuffing

### Blocking Actions
Several actions in IBControl will effectively block you from interacting with your characters until completion or failure. The best example is `#action ucp`. Your character will start running towards the portal to use it, but if something were
to obstruct your character's movement to the portal, you would have no way of aborting the use-closest-portal action to return your character to a state where it'll accept commands.

UltimateIBControl adds the `#cancel` command for this purpose. All blocking actions should now accept the `#cancel` command which results in the action being aborted and returning to the `Default2` state, which handles all the main chat commands.
You can also issue the `#busy` command for many of the new Ultimate IBControl commands to ask your characters whether they are still waiting to complete said action. If no characters respond, then everyone is done.

### Corpse/Item Looting
A major gap in IBControl, as it stands today, is looting or picking up items from the ground on all of your characters. It isn't very hard to issue a simple command like `#echo /mt pickup ITEM` but this will often fail because there will only be
one of those items that can be acquired on the ground. Similarly for looting a corpse, you cannot issue a command to all characters because only one will end up being able to act on that command due to contention among characters in your army, or
even the characters of other players. UltimateIBControl provides both a `#pickup` and `#loot`/`#lootcorpse` command to handle these exact situations.

### NPC Interactions
UltimateIBControl provides you with a few commands that provide built-in retry summon for interacting with NPCs in a variety of ways, with the expectation that each character in your army is contending for the NPC's attention, because the NPC is likely to be unavailable to talk to until it's done talking to another character. You can simply `#talk` to an NPC, which will retry until the NPC talks to your character in any way, or you can even ask them to talk to the NPC until the NPC gives
them an item using `#get ITEM from NPC`. You can also ask your characters to give items to an NPC using `#givenpc`, in addition to providing a version that supports accepting a confirmation dialog that is expected when giving NPCs an item. You can
also issue a single command to give *all* of a particular item, with or without the confirmation dialog support, to a given NPC.

### Portal Devices
Portal Devices can also require characters to use them one at a time. A great example is the hatches in Hoshino, which are in fact portal devices, and which cannot be used concurrently by multiple characters. Instead, you have to wait until the current user opens/closes the latch (visual animation) after which they teleport in and another character is able to use the hatch. The `#useportaldevice NAME` command provides retry support akin to the NPC interactions, and considers itself to
have completed successfully whenever the character enters portal space. You can also check who is `#busy` or `#cancel` while in progress.

### Ranged-vs-Melee-specific Commands
You can now issue `#action` and `#echo` and `#optset` to either all ranged characters or all melee characters, rather than the entirety of your army. This can be done by prefixing any of these commands with either `r` for ranged (e.g. `recho`) or
`m` for melee (e.g. `moptset`). This is especially useful for things like turning on nav priority or disabling combat for ranged characters that might be following your leader, without affecting the state of your melee hunters already with your 
leader. Additionally, it's useful for tweaking the attack range for melee vs ranged without interfering with the other.

### Checking Character Inventory
UltimateIBControl provides convenient commands to determine whether characters have an item, do not have an item, or have a certain number (or less than that number). These commands are fairly simple and will result in your leader receiving whispers from each character with the results of the command/query. These commands are documented below.

### Quest Flag Checks
UltimateIBControl also provides commands to help an army controller determine whether characters have a particular quest flag, or a given flag is ready so you can run a periodic quest again, etc. These commands are documented below.

### Check Character Location
Rather than having to rely on something like UB Networking UI, you can now issue the `#distance` command to determine how far characters are from your leader. You can also run the `#headcount` command which will whisper the leader from characters
that are out of range, rather than relying on the character being in range to listen to the command.

Running `#headcount` will cause the command issuer (leader) to issue a UB broadcast command that causes each character to report if they're out of range.

### Command Auth Exclusions
Have you ever been in a situation where you instructed your army to jump up to another platform, but only half of your army succeeded? Command Auth Exclusion is more/less designed for this exact case! You can exclude specific characters, which is 
fairly tedious for this particular use case, but you can also exclude characters beyond a given range from accepting commands from your leader. In this sample case, you can switch to a character that failed to jump, issue `#excludebeyond X` where X is a far enough range to cover the characters that failed the jump but won't hit the characters who made it. At that point, you can issue follow/stay commands and retry the jump command when in the proper position, without causing characters who
already made the jump to also run that jump command, which can cause said characters to jump *off* of the platform you're trying to get to.

You can then run `#resetexclusions` at any time and all characters will reset their exclusion list and begin accepting commands as they normally would.

## General Action Commands
### `#cancel` will cancel any active, otherwise-blocking command, such as `#action ucp` where the character is otherwise non-responsive if they are unable to reach the portal
### `#checkflag QUESTFLAG` will refresh the quests on each character and whisper the status of the quest with the given flag name, or indicate it has never been set for that character
### `#questready QUESTFLAG` will have only characters with the given flag either unset or having been completed and currently with a status of 1, indicating it is ready for another completion.
### `#noflag QUESTFLAG` will have only have characters whisper you if they have never been flagged, e.g. `testquestflag[..]==0`
### `#itemcount ITEMNAME` will have each character whisper the number of the given item that they have in their inventory to the command issuer
### `#itemcountp ITEMPARTIALNAME` will have each character whisper the number of total items matching the partial item name text
### `#itemabsent ITEMNAME` will have each character WITHOUT any items of the given name indicate such to the command issuer
### `#itemabsentp ITEMPARTIALNAME` will have each character WITHOUT any items containing the given partial name to the command issuer
### `#itemcountge MINCOUNT ITEMNAME` will have characters whisper the issuer if they have greater than OR equal to the minimum number of the given item provided in the command
### `#itemcountlt MAXCOUNT ITEMNAME` will have characters whisper the issuer if they have strictly less than the maximum number of the given item provided in the command
### `#vtprofile PROFILENAME` will load a *character-specific* settings profile, e.g. `/vt settings loadchar PROFILENAME`
### `#leader LEADERNAME` will instruct any listening character who is the fellow leader to promote the given character to the leader role, if found
### `#recruitme PASSWORD` provides a customized password-protected invite command akin to the passwordless `xp` command
### `#kick PLAYERNAME` will instruct any listening character who is the fellow leader to dismiss a character with the given name from the fellowship
### `#loadmeta METANAME` will load an external `met` file, since sometimes `#echo /vt meta load` does not work as expected
### `#reload` will reload the entire `met` file by loading the Ultimate IBC Group Config meta that initially transitioned to this core met 
### `#distance` will have every listening character indicate how far they are from the command issuer, or indicate they are not in range at all
### `#headcount` will have every out of range, listening character whisper the command issuer indicating their absence

## Command Authorization Commands
## `#excludechar CHARNAME` will exclude the given character from being authorized to run commands on IBControl'd-characters until the `#resetexclusions` command is run
## `#listexclusions` will whisper the issuer with the names or excluded characters, and the optional max range for characters to accept commands
## `#excludebeyond MAXRANGE` will cause characters to ignore *most* commands from command issuers beyond the given range. This will only impact commands that may induce the character to perform some action or change some option, or anything else that could impact future character behavior/position, rather than responding to queries for information. Similarly, this will remain in effect until `#resetexclusions` is issued
## `#resetexclusions` will clear the list of character exclusions as well as clear any optional maximum range for command issuers that may have been set earlier with `#excludebeyond`

## Class-Specific Commands
Ultimate IBControl takes into account the character role/class, providing the ability to selectively issue `echo` or `optset` only to a subset of your group, e.g. only Melee, Missile, or Mage characters.

### `#mecho TEXT`  is identical to `#echo TEXT` except that only characters trained in Melee weapon skills will echo the text
### `#recho TEXT`  is identical to `#echo TEXT` except that all Mage and Missile characters will echo the text
### `#moptset OPTION VALUE` is identical to `#optset OPTION VALUE` except that only characters trained in Melee weapon skills will set the option
### `#roptset OPTION VALUE` is identical to `#optset OPTION VALUE` except that only Mage and Missile characters will set the option
### `#maction TEXT`  is identical to `#action TEXT` except that only characters trained in Melee weapon skills will run the action
### `#raction TEXT`  is identical to `#action TEXT` except that all Mage and Missile characters will run the action

## NPC Interactions
### `#talk NPCNAME` will attempt to talk to the specified NPC periodically until they succeed, indicated by the NPC talking to them in some way
### `#talkwithconfirmation NPCNAME` is analogous to `#talk` command except it will also introduce a `/ub prepclick` to ensure that any confirmation dialog will be accepted (with a Yes, not OK)
### `#givenpc ITEMNAME to NPCNAME` attempts to give an item with the given name to the specified NPC. If the NPC is busy, then this action will spin and retry giving the item to the NPC before eventually timing out. If the character has no such item, or the item count decrements by one, then the operation is complete
### `#giveallnpc ITEMNAME to NPCNAME` will attempt to give _all_ items with the given name to the NPC. See #givenpc
### `#givenpcwithconfirmation ITEMNAME to NPCNAME` is analogous to `#givenpc` command but will also introduce a `/ub prepclick` to ensure that any confirmation dialog will be accepted (with a Yes, not OK)
### `#giveallnpcwithconfirmation ITEMNAME to NPCNAME` will attempt to give _all_ items with the given name to the NPC, using `/ub prepclick` to ensure any confirmation dialogs will be accepted (with a Yes, not OK)
### `#get ITEMNAME from NPCNAME` attempts to talk to the given NPC until they receive an item with the given name. If the NPC is busy, then this action will spin and retry giving the item to the NPC before eventually timing out.
### `#vendor VENDORNAME` will open a vendor window with the given vendor, if nearby, but will not perform any autovendoring/vendoring commands
### `#vendorprofile PROFILENAME from VENDORNAME` will open a vendor window with the given vendor, if nearby, and will perform a `/ub autovendor PROFILENAME` 

## Looting/Landscape Object Interaction Commands
### `#loot ITEMNAME from CORPSENAME` will attempt to loot the given named item from a corpse with the given name. If no corpse is present, then the action will abort and indicate such to the command issuer. Otherwise, the character will spin and attempt to both open the corpse and loot said item from the corpse. If the item count increments by one, OR if the character gets a solved-too-recently message, then the character is done looting.
### `#lootunique ITEMNAME from CORPSENAME` is analogous to `#loot` except that it will not even make a first attempt to loot the corpse if the item already exists in the character's inventory
### `#pickup ITEMNAME` attempts to pick up an item with the given name from the ground. If no object with that name exists, then the character will spin, waiting for such an object to exist, at which point it will attempt to loot it.
### `#pickupunique ITEMNAME` is analogous to `#pickup` except that it will not even make a first attempt to loot the corpse if the item already exists in the character's inventory
### `#lootchest CHESTNAME with KEYNAME for ITEMNAME` will attempt to use the given key item on a chest with the specified name (choosing the closest chest if multiple exist) and then will loot if for the specified item. If the character has no keys, or the number of items held by the character increases by one, OR if the key is used and no item is found in the chest, then this operation is complete.
### `#lootchestunique CHESTNAME with KEYNAME for ITEMNAME` will attempt to use the given key item on a chest with the specified, except that it will not even make a first attempt to loot the corpse if the item already exists in the character's inventory 
### `#useportaldevice OBJNAME` will attempt to use a nearby object (portal device) with the given name and will retry until the character has exited portal space. If the character is unable to successfully use the device, e.g. due to lack of a quest flag, the `#cancel` command must be issued if you want to proceed with using the character prior to waiting a long time for all the retries to timeout.
### `#landscape startlooting MAXRANGE MAXCOUNT OBJECTCLASSID OBJECTNAME` will register an object for scanning in the nearby landscape, automatically attempting to loot any matching objects. Use `/ub propertydump` on a target object to get the object class number. `MAXRANGE` and `MAXCOUNT` can be zero to indicate no max/unlimited count.
### `#landscape stoplooting OBJECTNAME` will disable landscape scanning for any registered objects with the given name, otherwise this will do nothing. If no remaining objects are configured to be scanned for / used on the landscape, then scanning will no longer run at all until a first object is registered again.
### `#landscape disablelooting` will clear all of the landscape scanning object configs

## Enhancements to existing commands
* The `#action fellow` command will not filter on nearby/known players that are in your character list, rather than attempting to iterate over every character name defined in that list, significantly improving speed when not all characters are present
* When running a command such as `#quest Graveyard Killtasks` you may have previously noticed that, upon completion of the action, your end up finding your characters having a different approach or nav distance. This should be rectified in Ultimate IBControl, and previous Approach/Nav distances should be restored after finishing